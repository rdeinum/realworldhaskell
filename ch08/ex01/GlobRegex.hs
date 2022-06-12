module GlobRegex(globToRegex, matchesGlob) where

import Text.Regex.Posix ( (=~) )
import Data.Char ()
import Control.Monad ()

globToRegex :: String -> String
globToRegex cs = '^' : globToRegex' cs ++ "$"

globToRegex' :: String -> String
globToRegex' ""             = ""
globToRegex' ('*':cs)       = ".*" ++ globToRegex' cs
globToRegex' ('?':cs)       = '.' : globToRegex' cs
globToRegex' ('[':'!':c:cs) = "[^" ++ c : charClass cs
globToRegex' ('[':c:cs)     = '[' : c : charClass cs
globToRegex' (c:cs)         = escape c ++ globToRegex' cs

escape :: Char -> String
escape c
    | c `elem` escapables = "\\" ++ [c]
    | otherwise           = [c]
    where escapables = "\\+()^$.{}|"

charClass :: String -> String
charClass (']':cs) = ']' : globToRegex' cs
charClass (c:cs)   = c : charClass cs
charClass []       = error "Unterminated character class"

matchesGlob :: FilePath -> String -> Bool
ns `matchesGlob` gs = ns =~ globToRegex gs