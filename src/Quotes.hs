{-# LANGUAGE OverloadedStrings #-}
module Quotes where

import Types

import Safe

import qualified Data.Text as T
import Data.Aeson
import Data.Aeson.Types (Parser)

import Control.Monad
import Control.Applicative

import qualified Data.ByteString.Lazy as B

jsonIO = B.readFile "quote.json"

instance FromJSON Quote where
  parseJSON (Object o) = do
    let readField :: (Read a) => T.Text -> Parser a
        readField f = do
          v <- o .: f
          case readMay (T.unpack v) of
            Nothing -> fail $ "Bad field: " ++ T.unpack f
            Just r -> return r
    Quote <$> o .: "Date"
          <*> readField "Open"
          <*> readField "High"
          <*> readField "Low"
          <*> readField "Close"
          <*> readField "Volume"
  parseJSON _ = mzero
