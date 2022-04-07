import Data.Char (digitToInt, isDigit)

asIntFold :: String -> Either Int String
asIntFold [] = Left 0
asIntFold "-" = Left 0
asIntFold xxs@(x:xs) 
    | outOfBounds xxs = Right "number out of bounds"
    | x == '-'        = negate (asIntFold xs)
    | otherwise       = foldl step (Left 0) xxs
    where step (Right e) _    = Right e
          step (Left acc) x
            | not $ isDigit x = Right (x : " is not a digit")
            | otherwise       = Left (acc * 10 + digitToInt x)
          outOfBounds xxs     = length xxs > 20
          negate (Left x)     = Left (-1 * x)
          negate (Right x)    = Right x