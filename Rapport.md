# RAPPORT DU PROJET POLISH


## 1. (Identifiants)


> Membres du groupe:
> -  FOURMONT Baptiste: 21953237 Groupe 3 @fourmont
> -  AL AZAWI RAYAN: 21959238 Groupe 3 @alazawi


## 2. (Fonctionnalités)

Les fonctionnalitées implémentées sont:
1. La fonction read_polish qui permet de convertir un fichier polish en une syntaxe concrète 

2. L'option -reprint (alias print_polish) qui permet de transformer au contraire une syntaxe concrète en abstraite ( câd read_polish est print_polish sont idendité )

3. L'option -eval (alias eval_polish) qui permet d'évaluer un programme ( qui a été transformé en syntaxe concrète par read_polish auparavant) .

4. L'option -sign (alias eval_sign) qui permet d'évaluer les signes des variables durant l'exécution d'un programme ( qui a été transformé en syntaxe concrète par read_polish auparavant) .

5. L'option -vars (alias vars_polish) qui permet de voir si il y a des variables non initialisé accessible.

6. L'option -simpl (alias simpl_polish) qui permet d'effectuer les simplifications élémentaires et d'affiche le programme ensuite.


## 3. (Compilation et exécution)
    Pour l'instant nous n'avons pas modifié le makefile ni dune 
    Normalement lors ce qu'on fait des open, dune détecte correctement les fichiers nécessaires au bon fonctionnement du projet.
    Nous n'avons utilisé aucune bibliothéque externe.

## 4. (Découpage modulaire)
    Nous avons séparés  nos fichiers de manière intelligente afin de rendre un contenu plus propre et plus pratique
    1. Parser: Ce fichier regroupe tout ce qui est lié au parsing câd l'analyseur d'expression, de condition, d'instruction etc
    2. Eval: Ce fichier contient tout ce qui est lié à l'évaluation d'un programme (câd --eval )
    3. Print: Ce fichier contient tout ce qui est lié à la fonctionnalité reprint
    4. Sign
    5. Vars
    6. Simpl
    7. Utility: Ce fichier contient les fonctions utilitaires qui peuvent être utile dans tout les fichiers 
    8. Type: Ce fichier contient tout les types de notre projet, nous avons préféré faire celà afin d'éviter tout conflit lié au type

## 5. (Organisation du travail)
    Nous nous sommes répartis les tâches en fonctions de notre emploi du temps et de notre intérêt particulier à certaines fonctions.
    Mais surtout, nous avons travaillé ensemble afin d'établir les meilleurs prototype de chaque fonction et nous avons compris ensemble l'intérêt principal de diviser chaque fonctionnalité en sous problème afin de mieux séparé les tâches et de pouvoir éviter tout bug.

## 6. (Miscs)
    Nous aurions voulu implémenter un parser/lexer de manière plus concrète peut-être, en utilisant directement la position de chaque mot et de terminer directement le type. Mais celà, nous paraissait inanvisageable par manque de temps, nous n'avons pas pu l'implémenté.
    Autrement, nous sommes assez satisfait de notre travail, peut-être nous aurions pu améliorer certaines fonctions qui n'était pas récursive terminale
