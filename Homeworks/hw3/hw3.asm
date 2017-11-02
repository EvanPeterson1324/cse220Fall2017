
##############################################################
# Homework #3
# name: Evan Peterson
# sbuid: 108509452
##############################################################
.text

##############################
# Replace1st
##############################
# $a0 = starting address of the character array
# $a1 = ascii character to find in the string
# $a2 = ascii character to replace the one we found
replace1st:
	# if $a1 or $a2 are outside the range of [0x00, 0x7F]
	bltz $a1, replace1stReturnNeg1
	bltz $a2, replace1stReturnNeg1
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
	
	
##############################
# PrintStringArray
# $a0 = starting address of the string array
# $a1 = starting index to print from (inclusive)
# $a2 = ending index to print from (inclusive)
# $a3 = number of elements in the array
##############################
printStringArray:
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
	move $t9, $a0
	
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
	printStringArrayLoop1:
		bgt $t4, $t2, printStringArrayReturnNumPrinted		 # if curr index is greater than ending index...
		lbu $t3, 0($t7)					 	 # $t3 = load the next character
		beqz $t3, printStringArrayLoop1NullTerm		 	 # if char is null terminator....
		addi $t7, $t7, 1					 # next character
		
		li $v0, 11						 # print character
		move $a0, $t3						 # move the character i want to print into $a0
		syscall
		j printStringArrayLoop1			# loop-DEE-LOOP
		
		printStringArrayLoop1NullTerm:
		addi $t4, $t4, 1			# increment current index
		addi $t5, $t5, 1			# add 1 to the number of strings we printed
		move $t0, $t9
		add $t6, $0, $t4	# add the starting index
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

##############################
# verifyIPv4Checksum
##############################
verifyIPv4Checksum:
	# $t0 = starting address of header
	# $t1 = header length
	move $t0, $a0		# starting address of header
	lb $t1, 3($t0)		# load the byte containing the header length
	andi $t1, $t1, 0xF	# get only the header length
	
	# Get the ending address of the header
	li $t2, 4		# $t2 will = ending address of header
	mul $t2, $t1, $t2 	# result of the header length * 4
	add $t2, $t2, $t0	# $t2 NOW = ending address of header
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
	
##############################
# extractData
# $a0 =  starting address of the 1D array of ordered IPv4 Packet(s).
# $a1 = number of packets in parray.
# $a2 = starting address of the 1D array of byte for the msg.
##############################
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
    		beq $t0, $t2, nextPacketIter	# if the address we are on exceeds the ending address of the payload...
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
    
##############################
# extractUnorderedData
# $a0 = parray: starting address of the 1D array of UNORDERED IPv4 packets.
# $a1 = n: number of packets in parray.
# $a2 = msg: starting address of the 1D array of bytes for the msg.
# $a3 = packetentrysize: the number of bytes for each packet array.
# return (0, M+1) if success, (-1, k) on failure where k is the array index of the first error.
##############################

