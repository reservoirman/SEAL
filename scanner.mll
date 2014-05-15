(* scanner for SEAL compiler *)
{ open Parser }

let digits = ['0'-'9']+
let exp = 'e'('+'|'-')? digits
let lxm = ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* 
let double = (digits exp? | digits '.' digits? exp? | digits '.' exp)
let str = '"' [^'"']* '"' 
rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
| "//"		{comment2 lexbuf}
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LCURLY }
| '}'      { RCURLY }
| ';'      { SEMIC }
| ','      { COMMA }
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| '='      { ASSIGN }
| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }
| "||"	   { ORL }
| "&&"	   { ANDL }
| "|"		{ OR }
| "&"		{ AND }
| "<<"	   { BSL }
| ">>"     { BSR }
| "^"	   { XOR }
| "!"		{ NOT }		(* the unary operators *)
| "++"		{ INC }
| "--"		{ DEC }
| "~"		{ INV }
| "If"     { IF }
| "Else"   { ELSE }
| "For"    { FOR }
| "While"  { WHILE }
| "Return" { RETURN }
| "Void"	{ VOID }
| "Int"    { INT }		(* the following are the fundamental types and are all unique to SEAL *)
| "Byte"	{ BYTE }
| "Double"	{ DOUBLE }
| "String"	{ STRING }
| "Thread"	{ THREAD }
| "Source"	{ SOURCE }
| "Map"		{ MAP }
| "Interrupt" { INTERRUPT }
| "Enum"	{ ENUM }
| '['		{ LBRACKET }	(* for arrays *)
| ']'		{ RBRACKET }	
| '.'		{ LABEL }		(* for labels *)
| "Address" { ADDRESS }
| "Swap"	{ SWAP }		(* can't be treated like normal labels, need to be handled *)
| "True"	{ TRUE }
| "False"	{ FALSE }
| "Type"	{ TYPE }		(* for the type declaration *)
| "Lock"	{ LOCK }		(* for the lock type *)
| digits as integer { ILITERAL(int_of_string integer) }
| double as dbl 	{ FLITERAL(float_of_string dbl) } 
| lxm as id 		{ ID(id) }
| str as slit 		{ SLITERAL(slit) }
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }

and comment2 = parse
	'\n' { token lexbuf}
|	_ { comment2 lexbuf }
