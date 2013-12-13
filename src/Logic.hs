module Logic
where

import Types

import Control.Monad (replicateM)
import Data.List (maximumBy,transpose)

import Data.Monoid.Statistics.Numeric

simulatePortfolio :: Portfolio -> Assessment
simulatePortfolio portfolio = Assessment varianceOfReturn meanReturn cumulativeReturn performance
  where performance = map sum . transpose $
          do
            (HistoricalData _ qs,weight) <- portfolio
            return . map (*weight) . diff dailyReturn . map close $ qs
        numOfQuotes = length performance
        meanDouble = sum performance / fromIntegral numOfQuotes
        meanReturn = Mean numOfQuotes meanDouble
        varianceOfReturn = Variance numOfQuotes (sum performance) (sum . map ((**2) . (subtract $ meanDouble)) $ performance)
        cumulativeReturn = sum performance / fromIntegral numOfQuotes

diff :: (a -> a -> b) -> [a] -> [b]
diff _ [] = []
diff _ [_] = []
diff f (x:y:zs) = f x y : diff f (y:zs)

dailyReturn :: Double -> Double -> Double
dailyReturn yesterday today = 1 + (yesterday - today) / today

optimizePortfolio :: [HistoricalData] -> Portfolio
optimizePortfolio = maximumBy comparator . makePossiblePortfolios
  where comparator a b = simulatePortfolio a `compare` simulatePortfolio b

-- Creates every combination of the provided HistoricalDatas and 10 units
-- e.g.:
--   input = [company1, company2]
--   output = [[(company1,0),(company2,10)],[(company1,1),(company2,9)],...]
-- TODO understand replicateM k [0..n]
makePossiblePortfolios :: [HistoricalData] -> [Portfolio]
makePossiblePortfolios historicalData =
  do
    allocation <- possibleAllocations
    return $ zip historicalData allocation
  where possibleAllocations = map (map ((/10) . fromIntegral)) . filter ((== 10) . sum) $ replicateM (length historicalData) [0::Int,1..10]
