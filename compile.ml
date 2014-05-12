open Ast
open Tac
module StringMap = Map.Make(String)

(* Symbol table: Information about all the names in scope *)
type env = {
    function_index : int StringMap.t; (* Index for each function *)
    global_index   : int StringMap.t; (* "Address" for global variables *)
    local_index    : int StringMap.t; (* FP offset for args, locals *)
  }


(*type for storing variables *)
type varSymbolTableEntry = {
  data_type : sealType;
}

(*the symbol table that contains global variables, as well as links to
lesser scope variable symbol tables *)
type symbolTable = {
  parent : symbolTable option;
  sealVarSymbolTable : sealType StringMap.t;
}

(*type for storing functions *)
type funcSymbolTableEntry = {
  ftype : sealType;
  fparameters : sealType StringMap.t;
  flocals :  sealType StringMap.t;
}

(*type for storing SEAL Threads and any local variables defined within the Thread *)
type threadSymbolTableEntry = {
  thlocals : sealType StringMap.t;
}

(*type for storing SEAL Interrupt handlers and any local variables defined within the handler*)
type interruptSymbolTableEntry = {
  inlocals : sealType StringMap.t;
}

(*type for storing SEAL types defined by the user*)
type typeTableEntry = {
  properties : sealType StringMap.t;
  functions : funcSymbolTableEntry StringMap.t;
}

(*the entire environment, containing the symbol table, the function table, 
  the thread table, the interrupt table, and the SEAL types table *)
type environment = {
  scope : symbolTable;
  sealFuncSymbolTable : funcSymbolTableEntry StringMap.t;
  sealThreadSymbolTable : threadSymbolTableEntry StringMap.t;
  sealInterruptSymbolTable : interruptSymbolTableEntry StringMap.t;
  sealTypeSymbolTable : typeTableEntry StringMap.t; (*TSG HMMMM *)
}



(* val enum : int -> 'a list -> (int * 'a) list *)
let rec enum stride n = function
    [] -> []
  | hd::tl -> (n, hd) :: enum stride (n+stride) tl

(* val string_map_pairs StringMap 'a -> (int * 'a) list -> StringMap 'a *)
let string_map_pairs map pairs =
  List.fold_left (fun m (i, n) -> StringMap.add n i m) map pairs



(*utility to print out keys of each string Map*)
let print_vars key value =
    print_string(key ^ " \n")

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


(*function that creates symbol tables for variables *)
let createSealVarSymbolTable map (var_elem: var_decl list) = 
  List.fold_left (fun map thelist -> StringMap.add thelist.vname thelist.vtype map) map var_elem

let createSealFuncSymbol (var_elem: func_decl) = 
  {
    ftype = Void;
    fparameters = createSealVarSymbolTable StringMap.empty var_elem.locals;
    flocals = createSealVarSymbolTable StringMap.empty var_elem.locals;
  }

(*function that creates symbol table for functions *)
let createSealFuncSymbolTable map (var_elem: func_decl list) = 
  List.fold_left (fun map thelist -> StringMap.add thelist.fname (createSealFuncSymbol thelist) map) map var_elem

let createSealThreadSymbol (var_elem: thread_decl) = 
  {
    thlocals = createSealVarSymbolTable StringMap.empty var_elem.tlocals;
  }

(*function that creates symbol table for functions *)
let createSealThreadSymbolTable map (var_elem: thread_decl list) = 
  List.fold_left (fun map thelist -> StringMap.add thelist.tname (createSealThreadSymbol thelist) map) map var_elem

let createSealInterruptSymbol (var_elem: interrupt_decl) = 
  {
    inlocals = createSealVarSymbolTable StringMap.empty var_elem.ilocals;
  }
  
(*function that creates symbol table for functions *)
let createSealInterruptSymbolTable map (var_elem: interrupt_decl list) = 
  List.fold_left (fun map thelist -> StringMap.add thelist.iname (createSealInterruptSymbol thelist) map) map var_elem

let createSealTypeSymbol (var_elem: type_decl) = 
  {
    properties = createSealVarSymbolTable StringMap.empty var_elem.yproperties;
    functions = createSealFuncSymbolTable StringMap.empty var_elem.yfunctions;
  }

(*function that creates symbol table for functions *)
let createSealTypeSymbolTable map (var_elem: type_decl list) = 
  List.fold_left (fun map thelist -> StringMap.add thelist.yname (createSealTypeSymbol thelist) map) map var_elem


(** Translate a program in AST form into a bytecode program.  Throw an
    exception if something is wrong, e.g., a reference to an unknown
    variable or function *)
let translate (globals, functions, threads, interrupts, types) =

    print_endline "OH SNAP HERE'S THE LIST OF GLOBALS";
    let var_table = createSealVarSymbolTable StringMap.empty globals in
    StringMap.iter print_vars var_table;

    print_endline "OH SNAP HERE's THE LIST OF FUNCTIONS";
    let fun_table = createSealFuncSymbolTable StringMap.empty functions in
    StringMap.iter print_funcs fun_table;

    print_endline "OH SNAP HERE's THE LIST OF THREADS";
    let thread_table = createSealThreadSymbolTable StringMap.empty threads in
    StringMap.iter print_threads thread_table;

    print_endline "OH SNAP HERE's THE LIST OF INTERRUPTS";
    let interrupt_table = createSealInterruptSymbolTable StringMap.empty interrupts in
    StringMap.iter print_interrupts interrupt_table;

    print_endline "OH SNAP HERE's THE LIST OF TYPES";
    let type_table = createSealTypeSymbolTable StringMap.empty types in
    StringMap.iter print_types type_table;

  {
    num_globals = 0;
    text = [||];    
  }