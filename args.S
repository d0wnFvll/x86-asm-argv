
.section .rodata
.LCargc:
	.string "argc = %d\n\n"
.LCargv:
	.string "argv[%d] = %s\n"
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
	return address      <-- EBP + 4
	saved EBP			<-- EBP
	local argv index	<-- EBP - 4
*/
main:
	pushl %ebp
	movl %esp, %ebp

	/* move argc into edi */
	movl 8(%ebp), %edi
	/* move argv base address into esi */
	movl 12(%ebp), %esi

	/* local index for argv */
	subl $4, %esp
	movl $0, -4(%ebp)

	/*
 	   print numbers of passed arguments (argc)
	*/
	pushl %edi
	pushl $.LCargc
	call printf
	addl $4, %esp
	popl %edi

.Lpr_args:
	cmpl -4(%ebp), %edi
	je .Lpr_args_out

	pushl (%esi) /* element in argv */
	pushl -4(%ebp) /* index */
	pushl $.LCargv /* format */
	call printf
	addl $4, %esp
	popl -4(%ebp)
	popl (%esi)

	incl -4(%ebp)
	/* point to the next arg */
	addl $4, %esi

	jmp .Lpr_args

.Lpr_args_out:
	pushl $0xa /* '\n' */
	call putchar
	addl $4, %esp

	movl 16(%ebp), %esi

.Lpr_envp:
	/* envp is a null terminated array */
	cmpl $0, (%esi)
	je .Lout

	pushl (%esi) /* environment variable */
	pushl $.LCenvp /* format */
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

