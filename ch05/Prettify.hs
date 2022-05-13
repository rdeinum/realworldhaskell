module Prettify (Doc, string, text, double) where

import Control.Applicative((<|>))
import Data.Bits(shiftR, (.&.))
import Data.Char(ord)
import Data.Maybe(fromMaybe)
import Numeric(showHex)

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
string = text . escapeString

escapeString :: String -> String
escapeString = concat . map escapeChar

escapeChar :: Char -> String
escapeChar x = fromMaybe [x] $ maybeSimpleEscapeChar x <|> maybeHexEscapeChar x

maybeSimpleEscapeChar :: Char -> Maybe String
maybeSimpleEscapeChar x = lookup x simpleEscapes

simpleEscapes :: [(Char, String)]
simpleEscapes = zipWith escape "\b\n\f\r\t\\\"/" "bnfrt\\\"/"
  where escape x y = (x, ['\\', y])

maybeHexEscapeChar :: Char -> Maybe String
maybeHexEscapeChar x
  | x < ' ' || x == '\x7f' || x > '\xff' = Just $ hexEscapeChar x
  | otherwise                            = Nothing

hexEscapeChar :: Char -> String
hexEscapeChar x
  | y < 0x10000 = hexify y
  | otherwise   = astral (y - 0x10000)
  where y = ord x

hexify :: Int -> String
hexify x = "\\u" ++ replicate (4 - length h) '0' ++ h
  where h = showHex x ""

astral :: Int -> String
astral x = hexify (a + 0xd800) ++ hexify (b + 0xdc00)
  where a = (x `shiftR` 10) .&. 0x3ff
        b = x .&. 0x3ff