ispalindrome :: Eq a => [a] -> Bool
ispalindrome []  = True
ispalindrome [x] = True
ispalindrome xs  = ((head xs) == (last xs)) && ispalindrome (tail . init $ xs)
