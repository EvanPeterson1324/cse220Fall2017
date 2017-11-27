# Demonstrates traversing a 2D array of words, storing a value at each
# cell of the array.

.data
matrix: .space 60 # 5 x 3 matrix of 4-byte words
rows: .word 5
columns: .word 3

.text

la $t0, matrix 
lw $t1, rows    # number of rows
lw $t2, columns # number of columns

li $t3, 0  # i, row counter
li $t9, 65  # value to store in array

row_loop:
	li $t4, 0  # j, column counter
col_loop:
	# Although this array traversal could be implemented by simply
	# adding 4 to a starting address (e.g., matrix's address), the
	# point here is to show the arithmetic of computing the address
	# of an element in a 2D array.
	
	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 2   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	sh $t9, 0($t5)

	addi $t4, $t4, 1  # j++
	addi $t9, $t9, 1  # generate next value to save
	blt $t4, $t2, col_loop
col_loop_done:

addi $t3, $t3, 1  # i++
blt $t3, $t1, row_loop

row_loop_done:
