.data
weight: .word 0
height: .word 0
bmi: .word 0
overweight: .asciiz "overweight\n"
underweight: .asciiz "underweight\n"
newline: .asciiz "\n"

.text
main:
	loop:	la $s0, height
		la $s1, weight
		la $s2, bmi
		
		li $v0, 5
		syscall
		move $s0, $v0  # $s0 = height

		beq $s0, -1, exit
		
		li $v0, 5
		syscall
		move $s1, $v0  # $s1 = weight
		
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		
		jal calculateBMI
		
		move $a0, $v0
		jal printResult
		
		j loop

	# exit program
	exit:	li $v0, 10
		syscall


calculateBMI:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	mul $t0, $a1, 10000
	mul $t1, $a0, $a0
	div $t0, $t1
	mflo $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
printResult:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	move $t0, $a0
	blt $t0, 18, under
	bgt $t0, 24, over
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
	under:	li $v0, 4
		la $a0, underweight
		syscall
		jr $ra
		
	over:	li $v0, 4
		la $a0, overweight
		syscall
		jr $ra
