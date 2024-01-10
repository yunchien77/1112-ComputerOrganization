.data
array: .space 20
newline: .asciiz "\n"

.text
main:
	la $a1, array     # $s0 = array's base address
	li $t0, 0         # i = 0
	
	loop1:
		bge $t0, 5, exit_loop1
		sll $t1, $t0, 2         # $t1 = i * 4
		add $t1, $a1, $t1       # $t1 = &array[0] + i*4 = &array[i]   
		li $v0, 5
		syscall
		sw $v0, 0($t1)          # 將user input賦值到array[i]
		addi $t0, $t0, 1
		j loop1
		
	exit_loop1:
		li $a2, 5    # length = 5
		jal insertionSort
		
	li $t0, 0     # i = 0
	loop2:
		bge $t0, 5, exit_loop2
		sll $t1, $t0, 2         # $t1 = i * 4
		add $t1, $a1, $t1       # $t1 = &array[0] + i*4 = &array[i]   #我是位址喔
		lw $t2, 0($t1)          # 取出array[i]的value
		
		li $v0, 1
		move $a0, $t2
		syscall
		
		li $v0, 4
		la $a0, newline
		syscall
		addi $t0, $t0, 1
		j loop2
	
	exit_loop2:
		# end program
		li $v0, 10
		syscall

insertionSort:
	addi $sp, $sp, -12
	sw $ra, 0($sp)   
	sw $a1, 4($sp)  # array[0]
	sw $a2, 8($sp)  # length
	
	li $t0, 1   # i = 1
	for_loop:
		bge $t0, $a2, exit_for
		sll $t1, $t0, 2
		add $t1, $a1, $t1  # $t1 = &array[0] + i*4 = &array[i]
		lw $t6, 0($t1)     # $t6 = current = array[i]
		subi $t2, $t0, 1   # $t2 = j = i-1
		
		while_loop:
			sll $t3, $t2, 2      # $t3 = j*4
			add $t3, $a1, $t3    # $t3 = &array[0] + j*4 = &array[j]
			lw $t4, 0($t3)       # $t4 = array[j]
			
			blt $t2, $zero, exit_while   # j < 0 --> exit_while
			ble $t4, $t6, exit_while     # array[j] <= current
			
			addi $t3, $t3, 4     # $t3 = &array[j] + 4 = &array[j+1]
			sw $t4, 0($t3)       # array[j+1] = array[j]
			subi $t2, $t2, 1
			j while_loop
					
		exit_while:
			li $v0, 1
			addi $a0, $t2, 1   # $a0 = j+1
			syscall
		
			li $v0, 4
			la $a0, newline
			syscall
		
			sll $t5, $t2, 2     # $t5 = j*4
			add $t5, $a1, $t5   # $t5 = &array[0] + j*4 = &array[j]
			sw $t6, 4($t5)      # array[j+1] = current
			addi $t0, $t0, 1    # i++
			j for_loop
		
	exit_for:
		lw $ra, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		addi $sp, $sp, 12
		jr $ra
