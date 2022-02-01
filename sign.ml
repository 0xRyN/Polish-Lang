open Type;;
let opposite_comp (comp: comp) :comp = match comp with
  | Eq -> Ne
  | Ne -> Eq
  | Lt -> Ge
  | Le -> Gt
  | Gt -> Le
  | Ge -> Lt

let merge_env m1 m2 = 
  VarEnv.merge (fun key x y -> 
      match x,y with
      | Some a, None -> Some a
      | None, Some b -> Some b
      | Some a, Some b -> 
        begin 
          let rec aux acc org = 
            match org with
            | [] -> acc@b
            | hd :: tl -> if List.mem hd b then aux acc tl else aux (hd::acc) tl
          in Some(aux [] a)
        end
      | None, None -> None)
    m1 m2 

let equal_contents a b =
  List.sort compare a = List.sort compare b

let join (s1 : sign list) (s2 : sign list) : sign list = 
  let rec aux acc list = match list with
    | [] -> acc
    | hd :: tl -> if List.mem (hd) (acc) then aux acc tl else aux (hd :: acc) tl
  in aux s1 s2

let print_sign (s: sign) = match s with 
  | Neg ->  "-"
  | Zero ->  "0"
  | Pos ->  "+"
  | Error ->  "!"

let pure_print_sign_list l = 
  let rec aux acc rest = match rest with 
    | sign :: tl -> aux (acc ^ " " ^ print_sign sign) tl
    | _ -> acc

  in (aux "" l)
let print_sign_list (env: sign list VarEnv.t) = 
  let rec aux acc rest = match rest with 
    | sign :: tl -> aux (acc ^ " " ^ print_sign sign) tl
    | _ -> acc

  in 
  VarEnv.iter (fun x y -> print_string x; print_string " -> "; print_string (aux "" y); print_string "\n") env

let sign_int (num: int) : sign =
  if num = 0 then Zero
  else if num > 0 then Pos 
  else Neg


(* sign_expression ( Op (Add, Num 0, Num 5)) (Names.empty);; *)

(*
  Positif + Positif = tout
  Positif + negatif = tout
  sign_expression (Op (Add, Num (-2), Num (2))) (Names.empty);;
*)

let opposite_sign (sign : sign) : sign = 
  match sign with
  | Pos -> Neg
  | Neg -> Pos
  | _ -> sign

let sign_add (l: sign) (r: sign) : sign list =
    (*
        Pos + Pos = Pos
        Neg + Neg = Neg
        Any + Zero = Any
    *)
  match l,r with 
  | Zero, right -> [right] 
  | left, Zero -> [left]
  | left, right when left = right -> [left]
  | _, _ -> [Pos; Neg; Zero]

let sign_sub (l: sign) (r: sign) : sign list =
    (*
        A - B = A + (-B)
    *)
  sign_add (l) (opposite_sign r)

let sign_mul (l: sign) (r: sign) : sign list =
    (*
        A * B = 0 If A or B is Zero
        Positive if same sign
        Else negative
    *)
  match l,r with 
  | Zero, right -> [Zero] 
  | left, Zero -> [Zero]
  | left, right when left = right -> [Pos]
  | _, _ -> [Neg]

let sign_div (l: sign) (r: sign) : sign list =
    (*
        A * B = 0 If A is Zero
        If B is Zero Error
        Positive if same sign
        Else negative
    *)
  match l,r with 
  | Zero, right -> [Zero] 
  | left, Zero -> [Error]
  | left, right when left = right -> [Pos]
  | _, _ -> [Neg]

let sign_mod (l: sign) (r: sign) : sign list =
    (*
        Mod is only applicable in these cases
    *)
  match l,r with 
  | Zero, Pos -> [Zero] 
  | Pos, Pos -> [Pos]
  | _, _ -> [Error]

let all_pairs (l1 : sign list) (l2 : sign list) : sign list list =
  (* print_sign_list l1; 
     print_string "\n";
     print_sign_list l2;
     print_string "\n END OF CALL \n"; *)
  List.concat
    (List.map 
       (fun a -> List.map (fun b -> [a;b]) l2)
       l1)

let sign_operation (op:op) (l_expr: sign list) (r_expr: sign list): sign list = 
  let possibilities = all_pairs l_expr r_expr in
  let rec aux acc list = match list with 
    | [] -> acc
    | hd :: tl -> 
      let first = List.hd hd in
      let second = List.nth hd 1 in
      match op with 
      | Add -> aux (join (sign_add first second) acc) tl
      | Sub -> aux (join (sign_sub first second) acc) tl
      | Mul -> aux (join (sign_mul first second) acc) tl
      | Div -> aux (join (sign_div first second) acc) tl
      | Mod -> aux (join (sign_mod first second) acc) tl

  in aux [] possibilities

let rec sign_expression (expr) (env: sign list VarEnv.t) : sign list = match expr with
  | Num(int) -> [sign_int int]
  | Var(x) -> VarEnv.find x env
  | Op(op, l_expr, r_expr) -> 
    let left = (sign_expression l_expr env) in 
    let right = (sign_expression r_expr env) in 
    sign_operation op left right
(* Nom associé à une liste de signe *)
(*  sign_condition (Num (10), Le, Num (-0)) (VarEnv.empty);; *)

let eq_possible (s1 : sign) (s2 : sign) : bool = 
  match s1, s2 with 
  | x, y when x = y -> true
  | _, _ -> false

let ne_possible (s1 : sign) (s2 : sign) : bool = 
  match s1, s2 with 
  | x, y when x = y -> false
  | _, _ -> true

