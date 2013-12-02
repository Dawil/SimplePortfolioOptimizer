module Loader where

import Network.HTTP.Base
import Network.HTTP


-- This is the module where the functions for loading quotes from the Yahoo API
-- are.
type Symbol = String
type Date = String
type URL = String

getRsp query = simpleHTTP $ getRequest query
parseBody :: String -> Either String Query
parseBody body = A.eitherDecode $ B.pack body

constructQuotesQuery :: [Symbol] -> Date -> Date -> URL
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
