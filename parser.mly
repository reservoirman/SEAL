%{ open Ast %}

%token PLUS TIMES MINUS DIVIDE ASSIGN EQ LT LEQ GT GEQ 
%token SEMIC LPAREN RPAREN LCURLY RCURLY LBRACKET RBRACKET COMMA
%token RETURN IF ELSE FOR WHILE 
%token <int> LITERAL
%token <string> ID
%token EOF

/* SEAL tokens */
 /* unary operators */
%token INC DEC NOT INV NEG 
 /* binary operators */
%token ANDL ORL
%token XOR AND OR 
%token EQU NEQ LTH GTH LTE GTE 
%token BSL BSR
%token ADD SUB MULT DIV MOD
/* the fundamental types */
%token INT UINT FLOAT DOUBLE BIT BYTE SHORT USHORT LONG ULONG BOOL
/* other types */
%token ENUM STRING LOCK
/* declarations */
%token THREAD INTERRUPT TYPE LABEL
/* boolean values */
%token TRUE FALSE


%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
/* SEAL unary operator precedence: */
%left NOT INV NEG   /* lowest precedence */
%left DEC 
%left INC           /* highest precendence */

/* SEAL binary operator precedence, left associative: */
%left COMMA         /* lowest precedence */
%left ANDL ORL
%left XOR AND OR
%left EQU NEQ
%left LTH GTH LTE GTE
%left BSL BSR
%left ADD SUB
%left MULT DIV MOD /* highest precedence */ 

%left EQ
%left LT GT LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE

%start program
%type <Ast.program> program

%%





program:
   /* nothing */ { [], [] }
 | program vdecl { ($2 :: fst $1), snd $1 }
 | program fdecl { fst $1, ($2 :: snd $1) }

fdecl:
   ID LPAREN formals_opt RPAREN LCURLY vdecl_list stmt_list RCURLY
     { { fname = $1;
	 formals = $3;
	 locals = List.rev $6;
	 body = List.rev $7 } }

formals_opt:
    /* nothing */ { [] }
  | formal_list   { List.rev $1 }

formal_list:
    ID                   { [$1] }
  | formal_list COMMA ID { $3 :: $1 }

vdecl_list:
    /* nothing */    { [] }
  | vdecl_list vdecl { $2 :: $1 }

vdecl:
   INT ID SEMIC { $2 }

stmt_list:
    /* nothing */  { [] }
  | stmt_list stmt { $2 :: $1 }

stmt:
    expr SEMIC { Expr($1) }
  | RETURN expr SEMIC { Return($2) }
  | LCURLY stmt_list RCURLY { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  | FOR LPAREN expr_opt SEMIC expr_opt SEMIC expr_opt RPAREN stmt
     { For($3, $5, $7, $9) }
  | WHILE LPAREN expr RPAREN stmt { While($3, $5) }

expr_opt:
    /* nothing */ { Noexpr }
  | expr          { $1 }

expr:
    LITERAL          { Literal($1) }
  | ID               { Id($1) }
  | expr PLUS   expr { Binop($1, Add,   $3) }
  | expr MINUS  expr { Binop($1, Sub,   $3) }
  | expr TIMES  expr { Binop($1, Mult,  $3) }
  | expr DIVIDE expr { Binop($1, Div,   $3) }
  | expr EQ     expr { Binop($1, Equal, $3) }
  | expr NEQ    expr { Binop($1, Neq,   $3) }
  | expr LT     expr { Binop($1, Less,  $3) }
  | expr LEQ    expr { Binop($1, Leq,   $3) }
  | expr GT     expr { Binop($1, Greater,  $3) }
  | expr GEQ    expr { Binop($1, Geq,   $3) }
  | ID ASSIGN expr   { Assign($1, $3) }
  | ID LPAREN actuals_opt RPAREN { Call($1, $3) }
  | LPAREN expr RPAREN { $2 }

actuals_opt:
    /* nothing */ { [] }
  | actuals_list  { List.rev $1 }

actuals_list:
    expr                    { [$1] }
  | actuals_list COMMA expr { $3 :: $1 }
