module Prettify (Doc, empty, char, text, line, (<++>), double, fsep, compact, pretty) where

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
compact doc = transform [doc]
  where transform []     = ""
        transform (d:ds) =
          case d of
            Empty        -> transform ds
            Char c       -> c : transform ds
            Text s       -> s ++ transform ds
            Line         -> '\n' : transform ds
            a `Concat` b -> transform (a:b:ds)
            _ `Union` b  -> transform (b:ds)

pretty :: Int -> Doc -> String
pretty width doc = transform 0 [doc]
  where transform col (d:ds) =
          case d of
            Empty              -> transform col ds
            Char c             -> c : transform (col + 1) ds
            Text s             -> s ++ transform (col + length s) ds
            Line               -> '\n' : transform 0 ds
            a `Concat` b       -> transform col (a:b:ds)
            fline `Union` line -> nicest col (transform col (fline:ds)) (transform col (line:ds))
        transform _ _        = ""
        nicest col a b
          | a `fits` (width - col) = a 
          | otherwise              = b

fits :: String -> Int -> Bool
fits "" _            = True
fits ('\n':_) _      = True
fits string maxWidth = length string - maxWidth < 0