-- 6. Create a function that sorts a list of lists based on the length of each sublist. (You
-- may want to look at the sortBy function from the Data.List module.)

import Data.List

sortListOfLists :: [[a]] -> [[a]]
sortListOfLists = sortBy compareByLength
  where compareByLength xs ys = compare (length xs) (length ys)
