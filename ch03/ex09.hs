intersperse' :: a -> [[a]] -> [a]
intersperse' _ [] = []
intersperse' _ [xs] = xs
intersperse' x (xs:xss) = xs ++ [x] ++ intersperse' x xss