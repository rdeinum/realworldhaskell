module Main where

main = interact (unlines . filter (elem 'a') . lines)