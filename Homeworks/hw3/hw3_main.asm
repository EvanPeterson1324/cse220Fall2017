# hw3_main1.asm

.include "hw3_examples.asm"

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
	#la $a0, emptyStr
	#la $a1, one
	#li $a2, 0
	#li $a3, 1
	#jal editDistance
	
	
	# Tests
	# 1. pm_checksum,1,msg_buffer,200 		---> Good!  ---> (-1,0)
	# 2. pm_flagerr,1,msg_buffer,200  		---> Good!  ---> (-1,-1)
	# 3. pm_3pkterr,3,msg_buffer,200  		---> Good!  ---> (-1,-1)
	# 4. pm_1pkt,1,msg_buffer,200	  		---> Good!  ---> (0, 7)
	# 5. queen_all,5,msg_buffer,80    		---> Good!  ---> (0, 153)
	# 6. queen_all_unsorted,5,msg_buffer,80		---> Good!  ---> (0, 153)
	# 7. marypoppins,4,msg_buffer,100		---> Good!  ---> (0, 190)
	# 8. marypoppins_unsorted,4,msg_buffer,100	---> Good!  ---> (0, 190)
	# 9. queen_holes,4,msg_buffer,80		---> Good!  ---> (0, 153)
	# 10. queen_holes_unsorted,4,msg_buffer,80	---> Good!  ---> (0, 153)
	
	la $a0, pm_3pkterr
	li $a1, 3
	la $a2, msg_buffer
	li $a3, 200
	jal extractUnorderedData
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	move $a0, $v1
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
