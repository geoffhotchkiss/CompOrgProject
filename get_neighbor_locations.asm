	.text 
	.align 2

	.globl rowcol_to_num

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


