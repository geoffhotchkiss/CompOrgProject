# File:		allocate_mem.asm
# Author:	K. Reek
# Contributors:	P. White, W. Carithers
#								Geoff Hotchkiss
#
# Description:	Dynamic memory allocator.
#
# Revisions:	$Log$


# CONSTANTS
#
# syscall codes
PRINT_STRING = 	4
EXIT = 		10

	.data
	.align 2

#
# Memory for allocating up to 900*2 + extra space  words.
#
next:	
	.word	pool
pool:	
	.space 10000	# room for the "dynamic" memory allocation
pool_end:		# a marker for the end of the free space
	.word	0	

new_error:
	.asciiz	"Out of memory during memory allocating.\n"

	.text			# this is program code
	.align 2		# instructions must be on word boundaries

#
# Name:		allocate_mem:
#
# Description:	Allocate space from the pool of free memory.
#
# Arguments:	a0: the number of words to allocate
# Returns:	v0: the address of the newly allocated memory.
#

	.globl allocate_mem

allocate_mem:
	#
	# See if there is any space left in the pool.
	#

	lw	$t0, next	# pointer to next available byte
	li	$t9, 4		# calculate number of bytes to allocate
	mult	$a0, $t9
	mflo	$t9
	add	$t8, $t0, $t9	# figure out where next would be if we
				# allocate the space
	la	$t1, pool_end

	slt	$t2, $t8, $t1	# Compare next addr to end of pool
	bne	$t2, $zero, new_mem_ok	#  if less then still have space

	#
	# No space left; write error message and exit.
	#

	li 	$v0, PRINT_STRING	# print error message
	la 	$a0, new_error
	syscall	

	li 	$v0, EXIT		# terminate program
	syscall	

new_mem_ok:
	#
	# There is space available.  Allocate the next chunk of mem
	#

	move	$v0, $t0	# set up to return spot for new mem block
	li	$t9, 4		# calculate number of bytes to allocate
	mult	$a0, $t9
	mflo	$t9
	add	$t0, $t0, $t9	# Adjust pointer for the allocated space
	sw	$t0, next

	jr	$ra
