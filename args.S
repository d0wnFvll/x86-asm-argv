
.section .rodata
.LCargc:
	.string "argc = %d\n\n"
.LCargv:
	.string "arg = %s\n"
.LCenvp:
	.string "%s\n"

.section .text
	.globl main
	.type main, @function

/*
			Stack
	saved EBP			<-- EBP
	return address		<-- EBP + 4
	agrc				<-- EBP + 8
	argv				<-- EBP + 12
	envp				<-- EBP + 16
*/
main:
	pushl %ebp
	movl %esp, %ebp

	/*
		push ecx and esi because
		they are used throughout the function
	*/
	pushl %ecx
	pushl %esi

	/* move argc into ecx */
	movl 8(%ebp), %ecx
	/* move argv base address into esi */
	movl 12(%ebp), %esi

	/*
		print numbers of
		passed arguments (argc)
	*/
	pushl %ecx
	pushl $.LCargc
	call printf
	addl $4, %esp
	popl %ecx

	dec %ecx
.Lpr_args:
	cmpl $0, %ecx
	jl .Lpr_args_out

	/*
		push ecx onto the stack
		because function may affect it
	*/
	pushl %ecx
	pushl (%esi)
	pushl $.LCargv
	call printf
	addl $4, %esp
	popl (%esi)
	popl %ecx

	/* point to the next arg */
	addl $4, %esi

	dec %ecx
	jmp .Lpr_args

.Lpr_args_out:
	pushl $0xa /* '\n' */
	call putchar
	addl $4, %esp

	movl 16(%ebp), %esi

.Lpr_envp:
	cmpl $0, (%esi)
	je .Lout

	pushl (%esi)
	pushl $.LCenvp
	call printf
	addl $4, %esp
	popl (%esi)

	addl $4, %esi
	jmp .Lpr_envp

.Lout:
	/* set up return value */
	movl $0, %eax

	popl %esi
	popl %ecx

	leave
	ret

