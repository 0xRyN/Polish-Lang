open Type;;
open Utility;;
(***********************************************************************)
(*                        PARSING                                      *)

(* Parses the first instruction given and returns the rest of the list to callback later *)
let rec parse_expression(words: string list): expr * string list = match words with 
    [] -> failwith "Pas de liste de mot" 
  | mot :: tl ->
    if is_int mot then 
      Num ( int_of_string mot ), tl
    else  
    if is_operator mot then 
      let (expr_gauche, tl') = parse_expression tl in 
      let (expr_droite, tl'') = parse_expression tl' in 
      match mot with 
      | "+" -> ( Op (Add, expr_gauche, expr_droite)), tl''
      | "-" -> ( Op (Sub, expr_gauche, expr_droite)), tl''
      | "*" -> ( Op (Mul, expr_gauche, expr_droite)), tl''
      | "/" -> ( Op (Div, expr_gauche, expr_droite)), tl''
      | "%" -> ( Op (Mod, expr_gauche, expr_droite)), tl''
      | _ -> failwith "ERROR: Doesn't contains other types" 
    else Var (mot: name ), tl 

(* Parses the first condition given and returns the rest of the list to callback later *)
let parse_condition(line: string list): cond * string list = 
  match line with 
  | [] -> failwith "EROR: Empty List of Words" 
  | _ ->
    let (expr_gauche, tl) = parse_expression line in 
    match tl with 
    | [] -> failwith "ERROR: Doesn't contains the right expression"
    | hd :: tl' ->
      let (expr_droite, tl') = parse_expression tl'  in match hd with
      | "=" -> (expr_gauche, Eq, expr_droite), tl'
      | "<>" -> (expr_gauche, Ne, expr_droite), tl'
      | "<" -> (expr_gauche, Lt, expr_droite), tl'
      | "<=" -> (expr_gauche, Le, expr_droite), tl'
      | ">" -> (expr_gauche, Gt, expr_droite), tl'
      | ">=" -> (expr_gauche, Ge, expr_droite), tl' 
      | _ -> failwith "ERROR: Doesn't find the condition operator"

(* 
    Parses the given instruction/block. Mutually recursive with parse_block to parse whole blocks.
    Uses callbacks and mutual recursivity for a pure functional approach to parsing.
    The first block contains all the lines in the program.
*)
let rec parse_instruction (lines:(int * string) list) : (instr * ( (int * string) list) ) =
  match lines with
  | [] -> failwith "ERROR: Liste vide"
  | line :: tl -> 
    let swords = (snd line) in 
    let words = get_words (swords) in 
    let cwords = clean_words words in 
    match cwords with
    | first :: second :: tl' -> (
        match first with 
        | "READ" ->
          (Read(second), tl)
        | "PRINT" -> 
          let parse = parse_expression (second::tl') in 
          (Print(fst(parse)), tl)
        | "WHILE" -> (* WHILE a < b *)
          let blk = parse_block tl in
          let cnd = parse_condition (second::tl') in
          (While(fst cnd, fst blk), snd blk)
        | "IF" -> (
            let cnd = parse_condition (second::tl') in
            let fstBlock = parse_block tl in
            match (snd fstBlock) with 
            | [] -> failwith "Else is bugged"
            | (num , content) :: tl'' ->
              let cnt = get_words (content) in 
              let cwords = clean_words cnt in 
              if List.hd (cwords) = "ELSE" then
                (let sndBlock = parse_block tl'' in
                 (If(fst cnd, fst fstBlock, fst sndBlock), snd sndBlock))
              else
                (let sndBlock = parse_block ((num,content)::tl'') in
                 (If(fst cnd, fst fstBlock,[]), snd fstBlock))
          )
        | _ ->
          match second with 
          | "" -> failwith "ERROR: Empty"
          | ":=" -> 
            let parse = parse_expression tl' in
            (Set(first, fst(parse)), tl)
          | _ -> failwith "ERROR: Not an instruction"
      )
    | _ -> failwith "err"

and parse_block (lines:(int * string) list) :(block * ((int * string) list)) =
  (* First, we define block's indentation *)
  let indentation_block = get_indentation(snd (List.hd lines)) in

  let rec aux acc (m_lines:(int * string) list) = match m_lines with
    | [] -> acc, m_lines
    | line :: tl -> 
      if indentation_block > get_indentation(snd line) then acc, m_lines else
        let pos = fst line in
        let inst = parse_instruction m_lines in
        let toAcc = (pos, fst inst) in
        aux (acc@[toAcc]) (snd inst)
  in aux [] lines