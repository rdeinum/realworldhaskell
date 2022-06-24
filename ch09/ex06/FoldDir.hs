module FoldDir where

import ControlledVisit(FileInfo (path), getFileInfo, isDirectory)
import System.Directory(listDirectory)
import System.FilePath((</>), takeFileName, takeExtension)
import Data.Char(toLower)

import qualified ControlledVisit as CV

data FoldState a = 
    Done     { accumulator :: a } | 
    Skip     { accumulator :: a } | 
    Continue { accumulator :: a }
    deriving (Show)

type FoldFunction a = a -> FileInfo -> FoldState a

foldDirectory :: FoldFunction a -> a -> FilePath -> IO a
foldDirectory f acc dir = do
    state <- fold acc dir
    return (accumulator state)
    where
        fold acc dir' = listDirectory dir' >>= walk acc
        walk acc (name:names) = do
            let path = dir </> name
            info <- getFileInfo path
            case f acc info of
                state@(Done _) -> return state
                Skip acc       -> walk acc names
                Continue acc
                    | isDirectory info -> do
                        state  <- fold acc path
                        case state of
                            state@(Done _) -> return state
                            state          -> walk (accumulator state) names
                    | otherwise -> walk acc names
        walk acc _ = return (Continue acc)

atMostThreePictures :: FoldFunction [FilePath]
atMostThreePictures acc info
    | length acc == 3                                 = Done acc
    | isDirectory info && takeFileName path == ".svn" = Skip acc
    | extension `elem` [".jpg", ".png"]               = Continue (path:acc)
    | otherwise                                       = Continue acc
    where
        path = CV.path info
        extension = map toLower (takeExtension path)

countDirectories :: FoldFunction Integer
countDirectories acc info = Continue (if isDirectory info then acc + 1 else acc)