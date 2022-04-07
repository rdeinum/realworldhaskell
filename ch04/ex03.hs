import System.Environment (getArgs)

firstWords :: String -> String
firstWords input = unlines (firstWordsOfLines (lines input))
    where firstWordsOfLines []  = []
          firstWordsOfLines ([]:xs) = [] : firstWordsOfLines xs
          firstWordsOfLines (x:xs) = (head . words $ x) : firstWordsOfLines xs

interactWith function inputFile outputFile = do
    input <- readFile inputFile
    writeFile outputFile (function input)

main = mainWith firstWords
    where mainWith function = do
            args <- getArgs
            case args of
                [input, output] -> interactWith function input output
                _ -> putStrLn "error: exactly two arguments needed"        