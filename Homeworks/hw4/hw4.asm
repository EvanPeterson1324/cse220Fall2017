
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
    lbu $t0, 0($sp)		# $t0 = int col: The column number of the cell we want to set.	
    lbu $t1, 4($sp)		# $t1 = int val: the value to be placed in the cell.
    
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
    	mul $t5, $a2, $t2	# $t5 = row_size
    	mul $t2, $t0, $t2, 	# $t2 = (2 * col)
    	mul $t3, $t5, $a3	# $t3 = (row_size * row)
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

# Start Game: (MUST CALL CLEAR_BOARD AND PLACE!!!)
# $a0 = cell[][] board: the starting address of a 2D array holding the state of the game board
# $a1 = int num_rows: number of rows on the board
# $a2 = int num_cols: number of cols on the board
# $a3 = int r1: row number for the first starting value
# 0($sp) = int c1: column number for the first starting value
# 4($sp) = int r2: row number for 2nd starting value
# 8($sp) = int c2: col number for the 2nd starting value
# return 0 on success, -1 on error
# Errors: num_rows/num_cols < 2 | r1/r2 is outside the range of [0, num_rows - 1] | c1/c2 is outside the range of [0, num_cols - 1]
start_game:
    blt $a1, 2, start_game_error	# ERROR: num_rows < 2
    blt $a2, 2, start_game_error	# ERROR: num_cols < 2
    
    # Load $s0 - $s6 from the arguments
    move $s0, $a0			# $s0 = board
    move $s1, $a1			# $s1 = num_rows
    move $s2, $a2			# $s2 = num_cols
    move $s3, $a3			# $s3 = r1
    lbu $s4, 0($sp)			# $s4 = c1
    lbu $s5, 4($sp)			# $s5 = r2
    lbu $s6, 8($sp)			# $s6 = c2
    
    bltz $s3, start_game_error		# ERROR: r1 < 0
    bltz $s4, start_game_error		# ERROR: c1 < 0
    bltz $s5, start_game_error		# ERROR: r2 < 0
    bltz $s6, start_game_error		# ERROR: c2 < 0
    
    bge $s3, $s1, start_game_error		# ERROR: r1 >= num_rows
    bge $s4, $s2, start_game_error		# ERROR: c1 >= num_cols
    bge $s5, $s1, start_game_error		# ERROR: r2 >= num_rows
    bge $s6, $s2, start_game_error		# ERROR: c2 >= num_cols
    
    # Call to clear_board first
    move $a0, $s0	# $a0 = board
    move $a1, $s1	# $a1 = num_rows
    move $a2, $s2	# $a2 = num_cols
    jal clear_board
    
    # Place starting value ---> board[r1][c1] = 2
    li $t0, 2		# starting value
    move $a0, $s0	# $a0 = board 
    move $a1, $s1	# $a1 = num_rows
    move $a2, $s2	# $a2 = num_cols
    move $a3, $s3	# $a3 = r1
    addi $sp, $sp, -8
    sb $t0, 4($sp)	# 4($sp) = starting value #1
    sb $s4, 0($sp)	# 0($sp) = c1
    jal place
    
    # Place starting value ---> board[r2][c2] = 2
    li $t0, 2		# starting value
    move $a0, $s0	# $a0 = board 
    move $a1, $s1	# $a1 = num_rows
    move $a2, $s2	# $a2 = num_cols
    move $a3, $s5	# $a3 = r2
    sb $t0, 4($sp)	# 4($sp) = starting value #1
    sb $s6, 0($sp)	# 0($sp) = c2
    jal place
    
    addi $sp, $sp, 8	# put stack point back to where it belongs
    j start_game_success
    
    start_game_success:
    	li $v0, 1		# SUCCESS: return 0
    	start_game_return
    	
    start_game_error:
    	li $v0, -1		# ERROR: return -1
    	j start_game_return
    
    start_game_return:
    	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

