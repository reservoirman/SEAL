%{ open Ast %}

%token PLUS TIMES MINUS DIVIDE ASSIGN EQ LT LEQ GT GEQ 
%token SEMIC LPAREN RPAREN LCURLY RCURLY LBRACKET RBRACKET COMMA
%token RETURN IF ELSE FOR WHILE 
%token <int> ILITERAL
%token <string> ID

%token <float> FLITERAL
%token <string> SLITERAL
%token EOF

/* SEAL tokens */
 /* unary operators */
%token INC DEC NOT INV NEG ADDRESS SWAP SOURCE MAP
 /* binary operators */
%token ANDL ORL
%token XOR AND OR 
%token EQU NEQ LTH GTH LTE GTE 
%token BSL BSR
%token ADD SUB MULT DIV MOD
/* the fundamental types */
%token INT DOUBLE BYTE STRING 
/* other types */
%token ENUM STRING LOCK
/* declarations */
%token THREAD INTERRUPT TYPE LABEL VOID
/* boolean values */
%token TRUE FALSE


%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
/* SEAL unary operator precedence: */
%left NOT INV NEG   /* lowest precedence */
%left DEC 
%left INC           /* highest precendence */
%left ADDRESS
%left SWAP

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


/* TG 4-22-14 here is where the entire grammar will need to go */
/*
transl_unit:
  | interrupt_def
  | interrupt_def transl_unit
*/



program:
   /* nothing */ { [], [], [], [], [] }
 | program vdecl { List.rev ($2 :: first $1), second $1, third $1, fourth $1, fifth $1 }
 | program fdecl { first $1, List.rev ($2 :: second $1), third $1, fourth $1, fifth $1 }
 | program tdecl { first $1, second $1, List.rev ($2 :: third $1), fourth $1, fifth $1 }
 | program idecl { first $1, second $1, third $1, List.rev ($2 :: fourth $1), fifth $1 }
 | program ydecl { first $1, second $1, third $1, fourth $1, List.rev ($2 :: fifth $1) }

tdecl:
  THREAD ID LCURLY vdecl_list stmt_list_opt RCURLY 
  {
    {
      tname = $2; 
      tlocals = List.rev $4; 
      tbody = List.rev $5;
    }

  }

idecl:
  INTERRUPT ID LCURLY vdecl_list stmt_list_opt RCURLY 
  { 
    {
      iname = $2;
      ilocals = List.rev $4;
      ibody = List.rev $5;
    }
  }

ydecl:
  TYPE ID LCURLY vdecl_list fdecl_opt RCURLY 
  { 
    {
      ytype = NewType($2);
      yname = $2;
      yproperties = $4;

      yfunctions = $5; 
    }
  }

fdecl:
   return_type ID LPAREN formals_opt RPAREN LCURLY vdecl_list stmt_list_opt RCURLY
   { 
    { 

      rtype = $1; 
      fname = $2;
      formals = $4;
      locals = List.rev $7;
      body = List.rev $8;
      } 
    }

formals_opt:
    /* nothing */ { [] }
  | formal_list   { List.rev $1 }

formal_list:
  formal /* nothing */        { [$1] }  
  | formal_list COMMA formal  { $3 :: $1 }


vdecl_list:
    /* nothing */    { [] }

  | vdecl_list vdecl { $2 :: $1 }

vdecl:
   return_type ID SEMIC 
   {  
    {
      vtype = $1;
      vname = $2; 
    };
   }
    | return_type ID array_id SEMIC 
     { 
      {
        vtype = Array($1, $3);
        vname = $2; 
      }
    }    

array_id:
  LBRACKET ILITERAL RBRACKET { string_of_int $2 }  
  | LBRACKET ID RBRACKET { $2 }  

array_size:
  ILITERAL { Iliteral($1) }
  | ID { Id($1) }

/*TSG 5-7-14*/
fdecl_list:
  | fdecl       { [$1] }
  | fdecl_list fdecl { $2 :: $1 }

fdecl_opt:
    /* nothing */ { [] }
  | fdecl_list   { List.rev $1 }

