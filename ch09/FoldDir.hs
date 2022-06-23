module FoldDir where

import ControlledVisit(Info (infoPath), getUsefulDirContents, getInfo, isDirectory)
import System.FilePath((</>), takeFileName, takeExtension)
import Data.Char(toLower)

data Iterate a = 
    Done     { unwrap :: a } | 
    Skip     { unwrap :: a } | 
    Continue { unwrap :: a }
    deriving (Show)

type Iterator a = a -> Info -> Iterate a

foldTree :: Iterator a -> a -> FilePath -> IO a
foldTree iterator initSeed path = do
    endSeed <- fold initSeed path
    return (unwrap endSeed)
    where 
        fold seed subpath = getUsefulDirContents subpath >>= walk seed
        walk seed (name:names) = do
            let path' = path </> name
            info <- getInfo path'
            case iterator seed info of
                done@(Done _)  -> return done
                Skip seed'     -> walk seed' names
                Continue seed'
                    | isDirectory info -> do
                        next  <- fold seed' path'
                        case next of
                            done@(Done _) -> return done
                            seed''        -> walk (unwrap seed'') names
                    | otherwise -> walk seed' names
        walk seed _ = return (Continue seed)

atMostThreePictures :: Iterator [FilePath]
atMostThreePictures paths info
    | length paths == 3                               = Done paths
    | isDirectory info && takeFileName path == ".svn" = Skip paths
    | extension `elem` [".jpg", ".png"]               = Continue (path:paths)
    | otherwise                                       = Continue paths
    where
        path = infoPath info
        extension = map toLower (takeExtension path)

countDirectories :: Iterator Integer
countDirectories count info = Continue (if isDirectory info then count + 1 else count)