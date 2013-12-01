module Main where

import System.Environment (getArgs)
import Data.Char (toUpper)

import Types
import Quotes
import qualified Data.Aeson as A
import qualified Data.ByteString.Lazy.Char8 as B

import Network.HTTP

getRsp = simpleHTTP $ getRequest "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D%20%22ACB.AX%22%20and%20startDate%20%3D%20%222009-09-11%22%20and%20endDate%20%3D%20%222010-03-10%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
getBody = getRsp >>= getResponseBody
parseBody :: String -> Either String Query
parseBody body = A.eitherDecode $ B.pack body

main :: IO ()
main = do
  symbols <- fmap (map (map toUpper) )getArgs
  print symbols
  datum <- jsonIO 
  let theQuote = case A.decode datum of
                   Just q -> return q :: IO Quote
                   _ -> undefined
  theQuote >>= print 
