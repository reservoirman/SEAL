##CS 4115
##Ten-Seng Guh
##tg2458
##HW2


###1. (a) Scanner for floating point numbers
```ocaml
(*integer part*)
let integer = ['0'-'9']+
(*decimal + fraction part*)
let fraction = '.'['0'-'9']*
(*e and exponent part*)
let exponent = 'e'('+'|'-')?['0' - '9']+

(*integer part missing*)
let floatingPt1 = integer? fraction exponent
(*decimal missing or fractional part missing*)
let floatingPt2 = integer fraction? exponent
(*e and the exponent missing*)
let floatingPt3 = integer? fraction exponent?

let floatingPt = '-'? (floatingPt1 | floatingPt2 | floatingPt3)
```

