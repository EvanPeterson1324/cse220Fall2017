# hw3_main1.asm


# Constants
.data
bunny:      .asciiz "Bunny"
funny:      .asciiz "Funny"
sun:        .asciiz "SuN"
mon:        .asciiz "Mon"
cat:        .asciiz "Cat"
toad:       .asciiz "Toad"
numberString: .asciiz "1234567890"
one:        .asciiz "1"
emptyStr:   .asciiz ""

.text
.globl _start


####################################################################
# This is the "main" of your program; Everything starts here.
####################################################################

_start:
	la $a0, emptyStr
	la $a1, one
	li $a2, 0
	li $a3, 1
	jal editDistance
	
	move $a0, $v0
	li $v0, 1
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

.include "hw3.asm"
