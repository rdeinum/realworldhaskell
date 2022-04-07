-- 4. Modify the WC.hs example again, in order to print the number of characters in a
-- file.

-- runghc ex04.hs < quux.txt

main = interact wordCount
    where wordCount input = show (length input) ++ "\n"