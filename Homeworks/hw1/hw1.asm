# Homework #1
# Name: Evan Peterson
# Net ID: erpeterson
# SBU ID: 108509452

# Helper macro for accessing command line arguments via label
.macro load_args
	sw $a0, numargs
	lw $t0, 0($a1)
	sw $t0, AddressOfIPDest3
	
	lw $t0, 4($a1)
	sw $t0, AddressOfIPDest2
	
	lw $t0, 8($a1)
	sw $t0, AddressOfIPDest1
	lw $t0, 12($a1)
	sw $t0, AddressOfIPDest0
	lw $t0, 16($a1)
	sw $t0, AddressOfBytesSent
	lw $t0, 20($a1)
	sw $t0, AddressOfPayload
.end_macro

# macro to print out the label Err_string
.macro printErrStr
	
	# Print out Err_string
	la $a0, Err_string	# load value found at the label Err_string. ** Why do we use la instead of lw? **
	li $v0, 4		# indicate we are printing a string
	syscall			# syscall prints the string
	
	# Terminate the program
	li $v0, 10
	syscall
	
.end_macro

# Helper macro for validating the integer values of the IPDest arguments
.macro validateIPDestArgs
	
	li $v1, 0	# init $v1 = 0 to avoid junk
	li $t0, 0	# count
	
	li $v0, 84	# Tells the system to use "atoi"
	la $a0, AddressOfIPDest3	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	li $v0, 84	# Tells the system to use "atoi"
	la $a0, AddressOfIPDest2	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	li $v0, 84	# Tells the system to use "atoi"
	la $a0, AddressOfIPDest1	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	li $v0, 84	# Tells the system to use "atoi"
	la $a0, AddressOfIPDest0	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	bnez $t0, callPrintErrStr	# if the count isnt zero, we know something failed so print err and terminate:
.end_macro

# Validate the Bytes sent arg
.macro validateBytesSentArg
	li $v0, 84			# Tells the system to use "atoi"
	la $a0, AddressOfBytesSent	# get the address of the string address
	lw $a0, 0($a0)			# get the pointer to the str address
	syscall				# call to atoi
	
	bnez $v1, callPrintErrStr	# if we failed, print err string and terminate the program
	li $t0, 8191			# upper bound for atoi value
	li $t1, -1			# lower bound for atoi value
	
	bgt $v0, $t0, callPrintErrStr	# above the upper bound so print err and terminate
	blt $v0, $t1, callPrintErrStr	# below the lower bound so print err and terminate
	li $t2, 8			# $t2 = 8
	div $v0, $t2			# divide value from atoi by 8
	mfhi $t2			# move remainder into $t2 
	bnez $t2, callPrintErrStr	# not a multiple of 8 so print err and terminate
	move $s7, $v0			# $s7 has the bytes sent value
.end_macro 	

.text
.globl main

