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
	srl $t4, $t4, 4
	bne $t3, $t2, unsupportedVersion	# if the Version Number is NOT 4, branch
	
	la $a0, IPv4_string			# Load the address of the string we want to print
	li $v0, 4				# Print String
	syscall
	j afterVersionCheck			# jump to the next operation
	
	unsupportedVersion:			# if the version is not 4, lets print out the string
	la $a0, IPv4_unsupported_string		# load the address of the IPv_ unsupported string 
	li $v0, 4
	###### Now we need to replace the '_' in the string with the version number that was given" ######
	syscall
	
	# Replace the unsupported version number with "4"
	sll $t3, $t2, 4	
	or $t5, $t3, $t4

	afterVersionCheck:
	
	
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
	IPv4_unsupported_string: .asciiz "Unsupported: IPv_\n"
	newline: .asciiz "\n"
	

	
	
	
	
	
	
