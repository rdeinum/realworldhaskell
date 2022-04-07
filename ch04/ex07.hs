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