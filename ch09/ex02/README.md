## Exercise 2
What should you pass to `traverse` to traverse a directory tree in reverse alphabetic order?

### Answer
Passing `(sortBy $ \x y -> compare y x)` to `traverse` should do the trick:

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l ControlledVisit.hs 
[1 of 1] Compiling ControlledVisit  ( ControlledVisit.hs, interpreted )
Ok, one module loaded.
*ControlledVisit> import Data.List
*ControlledVisit Data.List> traverse (sortBy $ \x y -> compare y x) "."
[Info {infoPath = "./README.md", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = False}), infoSize = Just 135, infoModTime = Just 2022-06-23 09:07:16.460308527 UTC},Info {infoPath = "./ControlledVisit.hs", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = False}), infoSize = Just 1513, infoModTime = Just 2022-06-23 09:07:39.748463127 UTC},Info {infoPath = ".", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = True}), infoSize = Just 4096, infoModTime = Just 2022-06-23 09:07:39.748463127 UTC}]
```