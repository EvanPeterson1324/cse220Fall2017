
##############################################################
# Homework #4
# name: Evan Peterson
# sbuid: 108509452
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

###### clear_board ######
# This function will set all the cells of the board array to -1
# $a0 = cell[][] board
# $a1 = int numRows
# $a2 = int numCols
# returns 0 if success,-1 on failure (error if numRows or numCols < 2)
clear_board:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
    	sw $s0, 4($sp)
    	sw $s1, 8($sp)
    	sw $s2, 12($sp)
    	sw $s3, 16($sp)
    	sw $s4, 20($sp)
	
	# Error checking
	blt $a1, 2, clear_board_error	# ERROR if num_rows < 2
	blt $a2, 2, clear_board_error	# ERROR if num_cols < 2
	
	# init registers for calculations
	move $s0, $a0		# $s0 = Base address of board
	move $s1, $a1		# $s1 = rows
	move $s2, $a2		# $s2 = cols
	li $s3, 0		# $s3 = i (current row)
	li $s4, 0		# $s4 = j (current col)
	
	clearBoardLoopRows:
		beq $s1, $s3, clear_board_success		# Return success!
		clearBoardLoopCols:
			beq $s2, $s4, clearBoardNextRow		# next row
			# Load the registers for the get cell function
			move $a0, $s0		# $a0 = starting address of board
			move $a1, $s1		# $a1 = num_rows
			move $a2, $s2		# $a2 = num_cols
			move $a3, $s3		# $a3 = current row
			addi $sp, $sp, -4	
			sb $s4, 0($sp)		# 0($sp) = current col
			jal get_cell		# FUNCTION CALL TO GET_CELL
			addi $sp, $sp, 4	# Restore stack space
			li $t0, -1		# $t0 = temp for -1
			move $t1, $v0		# $t1 = address of current cell
			sh $t0, 0($t1)		# STORE THE -1 IN THIS CELL!
			addi $s4, $s4, 1	# j++
			j clearBoardLoopCols	
		clearBoardNextRow:
			addi $s3, $s3, 1			# i++
			li $s4, 0				# j = 0
			j clearBoardLoopRows
			
	clear_board_error:
		li $v0, -1					# There was an error
		j clear_board_return
	
	clear_board_success:
		li $v0, 0					# We were successful in clearing the board!
		j clear_board_return
	clear_board_return:
		lw $ra, 0($sp)
    		lw $s0, 4($sp)
    		lw $s1, 8($sp)
    		lw $s2, 12($sp)
    		lw $s3, 16($sp)
    		lw $s4, 20($sp)
		addi $sp, $sp, 24
		jr $ra
		
###### place ######
# $a0 = int[][] board: starting address of a 2d array holding the game state
# $a1 = int n_rows: number of rows in the board
# $a2 = int n_cols: number of columns in the board
# $a3 = int row: The row number of the cell we want to set
# 0($sp) = int col: The column number of the cell we want to set
# 4($sp) = int val: the value to be placed in the cell
# returns 0 for success or -1 for error
# ERRORS: n_rows or n_cols < 2 | row/col is outside the range of [0, n_rows - 1], value is NOT -1 and NOT a power of 2>=2
place:
    # Get stack stuff
    lh $t0, 0($sp)		# $t0 = int col: The column number of the cell we want to set.	
    lh $t1, 4($sp)		# $t1 = int val: the value to be placed in the cell.
   
    addi $sp, $sp, -28
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    
    # Init $s0 - $s5
    move $s0, $a0	# $s0 = board
    move $s1, $a1	# $s1 =	num_rows
    move $s2, $a2	# $s2 =	num_cols
    move $s3, $a3	# $s3 =	row
    move $s4, $t0	# $s4 =	col
    move $s5, $t1	# $s5 =	value
    
    # Error checking
    blt $s1, 2, place_error	# ERROR: if n_rows < 2
    blt $s2, 2, place_error	# ERROR: if n_cols < 2
    
    # Error Checking
    bltz $s3, place_error	# ERROR: if row < 0
    bltz $s4, place_error	# ERROR: if col < 0
    bge $s3, $s1, place_error	# ERROR: if row >= n_rows
    bge $s4, $s2, place_error	# ERROR: if col >= n_cols
    beq $s5, -1, place_success	# SUCCESS: if val == -1
    blez $s5, place_error	# ERROR: if val <= 0
    addi $t2, $s5, -1		# CALC:  $t2 = val - 1
    and $t2, $t2, $s5		# CALC: $t2 = val && val - 1... Should be zero if its a power of two
    bnez $t2, place_error	# ERROR: Result is not zero so its not a power of two
	
    place_success:
	move $a0, $s0		# board
	move $a1, $s1		# num_rows
	move $a2, $s2		# num_cols
	move $a3, $s3		# row
	addi $sp, $sp, -4
	sw $s4, 0($sp)		# col
    	jal get_cell
    	addi $sp, $sp, 4	# Restore stack space
    	move $t0, $v0
    	sh $s5, 0($t0)		# store the value ---> cell[row][col] = val
    	li $v0, 0		# $v0 = 0, denotes success!
    	j place_return
    
    place_error:
    	li $v0, -1	# there was an ERROR!
    	j place_return
    	
    place_return:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
    	jr $ra

