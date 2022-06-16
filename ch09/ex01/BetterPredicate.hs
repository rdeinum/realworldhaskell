module BetterPredicate where

import Control.Exception(bracket, handle, SomeException(SomeException))
import System.IO(IOMode(..), hClose, hFileSize, openFile)

getFileSize :: FilePath -> IO (Maybe Integer)
getFileSize path = bracket (openFile path ReadMode) hClose $ \h -> do
    handle catch $ do
        size <- hFileSize h
        return (Just size)
    where catch :: SomeException  -> IO (Maybe Integer)
          catch _ = return Nothing