
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
	# $t0 = starting address of header
	# $t1 = header length
	move $t0, $a0		# starting address of header
	lb $t1, 3($t0)		# load the byte containing the header length
	andi $t1, $t1, 0xF	# get only the header length
	
	# lets get the ending address of the header
	# $t2 = ending address of header
	li $t2, 4
	mul $t2, $t1, $t2 	# result of the header length * 4
	add $t2, $t2, $t0	# get the endding address of the header
	
	li $t3, 0		# checksum
	li $t4, 0		# current word
	
	verifyIPv4ChecksumLoop:
	beq $t0, $t2, verifyIPv4ChecksumLoopEnd
	lw $t4, 0($t0)			# load the current word
	andi $t5, $t4, 0xFFFF		# lower half
	andi $t6, $t4, 0xFFFF0000	# upper half
	srl $t6, $t6, 16		# shift them over 16 bits
	add $t7, $t5, $t6		# add them together
	add $t3, $t3, $t7		# add to the checksum total	
	addi $t0, $t0, 4		# go to the next word
	j verifyIPv4ChecksumLoop
	
	verifyIPv4ChecksumLoopEnd:
	# see if the checksum is >= 65536
	move $t0, $t3					# move the checksum value into $t0
	li $t9, 65536
	blt  $t0, $t9, verifyIPv4ChecksumReturnZero	
	# if we get here then we do an end around carry
	verifyIPv4ChecksumEndAroundCarryLoop:
	andi $t1, $t0, 0xFFFF		# lower 16 bits
	andi $t2, $t0, 0xFFFF0000	# upper 16 bits
	srl $t2, $t2, 16		# shift them over 16 bits
	add $t3, $t1, $t2		# add them together
	andi $t4, $t3, 0xFFFF0000
	beqz $t4, verifyIPv4ChecksumEndAroundCarryLoopEnd
	move $t0, $t3		# move the checksum into $t0 for the next iteration
	j verifyIPv4ChecksumEndAroundCarryLoop
	
	verifyIPv4ChecksumEndAroundCarryLoopEnd:
	not $t4, $t3				# flip the bits
	andi $t4, $t4, 0xFFFF			# get rid of upper 16
	beqz $t4, verifyIPv4ChecksumReturnZero	# if the result is zero then we are good
	
	# if its not zero, return the checksum value we got
	move $v0, $t3
	j verifyIPv4ChecksumReturnJr	# return
	
	verifyIPv4ChecksumReturnZero:
	li $v0, 0	# all good so return zero
	j verifyIPv4ChecksumReturnJr
	
	verifyIPv4ChecksumReturnJr:
	jr $ra
	
	#### REMEMBER TO CHECK TO SEE IF THE LAST ADDRESS IS IN THE HEADER OR NOT! (DO WE INCLUDE IT IN THE CHECKSUM?) ########
##############################
# PART 2 FUNCTIONS
##############################

# $a0 =  starting address of the 1D array of ordered IPv4 Packet(s).
# $a1 = number of packets in parray.
# $a2 = starting address of the 1D array of byte for the msg.
# THIS FUNCTION MUST CALL verifyIPv4Checksum
# because we are calling another function, we might need to use $s registers to hold some values
extractData:
    # save some registers so we can use them
    addi $sp, $sp, -24
    sw $s4, 20($sp)
    sw $s3, 16($sp)
    sw $s2, 12($sp)
    sw $s1, 8($sp)
    sw $s0, 4($sp)
    sw $ra, 0($sp)
    
    # $s0 = packet array
    # $s1 = num of packets
    # $s2 = starting address of where we store our payload
    # $s3 = array index
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    li $s3, 0
    li $s4, 0	
    extractDataLoop:
    	# for every packet...
    	beq $s3, $s1, doneSavingPackets		# done if the current index is = to the number of packets we have
    	move $a0, $s0				# move the packet into $a0
    	jal verifyIPv4Checksum			# call to verifyIPv4Checksum
    	bnez $v0, extractDataReturnBadPacket	# if its a bad packet....
    	move $t0, $s0				# $t0 = starting address of the packet
    	lhu $t1, 0($t0)				# total length of the packet

    	add $t2, $t1, $t0			# packet address + packet length = where we stop our loop when storing bytes
    	addi $t3, $t1, -20			# subtract 20 from the total length to get payload size
    	add $s4, $s4, $t3			# keep track of the number of bytes we save
    	addi $t0, $t0, 20			# move to the starting address of the payload
    	extractDataSavePacketBytesLoop:
    		bgt $t0, $t2, nextPacketIter	# if the address we are on exceeds the ending address of the payload...
    		lbu $t4, 0($t0)			# load the next byte
    		sb $t4, 0($s2)			# store the byte at the current target byte location
    		addi $t0, $t0, 1		# move to the next byte to save
    		j extractDataSavePacketBytesLoop
    	nextPacketIter:
    	addi $s3, $s3, 1	# we move to the next index
    	addi $s0, $s0, 60	# move to the next packet
    	j extractDataLoop
    
    doneSavingPackets:
    move $v0, $s4		# Return the number of bytes we saved
    j extractDataRestoreAndReturn
    
    extractDataReturnBadPacket:
    li $v0, -1					# first return, -1
    move $v1, $s3				# second return, index of the packet that failed
    j extractDataRestoreAndReturn
    
    extractDataRestoreAndReturn:
    # Restoring stuff on stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    
    # Return
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






