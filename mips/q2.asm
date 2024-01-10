.data
dp: .space 800
newline: .asciiz "\n"

.text
main:
	la $t0, dp  # $t0為dp array的基底位置
	li $t1, 0   # i = 0

	loop:
		sw $zero, 0($t0)  # data[i] = 0
		addi $t0, $t0, 4
		addi $t1, $t1, 1
		bge $t1, 200, exit_loop
		j loop
	
	exit_loop:
		li $v0, 5
		syscall
		move $a1, $v0   # $s0 = num
		
	la $a2, dp       # $s1 = dp[]
	jal fib
	
	move $s3, $v0
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall

	# end program
	li $v0, 10
	syscall

fib:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a1, 4($sp)  # n
	sw $a2, 8($sp)  # dp
	
	# dp[n]
	sll $t0, $a1, 2    # n * 4
	add $t1, $a2, $t0  # $t1 = &dp[] + n*4 = &dp[n]
	lw $t5, 0($t1)     # $t1 = dp[n]      #t1是address; a1是value
		
	bne $t5, $zero, if_case1
		
	beq $a1, 1, if_case2
	beq $a1, 2, if_case2
		
	subi $a1, $a1, 1
	jal fib
	move $t2, $v0       # fib(n-1, dp)
	
	subi $a1, $a1, 1
	jal fib
	move $t3, $v0       # fib(n-2, dp)
	
	add $t5, $t2, $t3   # dp[n] = fib(n-1, dp) + fib(n-2, dp)
	sw $t5, 8($t1)
	li $t4, 3
	div $t5, $t4
	mfhi $t4
	beq $t4, $zero, if_case3
	f:
	move $v0, $t5
	j end
		
	if_case1:
		li $v0, 1
		move $a0, $t5
		syscall
		
		li $v0, 4
		la $a0, newline
		syscall
			
		move $v0, $t5
		j end
		
	if_case2:
		li $t5, 1
		sw $t5, 0($t1)
		li $v0, 1
		j end
		
	if_case3:
		li $v0, 1
		move $a0, $t5
		syscall
		
		li $v0, 4
		la $a0, newline
		syscall
		j f
		
			 
	end:
		lw $ra, 0($sp)
		lw $a1, 4($sp)  # n
		lw $a2, 8($sp)  # dp
		addi $sp, $sp, 12
		jr $ra
