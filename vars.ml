open Type;;
(* Check if element elt is in the list *)
let rec is_in_list elt list = match list with 
  | [] -> false 
  | (name, int) :: tl -> 
    if elt = name then true else is_in_list elt tl

(* Remove duplicates elements in a list *)
let remove_duplicates l =
  let remove_elt e l =
    let rec loop l acc = match l with
      | [] -> List.rev acc
      | x::xs when e = x -> loop xs acc
      | x::xs -> loop xs (x::acc)
    in loop l [] 
  in
  let rec loop l acc = match l with
    | [] -> List.rev acc
    | x :: xs -> loop (remove_elt x xs) (x::acc)
  in loop l []

(* 
  Get all the variable in an expression
*)
let rec get_vars_expression (expr: expr)(pos: position) : (name * int) option list = match expr with
  | Num(int) -> []
  | Var(name) -> [Some(name, pos)]
  | Op(op,l_expr,r_expr) ->
    remove_duplicates((get_vars_expression l_expr pos)@(get_vars_expression r_expr pos))

(* Convert string option list to string list  *)
let option_to_list(list: (name * int) option list): (name * int ) list = 
  let rec loop accu list = match list with 
  | [] -> accu 
  | hd :: tl -> match hd with 
    | Some(name, pos) -> loop (accu@[(name, pos)]) tl 
    | _ -> loop accu tl
  in loop [] list

(* Get all the variables in condition *)
let get_vars_condition (cond: cond)(pos: position): (name * int) option list =
  let (l_expr, comp, r_expr) = cond in match comp with 
  | _ -> remove_duplicates(get_vars_expression l_expr pos@get_vars_expression r_expr pos)


(* Function useful to calculate difference *)
let dif list1 list2  = 
  let rec find e = function
  | [] -> false
  | h :: t -> fst h = fst e || find e t 
  in 
  let rec rec_dif list1 list2 acc =
    match list1 with 
    |[]-> acc
    |hd :: tl -> if not (find hd list2) then rec_dif tl list2 (hd::acc) else rec_dif tl list2 acc 
  in rec_dif list1 list2 []

(* 
  Difference between two list
  difference ["a";"d"] ["d";"z"] ;;
  : string list = ["z"; "a"] 
*)
let difference list1 list2 = 
  let e = dif list2 list1
  in let a = dif list1 list2 in e@a 

