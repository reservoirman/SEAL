##CS 4115
##Ten-Seng Guh
##tg2458
##HW3


###1. (a) 
Each cell represents one byte, with the first byte starting from the upper right hand corner.

|||||
| ------------- |-------------| -----|----- | 
| a[0][0] | a[0][0] | a[0][0] | a[0][0]
| a[0][1] | a[0][1] | a[0][1] | a[0][1]
| a[0][2] | a[0][2] | a[0][2] | a[0][2]
| a[1][0] | a[1][0] | a[1][0] | a[1][0]
| a[1][1] | a[1][1] | a[1][1] | a[1][1]
| a[1][2] | a[1][2] | a[1][2] | a[1][2]

###1. (b)
expression for accessing a[ i ][ j ] = a + 12i + 4j

###1. (c)  
array.c:
```c
#include <stdio.h>

int a[2][3] = {0};
int main()
{
	a[0][1] = 1234;
	a[1][0] = 5678;
	a[1][2] = 9101112;
	char *aa = (char *)&a;
	
	printf("Here it is: %p and %p\n", &a[1][2], aa + 20);
}
```

array.s:
```asm
	.file	"array.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Here it is: %p and %p\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB22:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$1234, a+4(%rip)
	movl	$5678, a+12(%rip)
	movl	$9101112, a+20(%rip)
	movl	$a+20, %ecx
	movq	%rcx, %rdx
	movl	$.LC0, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	main, .-main
	.globl	a
	.bss
	.align 16
	.type	a, @object
	.size	a, 24
a:
	.zero	24
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",@progbits
```



###2. Optimized Assembly Pseudocode for C Switch Statements
Switch Statement:
```c
switch (a) {
case 5: x = 2; break;
case 6: x = 5; break;
case 7: x = 24; y = 11; break;
case 8: y = 8; break;
case 9: z = 3; break;
default: z = 4; break;
}
```
Optimized Pseudocode Assembly:
```asm
	cmp a, 5
	blt R1
	cmp a, 9
	bgt R1
	sub 5, a	;a -= 5
	jmp R3 + a	;jump to a - 5 instructions past R3.  R3 marks the start of the jump table.	  
				;Of course this pseudocode allows assigning addresses to labels.
R3:	jmp R5		
	jmp R6
	jmp R7
	jmp R8
	jmp R9
R5:	mov 2, x	;a was 5
	jmp BR
R6:	mov 5, x	;a was 6
	jmp BR
R7:	mov 24, x	;a was 7
	mov 11, y
	jmp BR
R8:	mov 8, y	;a was 8
	jmp BR
R9:	mov 3, z	;a was 9
	jmp BR
R1:	mov 4, z	;a was not 5 - 9
	jmp BR
BR:	nop
```


Switch Statement:
```c
switch (b) {
case 5: a = 18; break;
case 73: a = 2; break;
case 105: b = 7; c = 10; break;
case 5644: c = 8; break;
default: c = 17; break;
}
```
Optimized Pseudocode Assembly:
```asm
	cmp 5, b
	beq L1
	nop
	cmp 73, b
	beq L2
	nop
	cmp 105, b
	beq L3
	nop
	cmp 5644, b
	nop
	mov 17, c
	jmp BK
L1:	mov 18, a
	jmp BK
L2:	mov 2, a
	jmp BK
L3:	mov 7, b
	mov 10, c
	jmp BK
L4:	mov 8, c
	jmp BK
BK:	nop
```



###3. 
Memory layout for u1. Size = 8 bytes.

|||||
| ------------- |-------------| -----|----- | 
| b | b | b / a | b / a 
|   |  | c | c 
  
Memory layout for s1. Size = 12 bytes.

|||||
| ------------- |-------------| -----|----- | 
| | b | a |  a 
|  |  | c | c 
|d | d | d | d 

Memory layout for s2. Size = 12 bytes.

|||||
| ------------- |-------------| -----|----- | 
|d | d | d |  d
| c  | c | a | a 
| |  |  | b 



###4. (a) Applicative-order evaluation
In this case, incw() and incx() will be evaluated before foo(), and their values (9 and 13 respectively) passed on to foo.  Therefore, changing x to 4 is irrelevant.  Final output of the program is:
```
19
13
```

###4. (b) Normal-order evaluation
In this case, incw() and incx() will only be evaluated as the parameters appear, a la C macro style.  So incw() will be evaluated twice since y appears twice, and incx() will be evaluted once, but not until after x becomes 4.  Final output of the program is:
```
20
5
```
