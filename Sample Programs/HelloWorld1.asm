# Hello World Program

.text

main:
	# Prints a string on the screen
	li $v0 4
	la $a0 Greeting
	syscall
	
	# Terminates the program
	li $v0 10
	syscall
	
.data
Greeting: .asciiz "Hello World!\n"