COMMENT Decides whether a positive integer n is prime
COMMENT Prints only 0 if n is prime
COMMENT Prints the found factors followed by 1 if n is not prime
COMMENT Prints only 2 if n is not positive
READ n
res := 0
IF n <= 0
  PRINT 2
ELSE
  i := 2
  WHILE i < n
    IF % n i = 0
      res := 1
      PRINT i
    i := + i 1
  PRINT res
COMMENT Notice that it would be convenit to have the keyword
COMMENT "BREAK" in the language
