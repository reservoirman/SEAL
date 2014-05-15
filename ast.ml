type binop = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq 
            | Orl | Andl | Or | And | Bsr | Bsl | Xor

type unop = Not | Inc | Dec | Inv
type sealConstruct = Interrupt | Thread | Variable | Function | Class
type sealType = 
  Array of sealType * string | Void | Byte | Int |  Double | String | Lock | NewType of string


type expr =   
    Iliteral of int
  | Fliteral of float
  | Sliteral of string
  | Variable of sealType
  | Id of string (* used in SEAL as well *)
  | Binop of expr * binop * expr
  | Unop of unop * expr
  | Assign of expr   * expr
  | Call of string  * expr list (**)
  | LabelCall of string * string * expr list 
  | CastType of sealType * expr (* the following are new in SEAL*)
  | Address of string  * expr
  | GetAddress of string
  | ArrayIndex of string  * string 
  | Label of expr  * expr
  | Swap of string
  | Signal of string * expr
  | Map of string * string * expr * expr
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
  | For of expr * expr * expr * stmt list
  | While of expr * stmt list

type var_decl = {
  vtype : sealType ;
  vname : string;
}

type func_decl = {
    rtype : sealType ;
    fname : string;
    formals : var_decl list;
    locals : var_decl list;
    body : stmt list;
  }

type thread_decl = {
    tname : string;
    tlocals : var_decl list;
    tbody : stmt list;
}

type interrupt_decl = {
    iname : string;
    ilocals : var_decl list;
    ibody : stmt list;
}

type type_decl = {
  ytype       : sealType;
  yname      : string;
  yproperties : var_decl list;
  yfunctions  : func_decl list;
}

let first = fun (a,b,c,d,e) -> a
let second = fun (a,b,c,d,e) -> b
let third = fun (a,b,c,d,e) -> c
let fourth = fun (a,b,c,d,e) -> d
let fifth = fun (a,b,c,d,e) -> e

(* type program = string list * func_decl list *)
type program = var_decl list * func_decl list * thread_decl list * interrupt_decl list * type_decl list 

let rec string_of_expr = function
    Sliteral(l) -> l
  | Fliteral(l) -> string_of_float l
  | Iliteral(l) ->  string_of_int l
  | Id(s) -> s
  | Binop(e1, o, e2) -> "(" ^
      string_of_expr e1 ^ " " ^
      (match o with 
	Add -> "+" | Sub -> "-" | Mult -> "*" | Div -> "/"
      | Equal -> "==" | Neq -> "!="
      | Less -> "<" | Leq -> "<=" | Greater -> ">" | Geq -> ">=" 
      | Orl -> "||" | Andl -> "&&" | Or -> "|" | And -> "&" 
      | Bsr -> ">>" | Bsl -> "<<" | Xor -> "^" ) ^ " " ^
      string_of_expr e2 ^ ")"
  | Unop(o, e)-> "(" ^ 
    (match o with
      Not -> "!" 
      | Inc -> "++"
      | Dec -> "--"
      | Inv -> "~") ^ string_of_expr e^")" 
  | Assign(v, e) -> string_of_expr v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ") function call performed."
  | LabelCall(v, f, el) -> v ^ "." ^ f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ") function call performed."
  | Noexpr -> ""
  | CastType(a, b)->"" (* the following are new in SEAL*)
  | Address(a, b)-> a ^ ".Address is now = " ^  string_of_expr b
  | GetAddress(a)-> "address of " ^ a
  | ArrayIndex(a, b)-> "Array " ^ a ^ "[" ^  b ^ "] indexed."
  | Label(a, b)-> string_of_expr a ^ " . " ^ string_of_expr b
  | Signal(a, b)-> "Interrupt " ^ a ^ " now handling interrupt " ^ string_of_expr b
  | Variable(a)-> ""
  | Map(a,b,c,d)-> "Mapping function " ^ b ^ "of type " 
    ^ string_of_expr d ^ " with "^ string_of_expr c ^ " elements to " ^ a
  | Swap(a)-> a ^ "has been swapped!"

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
      string_of_expr e3  ^ ") " ^ String.concat "" (List.map string_of_stmt s)
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ String.concat "" (List.map string_of_stmt s)

let string_of_vdecl id =  " " ^ id.vname ^ ";\n"

let string_of_vparam id = " " ^ id.vname ^ ", "

let string_of_fdecl fdecl =
  fdecl.fname ^ "(" ^ String.concat ", " (List.map (fun x -> x.vname) fdecl.formals) ^ ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_tdecl tdecl = 
  tdecl.tname ^
  String.concat "" (List.map string_of_vdecl tdecl.tlocals) ^
  String.concat "" (List.map string_of_stmt tdecl.tbody) ^
  "}\n"

let string_of_idecl idecl = 
  idecl.iname ^ 
  String.concat "" (List.map string_of_vdecl idecl.ilocals) ^
  String.concat "" (List.map string_of_stmt idecl.ibody) ^
  "}\n"

let string_of_ydecl ydecl = 
  ydecl.yname ^ 
  String.concat "" (List.map string_of_vdecl ydecl.yproperties) ^
  String.concat "" (List.map string_of_fdecl ydecl.yfunctions) ^
  "}\n"




let string_of_program (vars, funcs, threads, interrupts, types) =
  "THE LIST OF VARS: " ^
  String.concat ""  (List.map string_of_vdecl vars) ^ "\n" ^
  "\nTHE LIST OF FUNCS: \n" ^ 
  String.concat ""  (List.map string_of_fdecl funcs) ^ "\n" ^
    "THE LIST OF THREADS: \n" ^
  String.concat ""  (List.map string_of_tdecl threads) ^ "\n" ^
    "THE LIST OF INTERRUPTS: \n" ^
  String.concat ""  (List.map string_of_idecl interrupts) ^ "\n" ^
    "THE LIST OF TYPES: \n" ^
  String.concat ""  (List.map string_of_ydecl types)

