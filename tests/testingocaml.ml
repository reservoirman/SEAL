module StringMap = Map.Make(String);;
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

type sealFuncSymbolTableEntry = {
	name2 : string;
	size2 : int;
	data_type2 : sealType;
	parameters : string StringMap.t;
}


let symbol_table = StringMap.empty;;

let entry01 = {name = "Int"; size = 4; data_type = Int; };;

let entry02 = {name = "Float"; size = 4; data_type = Float; };;

let entry01list = [];;

let entry01list = entry01 :: [];;

let entry01list = entry02:: entry01list;;

if (List.mem {name = "Int"; size = 4; data_type = Int; } entry01list) 
then print_endline "entry01 has been found!";;

if (List.mem entry02 entry01list) 
then print_endline "entry02 has been found!";;

let symbol_table = StringMap.add "Douglas" entry01 symbol_table;;

StringMap.find "Douglas" symbol_table;;





