Dans le cas d'une division par zéro, l'évaluation doit afficher une erreur sur
la sortie d'erreur :

  $ cat error-div0.p
  PRINT / 2 0

  $ (../../polish.exe -eval error-div0.p >/dev/null) 2>&1 | grep -o error
  error

et aussi renvoyer un code d'erreur non nul avec la fonction exit, ce qu'on
teste ainsi :

  $ ../../polish.exe -eval error-div0.p >/dev/null 2>/dev/null || echo OK
  OK


Même chose pour une variable non définie :

  $ cat error-undef.p
  PRINT x

  $ (../../polish.exe -eval error-undef.p >/dev/null) 2>&1 | grep -o error
  error

  $ ../../polish.exe -eval error-undef.p >/dev/null 2>/dev/null || echo OK
  OK


On vérifie aussi que sur un programme correct, ici le programme vide, ces
tests ne sont pas satisfaits :

  $ cat empty.p

  $ (../../polish.exe -eval empty.p >/dev/null) 2>&1 | grep -o error
  [1]

  $ ../../polish.exe -eval empty.p >/dev/null 2>/dev/null || echo OK