let lt_possible (s1 : sign) (s2 : sign) : bool = 
  match s1, s2 with 
  | Zero, Zero -> false
  | Pos, Neg -> false
  | Pos, Zero -> false
  | Zero, Neg -> false 
  | _, _ -> true

let le_possible (s1 : sign) (s2 : sign) : bool =
  match s1, s2 with 
  | Pos, Neg -> false
  | _, _ -> true

let gt_possible (s1 : sign) (s2 : sign) : bool = 
  match s1, s2 with 
  | Zero, Zero -> false
  | Neg, Pos -> false
  | Pos, Zero -> false
  | Zero, Neg -> false 
  | _, _ -> true

let ge_possible (s1 : sign) (s2 : sign) : bool = 
  match s1, s2 with 
  | Neg, Pos -> false
  | _, _ -> true


let cond_possible (cond: cond)(env: sign list VarEnv.t): bool =
  let (l_expr, comp, r_expr) = cond in 
  let possibilities = all_pairs (sign_expression l_expr env) (sign_expression r_expr env) in
  let rec aux list = match list with
    | [] -> false
    | hd :: tl -> 
      let first = List.hd hd in
      let second = List.nth hd 1 in
      match comp with 
      | Eq -> if(eq_possible first second) then true else aux tl
      | Ne -> if(ne_possible first second) then true else aux tl
      | Lt -> if(lt_possible first second) then true else aux tl
      | Le -> if(le_possible first second) then true else aux tl
      | Gt -> if(gt_possible first second) then true else aux tl
      | Ge -> if(ge_possible first second) then true else aux tl
  in aux possibilities

let rec sign_expression (expr) (env: sign list VarEnv.t)  : sign list  = match expr with
  | Num(int) -> [sign_int int]
  | Op(op, l_expr, r_expr) -> 
    let left = (sign_expression l_expr env) in 
    let right = (sign_expression r_expr env) in 
    sign_operation op left right
  | Var(name) -> VarEnv.find name env

let rec sign_instr(instru: instr)(env: sign list VarEnv.t)  = 
  begin
    match instru with
    | Set(name, expr) -> VarEnv.add (name) (sign_expression expr env) (env)
    | Read(name) -> VarEnv.add (name) ([Neg;Zero;Pos]) (env)
    | Print(expr) -> env
    | While(cond, block) -> 
      let isPossible = cond_possible cond env in 
      if isPossible then sign_while (cond, block) env 
      else env
    | If(cond, block_g, block_d) -> 
      let isPossible = cond_possible cond env in 
      if isPossible then sign_block block_g env 
      else sign_block block_d env 
  end
and sign_block (b: block)(env: sign list VarEnv.t): sign list VarEnv.t = 
  begin
    match b with 
    | [] -> env
    | ( _ , instr ) :: tl ->
      let env' = sign_instr instr env in 
      sign_block tl env'
  end

and sign_while (cond, block) (env: sign list VarEnv.t) : sign list VarEnv.t = 
  let propagate_var (c : cond) (e : sign list VarEnv.t) : sign list VarEnv.t =
  (*
    We are currently inside the while. The condition is verified.
    We will propagate condition if it has a better accuracy than actual variable.
    Only way we can actually say anything about the variable, is if the expression
    is strictly negative, strictly positive, or zero.
  *)
    match c with
    | Var(x), comp, expr -> (
        let sign_expr = sign_expression expr e in
        match sign_expr with 
        | [Pos] -> (
            match comp with 
            | Eq -> VarEnv.add x [Pos] e
            | Ne -> (* We check better accuracy *)
              if List.length(VarEnv.find x e) > 2 then (VarEnv.add x [Zero; Neg] e) else e
            | Lt -> e (* [Pos; Neg; Zero] doesn't help accuracy *)
            | Le -> e
            | Gt -> VarEnv.add x [Pos] e
            | Ge -> VarEnv.add x [Pos] e
          )
        | [Neg] -> (
            match comp with 
            | Eq -> VarEnv.add x [Neg] e
            | Ne -> (* We check better accuracy *)
              if List.length(VarEnv.find x e) > 2 then (VarEnv.add x [Zero; Pos] e) else e
            | Lt -> VarEnv.add x [Neg] e
            | Le -> VarEnv.add x [Neg] e
            | Gt -> e (* [Pos; Neg; Zero] doesn't help accuracy *)
            | Ge -> e
          )
        | [Zero] -> (
            match comp with 
            | Eq -> VarEnv.add x [Zero] e
            | Ne -> (* We check better accuracy *)
              if List.length(VarEnv.find x e) > 2 then (VarEnv.add x [Pos; Neg] e) else e
            | Lt -> VarEnv.add x [Neg] e (* [Pos; Neg; Zero] doesn't help accuracy *)
            | Le -> VarEnv.add x [Zero; Neg] e
            | Gt -> VarEnv.add x [Pos] e
            | Ge -> VarEnv.add x [Pos; Zero] e
          )
        | _ -> e
      )
    | (_, _, _) -> e
  in

  let rec aux e = 
    print_string "Old State : \n";
    print_sign_list e;
    print_string "\n";
    let propagated_env = propagate_var cond e in
    let new_e = sign_block (block) (propagated_env) in
    print_string "New State : \n";
    print_sign_list new_e;
    print_string "\n";
    if (VarEnv.equal equal_contents (e) (merge_env e new_e)) 
    then (
      print_string "Propagating reverse condition : \n";
      let (e1, comp, e2) = cond in
      let op_cond = (e1, opposite_comp comp, e2) in 
      propagate_var (op_cond) (e)
    )
    else aux (merge_env e new_e)
  in aux env