###### Start Game ######
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
    lw $t0, 0($sp)			# $t0 = c1
    lw $t1, 4($sp)			# $t1 = r2
    lw $t2, 8($sp)			# $t2 = c2
    
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    
    # Load $s0 - $s6 from the arguments
    move $s0, $a0			# $s0 = board
    move $s1, $a1			# $s1 = num_rows
    move $s2, $a2			# $s2 = num_cols
    move $s3, $a3			# $s3 = r1
    move $s4, $t0			# $s4 = c1
    move $s5, $t1			# $s5 = r2
    move $s6, $t2			# $s6 = c2
    
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
    beq $v0, -1, start_game_error		# ERROR: issue with clear_board
    
    # Place starting value ---> board[r1][c1] = 2
    li $t0, 2		# starting value
    move $a0, $s0	# $a0 = board 
    move $a1, $s1	# $a1 = num_rows
    move $a2, $s2	# $a2 = num_cols
    move $a3, $s3	# $a3 = r1
    addi $sp, $sp, -8
    sw $t0, 4($sp)	# 4($sp) = starting value #1
    sw $s4, 0($sp)	# 0($sp) = c1
    jal place
    addi $sp, $sp, 8	# put stack pointer back to where it belongs
    beq $v0, -1, start_game_error		# ERROR: issue with place
    
    # Place starting value ---> board[r2][c2] = 2
    li $t0, 2		# starting value
    move $a0, $s0	# $a0 = board 
    move $a1, $s1	# $a1 = num_rows
    move $a2, $s2	# $a2 = num_cols
    move $a3, $s5	# $a3 = r2
    addi $sp, $sp, -8
    sw $t0, 4($sp)	# 4($sp) = starting value #1
    sw $s6, 0($sp)	# 0($sp) = c2
    jal place
    beq $v0, -1, start_game_error
    addi $sp, $sp, 8	# put stack pointer back to where it belongs
    j start_game_success
    
    start_game_success:
    	li $v0, 0		# SUCCESS: return 0
    	j start_game_return
    	
    start_game_error:
    	li $v0, -1		# ERROR: return -1
    	j start_game_return
    
    start_game_return:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	lw $s6, 28($sp)
    	addi $sp, $sp, 32
    	jr $ra

##############################
# 	PART 2 FUNCTIONS     #    
##############################

###### merge_row ######
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
    lh $t0, 0($sp)			# $t0 = value of direction
    bgt $t0, 1, merge_row_error		# Error: direction != 1 or 0
    bltz $t0, merge_row_error		# Error: direction is negative
    
    addi $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    
    # Loading $s0 - $s4 with the arguments
    move $s0, $a0	# $s0 = board
    move $s1, $a1	# $s1 = num_rows
    move $s2, $a2	# $s2 = num_cols
    move $s3, $a3	# $s3 = row to merge
    move  $s4, $t0	# $s4 = direction to merge
    li $s5, 0		# counter for the column number
    beq $s4, 1, merge_row_right		# if direction == 1, merge row right
    
    merge_row_left:
    	addi $s7, $s2, -1	# index to stop at
    	move $a0, $s0
    	move $a1, $s1
    	move $a2, $s2
    	move $a3, $s3		# load in row
    	addi $sp, $sp, -4
    	sb $s5, 0($sp)		# store 0 for the column bc we only want the starting address of the start of the row
    	jal get_cell
    	addi $sp, $sp, 4	# restore stack space
    	move $s6, $v0		# $s6 = the FIRST cell in the window
    	addi $s5, $s5, 1	# counter +1 so we can get the next cell
    		merge_left_loop:
    		    beq $s7, $s5, merge_row_success
    		    move $a0, $s0
    		    move $a1, $s1
    		    move $a2, $s2
    		    move $a3, $s3
    		    addi $sp, $sp, -4 
    		    sb $s5, 0($sp)		# Get the cell to the right of the first one
    		    jal get_cell
    		    addi $sp, $sp, 4		# restore stack space
    		    move $t0, $v0		# $t0 = the 2nd cell in the window
    		    
    		    # compare, if equal, merge
    		    lh $t1, 0($s6)	# cell value #1
    		    lh $t2, 0($t0)	# cell value #2
    		    
    		    beq $t1, -1, merge_left_next_iter		# if either value is -1, next iteration
    		    beq $t2, -1, merge_left_next_iter		# if either value is -1, next iteration
    		    bne $t1, $t2, merge_left_next_iter		# if the values are not equal, next iteration
    		    
    		    # Here the values are equal, so we will merge!
    		    add $t1, $t1, $t2				# sum of the values
    		    sh $t1, 0($s6)
    		    li $t3, -1
		    sh $t3, 0($t0)		# store -1 into the 2nnd cell
    		    
    		    merge_left_next_iter:
    		    	move $s6, $t0		# keep the address of the 2nd cell for the next iteration
    			addi $s5, $s5, 1	# next column
    			j merge_left_loop
    	
    merge_row_right:
    	
    	
    	addi $s5, $s2, -1	# $s5 = num_col - 1 
    	# Here we are getting the address of the last cell
    	move $a0, $s0
    	move $a1, $s1
    	move $a2, $s2
    	addi $a3, $s5	# load in num_col - 1 bc we want the last cell in the row
    	addi $sp, $sp, -4
    	sb $s5, 0($sp)		# store zero for the column bc we only want the ending address of the row
    	jal get_cell
    	addi $sp, $sp, 4	# restore stack space
    	move $s6, $v0		# $s6 = the LAST cell in the window
    	addi $s5, $s5, -1	# get the index of the 2nd cell
    		merge_right_loop:
    		    beqz $s5, merge_row_success
    		    move $a0, $s0
    		    move $a1, $s1
    		    move $a2, $s2
    		    move $a3, $s3
    		    addi $sp, $sp, -4 
    		    sb $s5, 0($sp)		# Get the cell to the left of the first one
    		    jal get_cell
    		    addi $sp, $sp, 4		# restore stack space
    		    move $t0, $v0		# $t0 = the 2nd cell in the window
    		    
    		    # compare, if equal, merge
    		    lh $t1, 0($s6)	# cell value #1
    		    lh $t2, 0($t0)	# cell value #2
    		    beq $t1, -1, merge_right_next_iter		# if either value is -1, next iteration
    		    beq $t2, -1, merge_right_next_iter		# if either value is -1, next iteration
    		    bne $t1, $t2, merge_right_next_iter		# if the values are not equal, next iteration
    		    
    		    # Here the values are equal, so we will merge!
    		    add $t1, $t1, $t2				# sum of the values
    		    sh $t1, 0($s6)
    		    li $t3, -1
		    sh $t3, 0($t0)	# store -1 into the 2nd cell
    		    merge_right_next_iter:
    			addi $s5, $s5, -1	# next column
    			move $s6, $t0	# keep the address of the 2nd cell for the next iteration
    			j merge_right_loop
    	
    merge_row_error:
    	li $v0, -1	     # Error: return -1
    	j merge_row_return
    	
    merge_row_success:
    	move $a0, $s0	             # $t0 = base address
    	move $a1, $s3		     # row we are iterating over
    	move $a2, $s2		     # num cols
    	jal get_num_filled_row_cells # $v0 = num non-empty cells
    	j merge_row_return
    	
    merge_row_return:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	lw $s6, 28($sp)
    	lw $s7, 32($sp)
    	addi $sp, $sp, 36
    	jr $ra

