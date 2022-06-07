module ElfMagic where

import qualified Data.ByteString.Lazy as L
import Distribution.Simple.Setup (ConfigFlags(configCabalFilePath))

hasElfMagic :: L.ByteString -> Bool
hasElfMagic bytes = elfMagic == L.take 4 bytes
  where elfMagic = L.pack [0x7f, 0x45, 0x4c, 0x46]

isElfFile :: FilePath -> IO Bool
isElfFile filepath = do
    bytes <- L.readFile filepath
    return $ hasElfMagic bytes