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
  } deriving (Eq)

instance Show HistoricalData where
  show (HistoricalData symbol quotes) = show (symbol, length quotes)

type Weight = Double
type Portfolio = [(HistoricalData,Weight)]
type Performance = [Double]

data Quote = Quote
  {  date     ::  D.DateTime
  ,  open     ::  Double
  ,  high     ::  Double
  ,  low      ::  Double
  ,  close    ::  Double
  ,  volume   ::  Double
  } deriving (Show,Eq)

data Assessment = Assessment
  { variance :: Variance
  , mean :: Mean
  , cumulativeReturns :: Double
  , dailyValues :: [Double]
  } deriving (Eq)

instance Show Assessment where
  show (Assessment v m c _) = show (v,m,c)

getSharpeRatio :: Assessment -> Double
getSharpeRatio assessment = average / stdDev
  where stdDev = sqrt . calcVariance . variance $ assessment
        average = calcMean $ mean assessment

instance Ord Assessment where
  compare a1 a2 = compare (getSharpeRatio a1) (getSharpeRatio a2)
