module HighestClose where

import qualified Data.ByteString.Lazy.Char8 as L

highestCloseFrom :: FilePath -> IO ()
highestCloseFrom filepath = do
    quoteData <- L.readFile filepath
    print $ highestClose quoteData

highestClose :: L.ByteString -> Maybe Int
highestClose  = maximum . (Nothing:) . fmap closing . L.lines

closing :: L.ByteString -> Maybe Int
closing = readPrice . col 4

col :: Int -> L.ByteString -> L.ByteString
col index = (!!index) . L.split ','

readPrice :: L.ByteString -> Maybe Int
readPrice priceSpec = case L.readInt priceSpec of
    Nothing              -> Nothing
    Just (dollars, rest) -> Just $ dollars * 100 + readCents rest
    where readCents centsSpec 
                    | L.null centsSpec = 0
                    | otherwise        = case L.readInt . L.tail $ centsSpec of
                        Nothing         -> 0
                        Just (cents, _) -> cents