###### merge_col ######
# $a0 = cell[][] board: starting address of the board
# $a1 = int num_rows: Number of rows in the board
# $a2 = int num_cols: Number of cols in the board
# $a3 = int col: The col index we are merging
# 0($sp) = int direction: the direction of the merge (0 indicates bottom to top merge, 1 indicates top to bottom merge
# returns: Number of cells with non-empty values in the col after merge, or -1 on error
# Errors: row < 0 or row >= num_cols | num_rows/num_cols < 2 | direction is something other than 1 or 0	
merge_col:
    blt $a1, 2, merge_col_error		# Error: num_rows < 2
    blt $a2, 2, merge_col_error		# Error: num_cols < 2
    bltz $a3, merge_col_error		# Error: row < 0
    bge $a3, $a2, merge_col_error	# Error: row >= num_cols
    lh $t0, 0($sp)			# $t0 = value of direction
    bgt $t0, 1, merge_col_error		# Error: direction != 1 or 0
    bltz $t0, merge_col_error		# Error: direction is negative
    
    addi $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    
    # Loading $s0 - $s4 with the arguments
    move $s0, $a0	# $s0 = board
    move $s1, $a1	# $s1 = num_rows
    move $s2, $a2	# $s2 = num_cols
    move $s3, $a3	# $s3 = col to merge
    move  $s4, $t0	# $s4 = direction to merge
    li $s5, 0		# counter for the column number
    beqz $s4, merge_col_up		# if direction == 1, merge row up
    
    merge_col_down:
    	# Here we are getting the address of the last cell
    	move $a0, $s0
    	move $a1, $s1
    	move $a2, $s2
    	addi $a3, $s1, -1	# num_rows - 1: to get the last row/col cell in this col
    	addi $sp, $sp, -4	# Create stack space
    	sh $s3, 0($sp)		# Get the col we want to merge
    	jal get_cell
    	addi $sp, $sp, 4	# Restore stack space
    	move $s7, $v0		# $s7 = the last cell in col
    	
    	move $a0, $s0		
    	move $a1, $s1		
    	move $a2, $s2
    	move $a3, $s5		# load in first row
    	addi $sp, $sp, -4
    	sb $s3, 0($sp)		# # get the specified col
    	jal get_cell
    	addi $sp, $sp, 4	# restore stack space
    	move $s6, $v0		# $s6 = the FIRST cell in the window
    	addi $s5, $s5, 1	# counter +1 so we can get the next cell
    		merge_down_loop:
    		    beq $s7, $s6, merge_col_success
    		    move $a0, $s0
    		    move $a1, $s1
    		    move $a2, $s2
    		    move $a3, $s3
    		    addi $sp, $sp, -4 		# Allocate stack space
    		    sb $s5, 0($sp)		# Get the cell under the first one
    		    jal get_cell
    		    addi $sp, $sp, 4		# restore stack space
    		    move $t0, $v0		# $t0 = the 2nd cell in the window
    		    
    		    # compare, if equal, merge
    		    lh $t1, 0($s6)	# cell value #1
    		    lh $t2, 0($t0)	# cell value #2
    		    
    		    beq $t1, -1, merge_down_next_iter		# if either value is -1, next iteration
    		    beq $t2, -1, merge_down_next_iter		# if either value is -1, next iteration
    		    bne $t1, $t2, merge_down_next_iter		# if the values are not equal, next iteration
    		    
    		    # Here the values are equal, so we will merge!
    		    add $t1, $t1, $t2		# sum of the values
    		    sh $t1, 0($s6)
    		    li $t3, -1
		    sh $t3, 0($t0)		# store -1 into the 2nd cell
    		    
    		    merge_down_next_iter:
    		    	move $s6, $t0		# keep the address of the 2nd cell for the next iteration
    			addi $s5, $s5, 1	# next row
    			j merge_down_loop
    	
    merge_col_up:
    	# Get the first cell
    	move $a0, $s0		# $a0 = starting address of board
    	move $a1, $s1		# $a1 = num_rows
    	move $a2, $s2		# $a2 = num_cols
    	move $a3, $0, 		# $a3 = 0 (first row)
    	addi $sp, $sp, -4	# Allocate stack space
    	sb $s3, 0($sp)		# $a4 (1st argument on stack) = col we want
    	jal get_cell
    	addi $sp, $sp, 4	# Restore stack space
    	move $s7, $v0		# $s7 = the FIRST cell of the specified column
    	
    	# Here we are getting the address of the last cell
    	addi $s5, $s1, -1	# $s5 = num_row - 1
    	move $a0, $s0		# $a0 = starting address of the board
    	move $a1, $s1		# $a1 = num_rows
    	move $a2, $s2		# $a2 = num_cols
    	move $a3, $s5		# $a3 = (num_row - 1)
    	addi $sp, $sp, -4	# Allocate stack space
    	sb $s5, 0($sp)		# $a4 (1st argument on the stack) = the col we want
    	jal get_cell
    	addi $sp, $sp, 4	# restore stack space
    	move $s6, $v0		# $s6 = LAST cell in the col
    	addi $s5, $s5, -1	# $s5 = index of the 2nd cell
    		merge_up_loop:
    		    beq $s7, $s6, merge_col_success
    		    move $a0, $s0		# $a0 = starting address of board
    		    move $a1, $s1		# $a1 = num_rows
    		    move $a2, $s2		# $a2 = num_cols
    		    move $a3, $s5		# $a3 = row index of 2nd cell
    		    addi $sp, $sp, -4 		# Allocate stack space
    		    sb $s3, 0($sp)		# $a4 (1st argument on the stack) = specified col to merge
    		    jal get_cell
    		    addi $sp, $sp, 4		# restore stack space
    		    move $t0, $v0		# $t0 = address of the 2nd cell
    		    
    		    # compare, if equal, merge
    		    lh $t1, 0($s6)				# $t1 = cell value #1
    		    lh $t2, 0($t0)				# $t2 = cell value #2
    		    beq $t1, -1, merge_up_next_iter		# if either value is -1, next iteration
    		    beq $t2, -1, merge_up_next_iter		# if either value is -1, next iteration
    		    bne $t1, $t2, merge_up_next_iter		# if the values are not equal, next iteration
    		    
    		    # Here the values are equal, so we will merge!
    		    add $t1, $t1, $t2				# sum of the values
    		    sh $t1, 0($s6)				# store Sum(cell_1, cell_2) --> cell #1
    		    li $t3, -1					# $t3 = -1
		    sh $t3, 0($t0)				# store -1 into cell #2
    		    
    		    merge_up_next_iter:
    			addi $s5, $s5, -1	# $s5 = num_row-- (to get the next cell)
    			move $s7, $t0		# $s7: 1st cell = previous 2nd cell
    			j merge_up_loop		# LOOP-DEE-LOOP
    	
    merge_col_error:
    	li $v0, -1	     	     # Error: return -1
    	j merge_col_return
    	
    merge_col_success:
    	move $a0, $s0	             # $a0 = base address
    	move $a1, $s3		     # $a1 = row we are iterating over
    	move $a2, $s2		     # $a2 = num cols
    	jal get_num_filled_col_cells # $v0 = num non-empty cells
    	j merge_col_return
    	
    merge_col_return:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	lw $s6, 28($sp)
    	lw $s7, 32($sp)
    	addi $sp, $sp, 36
    	jr $ra