extractUnorderedData:
	# make space on the stack and save some registers
    	addi $sp, $sp, -36
    	sw $s7, 32($sp)
    	sw $s6, 28($sp)
    	sw $s5, 24($sp)
   	sw $s4, 20($sp)			
    	sw $s3, 16($sp)
    	sw $s2, 12($sp)
    	sw $s1, 8($sp)
   	sw $s0, 4($sp)	
   	sw $ra, 0($sp)
   	
   	# Init $s0 - $s3 with arguments
    	move $s0, $a0		# $s0 = $a0
    	move $s1, $a1		# $s1 = $a1
    	move $s2, $a2		# $s2 = $a2
    	move $s3, $a3		# $s3 = $a3
    	li $s4, 0		# current index we are at in the array (remember to increment this when looping)
    	li $s5, 0		# $s5 = $a0
    	li $s6, 0		# $s6 = the counter for checking if there is exactly 1 start packet
	li $s7, 0		# $s7 = the counter for checking if there is only 1 ending packet
	
	extractUnorderedVerifyChecksumLoop:
		beq $s1, $s4, unorderedBeforeGetData					# done if the current index is = to the number of packets we have
    		mul $t0, $s3, $s4							# index * num bytes of each packet
   		add $s5, $s0, $t0							# add packetEntrySize to the address to get the next address
    		move $a0, $s5								# move the packet into $a0
    		jal verifyIPv4Checksum							# call to verifyIPv4Checksum
   		bnez $v0, extractUnorderedDataReturnBadPacket				# if its a bad packet....
		lhu $t0, 0($s5)								# $t0 = total length of the packet
		bgt $t0, $s3, extractUnorderedDataReturnBadPacket			# return bad packet if the length is greater than the packet entry size
		addi $s4, $s4, 1							# next index for later
		j extractUnorderedVerifyChecksumLoop
	
	unorderedBeforeGetData:
		li $s4, 0								# init $s4 = 0 for the index of the packet array
   	extractUnorderedDataGetDataLoop:
   		beq $s1, $s4, unorderedLastChecks					# done if the current index is = to the number of packets we have
    		mul $t0, $s3, $s4							# index * num bytes of each packet
   		add $s5, $s0, $t0							# add packetEntrySize to the address to get the next address
   		lhu $t0, 0($s5)								# $t0 = total length of the packet
   		lbu $t1, 3($s5)								# $t1 = header length
   		andi $t1, $t1, 0xF							# get ONLY header length
   		li $t2, 4								# to multiply header *4
   		mul $t2, $t1, $t2							# $t2 = header length * 4
   		sub $t3, $t0, $t2							# $t3 = payload length... (total length - (4 * header length)
   		
   		lhu $t4, 4($s5)		# get the half word with the flags and flags offset
		srl $t5, $t4, 13	# $t5 = flags
		sll $t6, $t4, 24	# get rid of 3 flag bits
		srl $t6, $t6, 24	# $t6 = fragment offset
   		
   		# now we need to move the starting address of the payload, and save it depending on the offset
   		add $s5, $s5, $t1							# $s5 = starting address of the payload
   		add $t7, $s5, $t3							# $t7 = ending address of the payload
   		blez $s1, extractUnorderedDataReturnBadN				# if n < 1... return 
   		bne $s1, 1, unorderedNisNotEqualOne		# n > 1		
   		bnez $t5, extractUnorderedDataReturnBadN	# n == 1: if $t5 != zero... ERROR
   		bnez $t6, extractUnorderedDataReturnBadN	# n == 1: if $t6 != zero... ERROR
   		move $t8, $s2					# move the starting address of msg into $t8
   		li $t0, 0					# $t0 = num bytes we stored
   		unorderedOnlyOnePacketLoop:
   			beq $s5, $t7, unorderedLastChecks 
   			lbu $t9, 0($s5)		# load the byte from the payload
   			sb $t9, 0($t8)		# store the byte into the msg array
   			addi $s5, $s5, 1	# next byte of payload
   			addi $t8, $t8, 1	# next byte location in msg to save
   			addi $t0, $t0, 1	# numbytes++
   			j unorderedOnlyOnePacketLoop
   														
   		unorderedNisNotEqualOne:				# n > 1
   			beq $t5, 2, extractUnorderedDataReturnBadN	# n > 1
   			bne $t5, 4, unorderedCheckFlagEqualsZero	# n > 1
   			beqz $t6, unorderedFoundStartPacket	 	# n > 1: flag was 4 but offset was zero, so we found the start packet
   			j unorderedSavePacketPayload			# Save packet
   			
   			unorderedCheckFlagEqualsZero:
   				bnez $t6, unorderedFoundEndPacket 	# n > 1: flag was 0 and offset was != 0 so we found ending packet
   				j extractUnorderedDataReturnBadN	# Cant be zero here
		
		unorderedFoundStartPacket:
			addi $s6, $s6, 1				# increment the number of starting packets we have
			bgt $s6, 1, extractUnorderedDataReturnBadN	# if we have more than 1 starting packet, ERROR
			move $t8, $s2					# move the starting address of msg into $t8
   			unorderedFoundStartPacketLoop:
   				beq $s5, $t7, unorderedNextPacketIter 
   				lbu $t9, 0($s5)		# load the byte from the payload
   				sb $t9, 0($t8)		# store the byte into the msg array
   				addi $s5, $s5, 1	# next byte of payload
   				addi $t8, $t8, 1	# next byte location in msg to save
   				j unorderedFoundStartPacketLoop

   		unorderedFoundEndPacket:
			addi $s7, $s7, 1				# increment the number of ending packets we have
			bgt $s7, 1, extractUnorderedDataReturnBadN	# if we have more than 1 ending packet, ERROR
			move $t8, $s2					# move the starting address of msg into $t8
   			add $t8, $t8, $t6				# $t8 = msg starting address + frag offset 
			li $t0, 0					# counter for the index we stopped at
			unorderedFoundEndPacketLoop:
   				beq $s5, $t7, beforeUnorderedNextPacketIter 
   				lbu $t9, 0($s5)		# load the byte from the payload
   				sb $t9, 0($t8)		# store the byte into the msg array
   				addi $s5, $s5, 1	# next byte of payload
   				addi $t8, $t8, 1	# next byte location in msg to save
   				j unorderedFoundEndPacketLoop
   			beforeUnorderedNextPacketIter:
   				sub $t0, $t8, $s2
   				addi $sp, $sp, -4
   				sw $t0, 0($sp)
   				j unorderedNextPacketIter
   				
   		unorderedSavePacketPayload:
   			move $t8, $s2					# move the starting address of msg into $t8
   			add $t8, $t8, $t6				# $t8 = msg starting address + frag offset 
   			
   			extractUnorderedDataSavePayloadLoop:
   				beq $s5, $t7, unorderedNextPacketIter 
   				lbu $t9, 0($s5)		# load the byte from the payload
   				sb $t9, 0($t8)		# store the byte into the msg array
   				addi $s5, $s5, 1	# next byte of payload
   				addi $t8, $t8, 1	# next byte location in msg to save
   				j extractUnorderedDataSavePayloadLoop
   						
   				unorderedNextPacketIter:
   					addi $s4, $s4, 1	# next packet index
   					j extractUnorderedDataGetDataLoop
   					
   	unorderedLastChecks:
   		bne $s1, 1, unorderedMultiplePackets
   		# if we get here, we only have 1 packet
   		li $v0, 0	# return 0 to show we did it!
		move $v0, $t0	
   		
   		j extractUnorderedDataRestoreAndReturn
   		
   		unorderedMultiplePackets:				# n > 1
   			beqz $s6, extractUnorderedDataReturnBadN 			
   			beqz $s7, extractUnorderedDataReturnBadN
   			li $v0, 0	# return 0 to show we did it!
			lw $v1, 0($sp)
			addi $sp, $sp, 4
   			j extractUnorderedDataRestoreAndReturn
   														
   	extractUnorderedDataReturnBadN:
   		li $v0, -1		# return -1
   		li $v1, -1		# return -1
   		j extractUnorderedDataRestoreAndReturn		
   	
   	extractUnorderedDataReturnBadPacket:
   		li $v0, -1			# return -1
   		move $v1, $s4			# return the index of the array we were on
   		j extractUnorderedDataRestoreAndReturn
   	
   	extractUnorderedDataRestoreAndReturn:
   		# Restoring stack stuff
    		lw $s7, 32($sp)
    		lw $s6, 28($sp)
    		lw $s5, 24($sp)
   		lw $s4, 20($sp)			
    		lw $s3, 16($sp)
    		lw $s2, 12($sp)
    		lw $s1, 8($sp)
   		lw $s0, 4($sp)	
   		lw $ra, 0($sp)
    		addi $sp, $sp, 36
		jr $ra		
	
