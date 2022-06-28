
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
	envp				<-- EBP + 16
	argv				<-- EBP + 12
	agrc				<-- EBP + 8
	return address		<-- EBP + 4
	saved EBP			<-- EBP
*/
main:
	pushl %ebp
	movl %esp, %ebp

	/* move argc into edi */
	movl 8(%ebp), %edi
	/* move argv base address into esi */
	movl 12(%ebp), %esi

	/*
		print numbers of
		passed arguments (argc)
	*/
	pushl %edi
	pushl $.LCargc
	call printf
	addl $4, %esp
	popl %edi

	dec %edi
.Lpr_args:
	cmpl $0, %edi
	jl .Lpr_args_out

	/*
		push edi onto the stack
		because function may affect it
	*/
	pushl %edi
	pushl (%esi)
	pushl $.LCargv
	call printf
	addl $4, %esp
	popl (%esi)
	popl %edi

	/* point to the next arg */
	addl $4, %esi

	dec %edi
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

	leave
	ret

