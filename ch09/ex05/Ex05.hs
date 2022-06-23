module Ex05 where

import Data.List ( sortOn )
import Data.Ord ( comparing )
import ControlledVisit as CV ( Info, traverse, InfoP, andI )

traverse' :: Ord a => InfoP a -> InfoP Bool -> FilePath -> IO [Info]
traverse' traversalP filterP  = CV.traverse $ filter filterP . sortOn traversalP