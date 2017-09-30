.data

######################################################
# Sample input(s)  replace1st
######################################################
FF: .asciiz "Funny Funny"
FBunny: .asciiz "Funny Bunny"
TabBunny: .asciiz "Funny\tBunny"


######################################################
# Sample input(s) printStringArray
######################################################
ILP: .asciiz "I\nlove\nprogramming",
SBU: .asciiz "Stony Brook"
FB: .asciiz "FarBeyond"
.align 2
sarray_ex1: .word SBU, CS, MIPS, ILP, FB
MIPS:.asciiz "MIPS is amazing!!",
CS: .asciiz "Computer Science",


######################################################
# Sample input(s) for verifyIPv4Checksum
######################################################
.align 2

valid_header_ex1: .word 0x45f0001f, 0xaabb8018, 0x64cc3454, 0x7f000801, 0x0a3264c8
.space 4
valid_header_ex2: .word 0x46210023, 0xccdd8018, 0xffaac11f, 0x82f5ba0a, 0x0a3264c8, 0xFFFFFFFF
.space 4
invalid_header_ex1: .word 0x46210023, 0xccdd8018, 0xffaac1ff, 0x82f5ba0a, 0x0a3264c8
.space 4
invalid_header_ex2: .word 0x46aa0020, 0x18184000, 0xff801331, 0x0a0aa519, 0x82ba0101, 0x789abcde
.space 4


######################################################
# Sample input(s) for extractData
######################################################

.align 2
msg_buffer:   .space 256

pktArray_ex1: .word 0x45CC0034, 0x7BCD4000, 0x7461066D, 0xC0A80102, 0xC0A80110,
                    0x73696854, 0x20736920, 0x69732061, 0x656c676e, 0x63617020,
                    0x2174656b, 0x6c65480a, 0x0a216f6c, 0xFFFFFFFF, 0xFFFFFFFF

pktArray_ex2: .word 0x45CC0023, 0x7BCD0000, 0x7461467E, 0xC0A80102, 0xC0A80110,
                    0x62620a61, 0x6363630a, 0x6464640a, 0xEE650a64, 0xEEEEEEEE,
                    0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE,
                    0x45CC0020, 0x7BCD800F, 0x7461C671, 0xC0A80102, 0xC0A80110,
                    0x65656565, 0x6666660a, 0x0a666666, 0xDDDDDDDD, 0xDDDDDDDD,
                    0xDDDDDDDD, 0xDDDDDDDD, 0xDDDDDDDD, 0xDDDDDDDD, 0xDDDDDDDD

pktArray_ex3: .word 0x45CC0031, 0x7BCD0000, 0x74614670, 0xC0A80102, 0xC0A80110,
                    0x206d2749, 0x68732061, 0x69746f6f, 0x7320676e, 0x20726174,
                    0x7061656c, 0x20676e69, 0xAAAAAA74, 0xAAAAAAAA, 0xAAAAAAAA,
                    0x45CC003C, 0x7BCD801D, 0x7461C647, 0xC0A80102, 0xC0A80110,
                    0x756f7268, 0x74206867, 0x73206568, 0x4c0a796b, 0x20656b69,
                    0x69742061, 0x20726567, 0x79666564, 0x20676e69, 0x20656874,
                    0x45CC002F, 0x7BCD8045, 0x7461C62C, 0xC0A80102, 0xC0A80110,
                    0x7377616c, 0x20666f20, 0x76617267, 0x0a797469, 0x206d2749,
                    0x61722061, 0xFF6e6963, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
                    0x45CC0036, 0x7BCD8060, 0x7461C60A, 0xC0A80102, 0xC0A80110,
                    0x61632067, 0x61702072, 0x6e697373, 0x79622067, 0x6b696c20,
                    0x614c2065, 0x47207964, 0x7669646f, 0xBBBB0a61, 0xBBBBBBBB

pktArray_ex4: .word 0x45CC0031, 0x7BCD0000, 0x74614670, 0xC0A80102, 0xC0A80110,
                    0x206d2749, 0x68732061, 0x69746f6f, 0x7320676e, 0x20726174,
                    0x7061656c, 0x20676e69, 0xAAAAAA74, 0xAAAAAAAA, 0xAAAAAAAA,
                    0x45CC003C, 0x7BCD801D, 0x7461C647, 0xC0A80102, 0xC0A80110,
                    0x756f7268, 0x74206867, 0x73206568, 0x4c0a796b, 0x20656b69,
                    0x69742061, 0x20726567, 0x79666564, 0x20676e69, 0x20656874,
                    0x45CC002F, 0x7BCD8045, 0x7461C633, 0xC0A80102, 0xC0A80110,
                    0x7377616c, 0x20666f20, 0x76617267, 0x0a797469, 0x206d2749,
                    0x61722061, 0xFF6e6963, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
                    0x45CC0036, 0x7BCD8060, 0x7461C60A, 0xC0A80102, 0xC0A80110,
                    0x61632067, 0x61702072, 0x6e697373, 0x79622067, 0x6b696c20,
                    0x614c2065, 0x47207964, 0x7669646f, 0xBBBB0a61, 0xBBBBBBBB



######################################################
# Sample input(s) for processDatagram
######################################################

msg: .asciiz "a\nbb\nccc\ndddd\neeeee\nffffff\n"
msg2: .asciiz "hi\n\nhowareyou?\n"
msg3: .asciiz "helloworld"
     .word 0x40404040
abcArray: .word 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF
.space 20

