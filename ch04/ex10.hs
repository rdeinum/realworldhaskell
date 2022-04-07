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