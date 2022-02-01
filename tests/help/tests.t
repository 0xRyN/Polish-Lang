Fonctionnement des tests
========================

Pour le rendu du projet il n'est pas nécessaire d'écrire des fichiers de
tests, mais il est tout de même utile de comprendre leur fonctionnement pour
déchiffrer les erreurs.

Un fichier dont l'extension est ".t" sera traité comme fichier de test. Pour
lancer tous les tests de ce répertoire, on peut lancer la commande "dune test"
dans ce répertoire. Lancer "dune test" à la racine du projet lancera tous les
tests de tous les sous-répertoires.

Toutes les lignes dans les fichiers ".t" sont des commentaires qui seront
ignorés par le système de test, saufs celles qui commencent par deux espaces
(attention aux tabulations, qui ne fonctionneront pas).

Les lignes qui commencent par deux espaces puis "$ " sont des commandes qui
seront lancées, et les lignes qui les suivent sont la sortie attendue,
toujours préfixées de deux espaces. Par exemple, le test suivant va réussir :

  $ echo Hello
  Hello

Certaines commandes n'ont aucune sortie, comme par exemple la commande "true",
qui n'affiche rien sur la sortie standard. On vérifie que c'est bien le cas
ainsi:

  $ true

Certaines commandes échouent : elles renvoient un code d'erreur non nul. C'est
le cas de la commande "false", qui renvoie le code d'erreur 1. On peut
vérifier que la commande échoue en ajoutant le code d'erreur entre crochets.
(Ne pas indiquer le code d'erreur quand il n'est pas nul fera échouer le
test.)

  $ false
  [1]

On veut parfois extraire une sous-expression d'une sortie. Pour ça, on peut
utiliser le système de pipeline avec "|" puis "grep -o" suivi d'une expression
rationnelle

  $ echo "Erreur à la ligne 123 dans program.p" | grep -o "ligne [1-9]*"
  ligne 123

Pour vérifier l'absence d'un motif, on vérifie que grep échoue :

  $ echo "Erreur à la ligne 123 dans program.p" | grep "n'importe quoi"
  [1]

On peut aussi vérifier la présence d'un motif sans vouloir décrire exactement
la sortie, en utilisant l'option "-q" (ou "--quiet") de grep qui n'affiche
rien :

  $ echo "Erreur à la ligne 123 dans program.p" | grep -q "Erreur.*ligne"

et qui échoue quand le motif n'est pas présent :

  $ echo "Erreur à la ligne 123 dans program.p" | grep -q "Erreur.*Ligne"
  [1]



Test de ./polish.exe -help
==========================

Le mot "polish" doit apparaître dans la documentation affichée quand on lance
la commande ../../polish.exe -help:

  $ ../../polish.exe -help | grep -q 'polish'

Les options "reprint" et "eval" doivent également apparaître dans la
documentation on lance ../../polish.exe -help.

  $ ../../polish.exe -help | grep -q 'reprint'

  $ ../../polish.exe -help | grep -q 'eval'
