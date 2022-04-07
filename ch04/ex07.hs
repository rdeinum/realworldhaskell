-- 4. The asInt_fold function uses error , so its callers cannot handle errors. Rewrite
-- the function to fix this problem:
-- -- file: ch04/ch04.exercises.hs
-- type ErrorMessage = String
-- asInt_either :: String -> Ei
-- ghci> asInt_either "33"
-- Right 33
-- ghci> asInt_either "foo"
-- Left "non-digit 'o'"

import Data.Char (digitToInt, isDigit)

asIntFold :: String -> Int
asIntFold [] = 0
asIntFold "-" = 0
asIntFold xxs@(x:xs) 
    | outOfBounds xxs = error "number out of bounds"
    | x == '-'        = (-1) * asIntFold xs
    | otherwise       = foldl step 0 xxs
    where step acc x
            | not $ isDigit x = error (x : " is not a digit")
            | otherwise       = acc * 10 + digitToInt x
          outOfBounds xxs = length xxs > 20