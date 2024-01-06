.include "macrolib.asm"


.text
li t2 0
li t1 0xffff0010
li t0 2
test_program:
	add a0 t2 zero
	rem t3 t2 t0
	add a1 t1 t3
	jal setDigit
	addi t2 t2 1
	
	li a0 1000
	li a7 32
	ecall
	
	li t3 20
	ble t2 t3 test_program
	j end
	
end:
exit