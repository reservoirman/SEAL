type op = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq

type expr =
    Literal of int
  | Id of string (* used in SEAL as well *)
  | Binop of expr * op * expr
  | Assign of string * expr
  | Call of string * expr list
  | Noexpr
  (* the following are new expressions for SEAL only 
  | Int of int
  | Flt of float
  | Var of string *)

type stmt =
    Block of stmt list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | For of expr * expr * expr * stmt
  | While of expr * stmt

type func_decl = {
    rtype : string ;
    fname : string;
    formals : string list;
    locals : string list;
    body : stmt list;
  }

type thread_decl = {
    tname : string;
    tlocals : string list;
    tbody : stmt list;
}

type interrupt_decl = {
    iname : string;
    ilocals : string list;
    ibody : stmt list;
}

type type_decl = {
  yname      : string;
  yproperties : string list;
  yfunctions  : func_decl list;
}

let first = fun (a,b,c,d,e) -> a
let second = fun (a,b,c,d,e) -> b
let third = fun (a,b,c,d,e) -> c
let fourth = fun (a,b,c,d,e) -> d
let fifth = fun (a,b,c,d,e) -> e

type program = string list * func_decl list
type program1 = string list * thread_decl list * interrupt_decl list * type_decl list * func_decl list

let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | Id(s) -> s
  | Binop(e1, o, e2) -> "(" ^
      string_of_expr e1 ^ " " ^
      (match o with
	Add -> "+" | Sub -> "-" | Mult -> "*" | Div -> "/"
      | Equal -> "==" | Neq -> "!="
      | Less -> "<" | Leq -> "<=" | Greater -> ">" | Geq -> ">=") ^ " " ^
      string_of_expr e2 ^ ")"
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Noexpr -> ""

let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | If(e, s, Block([])) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let string_of_vdecl id = "int " ^ id ^ ";\n"

(*TSG placeholders for now, fill in later*)
let string_of_tdecl tdecl = 
  tdecl.tname

let string_of_idecl idecl = 
  idecl.iname

let string_of_ydecl ydecl = 
  ydecl.yname  

let string_of_fdecl fdecl =
  fdecl.fname ^ "(" ^ String.concat ", " fdecl.formals ^ ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"




let string_of_program (vars, threads, interrupts, types, funcs) =
  "THE LIST OF VARS: " ^
  String.concat ""  (List.map string_of_vdecl vars) ^ "\n" ^
    "THE LIST OF THREADS: " ^
  String.concat ""  (List.map string_of_tdecl threads) ^ "\n" ^
    "THE LIST OF INTERRUPTS: " ^
  String.concat ""  (List.map string_of_idecl interrupts) ^ "\n" ^
    "THE LIST OF TYPES: " ^
  String.concat ""  (List.map string_of_ydecl types) ^ "\n" ^
  "\nTHE LIST OF FUNCS: " ^ 
  String.concat ""  (List.map string_of_fdecl funcs)
