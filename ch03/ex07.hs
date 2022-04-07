-- 5. Write a function that determines whether its input list is a palindrome.

isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs  = xs == reverse xs
