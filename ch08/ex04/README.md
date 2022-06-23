## Exercise 4

If you’re on a Unix-like system, look through the documentation for the System.Posix.Files module, and see if you can find a replacement for the doesNameExist function.

### Answer

Imported in `Glob.hs`:

```haskell
import System.Posix.Files(fileExist)
```

And changed `doesNameExist` to use the `fileExist` function if `isUnix` evaluates to `True`:

```haskell
doesNameExist :: FilePath -> IO Bool
doesNameExist name
    | isUnix  = fileExist name
    | otherwise = do
        fileExists <- doesFileExist name
        if fileExists then return True else doesDirectoryExist name
```

When run on Unix in GHCi:

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l Glob.hs 
[1 of 2] Compiling GlobRegex        ( GlobRegex.hs, interpreted )
[2 of 2] Compiling Glob             ( Glob.hs, interpreted )
Ok, two modules loaded.
*Glob> namesMatching "Gl*"
["Glob.hs","GlobRegex.hs"]
*Glob> namesMatching "gl*"
[]
```