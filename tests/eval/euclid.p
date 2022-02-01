COMMENT Calcul la division euclidienne
COMMENT https://fr.wikipedia.org/wiki/Division_euclidienne
COMMENT Ne traite que le cas des entiers positifs
COMMENT et renvoie 0 0 sinon.
READ a
READ b
r0 := 0
q0 := 0
IF a <= 0
  PRINT 0
  PRINT 0
ELSE
  IF b <= 0
    PRINT 0
    PRINT 0
  ELSE
    q0 := 0
    r0 := a
    WHILE r0 >= b
      q0 := + 1 q0
      r0 := - r0 b
    PRINT q0
    PRINT r0
