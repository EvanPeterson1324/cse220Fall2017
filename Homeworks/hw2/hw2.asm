
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
	addi $t0, $t0, 1				# go to the next character
	j replace1stLoopCharArr				# loop again

	# here we found the character so we will replace it with $a2 and return the address of the NEXT character
	replace1stReplaceAndReturn:
	sb $a2, 0($t0)			# replace the character we found
	addi $t0, $t0, 1		# add 1 b/c we will return the next character
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
printStringArray:
    	# $a0 = starting address of the string array
	# $a1 = starting index to print from (inclusive)
	# $a2 = ending index to print from (inclusive)
	# $a3 = number of elements in the array
	
    	# ERROR CHECKING
    	bltz $a1, printStringArrayReturnNeg1		# if starting index < 0, return -1
    	bge  $a1, $a3 printStringArrayReturnNeg1	# if the starting index is greater than or equal to the length, return -1
	bltz $a2, printStringArrayReturnNeg1		# if ending index < 0, return -1
	bge  $a2, $a3 printStringArrayReturnNeg1	# if the ending index is greater than or equal to the length, return -1
    	blez $a3, printStringArrayReturnNeg1		# if length < 1, return -1
	blt $a2, $a1, printStringArrayReturnNeg1	# if the ending index is < the starting index, return -1
	
	
	# $t0 = starting address of the string array
	# $t1 = starting index to print from (inclusive)
	# $t2 = ending index to print from (inclusive)

	move $t0, $a0
	move $t1, $a1
	move $t2, $a2

	
	# init counters
	move $t4, $t1		# $t4 = curr index
	li $t5, 0		# $t5 = num strings printed
	li $t6, 0		# $t6 = offset to get the first index
	li $t8, 4		# $t7 = 4
	
	add $t6, $t6, $t4	# add the starting index
	mul $t6, $t6, $t8	# get the offset to add to the starting address
	add $t0, $t0, $t6	# get the address of the starting index string
	lw $t7, 0($t0)		# load the starting address of the first string
	
	# Print String Loop
	# WHY IS IT PRINTING OUT THE WRONG STRING?????????????
	printStringArrayLoop1:
		
		
		bgt $t4, $t2, printStringArrayReturnNumPrinted		 # if curr index is greater than ending index...
		lb $t3, 0($t7)					 	 # $t3 = load the next character
		beqz $t3, printStringArrayLoop1NullTerm		 	 # if char is null terminator....
		addi $t7, $t7, 1					 # next character
		
		li $v0, 11						 # print character
		move $a0, $t3						 # move the character i want to print into $a0
		syscall
		j printStringArrayLoop1			# loop-DEE-LOOP
		
		printStringArrayLoop1NullTerm:
		addi $t4, $t4, 1			# increment current index
		addi $t5, $t5, 1			# add 1 to the number of strings we printed
		
		li $t6, 0		# re init $t6 = 0
		add $t6, $t6, $t4	# add the starting index
		mul $t6, $t6, $t8	# get the offset to add to the starting address
		add $t0, $t0, $t6	# get the address of the starting index string
		lw $t7, 0($t0)		# load the starting address of the first string
		# double newline after each string
		li $v0, 11		# tell system we will print a character
		li $a0, '\n'		# newline
		syscall
		li $v0, 11		# tell system we will print a character
		li $a0, '\n'		# newline
		syscall	 
		j printStringArrayLoop1			# loop-DEE-LOOP
		
	printStringArrayReturnNeg1:
		li $v0, -1	# return neg 1
		j printStringArrayJr
	
	printStringArrayReturnNumPrinted:
		move $v0, $t5		# load the number of strings we printed into the return address
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
	move $v0, $t4
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
    		addi $t0, $t0, 1		# move to the next address to save
    		addi $s2, $s2, 1		# next byte location to save at
    		j extractDataSavePacketBytesLoop
    	nextPacketIter:
    	addi $s3, $s3, 1	# we move to the next index
    	addi $s0, $s0, 60	# move to the next packet
    	j extractDataLoop
    
    doneSavingPackets:
    li $v0, 0			# return 0 to say we all good
    move $v1, $s4		# Return the number of bytes we saved
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
	# Save $s0-$s4 and $ra since we call replace1st
    	addi $sp, $sp, -24
    	sw $s4, 20($sp)
    	sw $s3, 16($sp)
    	sw $s2, 12($sp)
    	sw $s1, 8($sp)
    	sw $s0, 4($sp)
    	sw $ra, 0($sp)
    	
    	# if M < 0, return -1
    	bltz $a1, processDatagramReturnNegOne
    	# Save our args
    	move $s0, $a0		# $s0 = starting byte address of the message in memory.
    	move $s1, $a1		# $s1 = total number of bytes stored in msg .
    	move $s2, $a2		# $s2 = starting address of array to hold the addresses of ASCII character strings in memory
	li $s3, 0		# init $s3 = 0
	
	# store a null term at the end of the array
	add $t0, $s0, $s1	# the location to store the null term
	sb $0, 0($t0)		# store null term
	
	processDatagramReplaceLoop:
		move $a0, $s0		# starting byte address of the msg in memory
    		li $a1, '\n'		# character to replace
    		li $a2, '\0'		# character to replace WITH
    		jal replace1st
    		beqz $v0, endProcessDatagramReplaceLoop
    		beq $v0, -1, processDatagramReturnNegOne
    		move $t0 , $v0		# move the return value from replace1st into $t0
    		sub $t1, $t0, $s0	# get the number of bytes we need to move over for the next iter
    		sb $s0, 0($s2)		# store the starting address of the string we found
    		addi $s2, $s2, 1	# move the pointer the Str Array
    		add $s0, $s0, $t1	# add the amount of bytes we traversed to $s0 for the next iteration
    		addi $s3, $s3, 1	# keep track of how many strings we saved
    		j processDatagramReplaceLoop
    		
    	endProcessDatagramReplaceLoop:
    	move $v0, $s3	# return the numberof strings we stored
    	j processDatagramRestoreAndReturn
    	
    	processDatagramReturnNegOne:
    	li $v0, -1
    	j processDatagramRestoreAndReturn
    	
    	processDatagramRestoreAndReturn:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
   	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	addi $sp, $sp, 24
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






