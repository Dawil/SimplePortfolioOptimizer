module Main where

import System.Environment (getArgs)
import Data.Char (toUpper)
import Network.HTTP

import Types
import Quotes
import Loader
import Logic

import qualified Data.Aeson as A
import qualified Data.ByteString.Lazy.Char8 as B


main :: IO ()
main = do
  symbols <- fmap (map (map toUpper) ) getArgs
  putStr $ "Fetching quotes for " ++ show symbols ++ "..."
  companies <- mapM symbolToHistoricalData symbols
  putStrLn " Done."
  print . assessPortfolio $ optimizePortfolio companies
