PRINT_INT	= 1		# code for syscall to print integer
PRINT_STRING	= 4		# code for syscall to print a string
READ_INT	= 5		# code for syscall to read an int
MIN_BOARD_SIZE = 4
MAX_BOARD_SIZE = 30
MIN_GENERATIONS = 0
MAX_GENERATIONS = 20
MIN_CELLS_ALIVE = 0

	.data

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
	.asciiz "\nStart entering locations\n"
enter_locations_error_string:
	.asciiz "\nERROR: illegal point location\n"

	.text
	.align	2
	.globl 	ask_for_board_size_init
	.globl 	ask_for_num_generations_init
	.globl 	ask_for_num_live_cells_A_init
	.globl 	ask_for_num_live_cells_B_init
	.globl 	ask_for_starting_locations_init
	.globl 	print_string
	.globl 	print_number

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

ask_for_num_live_cells_B_init:
				move $t2, $a0									# t2 is board size
				move $t0, $ra									# store ra go returning to main
				la $a0, num_live_cells_B_string
				jal print_string
				move $ra, $t0									# retrive ra to return to main

ask_for_num_live_cells_B:
				la	$v0, READ_INT
				syscall
				move	$t0, $v0								# t0 is number of cells alive
				li $t1, MIN_CELLS_ALIVE				# checking number of cells alive
				blt $t0, $t1, ask_for_num_live_cells_B_again
				mul $t1, $t2, $t2
				bgt $t0, $t1, ask_for_num_live_cells_B_again
				move $v0, $t0									# number of cells alive is good, so return
				jr $ra

ask_for_num_live_cells_B_again:
				move $t0, $ra									# store ra go returning to main
				la $a0, num_live_cells_error_string
				jal print_string
				move $ra, $t0									# retrive ra to return to main
				j ask_for_num_live_cells_B


# a0 is board location
# a1 is number alive
# a2 is width
# a3 is what to place
ask_for_starting_locations_init:
				addi $sp, $sp, -28
				sw $s0, 0($sp)
				sw $s1, 4($sp)
				sw $s2, 8($sp)
				sw $s3, 12($sp)
				sw $s4, 16($sp)
				sw $s5, 20($sp)
				sw $ra, 24($sp)
				move $s0, $a0		# board location
				move $s1, $a1		# number alive
				move $s2, $a2		# width
				move $s3, $a3		# what to place
				la $a0, enter_locations_string
				jal print_string

				li $s4, 0
				move $s5, $s1

ask_for_starting_locations_loop:
				beq $s4, $s5, ask_for_starting_locations_done
				la	$v0, READ_INT
				syscall
				move	$t2, $v0

				la	$v0, READ_INT
				syscall
				move	$t3, $v0

				blt $t2, $zero, ask_for_starting_locations_error
				bge $t2, $s2, ask_for_starting_locations_error
				blt $t3, $zero, ask_for_starting_locations_error
				bge $t3, $s2, ask_for_starting_locations_error
				move $a0, $t2
				move $a1, $t3
				move $a2, $s2
				.globl rowcol_to_num
				jal rowcol_to_num
				move $t0, $v0
				move $t2, $t0
				# move $a0, $t0
				# jal print_number
				move $a0, $t0
				move $a1, $s0
				.globl get
				jal get
				move $t0, $v0
				bne $t0, $zero, ask_for_starting_locations_error
				move $a0, $t2
				move $a1, $s3
				move $a2, $s0
				.globl set
				jal set

				addi $s4, $s4, 1
				j ask_for_starting_locations_loop

ask_for_starting_locations_error:
				la $a0, enter_locations_error_string
				jal print_string
				lw $s0, 0($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)
				lw $s3, 12($sp)
				lw $s4, 16($sp)
				lw $s5, 20($sp)
				lw $ra, 24($sp)
				addi $sp, $sp, 28
				.globl exit_program
				j exit_program

ask_for_starting_locations_done:
				lw $s0, 0($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)
				lw $s3, 12($sp)
				lw $s4, 16($sp)
				lw $s5, 20($sp)
				lw $ra, 24($sp)
				addi $sp, $sp, 28
				jr $ra

