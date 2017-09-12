# Conditionals practice in MIPS

.text

.globl main

main:
	### If statement ex .1 ###
	# if (i ==j)
	#	f = g + h
	# f = f - i
	
	
	# $s0 = i, $s1 = j, $s2 = f, $s3 = g, $s4 = h
	
	li $s0, 10	# i
	li $s1, 6	# j
	li $s2, 3	# f
	li $s3, 1	# g
	li $s4, 2	# h
	
	bne $s0, $s1, subInstead	# if $s0 =! $s1 then we will do f = f - i
	add $s2, $s3, $s4		# f = g + h
	
	subInstead:
		sub $s2, $s2, $s0	# f = f - i
	
	# Print the integer value of $s2
	move $a0, $s2
	li $v0, 1
	syscall
	
	# Terminate the program
	li $v0, 10
	syscall
	
	