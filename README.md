Simple Portfolio Optimizer
==========================

This project produces a command line tool that reads several Symbols from the
commandline and using a naive methodology generates an "optimal" portfolio
combination and plots a comparison with an index. I should mention that it's
inspiried by the first assignment of the Computational Investing 1 course
offered by Coursera.

Methodology
-----------

It uses historial data from Yahoo Finance. In order to generate an optimal
portfolio it finds the greatest Sharpe ratio of all combinations of the given
symbols in discrete ratios of up to 100 parts.

None of the historical data is saved, so you are advised against picking too
many symbols at once.

Dependencies
------------

* dates
  + datetime
  + dates
* json
  + aeson
* http
* concurrency
  + pipes-concurrent

I may also add in lens if it seems appropriate and repa for faster data
processing if I'm having too much fun.
