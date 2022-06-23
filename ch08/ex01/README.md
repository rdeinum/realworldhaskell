## Exercise 1
Use ghci to explore what happens if you pass a malformed pattern, such as [ , to globToRegex . Write a small function that calls globToRegex , and pass it a malformed pattern. What happens?

### Answer

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l GlobRegex.hs 
[1 of 1] Compiling GlobRegex        ( GlobRegex.hs, interpreted )
Ok, one module loaded.
*GlobRegex> let f = globToRegex "[["
*GlobRegex> f
CallStack (from HasCallStack):
  error, called at GlobRegex.hs:27:22 in main:GlobRegex
```