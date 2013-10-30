module Types
where

import  qualified  Data.Text   as  T
import  qualified  Data.Dates  as  D

type Symbol = T.Text

data Quote = Quote
  {  date     ::  T.Text --D.DateTime
  ,  open     ::  Double
  ,  high     ::  Double
  ,  low      ::  Double
  ,  close    ::  Double
  ,  volume   ::  Double
  } deriving (Show)

data HistoricalData = HistoricalData
  { symbol :: Symbol
  , quotes :: [Quote]
  } deriving (Show)

data Portfolio = Portfolio
  { allocations :: [(HistoricalData,Int)]
  } deriving (Show)

data Assessment = Assessment
  { stddev :: Double
  , average :: Double
  , sharpeRatio :: Double
  , cumulativeReturns :: Double
  } deriving (Show, Eq)

instance Ord Assessment where
  compare a1 a2 = compare (sharpeRatio a1) (sharpeRatio a2)
