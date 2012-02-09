
PRINT_INT	= 1		# code for syscall to print integer
PRINT_STRING	= 4		# code for syscall to print a string
READ_INT	= 5		# code for syscall to read an int
MIN_BOARD_SIZE = 4
MAX_BOARD_SIZE = 30
MIN_GENERATIONS = 0
MAX_GENERATIONS = 20
MIN_CELLS_ALIVE = 0

#
# DATA DECLARATIONS
#
	.data
into_msg:
	.ascii   "\n**********************\n"
	.ascii	   "****    Colony    ****\n"
	.asciiz    "**********************\n\n"
newline:
	.asciiz "\n"
start_generation_string:
	.asciiz "\n====    GENERATION "
end_generation_string: 
	.asciiz "    ===="

#
# MAIN PROGRAM
#
	.text
	.align	2
	.globl	main

main:
        addi    $sp, $sp, -32# space for return address/doubleword aligned
        sw      $ra, 28($sp)    # store the ra on the stack
				sw 			$s6, 24($sp)
				sw 			$s5, 20($sp)
				sw 			$s4, 16($sp)
				sw 			$s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)

				la	$a0, into_msg
        jal	print_string
				.globl ask_for_board_size_init
				jal ask_for_board_size_init
				move $s0, $v0						# s0 is board size
				.globl ask_for_num_generations_init
				jal ask_for_num_generations_init
				move $s1, $v0						# s1 is number of generations
				move $a0, $s0
				.globl ask_for_num_live_cells_A_init
				jal ask_for_num_live_cells_A_init
				move $s2, $v0
				.globl ask_for_num_live_cells_B_init
				move $a0, $s0
				jal ask_for_num_live_cells_B_init
				move $s3, $v0

				j exit_program

exit_program:
        #
        # Now exit the program.
				#
        lw      $ra, 28($sp)	# clean up stack
				lw			$s6, 24($sp)
				lw			$s5, 20($sp)
				lw			$s4, 16($sp)
				lw			$s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, 32
        jr      $ra

#
# Name;		print_number 
#
# Description:	This routine reads a number then a newline to stdout
# Arguments:	a0:  the number to print
# Returns:	nothing
#
	.globl print_number
print_number:

        li 	$v0, PRINT_INT
        syscall			#print a0

        la	$a0, newline
        li      $v0, PRINT_STRING
        syscall			#print a newline

        jr      $ra

#
# Name;		print_string 
#
# Description:	This routine prints out a string pointed to by a0
# Arguments:	a0:  a pointer to the string to print
# Returns:	nothing
#
	.globl print_string
print_string:

        li 	$v0, PRINT_STRING
        syscall			#print a0

        jr      $ra

