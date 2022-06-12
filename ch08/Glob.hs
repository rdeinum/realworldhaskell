module Glob(namesMatching, matchesGlob) where

import System.Directory (doesDirectoryExist, doesFileExist, getCurrentDirectory, getDirectoryContents)
import System.FilePath (dropTrailingPathSeparator, splitFileName, (</>), pathSeparator, makeRelative)
import System.Posix.Files(fileExist)
import Control.Exception (handle, SomeException (SomeException))
import Control.Monad (forM, filterM)
import Data.Char (toLower, toUpper)

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
                let listDir = case baseName of
                        "**"                  -> listDirsR
                        name | isPattern name -> listMatches
                             | otherwise      -> listPlain
                pathNames <- forM dirs $ \dir -> do
                    baseNames <- listDir dir baseName
                    let baseNames' = map (dir </>) baseNames
                    return (map (makeRelative ".") baseNames')
                return (concat pathNames)

isPattern :: String -> Bool
isPattern = any (`elem` "[?*")

doesNameExist :: FilePath -> IO Bool
doesNameExist name
    | isUnix  = fileExist name
    | otherwise = do
        fileExists <- doesFileExist name
        if fileExists then return True else doesDirectoryExist name

isUnix :: Bool
isUnix = pathSeparator == '/'

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

listPlain :: FilePath -> String -> IO [String]
listPlain dirName baseName = do
    exists <- if null baseName
              then doesDirectoryExist dirName
              else doesNameExist (dirName </> baseName)
    return [baseName | exists]

listDirsR :: FilePath -> String -> IO [String]
listDirsR dirName baseName
        | null dirName = listDirsR "." baseName
        | otherwise    = do
            dirExists <- doesDirectoryExist dirName
            if dirExists then listDirsR' dirName else return []

listDirsR' :: FilePath -> IO [FilePath]
listDirsR' dir = do
        dirs <- getDirectoryContents dir
        let dirs' = filter isNotSpecialDir dirs
        let dirs'' = map (dir </>) dirs'
        dirs''' <- filterM doesDirectoryExist dirs''
        dirs'''' <- forM dirs''' listDirsR'
        return (dir : concat dirs'''')
    where isNotSpecialDir dir = dir `notElem` [".", ".."]

matchesGlob :: FilePath -> String -> Bool -> Bool
matchesGlob [] [] _                           = True
matchesGlob _ [] _                            = False
matchesGlob _ "*" _                           = True
matchesGlob [] _ _                            = False
matchesGlob (_:ns) ('?':gs) matchCase         = matchesGlob ns gs matchCase
matchesGlob ns ('[':'!':gs) matchCase         = notMatchClass ns gs matchCase
matchesGlob ns ('[':gs) matchCase             = matchClass ns gs matchCase
matchesGlob nns@(n:ns) ggs@('*':gs) matchCase = matchesGlob nns gs matchCase || matchesGlob ns ggs matchCase
matchesGlob (n:ns) (g:gs) matchCase           = matchChar n g matchCase && matchesGlob ns gs matchCase

matchClass :: String -> String -> Bool -> Bool
matchClass _ [] _        = False
matchClass [] _ _        = False
matchClass _ (']':_) _   = False
matchClass nns@(n:ns) (g:gs) matchCase
    | matchChar n g True = matchesGlob ns (finishClass gs) matchCase
    | otherwise          = matchClass nns gs matchCase
    where finishClass = tail . dropWhile (/= ']')

notMatchClass :: String -> String -> Bool -> Bool 
notMatchClass _ [] _                      = False
notMatchClass [] _ _                      = False
notMatchClass (n:ns) (']':gs) matchCase   = matchesGlob ns gs matchCase
notMatchClass nns@(n:ns) (g:gs) matchCase = not (matchChar n g True) && notMatchClass nns gs matchCase

matchChar :: Char -> Char -> Bool -> Bool
matchChar x y matchCase
    | matchCase = x == y
    | otherwise = toUpper x == toUpper y