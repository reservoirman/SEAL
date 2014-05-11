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
  tlocals : sealType StringMap.t;
}

(*type for storing SEAL Interrupt handlers and any local variables defined within the handler*)
type interruptSymbolTableEntry = {
  ilocals : sealType StringMap.t;
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

(** Translate a program in AST form into a bytecode program.  Throw an
    exception if something is wrong, e.g., a reference to an unknown
    variable or function *)
let translate (globals, threads, interrupts, types, functions) =
  (* Allocate "addresses" for each global variable *)
  (*
  let global_indexes = string_map_pairs StringMap.empty (enum 1 0 globals) in

  (* Assign indexes to function names; built-in "print" is special *)
  let built_in_functions = StringMap.add "print" (-1) StringMap.empty in
  let function_indexes = string_map_pairs built_in_functions
      (enum 1 1 (List.map (fun f -> f.fname) functions)) in

  (* Translate a function in AST form into a list of bytecode statements *)
  let translate the_env fdecl =
    (* Bookkeeping: FP offsets for locals and arguments *)
    
    let num_formals = List.length fdecl.formals
    and num_locals = List.length fdecl.locals
    and local_offsets = enum 1 1 fdecl.locals
    and formal_offsets = enum (-1) (-2) fdecl.formals in
    let the_env = 
    {
      scope = {parent = None; sealVarSymbolTable = StringMap.empty};
      sealFuncSymbolTable = StringMap.empty;
      sealThreadSymbolTable = StringMap.empty;
      sealInterruptSymbolTable = StringMap.empty;
      sealTypeSymbolTable = StringMap.empty; (*TSG HMMMM *)

    } in let result = 
*)
  {
    num_globals = 0;
    text = [||];    
  }