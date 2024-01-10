.data
underweight: .asciiz "underweight\n"
overweight: .asciiz "overweight\n"
newline: .asciiz "\n"

.text
main:
	while:
		li $v0, 5
		syscall
		add $s0, $v0, $zero   # $s0 = height
		beq $s0, -1, exit_while
		li $v0, 5
		syscall
		add $s1, $v0, $zero   # $s1 = weight
		add $a0, $s0, $zero   # $a0 = height
		add $a1, $s1, $zero   # $a1 = weight
		jal calculateBMI
		add $a1, $v0, $zero   # $a1 = bmi
		jal printResult
		j while
		
	exit_while:
		li $v0, 10
		syscall
		
calculateBMI:
	# $a0 = height
	# $a1 = weight
	mul $t0, $a1, 10000
	mul $t1, $a0, $a0    
	div $t0, $t1  
	mflo $v0
	jr $ra 
	
printResult:
	# $a1 = bmi
	li $t0, 18
	slt $t0, $a1, $t0
	beq $t0, $zero, elseif
	li $v0, 4
	la $a0, underweight
	syscall
	j exit
	
	elseif:
		li $t0, 24
		slt $t0, $t0, $a1
		beq $t0, $zero, else
		li $v0, 4
		la $a0, overweight
		syscall
		j exit
		
	else:
		li $v0, 1
		add $a0, $a1, $zero
		syscall
		li $v0, 4
		la $a0, newline
		syscall
	
	exit:
		jr $ra
		 