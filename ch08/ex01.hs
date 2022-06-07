import GlobRegex(globToRegex)

malformedGlobToRegex :: String
malformedGlobToRegex = globToRegex "[" True