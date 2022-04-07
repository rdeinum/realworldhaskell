-- 1. Write the converse of fromList for the List type: a function that takes a List a and
-- generates a [a].

data List a = Cons a (List a) | Nil deriving (Show)

toList (Cons x xs) = x : toList xs
toList Nil         = []
