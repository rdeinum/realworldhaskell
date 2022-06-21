module BetterPredicate where

import Control.Monad(filterM)
import System.Directory(Permissions(..), getModificationTime, getPermissions)
import Data.Time(UTCTime(..), calendarDay)
import System.FilePath(takeExtension)
import Control.Exception(bracket, handle, SomeException(SomeException))
import System.IO(IOMode(..), hClose, hFileSize, openFile)
import RecursiveContents(getRecursiveContents)

type Predicate = FilePath      -- path to directory entry
              -> Permissions   -- permissions
              -> Maybe Integer -- file size (Nothing if not file)
              -> UTCTime       -- last modified
              -> Bool

getFileSize :: FilePath -> IO (Maybe Integer)
getFileSize path = handle catch $ do
    bracket (openFile path ReadMode) hClose $ \h -> do
        size <- hFileSize h
        return (Just size)
    where catch :: SomeException  -> IO (Maybe Integer)
          catch _ = return Nothing

betterFind :: Predicate -> FilePath -> IO [FilePath]
betterFind predicate dir = getRecursiveContents dir >>= filterM check
    where check path = do
            permissions <- getPermissions path
            size <- getFileSize path
            modified <- getModificationTime path
            return (predicate path permissions size modified)

simpleFileSize :: FilePath -> IO Integer
simpleFileSize path = do
    h <- openFile path ReadMode
    size <- hFileSize h
    hClose h
    return size

saferFileSize :: FilePath -> IO (Maybe Integer)
saferFileSize path = handle errorHandler $ do
    h <- openFile path ReadMode
    size <- hFileSize h
    hClose h
    return (Just size)
    where errorHandler :: SomeException  -> IO (Maybe Integer)
          errorHandler _ = return Nothing

myTest :: FilePath -> Permissions -> Maybe Integer -> UTCTime -> Bool
myTest path _ (Just size) _ = takeExtension path == ".cpp" && size > 131072
myTest _ _ _              _ = False

type InfoP a = FilePath      -- path to directory entry
            -> Permissions   -- permissions
            -> Maybe Integer -- file size (Nothing if not file)
            -> UTCTime       -- last modified
            -> a

pathP :: InfoP FilePath
pathP path _ _ _ = path

sizeP :: InfoP Integer
sizeP _ _ (Just size) _ = size
sizeP _ _ _           _ = -1

equalP :: (Eq a) => InfoP a -> a -> InfoP Bool
-- equalP f k = \w x y z -> f w x y z == k
equalP f k w x y z = f w x y z == k

liftP :: (a -> b -> c) -> InfoP a -> b -> InfoP c
liftP q f k w x y z = f w x y z `q` k

greaterP, lesserP :: (Ord a) => InfoP a -> a -> InfoP Bool
greaterP = liftP (>)
lesserP = liftP (<)

simpleAndP :: InfoP Bool -> InfoP Bool -> InfoP Bool
simpleAndP p1 p2 w x y z = p1 w x y z && p2 w x y z

liftP2 :: (a -> b -> c) -> InfoP a -> InfoP b -> InfoP c
liftP2 f p1 p2 w x y z = p1 w x y z `f` p2 w x y z

andP :: InfoP Bool -> InfoP Bool -> InfoP Bool
andP = liftP2 (&&)

orP :: InfoP Bool -> InfoP Bool -> InfoP Bool
orP = liftP2 (||)

constP :: a -> InfoP a
constP k _ _ _ _ = k

liftP' :: (a -> b -> c) -> InfoP a -> b -> InfoP c
liftP' f p1 k w x y z = p1 w x y z `f` k

liftPath :: (FilePath -> a) -> InfoP a
liftPath f w _ _ _ = f w

myTest2 :: FilePath -> Permissions -> Maybe Integer -> UTCTime -> Bool
myTest2 = (liftPath takeExtension `equalP` ".cpp") `andP` (sizeP `greaterP` 131072)

(==?) :: (Eq a) => InfoP a -> a -> InfoP Bool
infix 4 ==?
(==?) = equalP

(&&?) :: InfoP Bool -> InfoP Bool -> InfoP Bool
infixr 3 &&?
(&&?) = andP

(>?) :: (Ord a) => InfoP a -> a -> InfoP Bool
infix 4 >?
(>?) = greaterP

myTest3 :: FilePath -> Permissions -> Maybe Integer -> UTCTime -> Bool
myTest3 = (liftPath takeExtension ==? ".cpp") &&? (sizeP >? 131072)