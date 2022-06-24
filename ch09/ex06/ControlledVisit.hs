module ControlledVisit where

import System.Directory (Permissions (searchable), getDirectoryContents, getPermissions, getFileSize, getModificationTime, listDirectory)
import System.FilePath ( (</>) )
import Data.Time (UTCTime)
import Control.Monad (liftM, forM)
import Prelude hiding (traverse)
import Control.Exception (handle, SomeException (SomeException))

data FileInfo = FileInfo {
    path :: FilePath,
    perms :: Maybe Permissions,
    size :: Maybe Integer,
    modTime :: Maybe UTCTime
} deriving (Eq, Ord, Show)

getFileInfo :: FilePath -> IO FileInfo
getFileInfo path = do
    perms <- maybeIO $ getPermissions path
    size <- maybeIO $ getFileSize path
    modTime <- maybeIO $ getModificationTime path
    return (FileInfo path perms size modTime)

maybeIO :: IO a -> IO (Maybe a)
maybeIO action = handle catch $ Just <$> action
    where catch :: SomeException -> IO (Maybe a)
          catch _ = return Nothing

traverse :: ([FileInfo] -> [FileInfo]) -> FilePath -> IO [FileInfo]
traverse order dir = do
    entries <- listDirectory dir
    infos <- mapM getFileInfo (dir : map (dir </>) entries)
    fmap concat $ forM (order infos) $ \info -> 
        if isDirectory info && path info /= dir
            then traverse order (path info)
            else return [info]

isDirectory :: FileInfo -> Bool
isDirectory = maybe False searchable . perms