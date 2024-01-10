.data
newline: .asciiz "\n"
space: .asciiz " "

A: .align 2
   .space 36                  # A[3][3]
transposeOfA1: .align 2
	       .space 36      # transposeOfA1[3][3]
transposeOfA2: .align 2
	       .space 36      # transposeOfA2[3][3]

.text
main:
	la $s0, A                 # $s0 = &A[0][0]
	la $s1, transposeOfA1     # $s1 = &transposeOfA1[0][0]
	la $s2, transposeOfA2     # $s2 = &transposeOfA2[0][0]
	move $s3, $s0             # $s3 = *ptrA = &A[0][0]
	move $s4, $s2             # $s4 = *ptrTA2 = &transposeOfA2[0][0]
	
	add $a0, $s0, $zero    # $a0 = &A[0][0]
	jal inputMatrix    
	
	add $a0, $s0, $zero    # $a0 = &A[0][0]
	add $a1, $s1, $zero    # $a1 = &transposeOfA2[0][0]
	li $a2, 3              # $a2 = 3
	jal transposeMatrixA1
	
	add $a0, $s3, $zero    # $a0 = *ptrA
	add $a1, $s4, $zero    # $a1 = *ptrTA2
	li $a2, 3              # $a2 = 3
	jal transposeMatrixA2
	
	add $a0, $s1, $zero
	jal outputMatrix
	
	add $a0, $a1, $zero
	jal outputMatrix
	
	#exit program
	li $v0, 10
	syscall	

inputMatrix:
	li $t0, 0       # $t0 = i
	loop1:
		bge $t0, 3, exit_1       # $t0 >= 3 ---> exit_1
		li $t1, 0                # $t1 = j
		loop2:
			bge $t1, 3, exit_2
			
			# A[i][j]
			mul $t2, $t0, 12     # $t2 = i*12
			sll $t3, $t1, 2      # $t3 = j*4 
			add $t2, $t2, $t3    # $t2 = i*12 + j*4
			add $t2, $a0, $t2    # $t2 = &A[0][0] + i*12 + j*4 = &A[i][j]
			
			li $v0, 5
			syscall
			sw $v0, 0($t2)
			addi $t1, $t1, 1
			j loop2
			
		exit_2:
			addi $t0, $t0, 1     # i++
			j loop1
	exit_1:
		jr $ra

transposeMatrixA1:
	li $t0, 0    # $t0 = i
	loop_1:
		bge $t0, $a2, exit_loop_1
		li $t1, 0    # $t1 = j
		loop_2:
			bge $t1, $a2, exit_loop_2
			# A[i][j]
			mul $t2, $t0, $a2    # $t2 = i*3
			add $t2, $t2, $t1    # $t2 = i*3 + j
			sll $t2, $t2, 2      # $t2 = 4 * (i*3 + j) = 12*i + 4*j
			add $t2, $a0, $t2    # $t2 = &A[i][j]
			
			# T[j][i]
			mul $t3, $t1, $a2    # $t2 = j*3
			add $t3, $t3, $t0    # $t3 = j*3 + i
			sll $t3, $t3, 2      # $t3 = 4 * (j*3 + i) = 12*j + 4*i
			add $t3, $a1, $t3    # $t3 = &T[j][i]
			
			lw $t2, 0($t2)       # $t2 = A[i][j]
			sw $t2, 0($t3)       # T[j][i] = A[i][j]
			
			addi $t1, $t1, 1     # j++
			j loop_2
			
		exit_loop_2:
			addi $t0, $t0, 1
			j loop_1
			
	exit_loop_1:
		jr $ra

transposeMatrixA2:
	add $t1, $a0, $zero   # $t1 = *ptrB = B
	add $t2, $a1, $zero   # $t2 = *ptrT = T
	li $t0, 1             # $t0 = i
	L1:
		mul $t3, $a2, $a2       # $t3 = size * size
		add $t3, $a1, $t3       # $t3 = B + (size * size)
		bge $t1, $t3, exit_L1   # ptrB >= B + (size * size) --> exit_L1
		
		lw $t3, 0($t1)    # $t3 = *ptrB
		sw $t3, 0($t2)    # *ptrT = $t3
		
		if:
			bge $t0, $a2, else
			sll $t3, $a2, 2      # $t3 = size * 4
			add $t2, $t2, $t3    # $t2 = ptrT = ptrT + size*4
			addi $t0, $t0, 1     # i++
			j L
			
		else:
			subi $t3, $a2, 1     # $t3 = size - 1
			mul $t3, $a2, $t3    # $t3 = size * (size-1)
			subi $t3, $t3, 1     # $t3 = size * (size-1) - 1
			sll $t3, $t3, 2      # $t3 = {size * (size-1) - 1} * 4
			sub $t2, $t2, $t3    # $t2 = ptrT = ptrT - {size * (size-1) - 1} * 4
			li $t0, 1            # i = 1
		
		L:
			addi $t1, $t1, 4     # ptrB++
			j L1
		
	exit_L1:
		jr $ra
	

outputMatrix:
	add $a1, $a0, $zero
	li $t0, 0     # $t0 = i
	for_loop1:
		bge $t0, 3, exit_loop1
		li $t1, 0    # $t1 = j
		for_loop2:
			bge $t1, 3, exit_loop2
			# A[i][j]
			mul $t2, $t0, 3      # $t2 = i*3
			add $t2, $t2, $t1    # $t2 = i*3 + j
			sll $t2, $t2, 2      # $t2 = 4 * (i*3 + j) = 12*i + 4*j
			add $t2, $a1, $t2    # $t2 = &A[i][j]
			lw $a0, 0($t2)       # $a0 = A[i][j]
			
			li $v0, 1
			syscall
			li $v0, 4
			la $a0, space
			syscall
			
			addi $t1, $t1, 1     # j++
			j for_loop2
			
		exit_loop2:
			li $v0, 4
			la $a0, newline
			syscall
			
			addi $t0, $t0, 1
			j for_loop1
			
	exit_loop1:
		jr $ra