module FoldDir where

import ControlledVisit(Info, getUsefulDirContents, getInfo, isDirectory)
import System.FilePath ( (</>) )

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
                    | otherwise        -> walk seed' names
        walk seed _ = return (Continue seed)