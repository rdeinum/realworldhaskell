-- 3. Write a function that computes the mean of a list, i.e., the sum of all elements in
-- the list divided by its length. (You may need to use the fromIntegral function to
-- convert the length of the list from an integer into a floating-point number.)

mean numbers = sum numbers / fromIntegral (length numbers)