# Merge Row
# $a0 = cell[][] board: starting address of the board
# $a1 = int num_rows: Number of rows in the board
# $a2 = int num_cols: Number of cols in the board
# $a3 = int row: The row index we are merging
# 0($sp) = int direction: the direction of the merge (0 indicates left-right merge, 1 indicates right-left merge
# returns: Number of cells with non-empty values in the row after merge, -1 on error
# Errors: row < 0 or row >= num_cols | num_rows/num_cols < 2 | direction is something other than 1 or 0
merge_row:
    blt $a1, 2, merge_row_error		# Error: num_rows < 2
    blt $a2, 2, merge_row_error		# Error: num_cols < 2
    bltz $a3, merge_row_error		# Error: row < 0
    bge $a3, $a2, merge_row_error	# Error: row >= num_cols
    lb $t0, 0($sp)			# $t0 = value of direction
    bgt $t0, 1, merge_row_error		# Error: direction != 1 or 0
    bltz $t0, merge_row_error		# Error: direction is negative
    
    # Loading $s0 - $s4 with the arguments
    move $s0, $a0	# $s0 = board
    move $s1, $a1	# $s1 = num_rows
    move $s2, $a2	# $s2 = num_cols
    move $s3, $a3	# $s3 = row to merge
    move $s4, 0($sp)	# $s4 = direction to merge
    
    
     
    beqz $s4, merge_row_right		# if direction == 1, merge row right 
    merge_row_left:
    	# board[row][num_cols - 1] = base_address + (num_cols * 2 * row) + (2 * (num_cols - 1))
    	li $t0, 2			# $t0 = 2
    	move $t1, $s2			# get the value of num_cols
    	addi $t1, $t1, -1		# $t1 = num_cols - 1
    	mul $t1, $t1, $t0		# $t1 = 2 * num_cols - 1
    	mul $t0, $t0, $s2		# $t0 = row_size
    	mul $s5, $t0, $s3		# $s5 = (row_size * row)
    	add $s5, $s5, $s0		# $s5 = base_address + (row_size * row)
    	add $s5, $s5, $t0		# $s5 = base_address + (row_size * row) + (2 * (num_cols - 1))
    	# Address in $s5 starts at the last element of the row
    	# TODO: 
    merge_row_right:
    	# board[row][0] = base_address + (2 * num_cols * row)
    	li $t0, 2			# $t0 = 2
    	mul $t0, $t0, $s2		# $t0 = row_size
    	mul $s5, $t0, $s3		# $s5 = (row_size * row)
    	add $s5, $s5, $s0		# $s5 = base_address + (row_size * row)
    	# Address in $s5 starts at the first element of the row
    	sub $t0, $s5, $s0		# $t0 = the index we are at in the row
    	beq $s2, $t0, merge_row_success # if the index we are at is equal to num_cols, we are done
    	addi $s6, $s5, 1		# $s6 = the 2nd cell we want to check 
    merge_row_error:
    	li $v0, -1	     # Error: return -1
    	j merge_row_return
    	
    merge_row_success:
    	li $v0, 1	     # Success: TODO ---> supposed to return the number of cells with non-empty values in the row after merge
    	j merge_row_return
    	
    merge_row_return:
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
    
####################
# HELPER FUNCTIONS #
####################

###### get_cell ######
# $a0 = starting address of board
# $a1 = num_rows
# $a2 = num_cols
# $a3 = row
# 0($sp) = col
# returns the address of board[row][col]
get_cell:
    # obj_arr[i][j] = base_address + (row_size * row) + (2 * col)
    # row_size = 2 * (num_cols - 1)
    li $t0, 2		# $t0 = 2
    move $t1, $a2	# $t1 = num_cols
    addi $t1, $t1, -1	# $t1 = num_cols - 1
    mul $t1, $t1, $t0	# $t1 = row_size: 2 * (num_cols - 1)
    mul $t1, $t1, $a3	# $t1 = row_size * row
    lbu $t2, 0($sp)	# $t2 = col
    mul $t0, $t0, $t2	# $t0 = 2 * col
    add $t0, $t0, $t2	# $t0 = (row_size * row) + (2 * col)
    add $v0, $t0, $a0	# base_address + (row_size * row) + (2 * col)
    jr $ra		# return the cell

########################
# HELPER FUNCTIONS END #
########################
