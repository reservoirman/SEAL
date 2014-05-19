open Ast
module StringMap = Map.Make(String)

(*type for storing global variables *)
type varSymbolTableEntry = {
  data_type : sealType;
}

(*type for storing functions *)
type funcSymbolTableEntry = {
  ftype : sealType;
  fparameters : sealType StringMap.t;
  flocals :  sealType StringMap.t;
  fbodylist : stmt list;
}

(*type for storing SEAL Threads and any local variables defined within the Thread *)
type threadSymbolTableEntry = {
  thlocals : sealType StringMap.t;
  thbodylist : stmt list;
}

(*type for storing SEAL Interrupt handlers and any local variables defined within the handler*)
type interruptSymbolTableEntry = {
  inlocals : sealType StringMap.t;
  inbodylist : stmt list;
}

(*type for storing SEAL types defined by the user*)
type typeTableEntry = {
  thetype : sealType;
  properties : sealType StringMap.t;
  functions : funcSymbolTableEntry StringMap.t;
}

(*the entire environment, containing the symbol table, the function table, 
  the thread table, the interrupt table, and the SEAL types table *)
type environment = {
  sealVarSymbolTable : sealType StringMap.t;
  sealFuncSymbolTable : funcSymbolTableEntry StringMap.t;
  sealThreadSymbolTable : threadSymbolTableEntry StringMap.t;
  sealInterruptSymbolTable : interruptSymbolTableEntry StringMap.t;
  sealTypeSymbolTable : typeTableEntry StringMap.t; (*TSG HMMMM *)
}

let checkForVar s env = 
  if (StringMap.mem s env.sealVarSymbolTable) then s 
        else raise(Failure("Compiler error: a variable named \'" ^ s ^ "\' does not exists."))

let checkFunctionBody theBody env construct = 

let rec output_function_expr = function
    Sliteral(l) -> l
  | Fliteral(l) -> string_of_float l
  | Iliteral(l) ->  string_of_int l
  | Id(s) -> s ^  
    (match construct with 
      Function -> checkForVar s env
      | Thread -> checkForVar s env
      | Interrupt -> checkForVar s env
      | Class -> checkForVar s env
      | Var -> checkForVar s env )

 (* match construct with Function | Thread | Interrupt *)(*if ((StringMap.mem s env.sealVarSymbolTable)) then s 
              else  ""; raise(Failure("Compiler error:  \'" ^ s ^ "\' does not exist in the current context.")) *)
  | Binop(e1, o, e2) -> "(" ^
      output_function_expr e1 ^ " " ^
      (match o with
  Add -> "+" | Sub -> "-" | Mult -> "*" | Div -> "/"
      | Equal -> "==" | Neq -> "!="
      | Less -> "<" | Leq -> "<=" | Greater -> ">" | Geq -> ">=" 
      | Orl -> "||" | Andl -> "&&"| Or -> "|"      | And -> "&" 
      | Bsr -> ">>" | Bsl -> "<<" | Xor -> "^" ) ^ " " ^
      output_function_expr e2 ^ ")"
  | Unop(o, e)-> "(" ^ 
    (match o with
      Not -> "!" 
      | Inc -> "++"
      | Dec -> "--"
      | Inv -> "~") ^ output_function_expr e^")" 
  | Assign(v, e) -> output_function_expr v ^ " = " ^ output_function_expr e
  | Call(f, el) -> if (StringMap.mem f env.sealFuncSymbolTable) then 
  (match f with
    "print" -> "printf" ^ "(" ^ String.concat ", &" (List.map output_function_expr el) ^ ")"
    | _ -> f ^ "(" ^ String.concat ", &" (List.map output_function_expr el) ^ ")") 
    else raise(Failure("Compiler error: a function named \'" ^ f ^ "\' does not exists."))
  | LabelCall(v, f, el)->
  (match f with
    "Lcreate" -> "SEALLock_Create(&" ^ v ^ ")"
    | "Acquire" -> "SEALLock_Acquire(&" ^ v ^ ")"
    | "Release" -> "SEALLock_Release(&" ^ v ^ ")"
    | "Ldestroy"-> "SEALLock_Destroy(&" ^ v ^ ")"
    | "Tcreate" -> "SEALThread_Create(&" ^ v ^ ", " ^ v ^ "___Func)"
    | "Go"      -> "SEALThread_Go(&" ^ v ^ ")"
    | "Stop"    -> "SEALThread_Stop(&" ^ v ^ ")"
    | "Join"    -> "SEALThread_Join(&" ^ v ^ ")"
    | "Tdestroy"-> "SEALThread_Destroy(&" ^ v ^ ")"
    | _         -> v ^ "." ^ f ^ "(" ^ String.concat ", " (List.map output_function_expr el) ^ ")"
  )
  | Noexpr -> ""
  | CastType(a, b)->"" (* the following are new in SEAL*)
  | Address(a, b)-> "SEALUtil_Move((void *)(&"^ a ^ "), (void*)(&" ^ output_function_expr b ^ "), sizeof(" ^ a ^ "))";  
  | GetAddress(a)-> "(&" ^ a ^")"
  | ArrayIndex(a, b)-> a ^ "[" ^  b ^ "]"
  | Label(a, b)-> output_function_expr a ^ "." ^ output_function_expr b
  | Signal(a, b)-> "SEALSignal_SetISR(" ^ a ^ "____Handler, &"^ a ^");\nSEALSignal_SetSignal(" 
          ^ output_function_expr b ^ ", &" ^ a ^ ")"
  | Swap(a)-> "SEALUtil_Swap((void *)&" ^  a ^ ", sizeof(" ^  a ^ "))"
  | Map(a, b, c, d)-> (*find out the type of this array *)
      "SEALArray_Map((void *)" ^a^", (void (*)(void *))"^b^", "^output_function_expr c^", " ^ output_function_expr d ^")"
  | Variable(a)-> "" in

