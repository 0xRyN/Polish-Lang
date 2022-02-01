open Type;;


(* Simplify operations *)
let simplify_add (e1: expr) (e2: expr) :expr =
  match (e1,e2) with 
  | (Num c1,Num c2)-> Num (c1+c2)
  | (Num 0, _)-> e2
  | (_,Num 0)->e1 
  | (_,_)-> Op (Add,e1,e2);;

let simplify_sub (e1: expr) (e2: expr) :expr =
  match (e1,e2) with 
  | (Num c1,Num c2)-> Num (c1-c2)
  | (_, _) when e1=e2-> Num 0
  | (_,Num 0)->e1 
  | (_,_)-> Op (Sub,e1,e2);;

let simplify_mul (e1: expr) (e2: expr) :expr =
  match (e1,e2) with 
  | (Num c1,Num c2)-> Num (c1*c2)
  | (Num 0, _)-> Num 0
  | (_,Num 0)->Num 0
  | (Num 1, _)-> e2
  | (_,Num 1)-> e1       
  | (_,_)-> Op (Mul,e1,e2);;

let simplify_div (e1: expr) (e2: expr) :expr =
  match (e1,e2) with 
  | (Num c1,Num c2)-> Num (c1 / c2)
  | (Num 0, _)-> Num 0 
  | (_,Num 1)-> e1       
  | (_,_)-> Op (Div,e1,e2);;

let simplify_mod (e1: expr) (e2: expr) :expr =
  match (e1,e2) with 
  | (Num c1,Num c2)-> Num (c1 mod c2)
  | (Num 0, _)-> Num 0
  | (Num 1, _)-> Num 1
  | (_,Num 1)-> Num 0      
  | (_,_)-> Op (Mod,e1,e2);;

let simplify_bop (op: op) (e1: expr) (e2: expr) = match op with
  | Add -> simplify_add e1 e2
  | Sub -> simplify_sub e1 e2
  | Mul -> simplify_mul e1 e2
  | Div -> simplify_div e1 e2
  | Mod -> simplify_mod e1 e2

let rec simplify_expr (expr: expr) :expr =
  match expr with
  | Op(op, e1, e2) -> simplify_bop (op) (simplify_expr e1) (simplify_expr e2)
  | _ -> expr

let simplify_cond (cond: cond) :(cond * bool) = 
  let (e1, cmp, e2) = cond in
  let simp_e1 = simplify_expr e1 in 
  let simp_e2 = simplify_expr e2 in 
  match (simp_e1, simp_e2) with
  | (Num a, Num b) -> ((simp_e1, cmp, simp_e2), not (Eval.eval_comparaison (a) (cmp) (b)))
  | _ -> ((simp_e1, cmp, simp_e2), false)


let rec analyze_const(instr : instr) :  instr option = match instr with 
  | Set(name, expr) -> Some(Set(name, simplify_expr expr))
  | Print(expr) -> Some(Print(simplify_expr expr))
  | If(cond, block_g, block_d) -> 
    let (simplified_cond, is_dead_code) = simplify_cond cond in
    if is_dead_code then 
    (
      Some(If(simplified_cond, [], block_d))
    ) 
    else Some(If(simplified_cond, block_g, block_d))
  (* DELETE BLOCK *)
  | While(cond, block) -> let (simplified_cond, is_dead_code) = simplify_cond cond in
    if is_dead_code then None else Some(While(simplified_cond, block))
  (* DELETE BLOCK *)
  | _ -> None

and analyze_block(b: block) : block = 
  let rec aux (acc: (position * instr) list) (rest_lines : (position * instr) list) =
    match rest_lines with
    | [] -> acc
    | (pos, instr) :: tl -> 
      let check = analyze_const instr in match check with
      | Some(instru) -> 
          aux (acc@[pos, instru]) tl 
      | None -> aux acc tl

  in aux [] b