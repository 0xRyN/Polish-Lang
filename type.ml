type position = int

(** Nom de variable *)
type name = string

(** Opérateurs arithmétiques : + - * / % *)
type op = Add | Sub | Mul | Div | Mod


(** Expressions arithmétiques *)
type expr =
  | Num of int
  | Var of name
  | Op of op * expr * expr

(** Opérateurs de comparaisons *)
type comp =
  | Eq (* = *)
  | Ne (* Not equal, <> *)
  | Lt (* Less than, < *)
  | Le (* Less or equal, <= *)
  | Gt (* Greater than, > *)
  | Ge (* Greater or equal, >= *)

(** Signe des Variables *)
type sign = Neg | Zero | Pos | Error

(** Condition : comparaison entre deux expressions *)
type cond = expr * comp * expr

(** Instructions *)
type instr =
  | Set of name * expr
  | Read of name
  | Print of expr
  | If of cond * block * block
  | While of cond * block
and block = (position * instr) list

type program = 
  block

module Table = Map.Make(String)
module VarEnv = Map.Make(String)
