module PrettyJSON(renderJValue) where

import Control.Applicative((<|>))
import Data.Bits(shiftR, (.&.))
import Data.Char(ord)
import Data.Maybe(fromMaybe)
import Numeric(showHex)
import Prettify(Doc, text, double, char, fsep, (<++>))
import SimpleJSON(JValue(..))

renderJValue :: JValue -> Doc
renderJValue (JBool True)   = text "true"
renderJValue (JBool False)  = text "false"
renderJValue JNull          = text "null"
renderJValue (JNumber num)  = double num
renderJValue (JString str)  = string str
renderJValue (JArray ary)   = series '[' ']' renderJValue ary
renderJValue (JObject obj)  = series '{' '}' field obj
  where field (name, val) = string name <++> text ": " <++> renderJValue val

series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close jrenderer = enclose open close . fsep . punctuate (char ',') . map jrenderer

string :: String -> Doc
string = enclose '"' '"' . text . escapeString

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

punctuate :: Doc -> [Doc] -> [Doc]
punctuate p []     = []
punctuate p [x]    = [x]
punctuate p (x:xs) = (x <++> p) : punctuate p xs

enclose :: Char -> Char -> Doc -> Doc
enclose left right doc = char left <++> doc <++> char right