## Exercise 8
Glob patterns are simple enough to interpret that it’s easy to write a matcher directly in Haskell, rather than going through the regexp machinery. Give it a try.

### Answer

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l Glob.hs 
[1 of 1] Compiling Glob             ( Glob.hs, interpreted )
Ok, one module loaded.
*Glob> namesMatching "*.md"
["README.md"]
*Glob> 
```