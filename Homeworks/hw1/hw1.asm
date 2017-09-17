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
	# Remember that $a1 should still have the value of the starting address for our array of strings!
	# So we can actually loop over these addresses instead of doing them 1 by 1
# Where do the value

.macro validateIPDestArgs
	li $v0, 84	# Tells the system to use "atoi"
	li $v1, 0	# init $v1 = 0 to avoid junk
	li $t0, 0	# count
	
	la $a0, AddressOfIPDest3	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	la $a0, AddressOfIPDest2	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	la $a0, AddressOfIPDest1	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	la $a0, AddressOfIPDest0	# load the Addr
	lw $a0, 0($a0)			# test
	syscall				# converts to int value, $v1 = 0 if success, -1 if failure
	add $t0, $t0, $v1		# add the value of $v1 to the count
	
	bnez $t0, callPrintErrStr	# if the count isnt zero, we know something failed so print err and terminate:
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
	
	# Check the strings for each of the IPDest arguments
	validateIPDestArgs()	# Helper macro
	
	
	
	
	
	
	
	
	
	
	
	# Terminate the program
	li $v0, 10
	syscall
	
	# so we can use the macro in a beq instruction
	callPrintErrStr:
		printErrStr()
	
	
	
	
.data

# Include the file with the test case information
.include "./sample_asm/Header2.asm" 			# Change this line to test with other inputs

.align 2
	numargs: .word 0
	AddressOfIPDest3: .word 0
	AddressOfIPDest2: .word 0
	AddressOfIPDest1: .word 0
	AddressOfIPDest0: .word 0
	AddressOfBytesSent: .word 0
	AddressOfPayload: .word 0
	
	Err_string: .asciiz "ERROR\n"
	
	newline: .asciiz "\n"
	

	
	
	
	
	
	