let rec output_function_stmts = function
  | Block(stmts)  -> "{\n" ^ String.concat "" (List.map output_function_stmts stmts) ^ "}\n";
  | Expr(expr)    -> output_function_expr expr ^ ";\n";
  | Return(expr)  -> "return " ^ output_function_expr expr ^ ";\n"
  | If(e, s, Block([])) -> "if (" ^ output_function_expr e ^ ")\n" ^ output_function_stmts s;
  | If(e, s1, s2)       -> "if (" ^ output_function_expr e ^ ")\n" ^
      output_function_stmts s1 ^ "else\n" ^ output_function_stmts s2;
  | For(e1, e2, e3, s)  -> "for (" ^ output_function_expr e1  ^ " ; " ^ output_function_expr e2 ^ " ; " ^
      output_function_expr e3  ^ ") " ^ String.concat "" (List.map output_function_stmts s) ;
  | While(e, s)         -> "while (" ^ output_function_expr e ^ ")\n{" ^ String.concat "" (List.map output_function_stmts s) ^"}"


  in List.map output_function_stmts (List.rev theBody);; 

(* prints out the type.  Character can either be *, for parameters since SEAL
  is inherently pass-by-reference, or "", for local and global variables *)
let rec output_type key character = function
  | Byte                -> "unsigned char " ^ character ^ key
  | Int                 -> "int " ^ character ^ key
  | Double              -> "double " ^ character ^ key
  | String              -> "char *" ^ character ^ key
  | NewType(newtype)    -> newtype ^ character ^ " " ^ key
  | Lock                -> "Lock " ^ key
  | Array(basetype, sz) -> (output_type key character basetype ) ^ "[" ^ sz ^ "]" 

let rec output_typefunc key = function
  Void                  -> "void " ^ " " ^ key
  | Byte                -> "unsigned char "  ^ key
  | Int                 -> "int " ^ key
  | Double              -> "double " ^ key
  | String              -> "char *" ^ key
  | NewType(newtype)    -> newtype ^ " " ^ key

let output_newtype = function
| NewType(newtype) -> newtype ^ " "

(* spits out the global variables in C form, post semantically checked AST *)
 let output_globals global_table env =  
  let output_each_global key value =
    print_endline (output_type key "" value  ^ ";") in
  StringMap.iter output_each_global global_table

 let output_params param_table =  
  let output_each_param key value =
    print_string (output_type key "*" value ^ ", ") in
  StringMap.iter output_each_param param_table


(* spits out the thread definitions in C form, post semantically checked AST *)
 let output_threads thread_table env=  
  let output_each_thread key value =
    print_endline ("Thread " ^ key ^ ";"); in
    StringMap.iter output_each_thread thread_table;
  let output_each_threadbody key value = 
    let threadbody = 
    "void *" ^ key ^ "___Func (void *arg)\n{" in
    print_endline (threadbody);
    output_globals value.thlocals env; 
    (*eventually output the body here as well*)
    List.map print_endline (checkFunctionBody value.thbodylist env Thread); (*the gangsta line*)
    (* List.map print_endline (List.map output_function_stmts value.thbodylist); the gangsta line*)
    print_endline ("}\n") in
    StringMap.iter output_each_threadbody thread_table;;


