-- 7. Write your own definition of the standard takeWhile function, first using explicit
-- recursion, and then foldr .

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' _ [] = []
takeWhile' predicate (x:xs)
    | not (predicate x) = []
    | otherwise         = x : takeWhile' predicate xs

takeWhile'' :: (a -> Bool) -> [a] -> [a]
takeWhile'' predicate = foldr takeElement []
    where takeElement x acc
            | not (predicate x) = []
            | otherwise         = x : acc