-- 4. Write a program that transposes the text in a file. For instance, it should convert
-- "hello\nworld\n" to "hw\neo\nlr\nll\nod\n" .

import System.Environment (getArgs)

transpose :: String -> String
transpose = unlines . transposeLines . lines
    where transposeLines [] = []
          transposeLines [_] = []
          transposeLines (x0:x1:xs) = zipWith (\x y -> [x, y]) x0 x1 ++ transposeLines xs

interactWith function inputFile outputFile = do
    input <- readFile inputFile
    writeFile outputFile (function input)

main = mainWith transpose
    where mainWith function = do
            args <- getArgs
            case args of
                [input, output] -> interactWith function input output
                _ -> putStrLn "error: exactly two arguments needed"        