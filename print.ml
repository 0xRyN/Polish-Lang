open Type;;

(* 
    A function that gives the number of whitespaces necessary for a depth k 
    The function returns k * "  ". For k = 2 for example, 4 whitespaces
    will be returned in a string ("    ")
*)
let get_indentation_spaces (depth:int) : string = 
  let rec aux acc i =
    match i with 
    | 0 -> acc
    | k -> aux (acc ^ "  ") (i-1)

  in aux "" depth


(* Prints the given expression *)
let rec print_expression(expr): unit = match expr with 
  | Num(int) -> print_string (string_of_int (int) ^ " ")
  | Var(name) ->  print_string (name ^ " ")
  | Op(op, l_expr, r_expr) -> match op with 
    | Add -> 
      print_string "+ " ; print_expression (l_expr) ; print_expression (r_expr)
    | Sub ->
      print_string "- " ; print_expression (l_expr) ; print_expression (r_expr)
    | Mul ->
      print_string "* " ; print_expression (l_expr) ; print_expression (r_expr)
    | Div ->
      print_string "/ " ; print_expression (l_expr) ;  print_expression (r_expr)
    | Mod ->
      print_string "% " ; print_expression (l_expr) ; print_expression (r_expr)

(* Prints the given condition *)
let print_condition(cond:(expr * comp * expr))  = match cond with 
    (l_expr, comp, r_expr) -> match comp with 
    | Eq -> 
      print_expression (l_expr) ; print_string  "= " ; print_expression (r_expr)
    | Ne -> (* Not equal, <> *)
      print_expression (l_expr) ; print_string "<> " ; print_expression (r_expr)
    | Lt ->(* Less than, < *)
      print_expression (l_expr) ;  print_string "< " ; print_expression (r_expr)
    | Le ->(* Less or equal, <= *)
      print_expression (l_expr) ; print_string "<= " ; print_expression (r_expr)
    | Gt ->(* Greater than, > *)
       print_expression (l_expr) ; print_string "> " ; print_expression (r_expr)
    | Ge ->(* Greater or equal, >= *)
      print_expression (l_expr) ; print_string ">= " ; print_expression (r_expr)

(* 
    Prints the given instruction/block. Mutually recursive with print_block to print whole blocks.
    Each block has it's own depth. If and While instructions will see their respective
    blocks's depth increased by one. Identation is of a line is equal to get_indentation_spaces depth

    Otherwise, pretty trivial.
*)
let rec print_instruction(instru : instr) (depth : int) : unit = match instru with
  | Set(name, expr) ->
    print_string (name ^ " := ") ; print_expression expr ; print_newline ()
  | Read(name) ->  print_string ("READ " ^(name)) ; print_newline ()
  | Print(expr) -> 
    print_string ("PRINT ") ; print_expression expr ; print_newline ()
  | If(cond, block_g, block_d) ->
    print_string "IF " ; 
    print_condition cond ; 
    print_newline (); 
    print_block block_g (depth + 1); 
    print_string (get_indentation_spaces depth);
    if block_d != [] then 
      let message = "ELSE\n" in
      print_string message
    else print_string "";
      print_block block_d (depth + 1) 
  | While(cond, block) ->
    print_string ("WHILE ") ; print_condition cond ; print_newline (); print_block block (depth + 1)
and print_block( block: (position * instr) list) (depth : int) : unit = match block with 
  | [] -> print_string ""
  | (position, instr) :: tl -> 
    print_string (get_indentation_spaces depth);
    print_instruction instr depth;
    print_block tl depth