###### shift_row ######
# $a0 = cell[][] board: starting address of the board
# $a1 = int num_rows: Number of rows in the board
# $a2 = int num_cols: Number of cols in the board
# $a3 = int row: The row index we are shifting
# 0($sp) = int direction: the direction of the shift (0 indicates left shift, 1 indicates right shift
# returns: Number of cells shifted, -1 on error
# Errors: row < 0 or row >= num_cols | num_rows/num_cols < 2 | direction is something other than 1 or 0
shift_row:
    lb $t0, 0($sp)		# $t0 = int direction
    
    # Saving $s0 - $s7, $ra
    addi $sp, $sp, -28		# Allocate stack space
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    
    # Init saved registers
    move $s0, $a0	# $s0 = board
    move $s1, $a1	# $s1 = num_rows
    move $s2, $a2	# $s2 = num_cols
    move $s3, $a3	# $s3 = row
    move $s4, $t0	# $s4 = direction
    li $s5, 0		# $s5 = count of how many cells we shifted
    li $s6, 0		# $s6 = ???
    li $s7, 0		# $s7 = ???
    
    # Error Checking
    blt $s1, 2, shift_row_error		# ERROR: num_rows < 2
    blt $s2, 2, shift_row_error		# ERROR: num_cols < 2
    bltz $s3, shift_row_error		# ERROR: row < 0
    bge $s3, $s1, shift_row_error	# ERROR: row >= num_rows
    bltz $s4, shift_row_error		# ERROR: direction < 0
    bgt $s4, 1, shift_row_error		# ERROR: direction > 1
    beqz $s4, shift_row_left		# AFTER THIS CHECK, $s4 IS FREE TO USE!      <-------- LOOK!
    
    shift_row_right:
    	addi $s4, $a2, -2	# $s4 = i, (num_cols - 2)
    	# Starting cell = board[row][i], where i = (num_cols - 2)
    	move $a0, $s0		# $a0 = starting address of board
    	move $a1, $s1		# $a1 = num_rows
    	move $a2, $s2		# $a2 = num_cols
    	move $a3, $s3, 		# $a3 = row we want to shift
    	addi $sp, $sp, -4	# Allocate stack space
    	sb $s4, 0($sp)		# $a4 (1st argument on stack) = (num_cols - 2), the first cell we check
    	jal get_cell
    	addi $sp, $sp, 4	# Restore stack space
    	move $t0, $v0		# $t0 = first cell address
    	addi $s4, $s4, -1	# i-- for the next iteration
    	shift_row_right_loop:
    		beq $s4, -1, shift_row_success		# if i = -1, then stop
    		lh $t1, 0($t0)				# $t1 = current cell value
    		bne $t1, -1, shift_row_right_check_prev	# if the value here is NOT -1, check the prev cell
    		# The value is -1, so get the next cell and go to the next iteration
    		move $a0, $s0		# $a0 = starting address of board
    		move $a1, $s1		# $a1 = num_rows
    		move $a2, $s2		# $a2 = num_cols
    		move $a3, $s3, 		# $a3 = row we want to shift
    		addi $sp, $sp, -4	# Allocate stack space
    		sb $s4, 0($sp)		# $a4 (1st argument on stack) = i, the next cell in the row
    		jal get_cell
    		addi $sp, $sp, 4	# Restore stack space
    		move $t0, $v0		# $t0 = next cell address
    		addi $s4, $s4, -1	# i--
    		j shift_row_right_loop
    		
    		shift_row_right_check_prev:
    			addi $t2, $s4, 1		# $t2 = index of the prev cell
    			# while loop to check the previous cells
    			shift_row_right_check_prev_loop:
    				bge $t2, $s2 shift_row_right_loop	# if the index of the prev cell is -1, next iteration of shift_row_right
    				# Get the previous cell
    				move $a0, $s0		# $a0 = starting address of board
    				move $a1, $s1		# $a1 = num_rows
    				move $a2, $s2		# $a2 = num_cols
    				move $a3, $s3, 		# $a3 = row we want to get the value of
    				addi $sp, $sp, -16	# Allocate stack space
    				sw $t2, 0($sp)		# $a4 (1st argument on stack) = i, the prev cell in the row
    				sw $t0, 4($sp)		
    				sw $t1, 8($sp)
    				sw $t2, 12($sp)
    				jal get_cell
    				lw $t0, 4($sp)
    				lw $t1, 8($sp)
    				lw $t2, 12($sp)
    				addi $sp, $sp, 16	# Restore stack space
    				move $t3, $v0		# $t3 = previous cell address
    				lh $t4, 0($t3)		# $t4 = previous cell value
    				beq $t4, -1, shift_row_check_prev_right_loop_neg_one	# if it's neg 1, we shift
    				j shift_row_right_loop					# since prev != -1, we just go to the next iter
    				
    				shift_row_check_prev_right_loop_neg_one:
    					sh $t1, 0($t3)		# Prev cell val = current
    					sh $t4, 0($t0)		# Current cell val = -1
    					addi $t2, $t2, 1	# tempI++
    					addi $s5, $s5, 1	# num cells shifted++
    					j shift_row_right_check_prev_loop
    shift_row_left:
    	li $s4, 0		# $s4 = i, (the index of the current cell we are trying to shift)
    	
    	# Starting cell = board[row][i], where i = 0
    	move $a0, $s0		# $a0 = starting address of board
    	move $a1, $s1		# $a1 = num_rows
    	move $a2, $s2		# $a2 = num_cols
    	move $a3, $s3, 		# $a3 = row we want to shift
    	addi $sp, $sp, -4	# Allocate stack space
    	sb $s4, 0($sp)		# $a4 (1st argument on stack) = 0, the first cell in the row
    	jal get_cell
    	addi $sp, $sp, 4	# Restore stack space
    	move $t0, $v0		# $t0 = first cell address
    	addi $s4, $s4, 1	# i++ for the next iteration
    	shift_row_left_loop:
    		beq $s2, $s4, shift_row_success		# if i = the ending index, then stop
    		lh $t1, 0($t0)				# load the value at the current cell
    		bne $t1, -1, shift_row_left_check_prev	# if the value here is NOT -1, check the prev cell
    		
    		# The value is -1, so get the next cell and go to the next iteration
    		move $a0, $s0		# $a0 = starting address of board
    		move $a1, $s1		# $a1 = num_rows
    		move $a2, $s2		# $a2 = num_cols
    		move $a3, $s3, 		# $a3 = row we want to shift
    		addi $sp, $sp, -4	# Allocate stack space
    		sb $s4, 0($sp)		# $a4 (1st argument on stack) = i, the next cell in the row
    		jal get_cell
    		addi $sp, $sp, 4	# Restore stack space
    		move $t0, $v0		# $t0 = next cell address
    		addi $s4, $s4, 1	# i++
    		j shift_row_left_loop
    		
    		shift_row_left_check_prev:
    			addi $t2, $s4, -1			# $t2 = index of the prev cell
    			
    			# while loop to check the previous cells
    			shift_row_left_check_prev_loop:
    				bltz $t2, shift_row_left_loop	# if the index of the prev cell is -1, next iteration of shift_row_left
    				
    				# Get the previous cell
    				move $a0, $s0		# $a0 = starting address of board
    				move $a1, $s1		# $a1 = num_rows
    				move $a2, $s2		# $a2 = num_cols
    				move $a3, $s3, 		# $a3 = row we want to get the value of
    				addi $sp, $sp, -16	# Allocate stack space
    				sw $t2, 0($sp)		# $a4 (1st argument on stack) = i, the prev cell in the row
    				sw $t0, 4($sp)
    				sw $t1, 8($sp)
    				sw $t2, 12($sp)
    				jal get_cell
    				lw $t0, 4($sp)
    				lw $t1, 8($sp)
    				lw $t2, 12($sp)
    				addi $sp, $sp, 16	# Restore stack space
    				move $t3, $v0		# $t3 = previous cell address
    				lh $t4, 0($t3)		# $t4 = previous cell value
    				beq $t4, -1, shift_row_check_prev_left_loop_neg_one	# if it's neg 1, we shift
    				j shift_row_left_loop					# since prev != -1, we just go to the next iter
    				
    				shift_row_check_prev_left_loop_neg_one:
    					sh $t1, 0($t3)		# Prev cell val = current
    					sh $t4, 0($t0)		# Current cell val = -1
    					addi $t2, $t2, -1	# tempI--
    					addi $s5, $s5, 1	# num cells shifted++
    					j shift_row_left_check_prev_loop
    shift_row_success:
    	move $v0, $s5		# $v0 = number of cells we shifted
    	j shift_row_return
    	
    shift_row_error:
    	li $v0, -1		# Error: Something went wrong!
    	j shift_row_return 
    
    shift_row_return:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	addi $sp, $sp, 28	# Restore stack space
    	jr $ra

