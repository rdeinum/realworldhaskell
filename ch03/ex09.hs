-- Define a function that joins a list of lists together using a separator value:
-- -- file: ch03/Intersperse.hs
-- intersperse :: a -> [[a]] -> [a]

intersperse' :: a -> [[a]] -> [a]
intersperse' _ [] = []
intersperse' _ [xs] = xs
intersperse' x (xs:xss) = xs ++ [x] ++ intersperse' x xss