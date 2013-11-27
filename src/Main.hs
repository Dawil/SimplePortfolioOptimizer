module Main where

import Types
import Quotes
import qualified Data.Aeson as A

main :: IO ()
main = do
  datum <- jsonIO 
  let theQuote = case A.decode datum of
                   Just q -> return q :: IO Quote
                   _ -> undefined
  theQuote >>= print 
