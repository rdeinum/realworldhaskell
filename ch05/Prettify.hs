module Prettify (Doc, string, text, double) where

data Doc = Empty
         | Char Char
         | Text String
         | Line
         | Concat Doc Doc
         | Union Doc Doc
           deriving (Show, Eq)

text :: String -> Doc
text ""  = Empty
text xs = Text xs

double :: Double -> Doc
double = text . show

string :: String -> Doc
string = text . escapeChars

escapeChars :: String -> String
escapeChars = concat . map escapeChar

escapeChar :: Char -> String
escapeChar x = case simpleEscapeChar x of
               Just y -> y
               Nothing -> [x]

simpleEscapeChar :: Char -> Maybe String
simpleEscapeChar x = lookup x simpleEscapes

simpleEscapes :: [(Char, String)]
simpleEscapes = zipWith escape "\b\n\f\r\t\\\"/" "bnfrt\\\"/"
  where escape x y = (x, ['\\', y])

hexEscapeChar :: Char -> Maybe String
hexEscapeChar x
  | x < ' ' || x == '\x7f' || x > '\xff' = undefined
  | otherwise                            = Nothing