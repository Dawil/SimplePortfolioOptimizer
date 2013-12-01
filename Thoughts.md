Thoughts about the Codebase
===========================

This document is a place for some unorganized thoughts about the code.

Query Data Types
----------------

The Query data type uses a list to store the quotes. Given that the length of
the quotes is known it might be better to use an array instead of a lazy list
(if performance ever becomes a thing).

Parsing
-------

The parsing code for Quotes and Queries was annoying to write since I am used
to the dynamic parse/dynamic fail style of ruby and javascript. There was a lot
to learn for what I had incorrectly suspected to be trivial so in my
frustration I wrote some pretty bad code just to get things working. So
obviously the parsing code could be improved from a safety point of view.
