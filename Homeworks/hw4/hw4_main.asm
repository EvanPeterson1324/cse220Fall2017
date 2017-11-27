# TEST FILE FOR MY FUNCTIONS.  DO NOT SUBMIT THIS!


.data
matrix: .space 60 # n x m matrix of 2-byte words
rows: .word 4
columns: .word 4

.text
main:
	#j testPlace
	j testStartGame
	# CLEAR BOARD TESTING
    	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
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
    	li $t0, 2		# col index to store at
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
    	
    	# Terminate the program
    	li $v0, 10
    	syscall
    	
.include "hw4.asm"   	