##############################
# processDatagram
##############################
processDatagram:
	# Save $s0-$s4 and $ra since we call replace1st
    	addi $sp, $sp, -24
    	sw $s4, 20($sp)
    	sw $s3, 16($sp)
    	sw $s2, 12($sp)
    	sw $s1, 8($sp)
    	sw $s0, 4($sp)
    	sw $ra, 0($sp)
    	
    	# if M <= 0, return -1
    	blez $a1, processDatagramReturnNegOne
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
		lbu $t0, 0($a0)
		beqz $t0, endProcessDatagramReplaceLoop
    		li $a1, '\n'		# character to replace
    		li $a2, '\0'		# character to replace WITH
    		jal replace1st
    		beq $v0, -1, processDatagramReturnNegOne
    		move $t0 , $v0		# move the return value from replace1st into $t0
    		sub $t1, $t0, $s0	# get the number of bytes we need to move over for the next iter
    		sw $s0, 0($s2)		# store the starting address of the string we found
    		addi $s2, $s2, 4	# move the pointer the Str Array
    		add $s0, $s0, $t1	# add the amount of bytes we traversed to $s0 for the next iteration
    		addi $s3, $s3, 1	# keep track of how many strings we saved
    		beqz $v0, endProcessDatagramReplaceLoop
    		j processDatagramReplaceLoop
    		
    	endProcessDatagramReplaceLoop:
    	#sw $s0, 0($s2)		# store the starting address of the string we found
    	#addi $s3, $s3, 1 #off by 1
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
# printDatagram
##############################
printDatagram:
	beq $a1, -1, printDatagramReturnNegOne
    	# Save $s0-$s4 and $ra since we call replace1st
    	addi $sp, $sp, -24
    	sw $s4, 20($sp)
    	sw $s3, 16($sp)
    	sw $s2, 12($sp)
    	sw $s1, 8($sp)
    	sw $s0, 4($sp)
    	sw $ra, 0($sp)
    	
	# Move args into $s0 - $s3 registers
    	move $s0, $a0		# $s0 = startng address of a 1D array of ordered IPv4 packets
    	move $s1, $a1		# $s1 = the number of packets in parray
    	move $s2, $a2		# $s2 = starting byte address of the message in memory
    	move $s3, $a3		# $s3 = starting address of the array to hold the addresses of ASCII character strings
    	li $s4, 0		# $s4 = 0
    	
    		
    	# Begins by calling extractData
    	# $a0 = parray
    	# $a1 = n
    	# $a2 = msg
    	move $a0, $s0		# $a0 = startng address of a 1D array of ordered IPv4 packets
    	move $a1, $s1		# $a1 = the number of packets in parray
    	move $a2, $s2		# $a2 = starting byte address of the message in memory
    	jal extractData		# call to extractData

    	bnez $v0, printDatagramReturnNegOne	# if extractData returns something OTHER than zero, return -1
    	
    	# call processDatagram
    	# $a0 = msg
    	# $a1 = M
    	# $a2 = sarray
    	move $a0, $s2		# $a0 = starting byte address of the message in memory.
    	move $a1, $v1		# $a1 = number of bytes stored in the msg
    	move $a2, $s3		# $a2 = starting address of the array to hold the addresses of ASCII character strings in memory.
    	jal processDatagram
    	beq $v0, -1, printDatagramReturnNegOne    # if extractData returns something OTHER than zero, return -1
    	
    	# call printStringArray
    	# $a0 = sarray
    	# $a1 = start index
    	# $a2 = end index
    	# $a3 = length
    	move $a0, $s3
    	li $a1, 0
    	move $a3, $v0
    	addi $v0, $v0, -1
    	move $a2, $v0
    	jal printStringArray
    	beq $v0, -1, printDatagramReturnNegOne
    	j printDatagramReturnZero
   
    	printDatagramReturnNegOne:
    	li $v0, -1	# return -1 bc something failed
    	j printDatagramRestoreAndReturn
    	
    	printDatagramReturnZero:
    	li $v0, 0	# return 0 bc we good
    	j printDatagramRestoreAndReturn
    	
    	printDatagramRestoreAndReturn:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
   	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	addi $sp, $sp, 24
    	jr $ra
    	
