-- 2. Write a function splitWith that acts similarly to words but takes a predicate and a
-- list of any type, and then splits its input list on every element for which the predicate
-- returns False :
-- -- file: ch04/ch04.exercises.hs
-- splitWith :: (a -> Bool) -> [a] -> [[a]]

splitWith :: (a -> Bool) -> [a] -> [[a]]
splitWith _ [] = []
splitWith p xs = token : splitWith p remainder
  where (token, rest) = break p xs
        remainder = if null rest then [] else tail rest