COMMENT Calcul la division euclidienne (efficace, binaire)
COMMENT https://fr.wikipedia.org/wiki/Division_euclidienne
COMMENT Ne traite que le cas des entiers positifs
COMMENT et renvoie 0 0 sinon.
READ a
READ b
IF a <= 0
  PRINT 0
  PRINT 0
ELSE
  IF b <= 0
    PRINT 0
    PRINT 0
  ELSE
    n := 0
    2puissanceN := 1
    WHILE * 2puissanceN b <= a
      n := + 1 n
      2puissanceN := * 2puissanceN 2
    alpha := / 2puissanceN 2
    beta  := 2puissanceN
    step := n
    WHILE step >= 1
      step := - step 1
      IF * / + alpha beta 2 b <= a
        alpha := / + alpha beta 2
      ELSE
        beta := / + alpha beta 2
    q0 := alpha
    r0 := - a * q0 b
    PRINT q0
    PRINT r0
