module Glob(namesMatching) where

import GlobRegex ( matchesGlob )
import System.Directory (doesDirectoryExist, doesFileExist, getCurrentDirectory, getDirectoryContents)
import System.FilePath (dropTrailingPathSeparator, splitFileName, (</>), pathSeparator, makeRelative)
import System.Posix.Files(fileExist)
import Control.Exception (handle, SomeException (SomeException))
import Control.Monad (forM)

isPattern :: String -> Bool
isPattern = any (`elem` "[?*")

namesMatching :: String -> IO [String]
namesMatching globPattern
    | not (isPattern globPattern) = do 
        nameExists <- doesNameExist globPattern
        return [globPattern | nameExists]
    | otherwise                   = 
        case splitFileName globPattern of
            ("", baseName) -> do
                curDir <- getCurrentDirectory
                listMatches curDir baseName
            (dirName, baseName) -> do
                dirs <- if isPattern dirName
                        then namesMatching (dropTrailingPathSeparator dirName)
                        else return [dirName]
                let listDir = if isPattern baseName then listMatches else listPlain
                pathNames <- forM dirs $ \dir -> do
                    baseNames <- listDir dir baseName
                    let baseNames' = map (dir </>) baseNames
                    return (map (makeRelative ".") baseNames')
                return (concat pathNames)

doesNameExist :: FilePath -> IO Bool
doesNameExist name
    | isUnix  = fileExist name
    | otherwise = do
        fileExists <- doesFileExist name
        if fileExists then return True else doesDirectoryExist name

listMatches :: FilePath -> String -> IO [String]
listMatches dirName baseName = do
    dirName' <- if null dirName then getCurrentDirectory else return dirName
    handle errorHandler $ do
        names <- getDirectoryContents dirName'
        let names' = if isHidden baseName then filter isHidden names else filter (not . isHidden) names
        return (filter (\name -> matchesGlob name baseName isUnix) names')
    where 
        errorHandler :: SomeException -> IO [String]
        errorHandler = const (return [])

isHidden :: String -> Bool
isHidden ('.':_) = True
isHidden _       = False

isUnix :: Bool
isUnix = pathSeparator == '/'

listPlain :: FilePath -> String -> IO [String]
listPlain dirName baseName = do
    exists <- if null baseName
              then doesDirectoryExist dirName
              else doesNameExist (dirName </> baseName)
    return [baseName | exists]