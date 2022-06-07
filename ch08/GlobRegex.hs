module GlobRegex(globToRegex, matchesGlob) where

import Text.Regex.Posix
import Data.Char

globToRegex :: String -> Bool -> String
globToRegex globPattern caseSensitive = '^' : globToRegex' globPattern caseSensitive ++ "$"

globToRegex' :: String -> Bool -> String
globToRegex' []           _             = ""
globToRegex' ('*':xs)     caseSensitive = ".*" ++ globToRegex' xs caseSensitive
globToRegex' ('?':xs)     caseSensitive = '.' : globToRegex' xs caseSensitive
globToRegex' ('[':'!':xs) caseSensitive = "[^" ++ charClass xs caseSensitive
globToRegex' ('[':xs)     caseSensitive = '[' : charClass xs caseSensitive
globToRegex' (x:xs)       caseSensitive = escape x caseSensitive ++ globToRegex' xs caseSensitive

charClass :: String -> Bool -> String
charClass (']':xs) caseSensitive = ']' : globToRegex' xs caseSensitive
charClass (x:xs)   caseSensitive = x : charClass xs caseSensitive
charClass []       _             = error "Unterminated character class"

escape :: Char -> Bool -> String
escape x caseSensitive = if x `elem` escapables then "\\" ++ [x] else chaseCase x
  where escapables = "\\+()^$.{}|"
        chaseCase x
            | caseSensitive = [x]
            | otherwise     = '(' : toLower x : '|' : toUpper x : ")"

matchesGlob :: FilePath -> String -> Bool -> Bool
matchesGlob filePath globPattern caseSensitive = filePath =~ globToRegex globPattern caseSensitive