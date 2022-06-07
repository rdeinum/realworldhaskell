module Main where

main :: IO ()
main = putStrLn "Greetings! What is your name?" 
       >> getLine 
       >>= (\name -> putStrLn $ "Welcome to Haskell, " ++ name ++ "!")