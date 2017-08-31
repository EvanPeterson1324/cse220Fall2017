# Hello World program with user input

.text

main:
	# Print greeting
	li $v0 4			# 4 indicates print string
	la $a0 greeting			# load the memory address into $a0 from the label "greeting"
	syscall				# print the string from $a0
	
	# Display prompt
	li $v0 4			# 4 indicates we are printing a string
	la $a0 prompt1			# load the memory address into $a0 from the label "prompt1"
	syscall				# print the string from $a0
	
	# Read integer
	li $v0 5			# 5 indicates we will reading an integer
	syscall				# read an integer from the user and store it in $v0
	
	# Compute new age
	move $t1 $v0			# Move the value of $v0 into $t1 (the user input)
	addi $t1 $t1 5			# Increment the user input by 5
	
	# Print output
	li $v0 4			# 4 indicates printing a string
	la $a0 output1			# Load the address of the label, "output1", into $a0
	syscall				# Print the string  in $a0
	li $v0 1			# 1 indicates printing an integer
	move $a0 $t1			# move the value of $t1 into $a0
	syscall				# print the integer
	
	# Terminate program
	li $v0 10			# 10 indicates we will terminate the program
	syscall				# terminate the program
	
	
	
.data

greeting: .asciiz "Hello World!\n"
prompt1: .asciiz "Enter your age: "
output1: .asciiz "Your age in 5 years is: "
	
	
	