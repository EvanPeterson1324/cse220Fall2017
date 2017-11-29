# TEST FILE FOR MY FUNCTIONS.  DO NOT SUBMIT THIS!


.data
matrix: .space 60 # 
rows: .word 4
columns: .word 4
space: .asciiz " "
newline: .asciiz "\n"
.text
main:
	
	 
	j testStartGame
	#j testMergeRow
	
	# clear_board
    	#la $a0, matrix 
	#lw $a1, rows    # number of rows
	#lw $a2, columns # number of columns
    	#jal clear_board
    	#j testPlace
    	
    	#testPlace:
    	# place(int[][] board, int n_rows, int n_cols, int row, int col, int val)
    	#la $a0, matrix 		# starting address of board[][]
	#lw $a1, rows    	# number of rows in board
	#lw $a2, columns 	# number of columns in board
    	#li $a3, 2		# row index to store at
    	#addi $sp, $sp, -8
    	#li $t0, 4		# col index to store at
    	#li $t1, -1		# value to store
    	#sh $t0, 0($sp)		
    	#sh $t1, 4($sp)
    	#jal place
    	#addi $sp, $sp, 8
    	#j exit 
    	testStartGame:
    		la $a0, matrix 		# starting address of board[][]
		lw $a1, rows    	# number of rows in board
		lw $a2, columns 	# number of columns in board
    		li $a3, 0		# r1
    		li $t0, 0		# c1
    		li $t1, 0		# r2
    		li $t2, 1		# c2
    	
    		addi $sp, $sp, -12
    		sh $t0, 0($sp)		
    		sh $t1, 4($sp)
    		sh $t2, 8($sp)
    		jal start_game
    		addi $sp, $sp, 12
    	
    	
    	testMergeRow:
    		la $a0, matrix 		# starting address of board[][]
		lw $a1, rows    	# number of rows in board
		lw $a2, columns 	# number of columns in board
		li $a3, 0		# row = 0
		addi $sp, $sp, 4
		sh $0, 0($sp)
		jal merge_row
	
	
	
	exit:
    		# Terminate the program
    		li $v0, 10
    		syscall
    	
.include "hw4.asm"   	
