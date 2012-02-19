
	.data

space: 
	.asciiz " "
player_1_string:
	.asciiz "A"
player_2_string:
	.asciiz "B"
board_corner:
	.asciiz "+"
board_top_bottom:
	.asciiz "-"
board_side:
	.asciiz "|"
	.globl newline
newline:
	.asciiz "\n"

	.text
	.align 2


# a0 is location of board
# a1 is width
	.globl print_string
	.globl print_board
print_board:
				addi $sp, $sp, -12
				sw $s1, 8($sp)
				sw $s0, 4($sp)
				sw $ra, 0($sp)
				move $s1, $a1
				move $s0, $a0
				move $t0, $s1

print_board_top_start:
				la $a0, board_corner
				jal print_string
				
print_board_top:
				beq $t0, $zero, print_board_top_done
				la $a0, board_top_bottom
				jal print_string
				addi $t0, $t0, -1
				j print_board_top

print_board_top_done:
				la $a0, board_corner
				jal print_string
				la $a0, newline
				jal print_string
				move $t1, $zero

print_board_middle:
				beq $t1, $s1, print_board_bottom_start
				addi $t1, $t1, 1

print_board_row_start:
				la $a0, board_side
				jal print_string
				move $t0, $zero

print_board_row:
				beq $t0, $s1, print_board_row_end
				lw $a0, 0($s0)
				beq $a0, $zero, print_board_row_empty
				li $t2, 1
				beq $a0, $t2, print_board_row_player_1
				li $t2, 2
				beq $a0, $t2, print_board_row_player_2
				j print_board_done

print_board_row_empty:
				la $a0, space
				jal print_string
				j print_board_row_cont

print_board_row_player_1:
				la $a0, player_1_string
				jal print_string
				j print_board_row_cont

print_board_row_player_2:
				la $a0, player_2_string
				jal print_string
				j print_board_row_cont

print_board_row_cont:
				addi $s0, $s0, 4
				addi $t0, $t0, 1
				j print_board_row

print_board_row_end:
				la $a0, board_side
				jal print_string
				la $a0, newline
				jal print_string
				j print_board_middle

print_board_bottom_start:
				la $a0, board_corner
				jal print_string
				
print_board_bottom:
				beq $t0, $zero, print_board_bottom_done
				la $a0, board_top_bottom
				jal print_string
				addi $t0, $t0, -1
				j print_board_bottom

print_board_bottom_done:
				la $a0, board_corner
				jal print_string
				la $a0, newline
				jal print_string
				move $t1, $zero


print_board_done:
				lw $s1, 8($sp)
				lw $s0, 4($sp)	
				lw $ra, 0($sp)
				addi $sp, $sp, 12
				jr $ra

