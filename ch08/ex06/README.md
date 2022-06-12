## Exercise 6

Write a version of globToRegex that uses the type signature shown earlier.

### Answer

```ghci
Prelude> :l GlobRegex.hs 
[1 of 1] Compiling GlobRegex        ( GlobRegex.hs, interpreted )
Ok, one module loaded.
*GlobRegex> globToRegex "*" True
Right "^.*$"
*GlobRegex> globToRegex "[" True
Left "Unterminated character class"
```