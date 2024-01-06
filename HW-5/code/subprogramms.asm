.include "macrolib.asm"

.global input_num_elements, input_nums, initial_sum, data_output
	.text

input_num_elements:
.text
# Запрашиваем число элементов
	read_int_a0
	mv t0 a0 # регистр t0 = кол-во чисел
	j check_num_borders
	
	check_num_borders:
	li t3 1 # левая граница допустимого N
	li t4 10 # правая граница допустимого N
	blt a0 t3 not_correct_numb_elements
	bgt a0 t4 not_correct_numb_elements
	ret
	
	not_correct_numb_elements:
	print_string("Введено неверное число! Введите еще раз ")
	j input_num_elements
	
input_nums:
	bgeu t2 t0 all_is_input
	print_string("Введите число: ")
	read_int_a0
	sw a0 (t5)
	addi t5 t5 4 # шаг вперед
	addi t2 t2 1
	j input_nums
	
	all_is_input:
	ret


initial_sum:
	mv t1 zero # накопленная сумма
	mv t2 zero 
	li t6 0 # количество удавшихся в просуммировании чисел
	j sum
	
	sum:
	bge t2 t0 initial_sum_ret
	addi t2 t2 1
	j check_overflow
	
	
	check_overflow:
	lw t4 (t5) # в регистр t4 грузим текущее число
	beqz t1 plus
	bgez t1 check_overflow_plus
	bltz t1 check_overflow_minus
		check_overflow_plus:
		sub t3 s3 t1 # порог(+) - им сумма
		bge t3 t4 plus
		j sum
		
		check_overflow_minus:
		sub t3 s4 t1 # порог(-) - им разность
		ble t3 t4 plus
		j sum
	
		plus:
		add t1 t1 t4
		addi t6 t6 1
		addi t5 t5 4
		j sum
		
	initial_sum_ret:
		ret
		
data_output:
	print_string("Накопленная сумма: ")
	print_int(t1)
	newline
	print_string("Удалось просуммировать чисел: ")
	print_int(t6)
	ret