(* Add an expression to an accumulator and doesn't add variables which are already in*)
let add_to_accu (expr: (name * int) list ) (accu: (name * int) list ) : (name * int) list = 
  let rec loop list acc = match list with
  | [] -> acc
  | (name, pos) :: tl -> 
    (* Si le nom est déjà dans la liste on continue*)
    if is_in_list name acc then 
      loop tl acc 
    else 
      (* Sinon on ajoute à l'accumulateur le nom qu'il y est pas *)
      loop tl (acc@[(name, pos)])
  in loop expr accu

(* 
  First line of the option: -vars
  We get all the variables of the program
*)
let remove_duplicatess l =
  let remove_elt e l =
    let rec loop l acc = match l with
      | [] -> List.rev acc
      | x::xs when e = x -> loop xs acc
      | x::xs -> loop xs (x::acc)
    in loop l [] 
  in
  let rec loop l acc = match l with
    | [] -> List.rev acc
    | x :: xs -> loop (remove_elt x xs) (x::acc)
  in loop l []
let get_vars_block(blk: program) : (name * int ) list = 

  let rec aux (acc: (name * int) list) (aux_block: block): (name * int ) list = match aux_block with
  | [] -> acc
  | (pos, instr) :: tl -> match instr with 
    | Read(name) -> 
      if is_in_list name acc then aux acc tl
      else 
        let toAcc = (name, pos) in
        aux (acc@[toAcc]) tl
    | Set(name, expr) ->
      let expression = remove_duplicatess (option_to_list (get_vars_expression expr pos)) in
      let add_to_accu = add_to_accu expression acc in 
      if is_in_list name acc then aux add_to_accu tl
      else 
        let toAcc = (name, pos) in
        aux (remove_duplicatess (acc@[toAcc]@add_to_accu)) tl
    | While(cond, block) -> 
      let cond = remove_duplicatess (option_to_list ( get_vars_condition cond pos)) in 
      let add_to_accu = add_to_accu cond acc in 
      let res = aux add_to_accu block in 
      let n_accu = remove_duplicatess (acc@res) in
      aux n_accu tl   
    | If(cond, block_g, block_d) ->
      let cond = remove_duplicatess (option_to_list ( get_vars_condition cond pos)) in 
      let add_to_accu = add_to_accu cond acc in 
      let res = aux add_to_accu block_g in 
      let n_accu = remove_duplicatess (acc@res) in
      aux n_accu block_d
    | Print(expr) ->
      let expression = remove_duplicatess (option_to_list (get_vars_expression expr pos)) in
      let add_to_accu = add_to_accu expression acc in 
      aux (add_to_accu) tl 
  in aux [] blk 

(* 
  The second line of options -vars 
  This function get all the variables which are accessible but not initialize
  This function help to prevent mistakes of programmers
*)
let rec get_vars_block_second(blk: program) : (name * int) list = 
  (* add_invalid (option_to_list (get_vars_expression (Op (Add, Var "z", Var "e")) 2)) ([("res",1)]) [];; *)
  let add_invalid (liste: (name * int) list) (accu: (name * int) list ) (invalid: (name * int ) list ): (name * int) list = 
    let rec loop list valide inv = match list with
    | [] -> inv 
    | (name,pos) :: tl ->
      if is_in_list name valide then loop tl valide inv
      else 
        if is_in_list name inv then loop tl valide inv
        else
          let toAcc = [(name,pos)] in 
          loop tl valide (inv@toAcc) 
    in loop liste accu invalid in 
  
  let rec aux (acc: (name * int) list) (invalid: (name * int ) list) (aux_block: block) = match aux_block with
  | [] -> invalid
  | (pos, instr) :: tl -> match instr with 
    | Read(name) -> 
      if is_in_list name acc then aux acc invalid tl
      else 
        let toAcc = (name, pos) in
        aux (acc@[toAcc]) invalid tl
    | Set(name, expr) -> 
      (* On récupère l'expression *)
      if is_in_list name acc then 
        let expression = remove_duplicatess (option_to_list (get_vars_expression expr pos)) in 
        let invalide = add_invalid expression acc invalid in 
        aux acc (remove_duplicatess invalide) tl
      else 
        let toAcc = (name, pos) in
        let expression = remove_duplicatess (option_to_list (get_vars_expression expr pos)) in 
        let invalide = add_invalid expression acc invalid in 

        aux (remove_duplicatess(acc@[toAcc])) invalide tl
    | While(cond, block) -> 
      let condition = get_vars_condition cond pos in 
      let get_clean = (option_to_list condition) in 
      let invalide = add_invalid get_clean acc invalid in 
      
      let res = aux acc invalid block in 
      let n_accu = remove_duplicatess (invalide@res) in
      aux acc n_accu tl
    | If(cond, block_g, block_d) ->
      (* On ajoute la condition dans les invalides si la variable est invalide*)
      let condition = get_vars_condition cond pos in 
      let get_clean = (option_to_list condition) in 
      let invalid = add_invalid get_clean acc invalid in 

      (* On récupère toutes les variables invalide du bloc if*)
      let get_block_gauche = get_vars_block_second block_g in 
      let invalid = add_invalid get_block_gauche acc invalid in 
  
      (* On récupère toutes les variables invalide du bloc else*)
      let get_block_droite = get_vars_block_second block_d in 
      if get_block_droite == [] then aux acc invalid tl else 
      let invalid = add_invalid get_block_droite acc invalid in 
      

      (* On récupère toutes les variables du bloc gauche et droite*)
      let get_all_block_gauche = get_vars_block block_g in 
      let get_all_block_droite = get_vars_block block_d in 
      let get_all_variables = ( get_all_block_gauche @ get_all_block_droite) in 

      (* 
        On récupère les variables valide 
        Différence entre liste gauche total - invalide 
      *)
      let valide_g = dif get_all_block_gauche get_block_gauche in 
      let valide_d = dif get_all_block_droite get_block_droite in 

      (* 
        On vériffie si y a une différence entre les valides dans le if et le else 
        Il faut que les variables dans le if et dans le else pour être déclaré
      *)
      let difference_valide =  difference valide_g valide_d in 
      (* On ajoute celle qui différe dans invalide *)
      let invalid = add_invalid difference_valide acc invalid in 
      let diff = difference get_all_variables invalid in 


      (* On ajoute dans l'accumulateur ceux qui ne sont pas dans l'invalid mais qui sont dans valide_g et droite *)
      (* Les variables qui ne sont pas invalid sont forcément valide *)

      aux (acc@diff) (invalid) tl 
    | Print(expr) -> 
      let expression = (option_to_list (get_vars_expression expr pos)) in 
      let invalide = add_invalid expression acc invalid in 
      aux acc invalide tl
      
  in aux [] [] blk