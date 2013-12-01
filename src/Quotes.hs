{-# LANGUAGE OverloadedStrings #-}
module Quotes where

import Types

import Safe

import qualified Data.Text as T
import qualified Data.Dates as D
import qualified Data.HashMap.Strict as H
import Data.Aeson
import Data.Aeson.Types (Parser)

import Control.Monad
import Control.Applicative

import qualified Data.ByteString.Lazy as B

jsonIO = B.readFile "quote.json"

instance FromJSON Query where
  parseJSON (Object o) = do
    let o' .! f = case o' H.! f of
                    (Object o'') -> o''
                    _ -> error $ "Bad field: " ++ T.unpack f
    Query <$> o .! "query" .: "count"
          <*> o .! "query" .! "results" .: "quote"
  parseJSON _ = mzero

instance FromJSON Quote where
  parseJSON (Object o) = do
    let readField :: (Read a) => T.Text -> Parser a
        readField f = do
          v <- o .: f
          case readMay (T.unpack v) of
            Nothing -> fail $ "Bad field: " ++ T.unpack f
            Just r -> return r
        readDate f = do
          v <- o .: f
          case map (readMay . T.unpack) $ T.splitOn "-" v of
            [Just yyyy,Just mm,Just dd] -> return $ D.DateTime yyyy mm dd 0 0 0
            _ -> fail $ "Bad field: " ++ T.unpack f
    Quote <$> readDate "Date"
          <*> readField "Open"
          <*> readField "High"
          <*> readField "Low"
          <*> readField "Close"
          <*> readField "Volume"
  parseJSON _ = mzero
