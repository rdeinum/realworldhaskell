## Exercise 6
Modify `foldTree` to allow the caller to change the order of traversal of entries in a directory.

### Answer
I completely rewrote the identifiers in [ControlledVisit.hs](ControlledVisit.hs) and [FoldDir.hs](FoldDir.hs) because they did'nt help me in understanding the code. After having refactored the code I added a parameter to the `foldDirectory` function which can be used to control the order of traversal:

```haskell
foldDirectory :: FoldFunction a -> a -> ([FilePath] -> [FilePath]) -> FilePath -> IO a
```

The 3rd parameter `([FilePath] -> [FilePath])` controls the order of traversal, see the implementation of `foldDirectory` in [FoldDir.hs](FoldDir.hs) for more details.