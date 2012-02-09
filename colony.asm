
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
board_size_string:
	.asciiz "\nEnter board size: "
board_size_error_string:
	.asciiz "\nWARNING: illegal board size, try again: "
num_generations_string:
	.asciiz "\nEnter number of generations to run: "
num_generations_error_string:
	.asciiz "\nWARNING: illegal number of generations, try again: "
num_live_cells_A_string:
	.asciiz "\nEnter number of live cells for colony A: "
num_live_cells_B_string:
	.asciiz "\nEnter number of live cells for colony B: "
num_live_cells_error_string:
	.asciiz "\nWARNING: illegal number of live cells, try again: "
enter_locations_string:
	.asciiz "\nStart entering locations"
enter_locations_error_string:
	.asciiz "\nERROR: illegal point location"
start_generation_string:
	.asciiz "\n====    GENERATION "
end_generation_string: 
	.asciiz "    ===="
input_error:
	.asciiz "\nError with previous input, try again.\n"

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
				jal ask_for_board_size_init
				move $s0, $v0						# s0 is board size
				jal ask_for_num_generations_init
				move $s1, $v0						# s1 is number of generations
				move $a0, $s0
				jal ask_for_num_live_cells_A_init
				move $s2, $v0
				j exit_program

ask_for_board_size_init:
				move $t0, $ra									# store ra go returning to main
				la $a0, board_size_string
				jal print_string
				move $ra, $t0									# retrive ra to return to main

ask_for_board_size:
				la	$v0, READ_INT
				syscall
				move	$t0, $v0								# t0 is board size
				li $t1, MIN_BOARD_SIZE				# checking board size
				blt $t0, $t1, ask_board_size_again
				li $t1, MAX_BOARD_SIZE
				bgt $t0, $t1, ask_board_size_again
				move $v0, $t0									# board size is good, so return
				jr $ra

ask_board_size_again:
				move $t4, $ra									# ask the user again, store ra
				la $a0, board_size_error_string
				jal print_string
				move $ra, $t4									# retrive ra and read again
				j ask_for_board_size

ask_for_num_generations_init:
				move $t0, $ra									# store ra go returning to main
				la $a0, num_generations_string
				jal print_string
				move $ra, $t0									# retrive ra to return to main

ask_for_num_generations:
				la	$v0, READ_INT
				syscall
				move	$t0, $v0								# t0 is generations size
				li $t1, MIN_GENERATIONS 			# checking generations size
				blt $t0, $t1, ask_for_num_generations_again
				li $t1, MAX_GENERATIONS
				bgt $t0, $t1, ask_for_num_generations_again
				move $v0, $t0									# generations size is good, so return
				jr $ra

ask_for_num_generations_again:
				move $t0, $ra									# store ra go returning to main
				la $a0, num_generations_error_string
				jal print_string
				move $ra, $t0									# retrive ra to return to main
				j ask_for_num_generations

ask_for_num_live_cells_A_init:
				move $t2, $a0									# t2 is board size
				move $t0, $ra									# store ra go returning to main
				la $a0, num_live_cells_A_string
				jal print_string
				move $ra, $t0									# retrive ra to return to main

ask_for_num_live_cells_A:
				la	$v0, READ_INT
				syscall
				move	$t0, $v0								# t0 is number of cells alive
				li $t1, MIN_CELLS_ALIVE				# checking number of cells alive
				blt $t0, $t1, ask_for_num_live_cells_A_again
				mul $t1, $t2, $t2
				bgt $t0, $t1, ask_for_num_live_cells_A_again
				move $v0, $t0									# number of cells alive is good, so return
				jr $ra

ask_for_num_live_cells_A_again:
				move $t0, $ra									# store ra go returning to main
				la $a0, num_live_cells_error_string
				jal print_string
				move $ra, $t0									# retrive ra to return to main
				j ask_for_num_live_cells_A

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
        addi    $sp, $sp, 16
        jr      $ra

#
# Name;		print_number 
#
# Description:	This routine reads a number then a newline to stdout
# Arguments:	a0:  the number to print
# Returns:	nothing
#
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
print_string:

        li 	$v0, PRINT_STRING
        syscall			#print a0

        jr      $ra

