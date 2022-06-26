
.section .rodata
argc:
	.asciz "argc = %d\n\n"
argv:
	.asciz "arg = %s\n"

.section .text
	.globl main

main:
	pushl %esp
	movl %esp, %ebp

	# move argc into ecx
	movl 8(%ebp), %ecx
	# move argv base address into esi
	movl 12(%esp), %esi

	# Make a room for the 
	# temp argv index
	subl $12, %ebp

	# argv index
	movl $0, 4(%ebp) 

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
	jl out

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

out:
	# clear the stack
	addl $12, %ebp
	movl %ebp, %esp
	popl %esp

	# return 0
	movl $0, %eax
	ret

