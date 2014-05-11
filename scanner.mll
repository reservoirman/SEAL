(* scanner for SEAL compiler *)
{ open Parser }

let digits = ['0'-'9']+
let exp = 'e'('+'|'-')? digits
let lxm = ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* 

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
| "If"     { IF }
| "Else"   { ELSE }
| "For"    { FOR }
| "While"  { WHILE }
| "Return" { RETURN }
| "Int"    { INT }		(* the following are the fundamental types and are all unique to SEAL *)
| "Byte"	{ BYTE }
| "Double"	{ DOUBLE }
| "String"	{ STRING }
| "Thread"	{ THREAD }
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
| digits as holla { LITERAL(int_of_string holla) }
| (digits exp? | digits '.' digits? exp? | digits '.' exp) as holla { FLOAT(float_of_string holla) } 
| lxm as id { ID(id) }
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }

and comment2 = parse
	'\n' { token lexbuf}
|	_ { comment2 lexbuf }
