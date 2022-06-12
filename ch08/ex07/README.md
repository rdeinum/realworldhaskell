## Exercise 7

Modify the type signature of namesMatching so that it encodes the possibility of a bad pattern, and make it use your rewritten globToRegex function.

### Answer

```ghci
Prelude> :l Glob
[1 of 2] Compiling GlobRegex        ( GlobRegex.hs, interpreted )
[2 of 2] Compiling Glob             ( Glob.hs, interpreted )
Ok, two modules loaded.
*Glob> namesMatching "*"
["Glob.hs","GlobRegex.hs","README.md"]
*Glob> namesMatching "["
[]
```