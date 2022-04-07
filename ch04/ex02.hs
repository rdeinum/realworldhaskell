splitWith :: (a -> Bool) -> [a] -> [[a]]
splitWith _ [] = []
splitWith p xs = token : splitWith p remainder
  where (token, rest) = break p xs
        remainder = if null rest then [] else tail rest