###### shift_col ######
# $a0 = cell[][] board: starting address of the board
# $a1 = int num_rows: Number of rows in the board
# $a2 = int num_cols: Number of cols in the board
# $a3 = int col: The col index we are shifting
# 0($sp) = int direction: the direction of the shift (0 indicates up shift, 1 indicates down shift
# returns: Number of cells shifted, -1 on error
# Errors: row < 0 or row >= num_cols | num_rows/num_cols < 2 | direction is something other than 1 or 0
shift_col:
    lb $t0, 0($sp)
    
    # Saving $s0 - $s7, $ra
    addi $sp, $sp, -28	# Allocate stack space
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    
    # Moving arguements into saved registers
    move $s0, $a0	# $s0 = board
    move $s1, $a1	# $s1 = num_rows
    move $s2, $a2	# $s2 = num_cols
    move $s3, $a3	# $s3 = col
    move $s4, $t0	# $s4 = direction
    li $s5, 0		# $s5 = counter for how much we shifted
    
    # Error Checking
    blt $s1, 2, shift_col_error		# ERROR: num_rows < 2
    blt $s2, 2, shift_col_error		# ERROR: num_cols < 2
    bltz $s3, shift_col_error		# ERROR: col < 0
    bge $s3, $s2, shift_col_error	# ERROR: col >= num_cols
    bltz $s4, shift_col_error		# ERROR: direction < 0
    bgt $s4, 1, shift_col_error		# ERROR: direction > 1
    beqz $s4, shift_col_up		# AFTER THIS CHECK, $s4 IS FREE TO USE!      <-------- LOOK!
    
    shift_col_down:
    	addi $s4, $s1, -2	# $s4 = i, (num_rows - 2)
    	# Starting cell = board[row][i], where i = (num_rows - 2)
    	move $a0, $s0		# $a0 = starting address of board
    	move $a1, $s1		# $a1 = num_rows
    	move $a2, $s2		# $a2 = num_cols
    	move $a3, $s4, 		# $a3 = row we are starting on
    	addi $sp, $sp, -4	# Allocate stack space
    	sh $s3, 0($sp)		# $a4 (1st argument on stack) = col we want to shift
    	jal get_cell
    	addi $sp, $sp, 4	# Restore stack space
    	move $t0, $v0		# $t0 = first cell address
    	addi $s4, $s4, -1	# i-- for the next iteration
    	
    	shift_col_down_loop:
    		beq $s4, -1, shift_col_success		# if i = -1, then stop
    		lh $t1, 0($t0)				# $t1 = current cell value
    		bne $t1, -1, shift_col_down_check_prev	# if the value here is NOT -1, check the prev cell
    		# The value is -1, so get the next cell and go to the next iteration
    		move $a0, $s0		# $a0 = starting address of board
    		move $a1, $s1		# $a1 = num_rows
    		move $a2, $s2		# $a2 = num_cols
    		move $a3, $s4, 		# $a3 = row are currently on
    		addi $sp, $sp, -4	# Allocate stack space
    		sh $s3, 0($sp)		# $a4 (1st argument on stack) = col we want to shift
    		jal get_cell		
    		addi $sp, $sp, 4	# Restore stack space
    		move $t0, $v0		# $t0 = next cell address
    		addi $s4, $s4, -1	# i--
    		j shift_col_down_loop
    		
    		shift_col_down_check_prev:
    			addi $t2, $s4, 1		# $t2 = index of the prev cell
    			# while loop to check the previous cells
    			shift_col_down_check_prev_loop:
    				bge $t2, $s1 shift_col_down_loop	# if the index of the prev cell is num_rows, next iteration of shift_row_right
    				# Get the previous cell
    				move $a0, $s0		# $a0 = starting address of board
    				move $a1, $s1		# $a1 = num_rows
    				move $a2, $s2		# $a2 = num_cols
    				move $a3, $t2, 		# $a3 = row we want to get the value of
    				addi $sp, $sp, -16	# Allocate stack space
    				sw $s4, 0($sp)		# $a4 (1st argument on stack) = i, the prev cell in the col
    				sw $t0, 4($sp)		
    				sw $t1, 8($sp)
    				sw $t2, 12($sp)
    				jal get_cell
    				lw $t0, 4($sp)
    				lw $t1, 8($sp)
    				lw $t2, 12($sp)
    				addi $sp, $sp, 16	# Restore stack space
    				move $t3, $v0		# $t3 = previous cell address
    				lh $t4, 0($t3)		# $t4 = previous cell value
    				beq $t4, -1, shift_col_check_prev_down_loop_neg_one	# if it's neg 1, we shift
    				j shift_col_down_loop					# since prev != -1, we just go to the next iter
    				
    				shift_col_check_prev_down_loop_neg_one:
    					sh $t1, 0($t3)		# Prev cell val = current
    					sh $t4, 0($t0)		# Current cell val = -1
    					addi $t2, $t2, 1	# tempI++
    					addi $s5, $s5, 1	# num cells shifted++
    					j shift_col_down_check_prev_loop
    shift_col_up:
    	li $s4, 0		# $s4 = i, (the index of the current cell we are trying to shift)
    	
    	# Starting cell = board[row][i], where i = 0
    	move $a0, $s0		# $a0 = starting address of board
    	move $a1, $s1		# $a1 = num_rows
    	move $a2, $s2		# $a2 = num_cols
    	move $a3, $s4, 		# $a3 = row we are currently on
    	addi $sp, $sp, -4	# Allocate stack space
    	sb $s3, 0($sp)		# $a4 (1st argument on stack) = 
    	jal get_cell
    	addi $sp, $sp, 4	# Restore stack space
    	move $t0, $v0		# $t0 = first cell address
    	addi $s4, $s4, 1	# i++ for the next iteration
    	shift_col_up_loop:
    		beq $s2, $s4, shift_col_success		# if i = the ending index, then stop
    		lh $t1, 0($t0)				# load the value at the current cell
    		bne $t1, -1, shift_col_up_check_prev	# if the value here is NOT -1, check the prev cell
    		
    		# The value is -1, so get the next cell and go to the next iteration
    		move $a0, $s0		# $a0 = starting address of board
    		move $a1, $s1		# $a1 = num_rows
    		move $a2, $s2		# $a2 = num_cols
    		move $a3, $s3, 		# $a3 = row we want to shift
    		addi $sp, $sp, -4	# Allocate stack space
    		sb $s4, 0($sp)		# $a4 (1st argument on stack) = i, the next cell in the row
    		jal get_cell
    		addi $sp, $sp, 4	# Restore stack space
    		move $t0, $v0		# $t0 = next cell address
    		addi $s4, $s4, 1	# i++
    		j shift_col_up_loop
    		
    		shift_col_up_check_prev:
    			addi $t2, $s4, -1		# $t2 = index of the prev cell
    			
    			# while loop to check the previous cells
    			shift_col_up_check_prev_loop:
    				bltz $t2, shift_col_up_loop	# if the index of the prev cell is -1, next iteration of shift_row_left
    				
    				# Get the previous cell
    				move $a0, $s0		# $a0 = starting address of board
    				move $a1, $s1		# $a1 = num_rows
    				move $a2, $s2		# $a2 = num_cols
    				move $a3, $t2, 		# $a3 = row we want to get the value of
    				addi $sp, $sp, -16	# Allocate stack space
    				sw $s3, 0($sp)		# $a4 (1st argument on stack) = i, the prev cell in the row
    				sw $t0, 4($sp)
    				sw $t1, 8($sp)
    				sw $t2, 12($sp)
    				jal get_cell
    				lw $t0, 4($sp)
    				lw $t1, 8($sp)
    				lw $t2, 12($sp)
    				addi $sp, $sp, 16	# Restore stack space
    				move $t3, $v0		# $t3 = previous cell address
    				lh $t4, 0($t3)		# $t4 = previous cell value
    				beq $t4, -1, shift_col_check_prev_up_loop_neg_one	# if it's neg 1, we shift
    				j shift_col_up_loop					# since prev != -1, we just go to the next iter
    				
    				shift_col_check_prev_up_loop_neg_one:
    					sh $t1, 0($t3)		# Prev cell val = current
    					sh $t4, 0($t0)		# Current cell val = -1
    					addi $t2, $t2, -1	# tempI--
    					addi $s5, $s5, 1	# num cells shifted++
    					j shift_col_up_check_prev_loop
    
    
    
    shift_col_success:
    	move $v0, $s5			# Success! $v0 = the number of cells that need to be shifted
    	j shift_col_return
    	
    shift_col_error:
    	li $v0, -1			# Error: Something went wrong!
    	j shift_row_return 
    
    shift_col_return:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	addi $sp, $sp, 28		# Restore stack space
    	jr $ra
    	
