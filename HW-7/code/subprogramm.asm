.include "macrolib.asm"

.global setDigit

.text
# Вход: в регистре a0 цифра, в регистре a1 - левый или правый индикатор
setDigit:
	li t4 10

	lui t6 0xffff0  
	j getNumberUsingRegister
	
	afterGettingNumber:
	li t5 0x80
	mul t3 t3 t5
	or a0 a0 t3
	
	li t5 0xffff0011
	beq a1 t5 left
	li t5 0xffff0010
	beq a1 t5 right

	left:
	sb  a0 0x11(t6)
	ret
	
	right:
	sb  a0 0x10(t6)
	ret

    
getNumberUsingRegister:
	li t5 10
	li t3 0
	bge a0 t5 modifyNumber
	j instruct
	
	modifyNumber:
	rem a0 a0 t5
	li t3 1
	j instruct
	
	instruct:
	li t5 0
	beq a0 t5 zero_noDot
	li t5 1
	beq a0 t5 one_noDot
	li t5 2
	beq a0 t5 two_noDot
	li t5 3
	beq a0 t5 three_noDot
	li t5 4
	beq a0 t5 four_noDot
	li t5 5
	beq a0 t5 five_noDot
	li t5 6
	beq a0 t5 six_noDot
	li t5 7
	beq a0 t5 seven_noDot
	li t5 8
	beq a0 t5 eight_noDot
	li t5 9
	beq a0 t5 nine_noDot
	
zero_noDot:
	li a0 0x3f
	j afterGettingNumber
one_noDot:
	li a0 0x6
	j afterGettingNumber
two_noDot:
	li a0 0x5b
	j afterGettingNumber
three_noDot:
	li a0 0x4f
	j afterGettingNumber
four_noDot:
	li a0 0x66
	j afterGettingNumber
five_noDot:
	li a0 0x6d
	j afterGettingNumber
six_noDot:
	li a0 0x7d
	j afterGettingNumber
seven_noDot:
	li a0 0x7
	j afterGettingNumber
eight_noDot:
	li a0 0x7f
	j afterGettingNumber
nine_noDot:
	li a0 0x6f
	j afterGettingNumber