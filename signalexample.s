	.file	"signalexample.c"
	.comm	ouchie,24,16
	.section	.rodata
.LC0:
	.string	"OUCH! I got signal %d\n"
	.text
	.globl	ouch
	.type	ouch, @function
ouch:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	ouchie+8(%rip), %edx
	movl	$.LC0, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-4(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	signal
	movl	$0, ouchie+8(%rip)
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	ouch, .-ouch
	.section	.rodata
.LC1:
	.string	"Hello World!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	$ouch, ouchie+16(%rip)
	movq	$ouchie, ouchie(%rip)
	movl	$2, ouchie+8(%rip)
	movq	ouchie+16(%rip), %rdx
	movl	ouchie+8(%rip), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	signal
	movl	$2, -4(%rbp)
.L3:
	movl	$.LC1, %edi
	call	puts
	movl	$1, %edi
	call	sleep
	jmp	.L3
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",@progbits
