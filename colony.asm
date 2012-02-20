
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
	.asciiz    "**********************\n"
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
				sw 			$s6, 24($sp)		# location of the neighbors array
				sw 			$s5, 20($sp)		# location of next generation array
				sw 			$s4, 16($sp)		# location of current generation array
				sw 			$s3, 12($sp)		# number of cells alive in B
        sw      $s2, 8($sp)			# number of cells alive in A
        sw      $s1, 4($sp)			# number of generations
        sw      $s0, 0($sp)			# board size

				la	$a0, into_msg
        jal	print_string
				.globl ask_for_board_size_init
				jal ask_for_board_size_init
				move $s0, $v0						# s0 is board size

				.globl allocate_mem
				mul $a0, $s0, $s0				
				jal allocate_mem
				move $s4, $v0						# s4 is location of current generation array
				mul $a0, $s0, $s0				
				jal allocate_mem
				move $s5, $v0						# s5 is location of next generation array

				# initialize the arrays
				move $a0, $s4
				mul $a1, $s0, $s0
				jal init_array
				move $a0, $s5
				mul $a1, $s0, $s0
				jal init_array

				.globl ask_for_num_generations_init
				jal ask_for_num_generations_init
				move $s1, $v0						# s1 is number of generations
				move $a0, $s0
				.globl ask_for_num_live_cells_A_init
				jal ask_for_num_live_cells_A_init
				move $s2, $v0						# s2 is number of cells alive in A

				.globl ask_for_starting_locations_init
				move $a0, $s4
				move $a1, $s2
				move $a2, $s0
				li $a3, 1
				jal ask_for_starting_locations_init

				.globl ask_for_num_live_cells_B_init
				move $a0, $s0
				jal ask_for_num_live_cells_B_init
				move $s3, $v0						# s3 is number of cells alive in B

				move $a0, $s4
				move $a1, $s3
				move $a2, $s0
				li $a3, 2
				jal ask_for_starting_locations_init

				la $a0, newline
				jal print_string
				la $a0, newline
				jal print_string

				# make array for storing neighbor locations
				li $a0, 8
				jal allocate_mem
				move $s6, $v0

				li $a0, 1
				li $a1, 1
				move $a2, $s0
				move $a3, $s6
				jal get_neighbor_locations
				move $t0, $v0

				# li $a0, 1
				# li $a1, 1
				# move $a2, $s0
				# jal rowcol_to_num
				# move $t0, $v0
				# move $a0, $t0
				# jal print_number
				# move $a0, $t0
				# li $a1, 2
				# move $a2, $s4
				# jal set


print_generations:
				la $a0, start_generation_string
				jal print_string
				move $a0, $zero
				jal print_number
				la $a0, end_generation_string
				jal print_string
				.globl newline
				la $a0, newline
				jal print_string

				.globl print_board
				move $a0, $s4
				move $a1, $s0
				jal print_board
				beq $s1, $zero, print_generations_skip_newline
				la $a0, newline
				jal print_string

print_generations_skip_newline:
				li $t4, 1
				addi $t5, $s1, 1

print_generations_loop:
				beq $t4, $t5, print_generations_done
				la $a0, start_generation_string
				jal print_string
				move $a0, $t4
				jal print_number
				la $a0, end_generation_string
				jal print_string
				la $a0, newline
				jal print_string

				# get neighbors
				# count neighbors
				# set alive or dead on second board
				move $t0, $s4
				move $s4, $s5
				move $s5, $t0
				move $a0, $s4
				move $a1, $s0
				jal print_board

				addi $t4, $t4, 1
				bne $t4, $t5, print_generations_loop_newline
				j print_generations_loop

print_generations_loop_newline:
				la $a0, newline
				jal print_string
				j print_generations_loop

print_generations_done:
				la $a0, newline
				jal print_string
				j exit_program

	.globl exit_program
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

# a0 is row
# a1 is col
# a2 is width of board
	.globl rowcol_to_num
rowcol_to_num:
				move $t0, $a2
				# addi $t0, $t0, -1
				mul $v0, $a0, $t0
				add $v0, $v0, $a1
				li $t0, 4
				mul $v0, $v0, $t0
				jr $ra

# a0 location to insert
# a1 value to insert
# a2 is location of array
	.globl set
set:
				add $t0, $a2, $a0
				sw $a1, 0($t0)
				jr $ra

# a0 location to get
# a1 array location
	.globl get
get: 
				add $t0, $a1, $a0
				lw $v0, 0($t0)
				jr $ra
				

	.globl init_array
# Initializes an array to all zeros
# a0 location of array to initialize
# a1 size of array
init_array:
			move $t0, $a0
			move $t1, $a1
			li $t3, 1

init_array_loop:
			beq $t2, $t1, init_array_done
			sw $zero, 0($t0)
			addi $t0, $t0, 4
			addi $t2, $t2, 1
			j init_array_loop

init_array_done:
			jr $ra
	

# a0 is row
# a1 is col
# a2 is width of board
# a3 is location of where to store
	.globl get_neighbor_locations
get_neighbor_locations:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0		# row
	move $s1, $a1		# col
	move $s2, $a2		# width
	move $s3, $a3		# location

	# -1, -1
	addi $t0, $s0, -1
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, -1
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)
	addi $s3, $s3, 4

	# -1, 0
	addi $t0, $s0, -1
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, 0
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)
	addi $s3, $s3, 4


	# -1, 1
	addi $t0, $s0, -1
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, 1
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)
	addi $s3, $s3, 4

	# 0, -1
	addi $t0, $s0, 0
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, -1
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)
	addi $s3, $s3, 4

	# 0, 1
	addi $t0, $s0, 0
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, 1
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)
	addi $s3, $s3, 4
	
	# 1, -1
	addi $t0, $s0, 1
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, -1
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)
	addi $s3, $s3, 4

	# 1, 0
	addi $t0, $s0, 1
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, 0
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)
	addi $s3, $s3, 4

	# 1, 1
	addi $t0, $s0, 1
	add $t0, $t0, $s2
	rem $t0, $t0, $s2
	addi $t1, $s1, 1
	add $t1, $t1, $s2
	rem $t1, $t1, $s2
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	jal rowcol_to_num
	sw $v0, 0($s3)

get_neighbor_locations_done:
	addi $s3, $s3, -28
	move $v0, $s3
	lw $ra, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 20
	jr $ra

# a0 - location of current generation
# a1 - location of next generation
# a2 - width
get_next_generation:
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)


get_next_generation_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, -28
	jr $ra


