concat' :: Foldable t => t [a] -> [a]
concat' = foldr (++) []