formal:
  return_type ID
  {
    {
      vtype = $1;
      vname = $2;    
    }
  }
  | return_type ID array_id 
  {
    {
      vtype = Array($1, $3);
      vname = $2;
    }
  }

return_type:
   VOID         {Void}
  | BYTE        {Byte}
  | INT         {Int}
  | STRING      {String}
  | DOUBLE      {Double}
  | LOCK        {Lock}
  | ID          {NewType($1)}

stmt_list_opt:
      /* nothing */  { [] }
  | stmt_list { List.rev $1 }

stmt_list:
   stmt /* nothing */  { [$1] }
  | stmt_list stmt { $2 :: $1 }

stmt:
    expr SEMIC { Expr($1) }
  | RETURN expr SEMIC { Return($2) }
  | LCURLY stmt_list RCURLY { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  | FOR LPAREN expr_opt SEMIC expr_opt SEMIC expr_opt RPAREN LCURLY stmt_list_opt RCURLY
     { For($3, $5, $7, $10) }
  | WHILE LPAREN expr RPAREN LCURLY stmt_list_opt RCURLY { While($3, $6) }


expr_opt:
    /* nothing */ { Noexpr }
  | expr          { $1 }

expr:
    ILITERAL          { Iliteral($1) }
  | FLITERAL          { Fliteral($1) }
  | SLITERAL          { Sliteral($1) }
  | ID                {Id($1)}
  | ID array_id       {ArrayIndex($1, $2)}
  | ID  LABEL ID array_id { Label(Id($1), (ArrayIndex($3, $4))) }
  | INC expr          { Unop(Inc, $2) }
  | DEC expr          { Unop(Dec, $2) }
  | NOT expr          { Unop(Not, $2) }
  | INV expr          { Unop(Inv, $2) }
  | expr PLUS   expr  { Binop($1, Add,   $3) }
  | expr MINUS  expr  { Binop($1, Sub,   $3) }
  | expr TIMES  expr  { Binop($1, Mult,  $3) }
  | expr DIVIDE expr  { Binop($1, Div,   $3) }
  | expr EQ     expr  { Binop($1, Equal, $3) }
  | expr NEQ    expr  { Binop($1, Neq,   $3) }
  | expr LT     expr  { Binop($1, Less,  $3) }
  | expr LEQ    expr  { Binop($1, Leq,   $3) }
  | expr GT     expr  { Binop($1, Greater,  $3) }
  | expr GEQ    expr  { Binop($1, Geq,   $3) }
  | expr ORL    expr  { Binop($1, Orl,   $3) }
  | expr ANDL   expr  { Binop($1, Andl,   $3) }  
  | expr OR     expr  { Binop($1, Or,   $3) }
  | expr AND    expr  { Binop($1, And,   $3) }  
  | expr BSR    expr  { Binop($1, Bsr,   $3) }  
  | expr BSL    expr  { Binop($1, Bsl,   $3) }  
  | expr XOR    expr  { Binop($1, Xor,   $3) }  
  | expr ASSIGN expr  { Assign($1, $3) }
  | ID ADDRESS        { GetAddress($1)}
  | ID LABEL SOURCE ASSIGN expr  { Signal($1, $5) }
  | ID LABEL ADDRESS ASSIGN expr { Address($1, $5)}
  | ID LABEL ADDRESS ASSIGN ID LABEL ADDRESS { Address($1, Id($5))}
  | ID LABEL SWAP LPAREN RPAREN {Swap($1)}
  | ID LPAREN actuals_opt RPAREN { Call($1, $3) }
  | ID LABEL ID LPAREN actuals_opt RPAREN { LabelCall($1, $3, $5) }
  | ID LABEL MAP LPAREN ID COMMA expr COMMA expr RPAREN { Map($1, $5, $7, $9)}
  | LPAREN expr RPAREN { $2 }





actuals_opt:
    /* nothing */ { [] }
  | actuals_list  { List.rev $1 }

actuals_list:
    expr                    { [$1] }
  | actuals_list COMMA expr { $3 :: $1 }
