.include "macrolib.asm"

.global testing

.data
	# Различные тестовые данные
	.align 2
	mas1: .word 1,2,3,4,5
	correct_mas1: .word 1,2,3,4,5
	real_arr1: .space 20
	
	mas2: .word 12,12,12,13, 15
	correct_mas2: .word 13, 15
	real_arr2: .space 8
	
	mas3: .word 12,12, 12, 12, 12
	correct_mas3: .word 
	real_arr3: .space 0
	
	mas4: .word 1, -10, 100, 100, 954, 954, 1, 15
	correct_mas4: .word 1, -10, 100, 100, 1, 15
	real_arr4: .space 32
	
	mas5: .word -100, 100, -100, 100, -100, 100, 5
	correct_mas5: .word -100, -100, -100, 5
	real_arr5: .space 16
	
	
.text
testing:
	push(ra) # Запоминаем регистр возврата
	test(mas1, 5, real_arr1, 6, correct_mas1, 5) # кейс, когда ничего не удаляется
	test(mas2, 5, real_arr2, 12, correct_mas2, 2) # кейс когда удаляется большинство
	test(mas3, 5, real_arr3, 12, correct_mas3, 0) # кейс, когда удаляется все
	test(mas4, 8, real_arr4, 954, correct_mas4, 6) # кейс, когда удаляется из середины
	test(mas5, 7, real_arr5, 100, correct_mas5, 4) # кейс 2, когда удаляется через один
	
	pop(ra) # Удаляем регистр возврата
	ret
