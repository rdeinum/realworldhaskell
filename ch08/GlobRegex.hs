module GlobRegex(globToRegex, matchesGlob) where

import Text.Regex.Posix

globToRegex :: String -> String
globToRegex xs = '^' : globToRegex' xs ++ "$"

globToRegex' :: String -> String
globToRegex' []           = ""
globToRegex' ('*':xs)     = ".*" ++ globToRegex' xs
globToRegex' ('?':xs)     = '.' : globToRegex' xs
globToRegex' ('[':'!':xs) = "[^" ++ charClass xs
globToRegex' ('[':xs)     = '[' : charClass xs
globToRegex' (x:xs)       = escape x ++ globToRegex' xs

escape :: Char -> String
escape x = if x `elem` escapables then "\\" ++ [x] else [x]
  where escapables = "\\+()^$.{}|"

charClass :: String -> String
charClass (']':xs) = ']' : globToRegex' xs
charClass (x:xs)   = x : charClass xs
charClass []       = error "Unterminated character class"

matchesGlob :: FilePath -> String -> Bool
filepath `matchesGlob` pat = filepath =~ globToRegex pat