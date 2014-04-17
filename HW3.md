##CS 4115
##Ten-Seng Guh
##tg2458
##HW3


###1. (a) 
Each cell represents one byte, with the first byte starting from the upper right hand corner.

|         |            |   |  |
| ------------- |:-------------:| -----:|-----: | 
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


###2. Optimized Assembly pseudocode for 
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

```asm

```



```c
switch (b) {
case 5: a = 18; break;
case 73: a = 2; break;
case 105: b = 7; c = 10; break;
case 5644: c = 8; break;
default: c = 17; break;
}
```
```asm
	cmp b, 5
	beq L1
	nop
	cmp b, 73
	beq L2
	nop
	cmp b, 105
	beq L3
	nop
	cmp b, 5644
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




--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
