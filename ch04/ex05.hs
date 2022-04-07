-- 1. Use a fold (choosing the appropriate fold will make your code much simpler) to
-- rewrite and improve upon the asInt function from the earlier section“Explicit Re-
-- cursion” on page 85.
-- How to Think About Loops | 97-- file: ch04/ch04.exercises.hs
-- asInt_fold :: String -> Int
-- 2. Your function should behave as follows:
-- ghci> asInt_fold "101"
-- 101
-- ghci> asInt_fold "-31337"
-- -31337
-- ghci> asInt_fold "1798"
-- 1798

import Data.Char (digitToInt)

asInt_fold :: String -> Int
asInt_fold = foldl (\acc x -> acc * 10 + digitToInt x) 0
