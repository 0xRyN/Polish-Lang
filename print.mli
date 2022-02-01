open Type;;
(* Prints the given expression *
val print_expression : expr -> unit
(* Prints the given condition *)
val print_condition : expr * comp * expr -> unit
(* 
    Prints the given instruction/block. Mutually recursive with print_block to print whole blocks.
    Each block has it's own depth. If and While instructions will see their respective
    blocks's depth increased by one. Identation is of a line is equal to get_indentation_spaces depth

    Otherwise, pretty trivial.
*)
val print_instruction : instr -> int -> unit
*)
val print_block : block -> int -> unit