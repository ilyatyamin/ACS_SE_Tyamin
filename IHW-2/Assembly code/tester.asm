.include "macrolib.asm"

.global testing

.data
	num_1: .word 0
	res_1: .double 0.0
	
	num_2: .word 8
	res_2: .double 2.0
	
	num_3: .word -8
	res_3: .double -2.0
	
	num_4: .word 15
	res_4: .double 2.4662
	
	num_5: .word -91
	res_5: .double -4.4979
	
.text
testing:
	push(ra) # Запоминаем регистр возврата
	
	print_string("Тесты:")
	newline
	test(num_1, res_1)
	newline
	
	test(num_2, res_2)
	newline
	
	test(num_3, res_3)
	newline
	
	test(num_4, res_4)
	newline
	
	test(num_5, res_5)
	newline
	
	pop(ra) # Удаляем регистр возврата
	ret
