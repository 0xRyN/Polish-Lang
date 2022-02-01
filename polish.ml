(** Projet Polish -- Analyse statique d'un mini-langage impératif *)

(** Note : cet embryon de projet est pour l'instant en un seul fichier
    polish.ml. Il est recommandé d'architecturer ultérieurement votre
    projet en plusieurs fichiers source de tailles raisonnables *)

(*****************************************************************************)
(** Syntaxe abstraite Polish (types imposés, ne pas changer sauf extensions) *)

(** Position : numéro de ligne dans le fichier, débutant à 1 *)
open Type;;
open Utility;;

(***********************************************************************)
(*              Read a file a convert it to (int * string )list        *)

let read_polish (filename:string) : program = 
  let read_file (filename:string) :(int * string) list =
  let f = open_in filename in
  let rec loop acc count = 
    try
      let line = input_line f in
      let words = get_words line in 
      let indentation = get_indentation line in 
      let cwords = clean_words words in 
      (* Check if it's an empty line or a command and just ignore it *)
      if List.length words = indentation then
        loop ( acc ) ( count )
      else 
        (* Not a polish file *)
      if indentation mod 2 != 0 then 
        failwith "ERROR: Not a Polish File contains indentation odd"
      else
      if List.hd cwords = "COMMENT" then
        loop ( acc ) ( count )
      else 
        (* We add other words we want to the list *)
        loop ( (count,line)::acc ) ( count+1 )
    with End_of_file ->
      (  close_in f;  List.rev acc)
  in loop [] 1 in
  let rd = read_file ( filename ) in
  fst( Parser.parse_block rd )

(***********************************************************************)
(* 
  Option -print
  Translate the program to Polish syntax
*)
let print_polish (p:program) : unit = match p with 
  | _ -> Print.print_block p 0;;

(***********************************************************************)
(* 
  Option -eval 
  
*)
let eval_polish (p:program) : unit = 
  let f (x: int Table.t) : unit =  () in 
  let tbl = Eval.eval_block (p) (Table.empty) in 
  f tbl
  
(***********************************************************************)
(* 
  Option -simpl 
  Allows you to perform basic simplifications and then display the program.
*)
let simpl_polish (p:program) : unit = 
  print_polish (Simpl.analyze_block p)

(***********************************************************************)
(* 
  Option -vars 
  In the first line, we got all the variables
  In the second line you gonna see the variables which are accessible but not initialize
  (which produce errors)

*)
let vars_polish(p: program): unit = 

  let rec add_to_list (list: (name * position ) list) (accu: name) = match list with 
  | [] -> accu
  | (name, position ) :: tl -> match accu with 
    | "" -> add_to_list tl ( name )
    | _ -> add_to_list tl (accu ^ " " ^ name )
  in 

  print_string(add_to_list (Vars.get_vars_block p) "" );
  print_newline();
  print_string(add_to_list (Vars.get_vars_block_second p) "" )

(***********************************************************************)
(* 
  Option -sign 
  Evaluate the sign of variables
*)
let eval_sign (p:program) : unit = 
  if Vars.get_vars_block_second p != [] then failwith "Variable(s) non initialisé" else  
  let f (x: sign list VarEnv.t) = VarEnv.iter (fun x y -> Printf.printf "%s -> %s\n" x (Sign.pure_print_sign_list y)) x in 
  let tbl = Sign.sign_block (p) (VarEnv.empty) in 
  f tbl

(***********************************************************************)

let usage () =
  print_string "Polish : analyse statique d'un mini-langage\n";
  print_string "./run -eval <file>\n";
  print_string "Evaluate the program file\n";
  print_string "./run -reprint <file>\n";
  print_string "Display the content of file\n";
  print_string "./run -sign <file>\n";
  print_string "Evaluate the sign of variables\n";
  print_string "./run -vars <file>\n";
  print_string "In the first line, we got all the variables\n";
  print_string "and on the second line you gonna see the variables which are accessible but not initialize\n";
  print_string "./run -simpl <file>\n";
  print_string "Simplify (factorize the expression)"

let main () =
  match Sys.argv with
  | [|_;"-reprint";file|] -> print_polish (read_polish file)
  | [|_;"-eval";file|] -> eval_polish (read_polish file)
  | [|_;"-sign";file|] -> eval_sign (read_polish file)
  | [|_;"-simpl";file|] -> simpl_polish (read_polish file)
  | [|_;"-vars";file|] -> vars_polish (read_polish file)
  | _ -> usage ()

let () = main()