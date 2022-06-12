module GlobRegex(globToRegex, matchesGlob) where

import Text.Regex.Posix ( (=~) )
import Data.Char (toLower, toUpper)
import Control.Monad ()

globToRegex :: String -> Bool -> String
globToRegex cs matchCase = '^' : globToRegex' cs matchCase ++ "$"

globToRegex' :: String -> Bool -> String
globToRegex' "" _                     = ""
globToRegex' ('*':cs) matchCase       = ".*" ++ globToRegex' cs matchCase
globToRegex' ('?':cs) matchCase       = '.' : globToRegex' cs matchCase
globToRegex' ('[':'!':c:cs) matchCase = "[^" ++ c : charClass cs matchCase
globToRegex' ('[':c:cs) matchCase     = '[' : c : charClass cs matchCase
globToRegex' (c:cs) matchCase         = escape c matchCase ++ globToRegex' cs matchCase

escape :: Char -> Bool -> String
escape c matchCase
    | c `elem` escapables = "\\" ++ [c]
    | otherwise           = chaseCase
    where escapables = "\\+()^$.{}|"
          chaseCase
                | matchCase = [c]
                | otherwise = '(' : toLower c : '|' : toUpper c : ")"

charClass :: String -> Bool -> String
charClass (']':cs) matchCase = ']' : globToRegex' cs matchCase
charClass (c:cs) matchCase   = c : charClass cs matchCase
charClass [] matchCase       = error "Unterminated character class"

matchesGlob :: FilePath -> String -> Bool -> Bool
matchesGlob ns gs matchCase = ns =~ globToRegex gs matchCase