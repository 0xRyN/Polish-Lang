open Type;;
(*
(* Return the result of the operation of two expression *)
val eval_operation : op -> int -> int -> int
(* Return a bool which represents the result of the comparaison *)
val eval_comparaison : int -> comp -> int -> bool
(* Return an int which reprents the result of an expression *)
val eval_expression : expr -> int Table.t -> int
(* Return a bool which represents the result of the condition *)
val eval_condition : cond -> int Table.t -> bool
(*
    Evaluates the instruction/block given as argument. All instructions are trivial but 
    if and while. For if, we just need to check if the condition is valid, if it is,
    eval first part of the block (the if part). Else, the second part (the else part)

    While will just get looped in an auxiliary function if the condition is still true.

    Mutual recursion makes a purely functional approach to evaluation.
*)
val eval_instr : instr -> int Table.t -> int Table.t
*)
val eval_block : block -> int Table.t -> int Table.t
val eval_comparaison : int -> comp -> int -> bool