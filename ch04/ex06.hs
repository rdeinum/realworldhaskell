import Data.Char (digitToInt)

asIntFold :: String -> Int
asIntFold [] = 0
asIntFold xxs@(x:xs) 
    | x == '-'  = (-1) * asIntFold xs
    | otherwise = foldl (\acc x -> acc * 10 + digitToInt x) 0 xxs