(* spits out the interrupt handlers in C form, post semantically checked AST *)
let output_interrupts interrupt_table env = 
  let output_each_interrupt key value =
    print_endline ("Interrupt " ^ key ^ ";"); in
    StringMap.iter output_each_interrupt interrupt_table;
  let output_each_interruptbody key value =
    let interruptbody = 
    "void " ^ key ^ "____Handler (int sig)\n{" in
    print_endline (interruptbody);
    output_globals value.inlocals env;
    (*eventually output the body here as well*)
    List.map print_endline (checkFunctionBody value.inbodylist env Interrupt); 
    (* List.map print_endline (List.map output_function_stmts value.inbodylist); the gangsta line*)
    print_endline ("}\n") in
    StringMap.iter output_each_interruptbody interrupt_table;;


 let output_functions function_table typeFunction env = 
  (*we don't print out system functions such as print *)
  let output_each_function key value = if key <> "print" then (
    print_string (output_typefunc key value.ftype ^ "("); 
    output_params value.fparameters; 
    if typeFunction != Ast.Void then print_string ((output_newtype typeFunction) ^" *itself");
    print_endline (")");
    print_endline ("{"); 
    output_globals value.flocals env;
    (*eventually output the body here as well*)
    List.map print_endline (checkFunctionBody value.fbodylist env Function); 
    (* List.map print_endline (List.map output_function_stmts value.fbodylist); the gangsta line*)
    print_endline ("}\n")) in
    StringMap.iter output_each_function function_table;;

 let output_types types_table env = 
  let output_each_type key value =
    print_endline ("typedef struct {"); 

    output_globals value.properties env;
    print_endline ("} " ^ key ^ ";\n"); 
    (*eventually output the body here as well*)
    output_functions value.functions value.thetype env in
    StringMap.iter output_each_type types_table;;

(*utility to print out keys of each string Map*)
let print_vars key value =
    print_string(key ^ " \n");
    (*array type checking.  This is amazing!! *)
    let thetype = Ast.Array(Int, "function") and thattype = value in 
    if thetype = thattype then print_endline "BOOMSHAKALAKA!" 
  else print_endline "NOPE!";;

let print_funcs key value = 
    print_string("Function "^ key ^": \n");
    print_endline "Parameters:";
    StringMap.iter print_vars value.fparameters;
    print_endline "Local variables:";
    StringMap.iter print_vars value.flocals;;

let print_threads key value = 
    print_string("Thread "^ key ^": \n");
    print_endline "Local variables:";
    StringMap.iter print_vars value.thlocals;;

let print_interrupts key value = 
    print_string("Interrupt "^ key ^": \n");
    print_endline "Local variables:";
    StringMap.iter print_vars value.inlocals;;

let print_types key value = 
    print_string("SEAL Type "^ key ^": \n");
    print_endline "Properties:";
    StringMap.iter print_vars value.properties;
    print_endline "Methods:";
    StringMap.iter print_funcs value.functions;;    


(*TSG
let check_thread_bodies thread_table =
  let check_each_tbody key value =

    value.thbody = checkFunctionBody value.thbodylist value.thlocals StringMap.empty in 
  StringMap.map check_each_tbody thread_table;;

let check_interrupt_bodies interrupt_table =
  let check_each_ibody key value =
    value.inbody = checkFunctionBody value.inbodylist value.inlocals StringMap.empty in 
  StringMap.map check_each_ibody interrupt_table;;

let check_function_bodies function_table =
  let check_each_fbody key value =
    value.fbody = checkFunctionBody value.fbodylist value.flocals value.fparameters in 
  StringMap.map check_each_fbody function_table;;
*)

(*function that creates symbol tables for variables *)
let createSealVarSymbolTable map (var_elem: var_decl list) = 
  List.fold_left 
  (fun map thelist -> 
    if StringMap.mem thelist.vname map 
    then 
      raise(Failure("Compiler error: a variable named \"" ^ thelist.vname ^ "\" already exists.  Please choose a different name.")) 
    else 
      StringMap.add thelist.vname thelist.vtype map) 
  map var_elem

let createSealFuncSymbol (var_elem: func_decl) = 
  {
    ftype = var_elem.rtype;
    fparameters = createSealVarSymbolTable StringMap.empty var_elem.formals;
    flocals = createSealVarSymbolTable StringMap.empty var_elem.locals;
    fbodylist = var_elem.body;  (*this is prior to checking the body *)
  }
    

(*function that creates symbol table for functions *)
let createSealFuncSymbolTable map (var_elem: func_decl list) = 
  List.fold_left (fun map thelist -> 
    if StringMap.mem thelist.fname map then raise(Failure("Compiler error: a function named \'" ^ thelist.fname ^ "\' already exists.  Please choose a different name.")) else 
    StringMap.add thelist.fname (createSealFuncSymbol thelist) map) map var_elem

let createSealThreadSymbol (var_elem: thread_decl) = 
  {
    thlocals = createSealVarSymbolTable StringMap.empty var_elem.tlocals;
    thbodylist = var_elem.tbody; (*this is prior to checking the body *)
  }

(*function that creates symbol table for functions *)
let createSealThreadSymbolTable map (var_elem: thread_decl list) = 
  List.fold_left (fun map thelist -> 
    if StringMap.mem thelist.tname map then raise(Failure("Compiler error: a Thread named \'" ^ thelist.tname ^ "\' already exists.  Please choose a different name.")) else 
    StringMap.add thelist.tname (createSealThreadSymbol thelist) map) map var_elem

let createSealInterruptSymbol (var_elem: interrupt_decl) = 
  {
    inlocals = createSealVarSymbolTable StringMap.empty var_elem.ilocals;
    inbodylist = var_elem.ibody; (*this is prior to checking the body *)
  }
  
(*function that creates symbol table for functions *)
let createSealInterruptSymbolTable map (var_elem: interrupt_decl list) = 
  List.fold_left (fun map thelist -> 
    if StringMap.mem thelist.iname map then raise(Failure("Compiler error: an Interrupt handler named \'" ^ thelist.iname ^ "\' already exists.  Please choose a different name.")) else 
    StringMap.add thelist.iname (createSealInterruptSymbol thelist) map) map var_elem

let createSealTypeSymbol (var_elem: type_decl) = 
  {
    thetype = var_elem.ytype;
    properties = createSealVarSymbolTable StringMap.empty var_elem.yproperties;
    functions = createSealFuncSymbolTable StringMap.empty var_elem.yfunctions;
  }

(*function that creates symbol table for functions *)
let createSealTypeSymbolTable map (var_elem: type_decl list) = 
  List.fold_left (fun map thelist -> 
    if StringMap.mem thelist.yname map then raise(Failure("Compiler error: a Type named \'" ^ thelist.yname ^ "\' already exists.  Please choose a different name.")) else 
    StringMap.add thelist.yname (createSealTypeSymbol thelist) map) map var_elem


let header =
"#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include \"SEAL_Thread.h\"
#include \"SEAL_Lock.h\"
#include \"SEAL_Util.h\"
#include \"SEAL_Signal.h\"
#include \"SEAL_Array.h\"
"

(*  Translate a program in AST form into a bytecode program.  Throw an
    exception if something is wrong, e.g., a reference to an unknown
    variable or function *)
let translate (globals, functions, threads, interrupts, types) =


    (* print_endline "OH SNAP HERE'S THE LIST OF GLOBALS"; *)
    let var_table = createSealVarSymbolTable StringMap.empty globals in
    (* StringMap.iter print_vars var_table; *)

    (* print_endline "OH SNAP HERE's THE LIST OF FUNCTIONS"; *)
    let fun_table = createSealFuncSymbolTable StringMap.empty functions in
    (*TSG THIS DOESN'T WORK SOMEHOW: 
    (*adding the standard library function print: *)
    StringMap.add "print" ({ftype = Ast.Void;
    fparameters = createSealVarSymbolTable StringMap.empty [];
    flocals = createSealVarSymbolTable StringMap.empty [];
    fbodylist = []}) fun_table; *)
    (* StringMap.iter print_funcs fun_table; *)

    (* print_endline "OH SNAP HERE's THE LIST OF THREADS"; *)
    let thread_table = createSealThreadSymbolTable StringMap.empty threads in
    (* StringMap.iter print_threads thread_table; *)

    (* print_endline "OH SNAP HERE's THE LIST OF INTERRUPTS"; *)
    let interrupt_table = createSealInterruptSymbolTable StringMap.empty interrupts in
    (* StringMap.iter print_interrupts interrupt_table; *)

    (* print_endline "OH SNAP HERE's THE LIST OF TYPES"; *)
    let type_table = createSealTypeSymbolTable StringMap.empty types in
    (* StringMap.iter print_types type_table; *)
    let env = 
    {
      sealVarSymbolTable = var_table;
      sealFuncSymbolTable = fun_table;
      sealThreadSymbolTable = thread_table;
      sealInterruptSymbolTable = interrupt_table;
      sealTypeSymbolTable = type_table; (*TSG HMMMM *)

    } in
(*
    check_function_bodies fun_table;
    check_thread_bodies thread_table;
    check_interrupt_bodies interrupt_table;
*)  
    


    
    print_endline header; 
    output_globals var_table env;
    output_types type_table env;
    output_threads thread_table env;
    output_interrupts interrupt_table env;
    output_functions fun_table Void env;


    


