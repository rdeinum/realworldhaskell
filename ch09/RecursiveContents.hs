module RecursiveContents(getRecursiveContents) where

import Control.Monad(forM)
import System.Directory(doesDirectoryExist, getDirectoryContents)
import System.FilePath((</>))
import System.Posix (isDirectory)

getRecursiveContents :: FilePath -> IO [FilePath]
getRecursiveContents dir = do
    entries <- getDirectoryContents dir
    let entries' = filter (`notElem` [".", ".."]) entries
    paths <- forM entries' $ \entry -> do
        let path = dir </> entry
        isDirectory <- doesDirectoryExist path
        if isDirectory then getRecursiveContents path else return [path]
    return $ concat paths