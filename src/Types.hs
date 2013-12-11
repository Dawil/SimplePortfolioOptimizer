module Types
where

import  qualified  Data.Text   as  T
import  qualified  Data.Dates  as  D
import Data.Monoid
import Data.Monoid.Statistics.Numeric

type Symbol = String

data Query = Query
  { count :: Int
  , results :: [Quote]
  } deriving Show

data HistoricalData = HistoricalData
  { symbol :: Symbol
  , quotes :: [Quote]
  } deriving (Show)

data Portfolio = Portfolio
  { allocations :: [(HistoricalData,Int)]
  }

instance Show Portfolio where
  show p = show $ map (\(hd,i) -> (symbol hd, i)) $ allocations p

data Quote = Quote
  {  date     ::  D.DateTime
  ,  open     ::  Double
  ,  high     ::  Double
  ,  low      ::  Double
  ,  close    ::  Double
  ,  volume   ::  Double
  } deriving (Show)

data Assessment = Assessment
  { variance :: Variance
  , mean :: Mean
  , cumulativeReturns :: Double
  } deriving (Show, Eq)

getSharpeRatio :: Assessment -> Double
getSharpeRatio assessment = average / stdDev
  where stdDev = sqrt . calcVariance . variance $ assessment
        average = calcMean $ mean assessment

instance Ord Assessment where
  compare a1 a2 = compare (getSharpeRatio a1) (getSharpeRatio a2)

instance Monoid Assessment where
  mempty = Assessment (Variance 0 0 0) (Mean 0 0) 0
  mappend a1 a2 = Assessment var average returns
    where var = variance a1 <> variance a2
          average = mean a1 <> mean a2
          returns = cumulativeReturns a1 + cumulativeReturns a2