###### check_state ######
# $a0 = cell[][] board: starting address of the board
# $a1 = int num_rows: Number of rows in the board
# $a2 = int num_cols: Number of cols in the board
# returns: 1 if the game has been won, -1 if the game has been lost,0 otherwise
check_state:
    addi $sp, $sp, -32	# Allocate stack space
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    
    move $s0, $a0	# $s0 = board
    move $s1, $a1	# $s1 = num_rows
    move $s2, $a2	# $s2 = num_cols
    li $s3, 0		# $s3 = i
    li $s4, 0		# $s4 = j
    li $s5, 0		# $s5 = cell address #1
    li $s6, 0		# $s6 = cell address #2 (right)
    li $s7, 0		# $s7 = cell address #3 (down)
    
    check_state_row_loop:
    	beq $s1, $s3, check_state_lost		# if we havent returned by the time we are done traversing, we lost the game
    	check_state_col_loop:
    		beq $s2, $s4, check_state_col_loop_next
    		
    		# Get the cell
    		move $a0, $s0		# $a0 = board
    		move $a1, $s1		# $a1 = num_rows
    		move $a2, $s2		# $a2 = num_cols
    		move $a3, $s3		# $a3 = row
    		addi $sp, $sp, -4	# Allocate Stack Space
    		sh $s4, 0($sp)		# 0($sp) = col
    		jal get_cell		
    		move $s5, $v0		# $s5 = address of 1st cell
    		addi $sp, $sp, 4
    	
    		# Get the cell to the right
    		move $a0, $s0		# $a0 = board
    		move $a1, $s1		# $a1 = num_rows
    		move $a2, $s2		# $a2 = num_cols
    		move $a3, $s3		# $a3 = row
    		addi $t0, $s4, 1	# j + 1
    		addi $sp, $sp, -4	# Allocate Stack Space
    		sh $t0, 0($sp)		# 0($sp) = col
    		jal get_cell		
    		move $s6, $v0		# $s5 = address of the cell to the right
    		addi $sp, $sp, 4
    		
    		# Get the cell under the one we are on
    		move $a0, $s0		# $a0 = board
    		move $a1, $s1		# $a1 = num_rows
    		move $a2, $s2		# $a2 = num_cols
    		addi $a3, $s3, 1	# $a3 = i + 1
    		addi $sp, $sp, -4	# Allocate Stack Space
    		sh $t0, 0($sp)		# 0($sp) = col
    		jal get_cell		
    		move $s6, $v0		# $s6 = address of the cell to the right
    		addi $sp, $sp, 4	
    		
    		lh $t0, 0($s5)		# the value of the first cell
    		beq $t0, 2048, check_state_won		# if we find 2048, return 1
    		beq $t0, -1, check_state_continue	# if we find a -1, return 0
    		
    		# now if the values are in bounds, we can compare them
    		addi $t1, $s3, 1	# i + 1
    		addi $t2, $s4, 1	# j + 1
    		
    		beq $t1, $s1, check_state_right
    		beq $t2, $s2, check_state_down
    		
    		check_state_both:
    			lh $t3, 0($s6)				# load the value of the cell to the right into $t4 
    			lh $t4, 0($s7)				# load the value of the cell to the right into $t4
    			beq $t3, 2048, check_state_won
    			beq $t4, 2048, check_state_won
    			beq $t3, -1, check_state_continue
    			beq $t4, -1, check_state_continue
    			beq $t0, $t3, check_state_continue
    			beq $t0, $t4, check_state_continue
    			j check_state_next_col
    			
    		check_state_right:
    			beq $t2, $s2, check_state_lost		
    			lh $t3, 0($s6)				# load the value of the cell to the right into $t4
    			beq $t3, 2048, check_state_won
    			beq $t3, -1, check_state_continue
    			beq $t0, $t3, check_state_continue	# the cells match so keep playing
    			j check_state_next_col			# go to the next column iteration
				    						
    		check_state_down:
    			beq $t1, $s1, check_state_lost		
    			lh $t3, 0($s7)				# load the value of the cell to the right into $t4
    			beq $t3, 2048, check_state_won
    			beq $t3, -1, check_state_continue
    			beq $t0, $t3, check_state_continue	# the cells match so keep playing
    			j check_state_next_col			# go to the next column iteration
    		
    		check_state_next_col:
    			addi $s4, $s4, 1	# j++
    			j check_state_col_loop
    			
    		check_state_col_loop_next:
    			addi $s3, $s3, 1	# i++
    			li $s4, 0		# j = 0;
    			j check_state_row_loop	
    			
    check_state_won:
    	li $v0, 1	# Game has been won
    	j return_check_state
    	
    check_state_lost:
    	li $v0, -1	# Game has been lost
    	j return_check_state
    	
    check_state_continue:
    	li $v0, 0	# Game still going on
    	j return_check_state
    	
    return_check_state:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	addi $sp, $sp, 28	# Allocate stack space
    	jr $ra

