(* Get words of a line - string ( a word is a list of characters not containing " " ) *)
val get_words : string -> string list
(* Remove the empty whitespaces from a line *)
val remove_indentation : string -> string list
(* Get indentation of a line *)
val get_indentation : string -> int
(* Let clean empty word we don't want it *)
val clean_words : string list -> string list
(* Just checks if a string is convertible to int (is an int) *)
val is_int : string -> bool
(* Just check if a string is is an operator*)
val is_operator : string -> bool