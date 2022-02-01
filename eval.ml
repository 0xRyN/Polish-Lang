open Type;;
let eval_operation (op: op)(l_expr: int)(r_expr: int): int =  match op with
  | Add -> l_expr + r_expr
  | Sub -> l_expr - r_expr
  | Mul -> l_expr * r_expr
  | Div -> l_expr / r_expr
  | Mod -> l_expr mod r_expr

let eval_comparaison(l_expr: int)(comp: comp)(r_expr: int): bool = match comp with 
  | Eq -> l_expr = r_expr   (* = *)
  | Ne -> l_expr != r_expr  (* Not equal, <> *)
  | Lt -> l_expr < r_expr   (* Less than, < *)
  | Le -> l_expr <= r_expr  (* Less or equal, <= *)
  | Gt -> l_expr > r_expr   (* Greater than, > *)
  | Ge -> l_expr >= r_expr  (* Greater or equal, >= *)

let rec eval_expression (expr: expr) (env: int Table.t) : int = match expr with
  | Num(int) -> int
  | Var(name) -> Table.find name env
  | Op(op,l_expr,r_expr) -> eval_operation op (eval_expression l_expr env)(eval_expression r_expr env)


let eval_condition (cond: cond)(env: int Table.t): bool =
  let (l_expr, comp, r_expr) = cond in 
  eval_comparaison (eval_expression l_expr env) (comp) (eval_expression r_expr env)


(*
    Evaluates the instruction/block given as argument. All instructions are trivial but 
    if and while. For if, we just need to check if the condition is valid, if it is,
    eval first part of the block (the if part). Else, the second part (the else part)

    While will just get looped in an auxiliary function if the condition is still true.

    Mutual recursion makes a purely functional approach to evaluation.
*)

let rec eval_instr(instru: instr)(env: int Table.t)  = match instru with
  | Set(name, expr) -> Table.add name (eval_expression expr env) env
  | Read(name) -> Printf.printf "%s? " name; Table.add name (read_int()) env;
  | Print(expr) -> Printf.printf "%i\n" (eval_expression expr env); env
  | While(cond, block) ->
    let rec eval_while cond blk env = match eval_condition cond env with 
      | true ->  eval_while cond blk (eval_block blk env)
      | false -> env
    in eval_while cond block env 
  | If(cond, block_g, block_d) ->
    let x = eval_condition cond env in 
    if x then
      eval_block block_g env
    else
      eval_block block_d env
and eval_block (blk: block)(env: int Table.t): int Table.t = match blk with 
  | [] -> env
  | ( _ , instr ) :: tl -> 
    let env' = eval_instr instr env in 
    eval_block tl env'