main:
	load_args()	# Only do this once!
	# Start writing the program after the load-args macro is called	
	
	# First, add code to check the number of cmd line args provided
	lw $t0, numargs 	# Load the number of cmd line args into $t0
	li $t1, 6		# Load the immd 6 into $t1
	
	# Check if the cmd line args == 6
	bne $t0, $t1, callPrintErrStr	# if $t0 != 6, call the printErrStr macro and terminate the program
	
	# Helper macro: Check the strings for each of the IPDest arguments
	validateIPDestArgs()	# Helper macro
	
	# Helper macro: Check the strings for the BytesSent argument
	validateBytesSentArg()
	###--- Validate Version ---###
	# $t0 = address of first packet byte
	# $t1 = 3rd byte of the packet
	# $t2 = 4
	# $t3 = Packet Version
	# $t4 = Header Length
	la $t0, Header				# Load the address of the first byte into $t0
	lbu $t1, 3($t0)				# Load the 3rd byte of the packet
	li $t2, 4				# Immediate to check the version number
	srl $t3, $t1, 4				# Shift right 4 bits so we get the correct value for Packet Version
	andi $t4, $t1, 1111			# Bitwise AND to get the last 4 bits  (Header Length)
	bne $t3, $t2, unsupportedVersion	# if the Version Number is NOT 4, branch
	
	la $a0, IPv4_string			# Load the address of the string we want to print
	li $v0, 4				# Print String
	syscall
	j afterVersionCheck			# jump to the next operation
	
	unsupportedVersion:			# if the version is not 4, lets print out the string
	la $a0, IPv4_unsupported_string		# load the address of the IPv_ unsupported string 
	li $v0, 4
	syscall
	move $a0, $t3				# move the version number into the $a0 register
	li $v0, 1				# print int
	syscall
	
	la $a0, newline				# load newline address
	li $v0, 4				# print newline
	syscall
	# Replace the unsupported version number with "4"
	sll $t3, $t2, 4
	or $t5, $t3, $t4
	sb $t5, 3($t0)			# store the new value into the byte
	

	afterVersionCheck:
	la $t0, Header				# Load the address of the first byte into $t0
	lw $t1, 0($t0)				# Load the word containing the Type of service
	sll $t1, $t1, 8				
	srl $s0, $t1, 24			# $s0 = type_of_service
	
	lw $t1, 4($t0)
	srl $s1, $t1, 16			# $s1 = identifier
	
	lbu $s2, 11($t0)			# $s2 = time to live
	lbu $s3, 10($t0)			# $s3 = protocol
	
	li $v0, 1
	move $a0, $s0				# print type of service
	syscall
	
	li $v0, 4				# print comma
	la $a0, comma
	syscall
	
	li $v0, 1
	move $a0, $s1				# print identifier
	syscall
	
	li $v0, 4				# print comma
	la $a0, comma
	syscall
	
	li $v0, 1
	move $a0, $s2				# print time to live
	syscall
	
	li $v0, 4				# print comma
	la $a0, comma
	syscall
	
	li $v0, 1
	move $a0, $s3				# print protocol
	syscall
	
	li $v0, 4				# print newline
	la $a0, newline	
	syscall
	
	# Printing the value of source IP
	la $t0, Header
	lbu $t1, 12($t0)
	lbu $t2, 13($t0)
	lbu $t3, 14($t0)
	lbu $t4, 15($t0)
	
	li $v0, 1
	move $a0, $t4				# print IPSrc3
	syscall
	
	li $v0, 4				# print period
	la $a0, period
	syscall
	
	li $v0, 1
	move $a0, $t3				# print IPSrc2
	syscall
	
	li $v0, 4				# print period
	la $a0, period
	syscall
	
	li $v0, 1
	move $a0, $t2				# print IPSrc1
	syscall
	
	li $v0, 4				# print period
	la $a0, period
	syscall
	
	li $v0, 1
	move $a0, $t1				# print IPSrc0
	syscall
	
	li $v0, 4				# print newline
	la $a0, newline
	syscall
	
	# Store the value of the Destination IP Address field
	
	la $t3, AddressOfIPDest3	# load the Addr
	li $v0, 84
	lw $a0, 0($t3)
	syscall
	move $t3, $v0			# move the value into $t3
	
	la $t2, AddressOfIPDest2	# load the Addr
	li $v0, 84
	lw $a0, 0($t2)
	syscall
	move $t2, $v0			# move the value into $t2
	
	la $t1, AddressOfIPDest1	# load the Addr
	li $v0, 84
	lw $a0, 0($t1)
	syscall
	move $t1, $v0			# move the value into $t1
	
	la $t0, AddressOfIPDest0	# load the Addr
	li $v0, 84
	lw $a0, 0($t0)
	syscall
	move $t0, $v0			# move the value into $t0
	
	sll $t3, $t3, 24
	sll $t2, $t2, 16
	sll $t1, $t1, 8
	
	or $t4, $t0, $t1
	or $t4, $t4, $t2
	or $t4, $t4, $t3
	
	la $t5, Header				# Load the address of the first byte into $t0
	sw $t4, 16($t5)				# save the dest reg to memory
	
	li $v0, 34
	move $a0, $t4
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	# Use a loop to calc the number of bytes for the Payload arg
	li $s0, 0			# Init the counter to 0, $s0 = number of bytes for the payload arg
	la $t0, AddressOfPayload	# load the address of the payload
	
	### FIX THIS ######
	numPayloadBytesLoop:
	lbu $t3, 0($t0)				# load the next byte
	beqz $t3, stopNumPayloadBytesLoop	# if the null terminator is found, break out of the loop
	addi $t0, $t0, 1			# we will continue so go to the next byte
	addi $s0, $s0, 1			# increment count by 1
	j numPayloadBytesLoop			# loop again
	
	stopNumPayloadBytesLoop:
	# load the value from the header length
	la $t0, Header		# load header starting address
	lbu $t1, 3($t0)		# load the 3rd byte
	sll $t1, $t1, 28	# get rid of the 4 upper bits
	srl $t1, $t1, 28	# get rid of the 4 upper bits
	addi $s0, $s0, 1	# fix off by 1
	li $t9, 4		# mult
	mul $t1, $t1, $t9	# mult by 4	
	add $t2, $t1, $s0	# payload bytes + header length
	sb  $t2, 0($t0)		# the total length field
	
	# print the Flags field and the Fragment offset field in binary(Syscall 35)
	la $t0, Header	# load the header
	lbu $t1, 5($t0)	# load the 6th byte
	srl $t2, $t1, 5	# get rid of lower 5 bits to get the Flags field
	
	li $v0, 35
	move $a0, $t2	# print the binary value of the flags
	syscall
	
	li $v0, 4
	la $a0, comma	# print a comma
	syscall
	
	
	lhu $t3, 4($t0)	 # get the fragment offset
	sll $t3, $t3, 19 # get rid of upper bits
	srl $t3, $t3, 19 # same
	
	li $v0, 35
	move $a0, $t3	# print the binary value of the flags
	syscall
	
	li $v0, 4
	la $a0, newline	# print newline
	syscall
	
	move $t1, $s7			# move the bytes sent value
	li $t2, -1			# load -1
	beq $t1, $t2 bytesSentNegOne
	beqz $t1, bytesSentZero
	j bytesSentGreater
							
	# if bytes sent == 0, set flag field to 0 and fragment offset to 0
	bytesSentZero:
	lw $t3, 4($t0)		# load the word
	srl $t4,$t3, 16		# gets rid of anything that was in the flag and fragment offset
	sll $t4, $t4, 16	# maintain the upper 16 bits of the word in $t4
	sw $t4, 4($t0)		# save the word in memory
	j afterBytesSent
	
	# if bytes sent == -1, set flag field to 2, fragment offset to 0
	bytesSentNegOne:
	lw $t3, 4($t0)
	srl $t4,$t3, 16
	sll $t4, $t4, 16	# maintain the upper 16 bits of the word in $t4
	li $t5, 2		# load 4 into $t5
	sll $t5, $t5, 13	# shift over 13 bits so we can add the fragment offset
	add $t6, $t5, $t4	# add the upper 16 bits with the lower 16 to maintain the word
	sw $t6, 4($t0)		# save the word in memory
	j afterBytesSent
	
	# set the bits of the flag field to 100 (decimal value 4) and set the fragment offset to BytesSent.
	bytesSentGreater:
	lw $t3, 4($t0)		# load the 2nd word
	srl $t4,$t3, 16		# get rid of junk in the lower 16 bits
	sll $t4, $t4, 16	# maintain the upper 16 bits of the word in $t4
	
	li $t5, 4		# load 4 into $t5
	sll $t5, $t5, 13	# shift over 13 bits so we can add the fragment offset
	add $t5, $t5, $t1	# add the flag field to the bytes sent
	add $t6, $t5, $t4	# add the uppder 16 bits with the lower 16 to maintain the word
	sw $t6, 4($t0)		# save the word in memory
	
	afterBytesSent:
	# save the payload argument into memory after the packet header!
	
	lw $t0, AddressOfPayload	# load the address of the payload
	la $t1, Header			# load the address of the header
	lb $t2, 3($t1)			# load the 4th byte
	andi $t2, $t2, 0x0f		# get the first 4 bits, $t2 is the header length
	li $t3, 4			# multiplication
	mul $t4, $t2, $t3		# header length * 4
	add $t1,$t1, $t4		# header + header length * 4
	
	# Header + Header Length*4
	storePayloadBytesLoop:
	lbu $t4, 0($t0)					# load the next byte
	beqz $t4 stopStorePayloadBytesLoop		# if the null terminator is found, break out of the loop
	sb $t4, 0($t1)					# save the byte from the payload into the memory AFTER the header
	addi $t0, $t0, 1				# we will continue so go to the next byte
	addi $t1, $t1, 1				# go to the next byte in memory
	j storePayloadBytesLoop				# loop again
	
	stopStorePayloadBytesLoop:
	
	# print the starting address of the header in HEX
	la $a0, Header
	li $v0, 34
	syscall
	
	li $v0, 4				# print comma
	la $a0, comma
	syscall
	
	addi $t1, $t1, 1		# fix off by 1 error
	move $a0, $t1			# print the last location in memory
	li $v0, 34
	syscall
	
	li $v0, 4				# print newline
	la $a0, newline
	syscall
	
	# checksum
	# To calculate the checksum, we can first calculate the sum of each 16 bit value within the header, 
	# skipping only the checksum field itself.
	
	# grab all the values of the header and add them together, except the checksum
	la $t0, Header		# load the address of the header
	move $t1, $t0		# this value will be incremented to get the next word
	li $t2, 0		# count
	li $t3, 0		# sum
	lbu $t4, 3($t0)		# load the byte with the header length in it
	andi $t4, $t4, 15 	# get only the header length!
	
	checksumAddLoop:
	bgt $t2, $t4, endCheckSumAddLoop		# if the counter is greater than the header length, break the loop
	lw $t5, 0($t1)					# value of the current word
	beq $t2, 2, foundCheckSumWord			# dont add the checksum value!
	lhu $t6, 0($t1)					# load the lower 16 bits
	add $t3, $t3, $t6				# add the 2nd 16 bit value
	foundCheckSumWord:
	andi $t7, $t5, 4294901760			# keep the upper 16 bits
	srl $t7, $t7, 16				# shift 16 bits to the right to get proper value
	add $t3, $t3, $t7				# add the 1st 16 bit value
	
	addi $t1, $t1, 4				# go to the next word
	addi $t2, $t2, 1				# increment the count by 1
	j checksumAddLoop
	
	endCheckSumAddLoop:
	# first 4 bits are the carry which we add to the sum
	move $s0, $t3		  			# the value of the sum
	
	checkSumEndAroundCarryLoop:
	andi $t1, $s0, 65535		  		# keep the lower 16 bits
	andi $t2, $s0, 4294901760 			# get the upper 16 bits
	srl $t2, $t2, 16				# shift bits down to get correct value
	beqz $t2, endCheckSumEndAroundCarryLoop		# if the upper 16 bits are zero, stop looping
	add $s0, $t1, $t2				# add the carry to the sum
	j checkSumEndAroundCarryLoop			# loop-DEE-loop
	
	endCheckSumEndAroundCarryLoop:
	# save the checksum value
	la $t0, Header			# load the starting address of the header
	lw $t1, 8($t0)			# load the word with the checksum
	andi $t1, $t1, 4294901760	# keep the upper 16 bits
	add $t1, $t1, $s0		# add the checksum to the lower 16 bits
	sw $t1, 8($t0)			# store the updated checksum!
	
	# Terminate the program
	li $v0, 10
	syscall
	
	# so we can use the macro in a beq instruction
	callPrintErrStr:
		printErrStr()
	
	
	
	
.data

# Include the file with the test case information
.include "../sample_asm/Header2.asm" 			# Change this line to test with other inputs

.align 2
	numargs: .word 0
	AddressOfIPDest3: .word 0
	AddressOfIPDest2: .word 0
	AddressOfIPDest1: .word 0
	AddressOfIPDest0: .word 0
	AddressOfBytesSent: .word 0
	AddressOfPayload: .word 0
	
	Err_string: .asciiz "ERROR\n"
	IPv4_string: .asciiz "IPv4\n"
	IPv4_unsupported_string: .asciiz "Unsupported:IPv"
	comma: .asciiz ","
	period: .asciiz "."
	newline: .asciiz "\n"
	

	
	
	
	
	
	
