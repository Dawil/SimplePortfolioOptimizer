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
  rsp <- getRsp $ constructQuotesQuery symbols "2009-09-11" "2010-03-10"
  putStrLn "Done."
  body <- getResponseBody rsp >>= return . parseBody
  case body of
    Right query -> print . head $ results query
    Left err -> putStrLn $ "Error: " ++ err
