open Type;;

(***********************************************************************)
(*                        UTILITY                                      *)

(************************************************************************)
(* VERY USEFUL FOR DEBUGGING - NOT USED IN CODE *)
(************************************************************************)

(* Prints an (int * string) list *)
let print_l (l: (int * string) list) : unit = 
  List.iter (fun (x) -> print_int (fst x); print_string " "; print_string (snd x); print_string "\n") l

(* Prints a string list *)
let print_str_l (l: string list) : unit = 
  List.iter (fun (x) -> print_string x; print_string "\n") l

(* Prints an (int*instruction) tuple *)
let print_instr (l:(int * instr)) : unit = 
  match snd l with 
  | Set(name, expr) -> print_string "Set"; print_string "\n"
  | Read(name) -> print_string "Read : "; print_string name; print_string "\n"
  | Print(expr) -> print_string "Print"; print_string "\n"
  | If(cond, block1, block2) -> print_string "If"; print_string "\n"
  | While (cond, block) -> print_string "While"; print_string "\n"

(* Prints an arithmetic expression *)
let print_expr (ex:expr) : unit = 
  match ex with
  | Num(i) -> print_string "Num : "; print_int i; print_string "\n"
  | Var(s) -> print_string "Var : "; print_string s; print_string "\n"
  | Op(op, ex1, ex2) -> print_string "op"

(* Prints a list of (int * instr) tuples*)
let print_instr_list (l:(int * instr) list) : unit =
  print_string "-------------------\n";
  List.iter (fun (x) -> print_string "value: "; print_instr x; print_string "\n") l;
  print_string "END\n-------------------\n\n"

(* Get words of a line - string ( a word is a list of characters not containing " " ) *)
let get_words (line: string) : string list = String.split_on_char ' ' line

(* Remove the empty whitespaces from a line *)
let remove_indentation (line: string): string list =
  let rec loop l = match l with
    | [] -> []
    | "" :: tl -> loop tl
    | list -> list
  in loop (get_words line)

(* Get indentation of a line *)
let get_indentation (line: string) : int = 
  let rec loop l accu = match l with
    | [] -> accu
    | x::tl -> if x = "" then loop tl (accu+1) else accu
  in loop ( get_words line ) 0 

(* Let clean empty word we don't want it *)
let clean_words (line: string list): string list =
  let rec loop l = match l with
    | [] -> []
    | "" :: tl -> loop tl
    | hd :: tl -> hd :: loop tl
  in loop ( line )

(* Just checks if a string is convertible to int (is an int) *)
let is_int (word: string): bool = 
  try int_of_string word |> ignore; true
  with Failure _ -> false

let is_operator (word: string): bool = match word with
  | "+" | "-" | "*" | "/" | "%" -> true
  | _ -> false  