##############################
# printDatagram
##############################
printUnorderedDatagram:
	beq $a1, -1, printUnorderedDatagramReturnNegOne
	lw $t0, 0($sp) # get the firth argument off the stack
    	# Save $s0-$s4 and $ra since we call replace1st
    	addi $sp, $sp, -28
    	sw $s5, 24($sp)
    	sw $s4, 20($sp)
    	sw $s3, 16($sp)
    	sw $s2, 12($sp)
    	sw $s1, 8($sp)
    	sw $s0, 4($sp)
    	sw $ra, 0($sp)
    	
	# Move args into $s0 - $s3 registers
    	move $s0, $a0		# $s0 = startng address of a 1D array of ordered IPv4 packets
    	move $s1, $a1		# $s1 = the number of packets in parray
    	move $s2, $a2		# $s2 = starting byte address of the message in memory
    	move $s3, $a3		# $s3 = starting address of the array to hold the addresses of ASCII character strings
    	li $s4, 0		# $s4 = 0
    	move $s5, $t0		# $s5 = packetentrysize
    		
    	# Begins by calling extractData
    	# $a0 = parray
    	# $a1 = n
    	# $a2 = msg
    	# $a3 = packetentrysize
    	move $a0, $s0		# $a0 = startng address of a 1D array of ordered IPv4 packets
    	move $a1, $s1		# $a1 = the number of packets in parray
    	move $a2, $s2		# $a2 = starting byte address of the message in memory
    	move $a3, $s5		# $a3 = packetentrysize
    	jal extractUnorderedData		# call to extractUnorderedData
    	bnez $v0, printUnorderedDatagramReturnNegOne	# if extractData returns something OTHER than zero, return -1
    	
    	# call processDatagram
    	# $a0 = msg
    	# $a1 = M
    	# $a2 = sarray
    	move $a0, $s2		# $a0 = starting byte address of the message in memory.
    	move $a1, $v1		# $a1 = number of bytes stored in the msg
    	move $a2, $s3		# $a2 = starting address of the array to hold the addresses of ASCII character strings in memory.
    	jal processDatagram
    	beq $v0, -1, printUnorderedDatagramReturnNegOne    # if extractData returns something OTHER than zero, return -1
    	
    	# call printStringArray
    	# $a0 = sarray
    	# $a1 = start index
    	# $a2 = end index
    	# $a3 = length
    	move $a0, $s3
    	li $a1, 0
    	move $a3, $v0
    	addi $v0, $v0, -1
    	move $a2, $v0
    	jal printStringArray
    	beq $v0, -1, printUnorderedDatagramReturnNegOne
    	j printUnorderedDatagramReturnZero
   
    	printUnorderedDatagramReturnNegOne:
    	li $v0, -1	# return -1 bc something failed
    	j printDatagramRestoreAndReturn
    	
    	printUnorderedDatagramReturnZero:
    	li $v0, 0	# return 0 bc we good
    	j printUnorderedDatagramRestoreAndReturn
    	
    	printUnorderedDatagramRestoreAndReturn:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
   	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	addi $sp, $sp, 28
    	jr $ra
