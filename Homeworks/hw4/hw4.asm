
##############################################################
# Homework #4
# name: Evan Peterson
# sbuid: 108509452
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

# Clear Board
# This function will set all the cells of the board array to -1
# $a0 = cell[][] board
# $a1 = int numRows
# $a2 = int numCols
# returns 0 if success,-1 on failure (error if numRows or numCols < 2)
clear_board:
	# Error checking
	blt $a1, 2, clear_board_error	# ERROR if rows < 2
	blt $a2, 2, clear_board_error	# ERROR if cols < 2
	
	# init registers for calculations
	move $t0, $a0		# $t0 = Base address of board
	move $t1, $a1		# $t1 = rows
	move $t2, $a2		# $t2 = cols
	li $t3, 0		# $t3 = i (current row)
	li $t4, 0		# $t4 = j (current col)
	li $t5, 2		# $t5 = size_of(obj), AKA, num bytes per cell
	mul $t6, $t5, $t2	# $t6 = [num_cols * size_of(obj)] <--- (row_size)
	
	# obj_arr[i][j] = base_address + (row_size * i) + (size_of(obj) * j)
	clearBoardLoopRows:
		beq $t1, $t3, clear_board_success		# End of matrix, return 0 or success
		clearBoardLoopCols:
			beq $t2, $t4, clearBoardNextRow		# End of cols, next row
			mul $t7, $t6, $t3  			# $t7 = (row_size * i)
			mul $t8, $t5, $t4  			# $t8 = (size_of(obj) * j)
			add $t9, $t7, $t8 			# $t9 = (row_size * i) + (size_of(obj) * j)
			add $t9, $t9, $t0  			# $t9 = base_address + (row_size * i) + (size_of(obj) * j)
			li $t8, -1				# $t8 = temp for -1
			sh $t8, 0($t9)				# STORE THE -1 IN THIS CELL!
			addi $t4, $t4, 1			# j++
			j clearBoardLoopCols	
		clearBoardNextRow:
			addi $t3, $t3, 1			# i++
			li $t4, 0				# j = 0
			j clearBoardLoopRows
			
	clear_board_error:
		li $v0, -1					# There was an error
		j clear_board_return
	
	clear_board_success:
		li $v0, 0					# We were successful in clearing the board!
		j clear_board_return
		
	clear_board_return:
		jr $ra
# Place
# $a0 = int[][] board: starting address of a 2d array holding the game state
# $a1 = int n_rows: number of rows in the board
# $a2 = int n_cols: number of columns in the board
# $a3 = int row: The row number of the cell we want to set
# 0($sp) = int col: The column number of the cell we want to set
# 4($sp) = int val: the value to be placed in the cell
# returns 0 for success or -1 for error
# ERRORS: n_rows or n_cols < 2 | row/col is outside the range of [0, n_rows - 1], value is NOT -1 and NOT a power of 2>=2
place:
    # Error checking
    blt $a1, 2, place_error	# ERROR: if n_rows < 2
    blt $a2, 2, place_error	# ERROR: if n_cols < 2
    
    # Get stack stuff
    move $t0, 0($sp)		# $t0 = int col: The column number of the cell we want to set.	
    move $t1, 4($sp)		# $t1 = int val: the value to be placed in the cell.
    
    # Error Checking
    bltz $a3, place_error	# ERROR: if row < 0
    bltz $t0, place_error	# ERROR: if col < 0
    bge $a3, $a1, place_error	# ERROR: if row > n_rows
    bge $t0, $a2, place_error	# ERROR: if col > n_cols
    beq $t1, -1, place_success	# SUCCESS: if val == -1
    blez $t1, place_error	# ERROR: if val <= 0
    andi $t2, $t1, 1		# CALC:  $t2 = LSB of val
    bnez $t2, place_error	# ERROR: LSB(val) = 1 so it's NOT a power of 2!
	
    place_success:
    	li $t2, 2		# $t2 = num bytes per cell
    	mul $t2, $t0, $t2, 	# $t2 = (2 * col)
    	mul $t3, $a1, $a3	# $t3 = (row_size * row)
    	add $t4, $t2, $t3	# (row_size * row) + (2 * col)
    	add $t4, $t4, $a0	# base_address + (row_size * row) + (2 * col)
    	sh $t1, 0($t4)		# store the value ---> cell[row][col] = val
    	li $v0, 0		# $v0 = 0, denotes success!
    	j place_return
    
    place_error:
    	li $v0, -1	# there was an ERROR!
    	j place_return
    	
    place_return:
    	jr $ra

start_game:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $s0, 0x777
    li $v0, 0x777
	############################################
    jr $ra

##############################
# PART 2 FUNCTIONS
##############################

merge_row:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $s0, 0x777
    li $v0, 0x777
    ############################################
    jr $ra

merge_col:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $s0, 0x777
    li $v0, 0x777
    ############################################
    jr $ra

shift_row:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $s0, 0x777
    li $v0, 0x777
    ############################################
    jr $ra

shift_col:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $s0, 0x777
    li $v0, 0x777
    ############################################
    jr $ra

check_state:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $s0, 0x777
    li $v0, 0x777
    ############################################
    jr $ra

user_move:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $s0, 0x777
    li $v0, 0x777
    li $v1, 0x777
    ############################################
    jr $ra

#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here


