.data
A: .align 2
   .space 36
transposeOfA1: .align 2
	       .space 36
transposeOfA2: .align 2
	       .space 36
newline: .asciiz "\n"
space: .asciiz " "
	        
.text
main:
	la $s0, A               # $s0 = &A[0][0]
	la $s1, transposeOfA1   # $s1 = &transposeOfA1[0][0]
	la $s2, transposeOfA2   # $s2 = &transposeOfA2[0][0]
	add $s3, $s0, $zero     # $s3 = *ptrA
	add $s4, $s2, $zero     # $s4 = *ptrTA2
	
	add $a1, $s0, $zero
	jal inputMatrix
	
	add $a1, $s0, $zero
	jal outputMatrix
	li $v0, 10
	syscall
	
inputMatrix:
	# $a1 = &A[0][0]
	li $t0, 0      # $t0 = i
	for_1:
		slti $at, $t0, 3
		beq $at, $zero, exit_for1
		li $t1, 0      # $t1 = j
		for_2:
			slti $at, $t1, 3
			beq $at, $zero, exit_for2
			mul $t2, $t0, 3
			add $t2, $t2, $t1
			sll $t2, $t2, 2
			add $t2, $a1, $t2   # $t2 = &A[i][j]
			li $v0, 5
			syscall
			sw $v0, 0($t2)
			add $t1, $t1, 1
			j for_2
		exit_for2:
			add $t0, $t0, 1
			j for_1
			
	exit_for1:
		jr $ra
		
outputMatrix:
	# $a1 = &A[0][0]
	li $t0, 0      # $t0 = i
	for1:
		slti $at, $t0, 3
		beq $at, $zero, exit_1
		li $t1, 0      # $t1 = j
		for2:
			slti $at, $t1, 3
			beq $at, $zero, exit_2
			mul $t2, $t0, 3
			add $t2, $t2, $t1
			sll $t2, $t2, 2
			add $t2, $a1, $t2   # $t2 = &A[i][j]
			lw $a0, 0($t2)
			li $v0, 1
			syscall
			li $v0, 4
			la $a0, space
			syscall
			add $t1, $t1, 1
			j for2
		exit_2:
			li $v0, 4
			la $a0, newline
			syscall
			add $t0, $t0, 1
			j for1
			
	exit_1:
		jr $ra
