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
	.asciiz "\nStart entering locations"
enter_locations_error_string:
	.asciiz "\nERROR: illegal point location"

	.text
	.align	2
	.globl 	ask_for_board_size_init
	.globl 	ask_for_num_generations_init
	.globl 	ask_for_num_live_cells_A_init
	.globl 	ask_for_num_live_cells_B_init
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

