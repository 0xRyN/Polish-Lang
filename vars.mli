open Type;;
(* Get all the variables *)
val get_vars_block : program -> (name * int) list
(* Get the bad variables (variable which are accessible but not instanciate *)
val get_vars_block_second : program -> (name * int) list