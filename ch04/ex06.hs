-- 3. Extend your function to handle the following kinds of exceptional conditions by
-- calling error :
-- ghci> asInt_fold ""
-- 0
-- ghci> asInt_fold "-"
-- 0
-- ghci> asInt_fold "-3"
-- -3
-- ghci> asInt_fold "2.7"
-- *** Exception: Char.digitToInt: not a digit '.'
-- ghci> asInt_fold "314159265358979323846"
-- 564616105916946374

import Data.Char (digitToInt)

asIntFold :: String -> Int
asIntFold [] = 0
asIntFold xxs@(x:xs) 
    | x == '-'  = (-1) * asIntFold xs
    | otherwise = foldl (\acc x -> acc * 10 + digitToInt x) 0 xxs