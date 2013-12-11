module Loader where

import Types
import Quotes

import qualified Data.Aeson as A
import qualified Data.ByteString.Lazy.Char8 as B
import Network.HTTP.Base
import Network.HTTP


-- This is the module where the functions for loading quotes from the Yahoo API
-- are.
type Date = String
type URL = String

-- TODO don't hardcode dates
-- TODO make function total (not partial)
symbolToHistoricalData :: String -> IO HistoricalData
symbolToHistoricalData symbol = do
  let url = constructQuotesQuery [symbol] "2009-09-11" "2010-03-10"
  rsp <- getRsp url
  body <- getResponseBody rsp
  return . HistoricalData symbol $
    case parseBody body of
      Right (Query _ res) -> res
      _ -> error $ "Error loading symbol: " ++ symbol

getRsp query = simpleHTTP $ getRequest query
parseBody :: String -> Either String Query
parseBody body = A.eitherDecode $ B.pack body

constructQuotesQuery :: [String] -> Date -> Date -> URL
constructQuotesQuery symbols startDate endDate =
  "http://query.yahooapis.com/v1/public/yql?q=" ++ yqlString ++ "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
  where
    yqlString = --urlEncode $
      "select%20*" ++ (urlEncode $
      " from yahoo.finance.historicaldata\
      \ where symbol in (" ++ commaDelimited (map show symbols) ++ ")\
      \ and startDate = " ++ show startDate ++ " and endDate = " ++ show endDate)
    -- Fails on an empty list
    commaDelimited (x:xs) = foldr (\a b->a ++ "," ++ b) x xs
