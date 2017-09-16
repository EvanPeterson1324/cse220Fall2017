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

.text
.globl main

main:
	load_args()	# Only do this once!
	# Start writing the program after the load-args macro is called	
	
	
	
	
	
	
	
	
	
	
	# Terminate the program
	li $v0, 10
	syscall
	
	
.data

# Include the file with the test case information
.include "./sample_asm/Header1.asm" 			# Change this line to test with other inputs

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
	

	
	
	
	
	
	