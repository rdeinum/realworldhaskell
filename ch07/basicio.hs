module Main where

main :: IO ()
main = do
       putStrLn "Greetings! What is your name?"
       name <- getLine
       putStrLn $ "Welcome to Haskell, " ++ name ++ "!"