# TEST FILE FOR MY FUNCTIONS.  DO NOT SUBMIT THIS!


.data
matrix: .space 60 # 5 x 3 matrix of 4-byte words
rows: .word 5
columns: .word 5
space: .asciiz " "
newline: .asciiz "\n"
.text
main:
	# j testPlace
	j testStartGame
	#j testMergeRow
	# CLEAR BOARD TESTING
    	#la $a0, matrix 
	#lw $a1, rows    # number of rows
	#lw $a2, columns # number of columns
    	#jal clear_board
    	
    	########################################
    	# 		Test cases	       #
    	########################################
    	# 1. n_rows < 2:  			Expected: $v0 = -1 | Actual: $v0 = ???
    	# 2. n_cols < 2:  			Expected: $v0 = -1 | Actual: $v0 = ???
    	# 3. row < 0:     			Expected: $v0 = -1 | Actual: $v0 = ???
    	# 4. row >= n_rows:			Expected: $v0 = -1 | Actual: $v0 = ???
    	# 5. col < 0:     			Expected: $v0 = -1 | Actual: $v0 = ???
    	# 6. col >= n_cols:			Expected: $v0 = -1 | Actual: $v0 = ???
    	# 7. value != -1 && != pow(2)		Expected: $v0 = -1 | Actual: $v0 = ???
    	# 8. Everything else should store the value provided at the correct index and $v0 = 0
    	testPlace:
    	# place(int[][] board, int n_rows, int n_cols, int row, int col, int val)
    	la $a0, matrix 		# starting address of board[][]
	lw $a1, rows    	# number of rows in board
	lw $a2, columns 	# number of columns in board
    	li $a3, 2		# row index to store at
    	addi $sp, $sp, -8
    	li $t0, 0		# col index to store at
    	li $t1, 8		# value to store
    	sh $t0, 0($sp)		
    	sh $t1, 4($sp)
    	jal place
    	addi $sp, $sp, 8
    	
    	testStartGame:
    		la $a0, matrix 		# starting address of board[][]
		lw $a1, rows    	# number of rows in board
		lw $a2, columns 	# number of columns in board
    		li $a3, 2		# r1
    		li $t0, 2		# c1
    		li $t1, 1		# r2
    		li $t2, 1		# c2
    	
    		addi $sp, $sp, -12
    		sh $t0, 0($sp)		
    		sh $t1, 4($sp)
    		sh $t2, 8($sp)
    		jal start_game
    		addi $sp, $sp, 12
    		j printMatrix
    	
    	
    	testMergeRow:
    	la $a0, matrix 		# starting address of board[][]
	lw $a1, rows    	# number of rows in board
	lw $a2, columns 	# number of columns in board
	li $a3, 2		# row = 2
	addi $sp, $sp, 4
	sh $0, 0($sp)
	jal merge_row
	
	printMatrix:
	lw $t1, rows    # number of rows
	lw $t2, columns # number of columns

	li $t3, 0  # i, row counter


row_loop:
	li $t4, 0  # j, column counter
col_loop:
	
	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 2   # 2*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	lh  $t8, 0($t5)
	
	# Print integer
	move $a0, $t8
	li $v0, 1
	syscall
	
	# Print space
	la $a0, space
	li $v0, 4
	syscall
	
	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop
col_loop_done:
	addi $t3, $t3, 1  # i++
	la $a0, newline
	li $v0, 4
	syscall
	blt $t3, $t1, row_loop

row_loop_done:

    	# Terminate the program
    	li $v0, 10
    	syscall
    	
.include "hw4.asm"   	
