## Exercise 2
What should you pass to `traverse` to traverse a directory tree in reverse alphabetic order?

### Answer

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l ControlledVisit.hs 
[1 of 1] Compiling ControlledVisit  ( ControlledVisit.hs, interpreted )
Ok, one module loaded.
*ControlledVisit> import Data.List
*ControlledVisit Data.List> import Data.Ord
*ControlledVisit Data.List Data.Ord> traverse (sortBy $ flip $ comparing infoPath) "."
[Info {infoPath = "./README.md", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = False}), infoSize = Just 1073, infoModTime = Just 2022-06-23 10:09:22.166956928 UTC},Info {infoPath = "./ControlledVisit.hs", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = False}), infoSize = Just 1513, infoModTime = Just 2022-06-23 09:07:39.748463127 UTC},Info {infoPath = ".", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = True}), infoSize = Just 4096, infoModTime = Just 2022-06-23 10:09:09.314846845 UTC}]
```