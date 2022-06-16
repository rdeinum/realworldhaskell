module SimpleFinder(simpleFind) where

import RecursiveContents(getRecursiveContents)

simpleFind :: (FilePath -> Bool) -> FilePath -> IO [FilePath]
simpleFind match dir = do
    paths <- getRecursiveContents dir
    return (filter match paths)