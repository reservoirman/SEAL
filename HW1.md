##CS 4115
##Ten-Seng Guh
##tg2458
##HW1

###1. "Uniq" function

	let rec uniq = function 
	 [] -> []
	| [a] -> [a]
	| head::second::tail -> if (head = second) then uniq (second::tail) else head::(uniq (second::tail)) ;;

It produces the following output:
	# uniq [1;2;3];;
	- : int list = [1; 2; 3]
	# uniq [1;1;1;3;4;1;1];;
	- : int list = [1; 3; 4; 1]
	# uniq [1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4;1;1;1;1];;
	- : int list = [1; 2; 3; 4; 1]
	# uniq [1;1];;
	- : int list = [1]

###2. Word frequency counter

wordcount.mll:

	{ type token = EOF | Word of string 
	  module StringMap = Map.Make(String)
	;;}

	rule token = parse
		| eof { EOF }
		| ['a' - 'z' 'A' - 'Z']+ as word { Word(word) }
		| _ { token lexbuf }
	{
		
		let wordmap = StringMap.empty;;

		let lexbuf = Lexing.from_channel stdin


		let wordlist =
			let rec next l = 
			match token lexbuf with
				|	EOF -> l
				| Word(s) -> next (s :: l)
			in next [];; 

	let rec next wordmap = function
	| [] -> wordmap
	| s::t -> if StringMap.mem s wordmap 
				then next (StringMap.add s ((StringMap.find s wordmap) + 1) wordmap) t  
				else next (StringMap.add s 1 wordmap) t;;

	(* generating the word stringmap from the word list *)
	let wordmap = next StringMap.empty wordlist;;

	(* generating the word tuple list from the word stringmap *)
	let wordtuplelist = StringMap.fold (fun word count list -> (count, word)::list) wordmap [];; 

	(* sorting the tuple list using the sorting function provided in Homework Assignment 1 *)
	let wordtuplelist = List.sort( fun(c1, _) (c2, _) -> Pervasives.compare c2 c1) wordtuplelist;;

	(* outputting each count, word tuple via the C printf function *)
	List.iter (fun (count, word)-> Printf.printf "%d %s\n" count word) wordtuplelist;;
	}

It produces the following output:

	w4118@ubuntu:~/Documents/Columbia/CS 4115/HW1$ ocaml wordcount.ml < wordcount.mll
	11 word
	9 wordmap
	8 s
	8 let
	8 StringMap
	7 the
	7 next
	5 list
	5 count
	4 wordtuplelist
	4 token
	4 c
	3 tuple
	3 t
	3 lexbuf
	3 l
	3 function
	3 fun
	3 from
	3 Word
	3 EOF
	2 wordlist
	2 stringmap
	2 sorting
	2 rec
	2 printf
	2 in
	2 generating
	2 empty
	2 add
	2 List
	1 z
	1 with
	1 via
	1 using
	1 type
	1 then
	1 string
	1 stdin
	1 sort
	1 rule
	1 provided
	1 parse
	1 outputting
	1 of
	1 n
	1 module
	1 mem
	1 match
	1 iter
	1 if
	1 fold
	1 find
	1 eof
	1 else
	1 each
	1 d
	1 compare
	1 channel
	1 as
	1 a
	1 Z
	1 String
	1 Printf
	1 Pervasives
	1 Map
	1 Make
	1 Lexing
	1 Homework
	1 C
	1 Assignment
	1 A
	w4118@ubuntu:~/Documents/Columbia/CS 4115/HW1$ 




###3. Extended "Calculator"
scanner.mll:
	{ open Parser }

	let digit = ['0'-'9']+
	let variable = '$' ['0' - '9']

	rule token = parse
	  [' ' '\t' '\r'] { token lexbuf }
	| '+' { PLUS } 
	| '-' { MINUS }
	| '*' { TIMES }
	| '/' { DIVIDE }
	| digit as lit { LITERAL(int_of_string lit) }
	| variable as var { VARIABLE(int_of_char var.[1] - 48) }
	| '=' { ASSIGN }
	| ',' { SEQUENCE }
	| eof { EOF }
	| '\n' {EOF}	(*moved the new line here so that expressions can be evalauted at the terminal by pressing "Enter" *)




ast.mli:
	type operator = Add | Sub | Mul | Div

	type expr =
	    Binop of expr * operator * expr
	  | Lit of int
	  | Seq of expr * expr
	  | Asn of int * expr
	  | Var of int




parser.mly:
	%{ open Ast %}

	/* declarations */
	%token PLUS MINUS TIMES DIVIDE EOF SEQUENCE ASSIGN /*added new token SEQUENCE (comma) and ASSIGN (=) */
	%token <int> LITERAL
	%token <int> VARIABLE

	%left SEQUENCE
	%left ASSIGN
	%left PLUS MINUS
	%left TIMES DIVIDE


	%start expr
	%type < Ast.expr> expr

	/*section separator */
	%%	
	/* rules */
	expr:
	  expr PLUS   expr 		{ Binop($1, Add, $3) }
	| expr MINUS  expr 		{ Binop($1, Sub, $3) }
	| expr TIMES  expr 		{ Binop($1, Mul, $3) }
	| expr DIVIDE expr 		{ Binop($1, Div, $3) }
	| LITERAL          		{ Lit($1) }
	| VARIABLE 				{ Var($1) }
	| VARIABLE ASSIGN expr 	{ Asn($1, $3) }
	| expr SEQUENCE	expr	{ Seq($1, $3)}




calc.ml:
	open Ast

	let var_array = Array.make 10 0;;

	let rec eval = function 
	    Lit(x) -> x
	  | Var(x) -> var_array.(x)
	  | Asn(x, y) -> (var_array.(x) <- (eval y); var_array.(x))
	  | Seq(x,y) -> (eval x; eval y)
	  | Binop(e1, op, e2) ->
	      let v1 = eval e1 and v2 = eval e2 in
	      match op with
		    | Add -> v1 + v2
	      | Sub -> v1 - v2
	      | Mul -> v1 * v2
	      | Div -> v1 / v2

	let _ =
	  let lexbuf = Lexing.from_channel stdin in
	  let expr = Parser.expr Scanner.token lexbuf in
	  let result = eval expr in
	  print_endline (string_of_int result)

It produces the following output:
	w4118@ubuntu:~/Documents/Columbia/CS 4115/calculator$ ./calc 
	$1 = 1, $2 = 2, $3 = 3, $1 + $2 + $3
	6
	w4118@ubuntu:~/Documents/Columbia/CS 4115/calculator$ ./calc 
	$4 = 4, $4 * $4 * $4 + $4 / $4
	65
	w4118@ubuntu:~/Documents/Columbia/CS 4115/calculator$ ./calc 
	$4 + $3
	0
	w4118@ubuntu:~/Documents/Columbia/CS 4115/calculator$ ./calc 
	1 + 2 + 3 + 4
	10

