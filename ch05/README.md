# Chapter 5

## Example 1

```bash
ghc SimpleJSON.hs
ghc -o simple Main.hs
```

## Example 2

```bash
ghci> :l PutJSON.hs
ghci> putJValue (JObject [("foo", JNumber 1), ("bar", JBool False)])
```

## Example 3

```bash
ghci> :l PrettyJSON.hs
ghci> import Prettify
ghci> putStrLn . compact $ renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
ghci> putStrLn . pretty 80 $ renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
```

## Exercise 1

. Our current pretty printer is spartan so that it will fit within our space constraints,
but there are a number of useful improvements we can make.
Write a function, fill , with the following type signature:

```haskell
-- file: ch05/Prettify.hs
fill :: Int -> Doc -> Doc
```

It should add spaces to a document until it is the given number of columns wide.
If it is already wider than this value, it should not add any spaces.

### Answer

```bash
ghci> :l Prettify.hs
ghci> fill 5 $ text "hello"
ghci> fill 6 $ text "hello"
ghci> fill 7 $ text "hello"
```