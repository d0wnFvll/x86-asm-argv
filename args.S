
.section .rodata
argc:
	.asciz "argc = %d\n\n"
argv:
	.asciz "arg = %s\n"
envp:
	.asciz "%s\n"

.section .text
	.globl main

#			Stack
# saved EBP			<-- ebp
# return address	<-- ebp + 4
# agrc				<-- ebp + 8
# argv				<-- ebp + 12
# envp				<-- ebp + 16
main:
	pushl %ebp
	movl %esp, %ebp

	# move argc into ecx
	movl 8(%ebp), %ecx
	# move argv base address into esi
	movl 12(%esp), %esi

	# print numbers of
	# passed arguments (argc)
	pushl %ecx
	pushl $argc
	call printf
	addl $4, %esp
	popl %ecx

	dec %ecx
pr_args:
	cmpl $0, %ecx
	jl pr_args_out

	# push ecx onto the stack
	# because function may affect it
	pushl %ecx
	pushl (%esi)
	pushl $argv
	call printf
	addl $4, %esp
	popl (%esi)
	popl %ecx

	# point to the next arg
	addl $4, %esi

	dec %ecx
	jmp pr_args

pr_args_out:
	pushl $0xa # '\n'
	call putchar
	addl $4, %esp

	movl 16(%ebp), %esi

pr_envp:
	cmpl $0, (%esi)
	je out

	pushl (%esi)
	pushl $envp
	call printf
	addl $4, %esp
	popl (%esi)

	addl $4, %esi
	jmp pr_envp

out:
	movl %ebp, %esp
	popl %ebp

	# return 0
	movl $0, %eax
	ret

