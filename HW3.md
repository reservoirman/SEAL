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


###2.


if (b == 5) a = 18; break;
else if (b == 73) a = 2; break;
else if (b == 105) b = 7; c = 10; break;
else if (b == 5644) c = 8; break;
default: c = 17; break;




--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
