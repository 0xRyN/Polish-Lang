open Type;;
(*
(* Parses the first instruction given and returns the rest of the list to callback later *)
val parse_expression : string list -> expr * string list
(* Parses the first condition given and returns the rest of the list to callback later *)
val parse_condition : string list -> cond * string list
(* 
    Parses the given instruction/block. Mutually recursive with parse_block to parse whole blocks.
    Uses callbacks and mutual recursivity for a pure functional approach to parsing.
    The first block contains all the lines in the program.
*)
val parse_instruction : (int * string) list -> instr * (int * string) list
(* Parse lines and convert it to a block and return the rest of the lines*)
*)
val parse_block : (int * string) list -> block * (int * string) list