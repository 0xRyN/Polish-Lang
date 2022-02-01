open Type;;
val sign_block : block -> sign list VarEnv.t -> sign list VarEnv.t
val pure_print_sign_list : sign list -> string