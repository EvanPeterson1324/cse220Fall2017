
##############################################################
# Homework #2
# name: Evan Peterson
# sbuid: 108509452
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

# $a0 = starting address of the character array
# $a1 = ascii character to find in the string
# $a2 = ascii character to replace the one we found
replace1st:
	# if $a1 or $a2 are outside the range of [0x00, 0x7F]
	blez $a1, replace1stReturnNeg1
	blez $a2, replace1stReturnNeg1
	li $t0, 0x7F				# load the upper bound into $t0
	bgt $a1, $t0, replace1stReturnNeg1
	bgt $a2, $t0, replace1stReturnNeg1
	
	move $t0, $a0		# move the starting address of the char[] into $t0
	
	replace1stLoopCharArr:				# for every character in the array...
	lb $t1, 0($t0)					# load the next character into $t1
	beqz $t1, replace1stReturnZero			# if we reached the end of the char[], return 0, char not found
	beq $a1, $t1, replace1stReplaceAndReturn	# if the character matches the one we are looking for
	addi $t0, $t0, 4				# go to the next character
	j replace1stLoopCharArr				# loop again

	# here we found the character so we will replace it with $a2 and return the address of the NEXT character
	replace1stReplaceAndReturn:
	sb $a2, 0($t0)			# replace the character we found
	addi $t0, $t0, 4		# add 4 b/c we will return the next character
	move $v0, $t0			# move address of next character so we can return
	j replace1stJr
	
	# We didnt find the char so return 0
	replace1stReturnZero:
	li $v0, 0	
	j replace1stJr
	
	# The arguments were of invalid range so return -1
	replace1stReturnNeg1:
	li $v0, -1		# something went wrong
	j replace1stJr		# return from the function
	
	replace1stJr:
	jr $ra
# PRINT STRING ARRAY FUNCTION
# $a0 = atarting address of the string array
# $a1 = starting index to print from (inclusive)
# $a2 = ending index to print from (inclusive)
# $a3 = number of elements in the array
printStringArray:
    	
    	# ERROR CHECKING
    	bltz $a1, printStringArrayReturnNeg1		# if starting index < 0, return -1
    	bge  $a1, $a3 printStringArrayReturnNeg1	# if the starting index is greater than or equal to the length, return -1
	bltz $a2, printStringArrayReturnNeg1		# if ending index < 0, return -1
	bge  $a2, $a3 printStringArrayReturnNeg1	# if the ending index is greater than or equal to the length, return -1
    	blez $a3, printStringArrayReturnNeg1		# if length < 1, return -1
	blt $a2, $a1, printStringArrayReturnNeg1	# if the ending index is < the starting index, return -1
	
	
	# init counters
	# $t1 = starting address of our loop
	# $t2 = ending address of our loop
	# $t3 = the number of strings we printed
	
	li $t0, 4
	mul $t1, $a1, $t0	# multiply the starting index by 4 (this will be our offset to start our loop)
	add $t1, $a0, $t1	# now we have the starting address of the first character to print
	
	mul $t2, $a2, $t0	# multiply the starting index by 4 (this will be our offset to start our loop)
	add $t2, $a0, $t2	# this gets us the ending address of the string array.  Return AFTER printing this
	
	li $t3, 0		# printed strings = 0
	# first lets just print out the entire string array
	printStringArrayLoop1:
	lb $t0, 0($t1)					 # load the next character
	beq $t1, $t2, printStringArrayEndIndex		 # we reached the ending index
	bnez $t0, printStringArrayDontIncrementCount	 # if not the null terminator, just print the character and dont incremement count
	beq $t0, $t1, printStringArrayDontIncrementCount # if the starting index is the null terminator, we didnt print anything so dont increment
	addi $t3, $t3, 1				 # add 1 to the number of strings printed
	
	li $v0, 11	# tell system we will print a character
	move $a0, $t0	# the character we want to print
	syscall
	
	# double newline after each string
	li $v0, 11		# tell system we will print a character
	li $a0, '\n'		# newline
	syscall
	li $v0, 11		# tell system we will print a character
	li $a0, '\n'		# newline
	syscall
	addi $t1, $t1, 4	# address of next character
	j printStringArrayLoop1
	
	printStringArrayDontIncrementCount:
	li $v0, 11		# tell system we will print a character
	move $a0, $t0		# the character we want to print
	syscall
	addi $t1, $t1, 4	# address of next character
	j printStringArrayLoop1
	
	printStringArrayEndIndex:
	beqz $t1, printStringArrayLastIndexWithNullTerm
	addi $t3, $t3, 1	# add 1 to the number of strings printed
	li $v0, 11	# tell system we will print a character
	move $a0, $t0	# the character we want to print
	syscall
	
	li $v0, 11		# tell system we will print a character
	li $a0, '\n'		# newline
	syscall
	li $v0, 11		# tell system we will print a character
	li $a0, '\n'		# newline
	syscall
	move $v0, $t3		# load the number of strings we printed into the return address
	j printStringArrayJr
	
	printStringArrayReturnNeg1:
	li $v0, -1	# return neg 1
	j printStringArrayJr
	
	printStringArrayLastIndexWithNullTerm:
	addi $t3, $t3, 1	# add 1 to the number of strings printed
	move $v0, $t3		# move the number of strings printed into the return register
	li $v0, 11		# tell system we will print a character
	li $a0, '\n'		# newline
	syscall
	li $v0, 11		# tell system we will print a character
	li $a0, '\n'		# newline
	syscall
	
	move $v0, $t3		# load the number of strings we printed into the return address
	j printStringArrayJr	
	
	printStringArrayJr:
	jr $ra

verifyIPv4Checksum:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	li $v0, -555
	############################################
    jr $ra

##############################
# PART 2 FUNCTIONS
##############################

extractData:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	li $v0, -555
	li $v1, -555
	############################################
    jr $ra

processDatagram:
    #Define your code here

    jr $ra

##############################
# PART 3 FUNCTIONS
##############################

printDatagram:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -555
    ############################################
    jr $ra

#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here


