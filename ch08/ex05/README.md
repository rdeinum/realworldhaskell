## Exercise 5

The * wild card matches names only within a single directory. Many shells have an extended wild card syntax, ** , that matches names recursively in all directories. For example, **.c would mean “match a name ending in .c in this directory or any subdirectory at any depth”. Implement matching on ** wild cards.

### Answer

Changed the part of `namesMatching` where the function for matching is determined:

```haskell
let listDir = case baseName of
        "**"                  -> listDirsR
        name | isPattern name -> listMatches
             | otherwise      -> listPlain
```

The `listDirsR` function is used for listing a directory and all its subdirectories:

```haskell
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
```

When run in GHCi:

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l Glob
[1 of 2] Compiling GlobRegex        ( GlobRegex.hs, interpreted )
[2 of 2] Compiling Glob             ( Glob.hs, interpreted )
Ok, two modules loaded.
*Glob> namesMatching "**/*.txt"
["a/cow.txt","a/b/monkey.txt","a/b/c/rat.txt"]
```