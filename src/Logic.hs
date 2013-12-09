module Logic
where

import Types


assess :: [Quote] -> (Assessment,[Double])
assess quotes = (Assessment stdDev meanReturn sharpeRatio cumulativeReturn, dailyReturns)
  where closingValues = map close quotes
        -- dailyReturns folds over the closing values, putting the daily difference
        -- into a reversed list
        -- TODO ~~don't use reverse~~ rewrite all of this to be less of a performance joke
        dailyReturns = reverse . fst $ foldr go ([],head closingValues) (tail closingValues)
          where go current (res,previous) = (current - previous:res, current)
        meanReturn = sum dailyReturns / (fromIntegral $ length dailyReturns)
        stdDev = sqrt $ sum [ (x - meanReturn) ** 2 | x <- dailyReturns ] / (fromIntegral $ length dailyReturns)
        sharpeRatio = meanReturn / stdDev
        cumulativeReturn = sum dailyReturns

-- using the close data of a quote
-- find 
--  * daily return (using previous day)
--  * volatility (using full data)
--  * sharpe ratio (currently compare it to it's previous price)
--  * cumulative return (per share)
