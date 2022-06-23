## Exercise 3
Using `id` as a control function, `traverse id` performs a preorder traversal of a tree: it returns a parent directory before its children. Write a control function that makes `traverse` perform a postorder traversal, in which it returns children before their parent.

### Answer

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l ControlledVisit.hs 
[1 of 1] Compiling ControlledVisit  ( ControlledVisit.hs, interpreted )
Ok, one module loaded.
*ControlledVisit> import Data.List
*ControlledVisit Data.List> import Data.Ord
*ControlledVisit Data.List Data.Ord> traverse (sortBy $ flip $ comparing infoSize) "."
[Info {infoPath = ".", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = True}), infoSize = Just 4096, infoModTime = Just 2022-06-23 10:09:09.314846845 UTC},Info {infoPath = "./ControlledVisit.hs", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = False}), infoSize = Just 1513, infoModTime = Just 2022-06-23 09:07:39.748463127 UTC},Info {infoPath = "./README.md", infoPerms = Just (Permissions {readable = True, writable = True, executable = False, searchable = False}), infoSize = Just 1133, infoModTime = Just 2022-06-23 10:11:20.151968075 UTC}]
```