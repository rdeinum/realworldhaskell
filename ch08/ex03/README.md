## Exercise 3

Although we’ve gone to some lengths to write a portable namesMatching function, the function uses our case sensitive globToRegex function. Find a way to modify namesMatching to be case-sensitive on Unix, and case insensitive on Windows, without modifying its type signature. (Hint: consider reading the documentation for System.FilePath to look for a variable that tells us whether we’re running on a Unix-like system or on Windows.)

### Answer

Added to `Glob.hs` the function `isUnix`:

```haskell
isUnix :: Bool
isUnix = pathSeparator == '/'
```

This function is used to determine if `matchesGlob` should be case sensitive:

```haskell
return (filter (\name -> matchesGlob name baseName isUnix) names')
```

When run on Unix in GHCi the matching will be done case sensitive:

```bash
Prelude> :l Glob.hs 
[1 of 2] Compiling GlobRegex        ( GlobRegex.hs, interpreted )
[2 of 2] Compiling Glob             ( Glob.hs, interpreted )
Ok, two modules loaded.
*Glob> namesMatching "Glob.hs"
["Glob.hs"]
*Glob> namesMatching "glob.hs"
[]
```