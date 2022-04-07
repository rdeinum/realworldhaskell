data Tree a = Node (Maybe a) (Maybe (Tree a)) (Maybe (Tree a)) deriving (Show)
