module Prettify (Doc, empty, char, text, line, (<++>), double, fsep, compact) where

data Doc = Empty
         | Char Char
         | Text String
         | Line
         | Concat Doc Doc
         | Union Doc Doc
           deriving (Show, Eq)

empty :: Doc
empty = Empty

char :: Char -> Doc
char = Char

text :: String -> Doc
text ""  = Empty
text xs = Text xs

line :: Doc
line = Line

(<++>) :: Doc -> Doc -> Doc
x <++> Empty = x
Empty <++> y = y
x <++> y     = x `Concat` y

double :: Double -> Doc
double = text . show

fsep :: [Doc] -> Doc
fsep = foldr (</>) empty

(</>) :: Doc -> Doc -> Doc
x </> y = x <++> softline <++> y
  where softline = flatten line `Union` line

flatten :: Doc -> Doc
flatten (x `Concat` y) = flatten x `Concat` flatten y
flatten Line          = char ' '
flatten (x `Union` _) = flatten x
flatten other         = other

compact :: Doc -> String
compact x = transform [x]
  where transform []     = ""
        transform (d:ds) =
          case d of
            Empty        -> transform ds
            Char c       -> c : transform ds
            Text s       -> s ++ transform ds
            Line         -> '\n' : transform ds
            a `Concat` b -> transform (a:b:ds)
            _ `Union` b  -> transform (b:ds)