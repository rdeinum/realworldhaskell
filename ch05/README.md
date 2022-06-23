# Chapter 5

## Example 1

```bash
ghc SimpleJSON.hs
ghc -o simple Main.hs
```

## Example 2

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
ghci> :l PutJSON.hs
ghci> putJValue (JObject [("foo", JNumber 1), ("bar", JBool False)])
```

## Example 3

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
ghci> :l PrettyJSON.hs
ghci> import Prettify
ghci> putStrLn . compact $ renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
ghci> putStrLn . pretty 80 $ renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
```

## Exercise 1

Our current pretty printer is spartan so that it will fit within our space constraints, but there are a number of useful improvements we can make. Write a function, fill , with the following type signature:

```haskell
-- file: ch05/Prettify.hs
fill :: Int -> Doc -> Doc
```

It should add spaces to a document until it is the given number of columns wide. If it is already wider than this value, it should not add any spaces.

### Answer

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
ghci> :l Prettify.hs
ghci> fill 5 $ text "hello"
ghci> fill 6 $ text "hello"
ghci> fill 7 $ text "hello"
```

## Exercise 2

Our pretty printer does not take nesting into account. Whenever we open parentheses, braces, or brackets, any lines that follow should be indented so that they are aligned with the opening character until a matching closing character is encountered. Add support for nesting, with a controllable amount of indentation: 

```haskell
-- file: ch05/Prettify.hs
fill :: Int -> Doc -> Doc
```

### Answer

```ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
ghci> :l PrettyJSON.hs
ghci> import Prettify
ghci> putStrLn . indent 4 $ renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
```