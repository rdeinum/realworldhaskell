## Exercise 1

Is the order in which we call bracket and handle important? Why?

### Answer

If you flip the order of `brackets` and `handle` you get:

```haskell
getFileSize :: FilePath -> IO (Maybe Integer)
getFileSize path = bracket (openFile path ReadMode) hClose $ \h -> do
    handle catch $ do
        size <- hFileSize h
        return (Just size)
    where catch :: SomeException  -> IO (Maybe Integer)
          catch _ = return Nothing
```

When `openFile` raises an exception, e.g. if `path` is a directory instead of a file, then that exception will not be taken care of:

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l BetterPredicate
[1 of 1] Compiling BetterPredicate  ( BetterPredicate.hs, interpreted )
Ok, one module loaded.
*BetterPredicate> getFileSize "."
*** Exception: .: openFile: inappropriate type (is a directory)
```