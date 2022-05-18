# Chapter 5

# Example 1

```bash
ghc SimpleJSON.hs
ghc -o simple Main.hs
```

# Example 2

```bash
ghci> :l PutJSON.hs
ghci> putJValue (JObject [("foo", JNumber 1), ("bar", JBool False)])
```

# Example 3

```bash
ghci> :l PrettyJSON.hs
ghci> import Prettify
ghci> putStrLn $ compact $ renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
ghci> putStrLn $ pretty 80 $ renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
```