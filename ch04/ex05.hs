import Data.Char (digitToInt)

asInt_fold :: String -> Int
asInt_fold = foldl (\acc x -> acc * 10 + digitToInt x) 0
