
let p = ("Guh", "Ten-Seng") in
print_endline (fst p) ; print_endline (snd p);;

type sealType = 
Void | Bit | Byte | Short | Ushort | Int | Uint | Long | Ulong | Float | Double | Custom;;

type sealConstruct = Interrupt | Thread | Variable | Function;; 

type sealVarSymbolTableEntry = {
	name : string;
	size : int;
	data_type : sealType;
	(*future: possible to add scope here*)
};;
module StringMap = Map.Make(String);;

type sealFuncSymbolTableEntry = {
	name2 : string;
	size2 : int;
	data_type2 : sealType;
	parameters : sealVarSymbolTableEntry StringMap.t;
}


let symbol_table = StringMap.empty;;
let func_var_symbol_table = StringMap.empty;;
let parameter1 = {name = "Int"; size = 4; data_type = Int; };;
let parameter2 = {name = "Int"; size = 4; data_type = Int; };;
let parameter3 = {name = "Int"; size = 4; data_type = Int; };;

let func_var_symbol_table = StringMap.add "x" parameter1 func_var_symbol_table;; 
let func_var_symbol_table = StringMap.add "y" parameter2 func_var_symbol_table;; 
let func_var_symbol_table = StringMap.add "z" parameter3 func_var_symbol_table;; 

if StringMap.is_empty func_var_symbol_table then print_endline "FAILED!" 
else print_endline "It's got stuff in it!";;

let entry01 = {name = "Int"; size = 4; data_type = Int; };;

let entry02 = {name = "Float"; size = 4; data_type = Float; };;

let entry03 = {name2 = "Holla"; size2 = 12; data_type2 = Custom; parameters = func_var_symbol_table};;

let entry01list = [];;

let entry01list = entry01 :: [];;

let entry01list = entry02:: entry01list;;

let funcsymboltable = entry03::[];;

if (List.mem {name = "Int"; size = 4; data_type = Int; } entry01list) 
then print_endline "entry01 has been found!";;

if (List.mem entry02 entry01list) 
then print_endline "entry02 has been found!";;

let symbol_table = StringMap.add "Douglas" entry01 symbol_table;;

StringMap.find "Douglas" symbol_table;;





