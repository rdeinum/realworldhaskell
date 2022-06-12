## Exercise 2

While filesystems on Unix are usually case-sensitive (e.g., “G” vs. “g”) in filenames, Windows filesystems are not. Add a parameter to the globToRegex and matchesGlob functions that allows control over case sensitive matching.

### Answer

```ghci
Prelude> :l GlobRegex.hs 
[1 of 1] Compiling GlobRegex        ( GlobRegex.hs, interpreted )
Ok, one module loaded.
*GlobRegex> globToRegex "abc" True
"^abc$"
*GlobRegex> globToRegex "abc" False
"^(a|A)(b|B)(c|C)$"
```