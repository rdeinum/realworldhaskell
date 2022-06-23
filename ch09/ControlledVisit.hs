module ControlledVisit where

import System.Directory (Permissions (searchable), getDirectoryContents, getPermissions, getFileSize, getModificationTime)
import System.FilePath ( (</>) )
import Data.Time (UTCTime)
import Control.Monad (liftM, forM)
import Prelude hiding (traverse)
import Control.Exception (handle, SomeException (SomeException))

data Info = Info {
    infoPath :: FilePath,
    infoPerms :: Maybe Permissions,
    infoSize :: Maybe Integer,
    infoModTime :: Maybe UTCTime
} deriving (Eq, Ord, Show)

getInfo :: FilePath -> IO Info
getInfo path = do
    perms <- maybeIO $ getPermissions path
    size <- maybeIO $ getFileSize path
    modTime <- maybeIO $ getModificationTime path
    return (Info path perms size modTime)

maybeIO :: IO a -> IO (Maybe a)
maybeIO action = handle catch $ Just <$> action
    where catch :: SomeException -> IO (Maybe a)
          catch _ = return Nothing

traverse :: ([Info] -> [Info]) -> FilePath -> IO [Info]
traverse order dir = do
    entries <- getUsefulDirContents dir
    infos <- mapM getInfo (dir : map (dir </>) entries)
    fmap concat $ forM (order infos) $ \info -> 
        if isDirectory info && infoPath info /= dir
            then traverse order (infoPath info)
            else return [info]

getUsefulDirContents :: FilePath -> IO [String]
getUsefulDirContents dir = do
    entries <- getDirectoryContents dir
    return (filter (`notElem` [".", ".."]) entries)

isDirectory :: Info -> Bool
isDirectory = maybe False searchable . infoPerms