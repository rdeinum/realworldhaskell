## Exercise 7
The `foldTree` function performs preorder traversal. Modify it to allow the caller to determine the order of traversal.

### Answer
See implementation of `foldDirectory` in [foldDir.hs](foldDir.hs). The 3rd parameter now is of type `([FileInfo] -> [FileInfo])` instead of `([FilePath] -> [FilePath])`. This lets us determine the order of traversal based on other file charactaristics instead of only its path. So now we could also switch to postorder traversal like so:

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l FoldDir.hs 
[1 of 2] Compiling ControlledVisit  ( ControlledVisit.hs, interpreted )
[2 of 2] Compiling FoldDir          ( FoldDir.hs, interpreted )
Ok, two modules loaded.
*FoldDir> import Data.List
*FoldDir Data.List> foldDirectory atMostThreePictures [] (sortOn $ CV.size) "."
```