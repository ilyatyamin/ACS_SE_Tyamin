.include "macrolib.asm"
.global text_handler, create_str

.data
	not_found: .asciz "NOT FOUND"

.text
# Входные данные: в регистре a0 текст, в регистре a1 - число N, в регистре a2 - кол-во символов в тексте
# Выходные данные: в регистре a4 индекс начала последовательности, в регистре a5 индекс конца последовательности.
# Если последовательность не найдена, то возвращается -1 -1
text_handler:	
	li t1 1 # t1 = nakop
	# В регистре t0 на данный момент сколько символов в строке
	addi t4 t0 -1 # it = len - 1
	addi t0 t0 -2 # i = len - 2 => предпоследний символ строки
	
	li a6 0
	j loop_handler
	
	loop_handler:
	bltz t0 false_ret
	# формируем str[i]
	add a5 t0 a0
	lb t2 (a5) # t2 = *(a0 + t0)
	
	# формируем str[i+1]
	addi a5 a5 1
	lb t3 (a5) # t3 = *(a0 + t0)
	
	blt t2 t3 less_symb
	mv t4 t0 # it = i
	li t1 1 # nakop = 1
	addi t0 t0 -1
	j loop_handler
	
	less_symb:
	addi t1 t1 1
	beq t1 a1 found_ret
	addi t0 t0 -1
	j loop_handler
	
	false_ret:
	li a4 -1
	li a5 -1
	ret
	
	found_ret:
	mv a4 t0
	mv a5 t4
	ret
	
		
# В регистре a1 - буфер для текста, в a2, a3 - индексы, a4 - исходный текст
# Выход: a5 - количество записанных символов
create_str:
	li t0 0
	add t1 a2 a3
	li t2 -2
	beq t1 t2 nf
	add t2 a4 a2 # начало
	li t5 5
	j loop_create
	
	loop_create:
	lb t3 (t2)
	beq t0 t5 end_creation
	sb t3 (a1)
	addi a1 a1 1
	addi t0 t0 1
	addi t2 t2 1
	j loop_create
	
nf:
	la t5 not_found
	li t6 11
	str_copy(t5, a1, t6)
	ret
	
end_creation:
	mv a5 t0
	ret
