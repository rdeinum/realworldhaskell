module Glob(namesMatching) where

import System.Directory (doesDirectoryExist, doesFileExist, getCurrentDirectory, getDirectoryContents)
import System.FilePath (dropTrailingPathSeparator, splitFileName, (</>), pathSeparator)
import System.Posix.Files(fileExist)
import Control.Exception (handle, SomeException (SomeException))
import Control.Monad (forM)
import GlobRegex (matchesGlob)
import Llvm (LlvmCallConvention(CC_Ghc))

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
                    return (map (dir </>) baseNames)
                return (concat pathNames)

isPattern :: String -> Bool
isPattern = any (`elem` "[?*")

doesNameExist :: FilePath -> IO Bool
doesNameExist name
    | isUnixFS  = fileExist name
    | otherwise = do
        fileExists <- doesFileExist name
        if fileExists then return True else doesDirectoryExist name

isUnixFS :: Bool
isUnixFS = pathSeparator == '/'

listMatches :: FilePath -> String -> IO [String]
listMatches dirName baseName = do
    dirName' <- if null dirName
                then getCurrentDirectory
                else return dirName
    handle errorHandler $ do
        names <- getDirectoryContents dirName'
        let names' = if isHidden baseName
                     then filter isHidden names
                     else filter (not . isHidden) names
        return (filter (\name -> matchesGlob name baseName isUnixFS) names')
    where 
        errorHandler :: SomeException -> IO [String]
        errorHandler = const (return [])

isHidden :: String -> Bool
isHidden ('.':_) = True
isHidden _       = False

listPlain :: FilePath -> String -> IO [String]
listPlain dirName baseName = do
    exists <- if null baseName
              then doesDirectoryExist dirName
              else doesNameExist (dirName </> baseName)
    return [baseName | exists]