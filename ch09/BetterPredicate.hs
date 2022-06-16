module BetterPredicate where

import Control.Monad(filterM)
import System.Directory(Permissions(..), getModificationTime, getPermissions)
import Data.Time(UTCTime(..))
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