###### user_move ######
# $a0 = cell[][] board: starting address of the board
# $a1 = int num_rows: Number of rows in the board
# $a2 = int num_cols: Number of cols in the board
# $a3 = char dir: 'L', 'R', 'U', 'D' to indicate what direction we want the user to move
# returns: (0, x) where x is the return value of check_state or (-1, -1) if any of the functions had an error or dir is invalid
user_move:
    addi $sp, $sp, -36	# Allocate stack space
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    
    # Init $s0- $s7
    move $s0, $a0	# $s0 = board	
    move $s1, $a1	# $s1 = num_rows
    move $s2, $a2	# $s2 = num_cols
    move $s3, $a3	# $s3 = char direction (L, R, U, D)
    li $s4, 0		# $s4 = ???
    li $s5, 0		# $s5 = ???
    li $s6, 0		# $s6 = ???
    li $s7, 0		# $s7 = ???
    
    beq $s3, 'L', user_move_left
    beq $s3, 'R', user_move_right
    beq $s3, 'D', user_move_down
    beq $s3, 'U', user_move_up
    j user_move_error            # if we get here, that means the user didnt press a valid key
    
    
    user_move_left:
    	li $s4, 0			 # $s4 = direction for left
    	li $s5, 0			 # $s5 = i
    		user_move_left_loop:
    			beq $s1, $s5, user_move_success  # for each row..
    			# shift_row_left
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $0, 0($sp)
    			jal shift_row
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# merge_row_left
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $0, 0($sp)
    			jal merge_row
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# shift_row_left
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $0, 0($sp)
    			jal shift_row
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    			addi $s5, $s5, 1			# next row!
    			j user_move_left_loop			# loop-dee-loop!
    user_move_right:
    	li $s4, 1		# $s4 = direction for right
    	li $s5, 0			 # $s5 = i
    		user_move_right_loop:
    			beq $s1, $s5, user_move_success  # for each row..
    			# shift_row_right
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $s4, 0($sp)
    			jal shift_row
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# merge_row_right
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $s4, 0($sp)
    			jal merge_row
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# shift_row_left
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $s4, 0($sp)
    			jal shift_row
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    			addi $s5, $s5, 1			# next row!
    			j user_move_right_loop			# loop-dee-loop!
    
    user_move_down:
    	li $s4, 0		# $s4 = direction for down
    	li $s5, 0		# $s5 = i
    		user_move_down_loop:
    			beq $s1, $s5, user_move_success  # for each row..
    			# shift_col_down
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $0, 0($sp)
    			jal shift_col
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# merge_col_down
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $0, 0($sp)
    			jal merge_col
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# shift_col_left
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $0, 0($sp)
    			jal shift_col
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    			addi $s5, $s5, 1			# next col!
    			j user_move_down_loop			# loop-dee-loop!
    
    user_move_up:
    	li $s4, 1		# $s4 = direction for up
    	li $s5, 0		# $s5 = i
    		user_move_up_loop:
    			beq $s1, $s5, user_move_success  # for each col..
    			# shift_col_up
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $s4, 0($sp)
    			jal shift_col
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# merge_col_up
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $s4, 0($sp)
    			jal merge_col
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    		
    			# shift_col_up
    			move $a0, $s0
    			move $a1, $s1
    			move $a2, $s2
    			move $a3, $s3
    			addi $sp, $sp, -4
    			sw $s4, 0($sp)
    			jal shift_col
    			beq $v0, -1, user_move_error		# ERROR: Something went wrong in one of the functions!
    			addi $sp, $sp, 4
    			addi $s5, $s5, 1			# next col!
    			j user_move_down_loop			# loop-dee-loop!
    
    user_move_error:
    	li $v0, -1		# Error!
    	li $v1, -1		# Error!
    	j user_move_return	# Return
    
    user_move_success:
    	# check the game state here!
    	move $a0, $s0
    	move $a1, $s1
    	move $a2, $s2
    	jal check_state
    	move $v1, $v0		# $v1 = return value of check_state
    	li $v0, 0		# $v0 = 0
    	j user_move_return	# return!
		
    user_move_return:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	lw $s6, 28($sp)
    	lw $s7, 32($sp)
    	addi $sp, $sp, -36	# Allocate stack space
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
    mul $t1, $t1, $t0	# $t1 = row_size = 2 * (num_cols)
    mul $t1, $t1, $a3	# $t1 = row_size * row
    lbu $t2, 0($sp)	# $t2 = col
    mul $t0, $t0, $t2	# $t0 = 2 * col
    add $t0, $t0, $t1	# $t0 = (row_size * row) + (2 * col)
    add $v0, $t0, $a0	# base_address + (row_size * row) + (2 * col)
    jr $ra		# return the cell

