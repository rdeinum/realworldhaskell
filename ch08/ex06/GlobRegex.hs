module GlobRegex(globToRegex, matchesGlob) where

import Text.Regex.Posix
import Data.Char
import Control.Monad

type GlobError = String

globToRegex :: String -> Bool -> Either GlobError String
globToRegex globPattern caseSensitive = liftM (\regex -> '^' : regex ++ "$") $ globToRegex' globPattern caseSensitive

globToRegex' :: String -> Bool -> Either GlobError String
globToRegex' []           _             = Right ""
globToRegex' ('*':xs)     caseSensitive = liftM (".*" ++) $ globToRegex' xs caseSensitive
globToRegex' ('?':xs)     caseSensitive = liftM ('.' :) $ globToRegex' xs caseSensitive
globToRegex' ('[':'!':xs) caseSensitive = liftM ("[^" ++) $ charClass xs caseSensitive
globToRegex' ('[':xs)     caseSensitive = liftM ('[' :) $ charClass xs caseSensitive
globToRegex' (x:xs)       caseSensitive = liftM (escape x caseSensitive ++) $ globToRegex' xs caseSensitive

charClass :: String -> Bool -> Either GlobError String
charClass (']':xs) caseSensitive = liftM (']' :) $ globToRegex' xs caseSensitive
charClass (x:xs)   caseSensitive = liftM (x :) $ charClass xs caseSensitive
charClass []       _             = Left "Unterminated character class"

escape :: Char -> Bool -> String
escape x caseSensitive = if x `elem` escapables then "\\" ++ [x] else chaseCase x
  where escapables = "\\+()^$.{}|"
        chaseCase x
            | caseSensitive = [x]
            | otherwise     = '(' : toLower x : '|' : toUpper x : ")"

matchesGlob :: FilePath -> String -> Bool -> Bool
matchesGlob filePath globPattern caseSensitive = case globToRegex globPattern caseSensitive of
    Left error  -> False
    Right regex -> filePath =~ regex