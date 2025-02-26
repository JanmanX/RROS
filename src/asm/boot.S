# boot.S

.option norvc
.section .data

.section .text.init
.global _start

_start:

	# Control Status Register Read
	csrr t0, mhartid # Hardware threads wait for IPI
	bnez t0, 3f

	csrw satp, zero

.option push
.option norelax

	la gp, _global_pointer

.option pop
	# Loads addresses of start of bss and end of bss
	la 	a0, _bss_start
	la	a1, _bss_end
	bgeu 	a0, a1, 2f

	# Zero out everything between _bss_start -> _bss_end
1:
	sd 	zero, (a0)
	addi 	a0, a0, 8
	bltu	a0, a1, 1b

3:
	wfi
	j 3b


	# Load stack pointer
	la 	sp, _stack

	# [12:11]: Machine mode. Reset to be sure
	# [7], [3]: Enable interrupts at a coarse level
	li	t0, (0b11 << 11) | (1 << 7) | (1 << 3)	
	csrw 	mstatus, t0

	# Set the "machine exception program counter" 
	la	t1, kmain
	csrw	mepc, t1

	# Machine trap vector
	la	t2, asm_trap_vector
	csrw	mtvec, t2

	# Todo: not sure about this?		
	li	t3, (1 << 3) | (1 << 7) | (1 << 11)
	csrw 	mie, t3
	la 	ra, 4f
	mret

4:
	wfi
	j 4b
