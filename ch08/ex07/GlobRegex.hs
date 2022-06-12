module GlobRegex(globToRegex, matchesGlob) where

import Text.Regex.Posix ( (=~) )
import Data.Char (toLower, toUpper)
import Control.Monad (liftM)

type GlobError = String

globToRegex :: String -> Bool -> Either GlobError String
globToRegex cs matchCase = liftM (\regex -> '^' : regex ++ "$") $ globToRegex' cs matchCase

globToRegex' :: String -> Bool -> Either GlobError String
globToRegex' "" _                     = Right ""
globToRegex' ('*':cs) matchCase       = liftM (".*" ++) $ globToRegex' cs matchCase
globToRegex' ('?':cs) matchCase       = liftM ('.' :) $ globToRegex' cs matchCase
globToRegex' ('[':'!':cs) matchCase   = liftM ("[^" ++) $ charClass cs matchCase
globToRegex' ('[':cs) matchCase       = liftM ('[' :) $ charClass cs matchCase
globToRegex' (c:cs) matchCase         = liftM (escape c matchCase ++) $ globToRegex' cs matchCase

escape :: Char -> Bool -> String
escape c matchCase
    | c `elem` escapables = "\\" ++ [c]
    | otherwise           = chaseCase
    where escapables = "\\+()^$.{}|"
          chaseCase
                | matchCase = [c]
                | otherwise = '(' : toLower c : '|' : toUpper c : ")"

charClass :: String -> Bool -> Either GlobError String
charClass (']':cs) matchCase = liftM (']' :) $ globToRegex' cs matchCase
charClass (c:cs) matchCase   = liftM (c :) $ charClass cs matchCase
charClass [] matchCase       = Left "Unterminated character class"

matchesGlob :: FilePath -> String -> Bool -> Bool
matchesGlob ns gs matchCase = 
      case globToRegex gs matchCase of
            Left error -> False
            Right regex -> ns =~ regex