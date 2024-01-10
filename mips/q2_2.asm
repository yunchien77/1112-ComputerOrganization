.data
dp: .space 800
newline: .asciiz "\n"

.text
main:
	la $s3, dp  # $s3 = &dp[0]
	li $s0, 0   # $s0 = answer
	li $s1, 0   # $s1 = num
	li $s2, 0   # $s2 = i
	for:
		slti $at, $s2, 200
		beq $at, $zero, exit_for
		sll $s2, $s2, 2       # $s2 = i*4
		add $s2, $s3, $s2     # $s2 = &dp[i]
		sw $zero, 0($s2)      # dp[i] = 0
		addi $s2, $s2, 1
		j for
		
	exit_for:
		li $v0, 5
		syscall
		add $s1, $v0, $zero
		add $a1, $s1, $zero   # $a1 = n
		add $a2, $s3, $zero   # $a2 = &dp[0]
		jal fib
		add $s4, $v0, $zero   # $s4 = answer
		li $v0, 1
		add $a0, $s4, $zero
		syscall
		li $v0, 4
		la $a0, newline
		syscall
		li $v0, 10
		syscall
		
fib:
	# $a1 = n
	# $a2 = &dp[0]
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	if_1:
		sll $t1, $a1, 2     # $t1 = n*4
		add $t1, $a2, $t1   # $t1 = &dp[n]
		lw $t0, 0($t1)      # $t0 = dp[n]
		beq $t0, $zero, if_2
		
		li $v0, 1
		add $a0, $t0, $zero
		syscall
		li $v0, 4
		la $a0, newline
		syscall
		add $v0, $t0, $zero
		j exit
	if_2:
		beq $a1, 1, if
		beq $a1, 2, if
		j else
	if:	
		li $t2, 1
		sw $t2, 0($t1)   # dp[n] = 1
		addi $v0, $zero, 1
		j exit
	
	else:
		addi $a1, $a1, -1
		jal fib
		add $t3, $v0, $zero
		
		addi $a1, $a1, -1
		jal fib
		add $t4, $v0, $zero
		add $t3, $t3, $t4
		sw $t3, 8($t1)    # &dp[n] = $t3
		li $t5, 3
		div $t3, $t5
		mfhi $t5
		bne $t5, $zero, L1
		li $v0, 1
		add $a0, $t3, $zero
		syscall
		li $v0, 4
		la $a0, newline
		syscall
		L1:
			add $v0, $t3, $zero
			j exit
	exit:
		lw $ra, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		addi $sp, $sp, 12
		jr $ra
		