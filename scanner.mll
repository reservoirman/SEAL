(* scanner for SEAL compiler *)
{ open Parser }



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
| "Uint"	{ UINT }
| "Bit"		{ BIT }
| "Byte"	{ BYTE }
| "Bool"	{ BOOL }
| "Short"	{ SHORT }
| "Ushort" 	{ USHORT }
| "Long"	{ LONG }
| "Ulong"	{ ULONG }
| "Float"	{ FLOAT }
| "Double"	{ DOUBLE }
| "Thread"	{ THREAD }
| "Interrupt" { INTERRUPT }
| "Enum"	{ ENUM }
| '['		{ LBRACKET }	(* for arrays *)
| ']'		{ RBRACKET }	
| '.'		{ LABEL }		(* for labels *)
| "True"	{ TRUE }
| "False"	{ FALSE }
| "Type"	{ TYPE }		(* for the type declaration *)
| "Lock"	{ LOCK }		(* for the lock type *)
| ['0'-'9']+ as lxm { LITERAL(int_of_string lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }

and comment2 = parse
	'\n' { token lexbuf}
|	_ { comment2 lexbuf }