##############################
# editDistance
# $a0 = Starting address of String #1
# $a1 = Starting address of String #2
# $a2 = length of string #1    (m)
# $a3 = length of string #2    (n)
##############################
editDistance:
	addi $sp, $sp, -24
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
    	sw $ra, 0($sp)
	
	move $t0, $a0		# str1
	move $t1, $a1		# str2
	move $t2, $a2		# m
	move $t3, $a3		# n
	addi $t4, $t2, -1	# m - 1
	addi $t5, $t3, -1	# n - 1
	
	# if m or n < 0, return -1
	bltz $a2, editDistanceErrorReturn
	bltz $a3, editDistanceErrorReturn
	
	# System.out.print("m:" + m + ",n:" + n + "\n");
	li $v0, 4
	la $a0, m
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, n
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	
	# if m or n are empty strings, return n or m respectively
	beqz $a2, editDistanceReturnN
	beqz $a3, editDistanceReturnM
	
	add $t6, $t0 $t4	# get last char address of str2
	add $t7, $t1 $t5	# get last char address of str1
	lbu $t6, 0($t6)
	lbu $t7, 0($t7)
	bne $t6, $t7, editDistanceNotSameLastChar 
	
	move $a0, $t0	# set up recursive call
	move $a1, $t1	# set up recursive call
	move $a2, $t4	# set up recursive call
	move $a3, $t5	# set up recursive call
	jal editDistance
	j editDistanceRestoreAndReturn
	
	editDistanceNotSameLastChar:
		move $s0, $t2		# m
		move $s1, $t3		# n
		
		#int insert = editDistance(str1, str2, m, n-1);
		move $a0, $t0	# set up recursive call
		move $a1, $t1	# set up recursive call
		move $a2, $s0	# set up recursive call
		move $a3, $s1	# set up recursive call
		addi $a3, $a3, -1	# n - 1
		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		jal editDistance
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		addi $sp, $sp, 8
		
		move $s2, $v0	# insert
		move $a0, $t0	# set up recursive call
		move $a1, $t1	# set up recursive call
		
		#int remove = editDistance(str1, str2, m-1, n);
		move $a2, $s0	# set up recursive call
		move $a3, $s1	# set up recursive call
		addi $a2, $a2, -1	# m - 1
		
		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		jal editDistance
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		addi $sp, $sp, 8
		
		move $s3, $v0						# remove
		#int replace = editDistance(str1, str2, m-1, n-1);
		move $a0, $t0	# set up recursive call
		move $a1, $t1	# set up recursive call
		move $a2, $s0	# set up recursive call
		move $a3, $s1	# set up recursive call
		addi $a2, $a2, -1	# m - 1
		addi $a3, $a3, -1	# n - 1
		
		jal editDistance
		move $s4, $v0						# replace
		
		# get the minimum of the three
		move $a0, $s2
		move $a1, $s3
		move $a2, $s4
		jal minThree
		addi $v0, $v0, 1
		j editDistanceRestoreAndReturn
		
	editDistanceErrorReturn:
		li $v0, -1
		jr $ra
	
	editDistanceReturnM:
		move $v0, $a2
		j editDistanceRestoreAndReturn
	
	editDistanceReturnN:
		move $v0, $a3
		j editDistanceRestoreAndReturn
		
	editDistanceRestoreAndReturn:
		lw $s3, 20($sp)
		lw $s3, 16($sp)
		lw $s2, 12($sp)
		lw $s1, 8($sp)
		lw $s0, 4($sp)
    		lw $ra, 0($sp)
		addi $sp, $sp, 24
		jr $ra
	
	
##############################
# minThree
# $a0 = value 1
# $a1 = value 2
# $a2 = value 3
# Returns the min of the three values
##############################
minThree:
	move $t0, $a0			# $a0 = $t0, $a0 = min for now
	minThreeFirstCheck: 
		blt $a1, $t0, minThreeSetMin1
		
	minThreeSecondCheck:
		blt $a2, $t0, minThreeSetMin2
		j minThreeReturn
		
	minThreeSetMin1:
		move $t0, $a1		# $a1 is the new min
		j minThreeSecondCheck
	
	minThreeSetMin2: 
		move $t0, $a2		# $a2 is the new min
	
	minThreeReturn:
		move $v0, $t0
		jr $ra
	
#################################################################
# Student defined data section
#################################################################
.data
newline:  .asciiz "\n"
m:    .asciiz "m:"
n:    .asciiz ",n:"
.align 2  # Align next items to word boundary






