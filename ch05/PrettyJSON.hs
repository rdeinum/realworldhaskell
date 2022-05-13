module PrettyJSON(renderJValue) where

import SimpleJSON(JValue(..))
import Prettify(Doc, text, double, string)

renderJValue :: JValue -> Doc
renderJValue (JBool True)   = text "true"
renderJValue (JBool False)  = text "false"
renderJValue JNull          = text "null"
renderJValue (JNumber num)  = double num
renderJValue (JString str)  = string str
renderJValue (JArray ary)   = series '[' ']' renderJValue ary
renderJValue (JObject obj)  = undefined -- TODO

series :: JValue a => Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close renderer values = undefined -- TODO