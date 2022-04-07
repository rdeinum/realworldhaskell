-- 5. The Prelude function concat concatenates a list of lists into a single list and has the
-- following type:
-- -- file: ch04/ch04.exercises.hs
-- concat :: [[a]] -> [a]

concat' :: Foldable t => t [a] -> [a]
concat' = foldr (++) []