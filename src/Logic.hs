module Logic
where

-- Fair warning, this file is retarded.

import Types

import Control.Monad (replicateM)
import Data.Monoid (mconcat)
import Data.List (maximumBy)

import Data.Monoid.Statistics.Numeric

-- Oh god, oh god, oh god
assess :: [Quote] -> Assessment
assess quotes = Assessment varianceOfReturn meanReturn cumulativeReturn
  where closingValues = map close quotes
        numOfQuotes = length quotes
        -- dailyReturns folds over the closing values, putting the daily difference
        -- into a reversed list
        -- TODO ~~don't use reverse~~ rewrite all of this to be less of a performance joke
        dailyReturns = reverse . fst $ foldr go ([],head closingValues) (tail closingValues)
          where go current (res,previous) = (current - previous:res, current)
        meanDouble = sum dailyReturns / fromIntegral numOfQuotes
        meanReturn = Mean numOfQuotes meanDouble
        varianceOfReturn = Variance numOfQuotes (sum dailyReturns) (sum . map ((**2) . (subtract $ meanDouble)) $ dailyReturns)
        cumulativeReturn = sum dailyReturns

optimizePortfolio :: [HistoricalData] -> Portfolio
optimizePortfolio = maximumBy comparator . makePossiblePortfolios
  where comparator a b = assessPortfolio a `compare` assessPortfolio b

-- Creates every combination of the provided HistoricalDatas and 10 units
-- e.g.:
--   input = [company1, company2]
--   output = [[(company1,0),(company2,10)],[(company1,1),(company2,9)],...]
-- TODO understand replicateM k [0..n]
makePossiblePortfolios :: [HistoricalData] -> [Portfolio]
makePossiblePortfolios historicalData = map (Portfolio . zip historicalData) possibleAllocations
  where possibleAllocations = filter ((== 10) . sum) $ replicateM (length historicalData) [0..10]

assessPortfolio :: Portfolio -> Assessment
assessPortfolio = mconcat . map (assess . quotes . fst) . allocations
