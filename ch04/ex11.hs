import Data.Char

groupBy' :: Eq a => (a -> a -> Bool) -> [a] -> [[a]]
groupBy' _ [] = []
groupBy' p xs = foldr step [] xs
    where step x [] = [[x]]
          step x yys@(y:ys)
             | x `elem` y = (x : y) : ys
             | otherwise  = [x] : yys

any' :: Foldable t => (a -> Bool) -> t a -> Bool
any' p = foldr step False
    where step x acc = p x || acc

cycle' :: [a] -> [a]
cycle' [] = error "empty list"
cycle' xs = foldr step [] [0..]
    where step x acc = (xs!!(x `mod` length xs)):acc

words' :: String -> [String]
words' = foldr step []
    where step x [] = [[x]]
          step x acc
            | isSpace x = []:acc
            | otherwise = (x : head acc):tail acc

unlines' :: [String] -> String
unlines' = foldr step ""
    where step x acc = x ++ "\n" ++ acc