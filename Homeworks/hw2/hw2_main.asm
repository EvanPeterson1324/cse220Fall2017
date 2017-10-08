# hw2_main1.asm
# This file is NOT part of your homework 2 submission.
# Any changes to this file WILL NOT BE GRADED.
#
# We encourage you to modify this file  and/or make your own mains to test different inputs

.include "hw2_examples.asm"

# Constants
.data
newline:  .asciiz "\n"
comma:    .asciiz ", "
testchar: .byte '9'
success: .asciiz "Success: "
bytes: .asciiz "Bytes: "
packetNumber_1: .asciiz "packet number "
packetNumber_2: .asciiz " has invalid checksum"

.text
.globl _start


####################################################################
# This is the "main" of your program; Everything starts here.
####################################################################

_start:
		j toPrintDatagram
		#j toProcessDatagram
	##################
	# replace1st
	##################
	#la $a0, FF
	#li $a1, 0x80
	#li $a2,	0xFF
	# jal replace1st

	# print return value
	#move $a0, $v0
	#li $v0, 34
	#syscall
	#li $v0, 4
	#la $a0, newline
	#syscall
	
	# TESTING 1st FUNCTION
	#li $v0, 10
	#syscall

	##################
	# printStringArray
	##################
	la $a0, sarray_ex1
	li $a1, 0
	li $a2, 2
	li $a3, 4
	jal printStringArray

	# print return value
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	
	# Testing Print string array
	li $v0, 10
	syscall
	
	##################
	# verifyIPv4Checksum
	##################
	#la $a0, invalid_header_ex1
	#jal verifyIPv4Checksum

	# print return value
	#move $a0, $v0
	#li $v0, 34
	#syscall
	#li $v0, 4
	#la $a0, newline
	#syscall
	
	#li $v0, 10
	#syscall
	
	
	j toPrintDatagram
	##################
	# extractData
	##################
	
	la $a0, pktArray_ex4
	li $a1, 4
	la $a2, msg_buffer
	jal extractData

	# print return value, success
	move $t0, $v0
	li $v0, 4
	la $a0, success
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	beqz $t0, Print_Bytes
	li $v0, 4
	la $a0, packetNumber_1
	syscall
	li $v0, 1
	move $a0, $v1
	syscall
	li $v0, 4
	la $a0, packetNumber_2
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 10
	syscall
	j toProcessDatagram

	Print_Bytes:
		li $v0, 4
		la $a0, bytes
		syscall
		li $v0, 1
		move $a0, $v1
		syscall
		li $v0, 4
		la $a0, newline
		syscall
	li $v0, 10
	syscall
toProcessDatagram:
	##################
	# processDatagram
	##################
	la $a0, msg
	li $a1, 8
	la $a2, abcArray
	jal processDatagram

	# print return value
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	# Exit the program
	li $v0, 10
	syscall
	#print abcArray addresses

	##################
	# printDatagram
	##################
	toPrintDatagram:
	la $a0, pktArray_ex4
	li $a1, 4
	la $a2, msg_buffer
	la $a3, abcArray
	jal printDatagram

	# Ouptut:
	# I'm a shooting star leaping through the sky
	# Like a tiger defying the laws of gravity
	# I'm a racing car passing by like Lady Godiva
	#
	# print return value
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall

	# Exit the program
	li $v0, 10
	syscall

###################################################################
# End of MAIN program
####################################################################


#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw2.asm"
