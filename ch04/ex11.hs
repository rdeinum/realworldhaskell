-- 8. The Data.List module defines a function, groupBy , which has the following type:
-- -- file: ch04/ch04.exercises.hs
-- groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
-- 9. Use ghci to load the Data.List module and figure out what groupBy does, then
-- write your own implementation using a fold.
-- 10. How many of the following Prelude functions can you rewrite using list folds?
-- • any
-- • cycle
-- • words
-- 98 | Chapter 4: Functional Programming• unlines
-- For those functions where you can use either foldl' or foldr , which is more ap-
-- propriate in each case?

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