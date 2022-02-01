Ce dossier de test vérifie que les programmes Polish syntaxiquement corrects
ne provoquent pas d'erreur de syntaxe et sont correctement affichés, mais
aussi que ceux qui sont syntaxiquement incorrects provoquent bien une erreur
de syntaxe avec le bon numéro de ligne.


Un exemple d'un programme syntaxiquement correct
================================================

La commande "cat good01.p" affiche le contenu fichier "good01.p" sur la sortie
standard. Le test vérifie donc que le contenu du fichier "good01.p" est bien
deux lignes "READ x", puis "PRINT x", puis une ligne de commentaire.

  $ cat good01.p
  READ x
  PRINT x
  COMMENT ce programme affiche l'entier que l'utilisateur a écrit

Voici aussi un programme qui est syntaxiquement incorrect, car "READ" n'est
pas une instruction complète, il manque un nom de variable :

  $ cat bad01.p
  READ

Vérifions que le fichier good01.p est bien accepté avec l'option "-reprint" et
est bien ré-affiché:

  $ ../../polish.exe -reprint good01.p
  READ x
  PRINT x

Le commentaire doit avoir disparu.


Exemples de programmes avec erreurs de syntaxe
==============================================

La première vérification à faire, c'est que l'exécutable polish.exe n'affiche
rien sur la sortie standard quand on lui donne un programme syntaxiquement
invalide en entrée, mais aussi qu'il renvoie un code d'erreur non-nul.

  $ ../../polish.exe -reprint bad01.p 2>/dev/null || echo OK
  OK

La partie "2>/dev/null" efface toute la sortie standard d'erreur (stderr). Le
code d'erreur renvoyé n'importe pas mais on peut vérifier qu'il n'est pas nul
avec la syntaxe de la disjonction paresseuse "|| echo OK", et en vérifiant que
"OK" est bien affiché.

La deuxième vérification, c'est qu'il faut que polish.exe affiche au moins le
mot "error" sur la sortie standard d'erreur (en faisant Printf.fprintf stderr
au lieu de Printf.printf en ocaml):

  $ ../../polish.exe -reprint bad01.p 2>&1 | grep -o 'error'
  error

Ensuite, on veut aussi qu'il affiche le numéro de ligne de la première erreur
de syntaxe :

  $ ../../polish.exe -reprint bad01.p 2>&1 | grep -o 'line [0-9]*'
  line 1

Voyons ensuite un autre exemple :

  $ cat bad02.p
  IF x = 1
      x := 2

Ce programme est syntaxiquement incorrect car la ligne 2 a une indentation de
4 espaces, au lieu des 2 espaces attendus. Il faut donc qu'il indique la
deuxième ligne:

  $ ../../polish.exe -reprint bad02.p 2>&1 | grep -o 'line [0-9]*'
  line 2

À noter que quand un fichier est accepté par polish.exe, alors qu'il ne
devrait pas l'être, "grep" renvoie le code d'erreur 1 (au lieu de 0). On
n'aura donc pas "line x" mais "[1]" quand on lance le test. C'est ce qui
arrive par exemple si on essaie de vérifier que le fichier good01.p est
refusé:

  $ ../../polish.exe -reprint good01.p 2>&1 | grep -o 'line [0-9]*'
  [1]

Enfin, le test suivant vérifie que tous les fichiers .p de ce dossier
apparaissent au moins une fois dans ce fichier tests.t.

  $ ls *.p | while read i; do grep -q "$i" tests.t || echo "file $i missing in tests.t"; done

Voilà qui termine les explications. Ci-dessous, on vérifie la sortie pour tous
les fichiers (les good**.p et les bad**.p).




Programmes syntaxiquement corrects
==================================

  $ ../../polish.exe -reprint good02.p
  PRINT / / 1 1 1

  $ ../../polish.exe -reprint good03.p
  READ x
  PRINT + x 0

  $ ../../polish.exe -reprint good04.p
  IF 1 = 1
    READ x

  $ ../../polish.exe -reprint good05.p
  READ x
  IF x = 0
    READ y
    IF y = 0
      READ z
      PRINT z

  $ ../../polish.exe -reprint good06.p
  WHILE 1 = 1
    PRINT 1

  $ ../../polish.exe -reprint good07.p
  x := 1
  x := * x * x x

  $ ../../polish.exe -reprint good08.p
  abcdefghijklmopq-=+ := 1

  $ ../../polish.exe -reprint good09.p
  comment := 1

  $ ../../polish.exe -reprint good10.p
  READ x
  WHILE x <> 0
    PRINT x
    READ x
  PRINT 0

  $ ../../polish.exe -reprint good11.p
  %% := % 1 1

  $ ../../polish.exe -reprint good12.p
  x := 2
  x := 2
  x := 2
  x := 2

  $ ../../polish.exe -reprint good13.p
  READ x
  PRINT / 2 x

  $ ../../polish.exe -reprint good14.p


Programmes syntaxiquement incorrects
====================================

On rappelle que si la sortie affichée est [1], c'est que le "grep" a échoué,
et donc qu'il n'y avait pas de numéro de ligne d'erreur.

  $ ../../polish.exe -reprint bad03.p 2>&1 | grep -o 'line [0-9]*'
  line 1

  $ ../../polish.exe -reprint bad04.p 2>&1 | grep -o 'line [0-9]*'
  line 1

  $ ../../polish.exe -reprint bad05.p 2>&1 | grep -o 'line [0-9]*'
  line 1

  $ ../../polish.exe -reprint bad06.p 2>&1 | grep -o 'line [0-9]*'
  line 7

  $ ../../polish.exe -reprint bad07.p 2>&1 | grep -o 'line [0-9]*'
  line 1

  $ ../../polish.exe -reprint bad08.p 2>&1 | grep -o 'line [0-9]*'
  line 2

  $ ../../polish.exe -reprint bad09.p 2>&1 | grep -o 'line [0-9]*'
  line 3

  $ ../../polish.exe -reprint bad10.p 2>&1 | grep -o 'line [0-9]*'
  line 2

  $ ../../polish.exe -reprint bad11.p 2>&1 | grep -o 'line [0-9]*'
  line 1

  $ ../../polish.exe -reprint bad12.p 2>&1 | grep -o 'line [0-9]*'
  line 2

  $ ../../polish.exe -reprint bad13.p 2>&1 | grep -o 'line [0-9]*'
  line 3

  $ ../../polish.exe -reprint bad14.p 2>&1 | grep -o 'line [0-9]*'
  line 3

  $ ../../polish.exe -reprint bad15.p 2>&1 | grep -o 'line [0-9]*'
  line 1

  $ ../../polish.exe -reprint bad17.p 2>&1 | grep -o 'line [0-9]*'
  line 3

  $ ../../polish.exe -reprint bad16.p 2>&1 | grep -o 'line [0-9]*'
  line 3
