import Data.List

sortListOfLists :: [[a]] -> [[a]]
sortListOfLists = sortBy compareByLength
  where compareByLength xs ys = compare (length xs) (length ys)
