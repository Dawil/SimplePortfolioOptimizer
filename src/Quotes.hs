module Quotes where

import Types
import Aeson

import Control.Applicative

instance FromJSON Quote where
  parseJSON (Object o) =
    Quote <$> o .: "Date"
          <*> o .: "Open"
          <*> o .: "High"
          <*> o .: "Low"
          <*> o .: "Close"
          <*> o .: "Volume"
  parseJSON _ = mzero