##### get_num_empty_row_cells #####
# $a0 = starting address of board
# $a1 = row
# $a2 = num_cols
# returns the number of non-empty cells in a specified row
get_num_filled_row_cells:
    move $t0, $a0	# $t0 = board starting address
    move $t1, $a1	# $t1 = row to start at
    move $t2, $a2	# $t2 = num_cols
    li $t3, 0		# $t3 = num non-empty cols
    li $t4, 0		# $t4 = i

    get_num_non_empty_cells_loop:
    	beq $t4, $t2, return_num_non_empty_cells
    	li $t5, 2		# $t5 = 2
    	move $t6, $s2		# $t6 = num_cols
    	mul $t6, $t6, $t5	# $t6 = row_size = 2 * (num_cols)
    	mul $t6, $t6, $t1	# $t6 = row_size * row
    	mul $t5, $t5, $t4	# $t5 = 2 * col
    	add $t5, $t5, $t6	# $t5 = (row_size * row) + (2 * col)
    	add $t7, $t5, $t0	# $t7 = base_address + (row_size * row) + (2 * col)
    	lh $t8, 0($t7)		# $t8 = value of the cell
    	addi $t4, $t4, 1	# $t4 = $t4++
    	beq $t8, -1, get_num_non_empty_cells_loop	# if the value from the cell === -1, loop w/o incrementing count
    	addi $t3, $t3, 1	# $t3 = count++
    	j get_num_non_empty_cells_loop	# Loop-Dee-Loop
    	
    return_num_non_empty_cells:
    	move $v0, $t3	# $v0 = the number of non-empty cells
    	jr $ra
    
##### get_num_filled_col_cells #####
# $a0 = starting address of board
# $a1 = num_rows
# $a2 = num_cols
# $a3 = col
# returns the number of non-empty cells in a specified col
get_num_filled_col_cells:
    move $t0, $a0	# $t0 = board starting address
    move $t1, $a1	# $t1 = num_rows
    move $t2, $a2	# $t2 = column we start at
    li $t3, 0		# $t3 = num non-empty cols
    li $t4, 0		# $t4 = i
    
    get_num_non_empty_cols_loop:
    	beq $t4, $t2, return_num_non_empty_cols
    	li $t5, 2		# $t5 = 2
    	move $t6, $s2		# $t6 = num_cols
    	mul $t6, $t6, $t5	# $t6 = row_size = 2 * (num_cols)
    	mul $t6, $t6, $t1	# $t6 = row_size * row
    	mul $t5, $t5, $t4	# $t5 = 2 * col
    	add $t5, $t5, $t6	# $t5 = (row_size * row) + (2 * col)
    	add $t7, $t5, $t0	# $t7 = base_address + (row_size * row) + (2 * col)
    	lh $t8, 0($t7)		# $t8 = value of the cell
    	addi $t4, $t4, 1	# $t4 = $t4++
    	beq $t8, -1, get_num_non_empty_cols_loop	# if the value from the cell === -1, loop w/o incrementing count
    	addi $t3, $t3, 1	# $t3 = count++
    	j get_num_non_empty_cols_loop	# Loop-Dee-Loop
    	
    return_num_non_empty_cols:
    	move $v0, $t3	# $v0 = the number of non-empty cells
    	jr $ra

########################
# HELPER FUNCTIONS END #
########################
