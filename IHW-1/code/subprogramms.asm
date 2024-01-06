.include "macrolib.asm"

.global input_num_elements, read_mas, make_new_array

.text

input_num_elements:
	push(ra) # Тут я показываю, что умею пользоваться стеком
	# Запрашиваем число элементов
	read_int(t0)
	j check_num_borders
	
	check_num_borders:
	li t3 1 # Левая граница допустимого N
	li t4 10 # Правая граница допустимого N
	blt t0 t3 not_correct_numb_elements
	bgt t0 t4 not_correct_numb_elements
	pop(ra)
	mv a1 t0 # По правилам выходные данные в регистрах a0-a1
	ret
	
	not_correct_numb_elements:
	print_string("Введено неверное число! Введите еще раз ")
	j input_num_elements

# Подпрограмма, считывающая массив
read_mas:
	pop(t1) # s0, передали через стек
	push(ra) # Добавляем в стек текущий регистр возврата
	
	mv t3 s1
	li t2 0 # Счетчик i
	j loop
	loop:
	bgeu t2 t1 end # t2 >= t1 -> end
	print_string("Введите число: ")
	read_int_a0 # считываю число в регистр a0
	sw a0 (t3) 
	addi t3 t3 4 # шаг вперед
	addi t2 t2 1
	j loop
	
	end:
	pop(ra) # Восстаналиваем регистр возврата
	ret
	
make_new_array:
	# Логика такова: если число не X, то вставляем в массив, иначе нет
	pop(t0) # t0 - число X со стека
	pop(t1) # t1 - кол-во чисел в изначальном массиве со стека
	push(ra) # Добавляем в стек регистр возврата
	
	mv t5 s1 # t5 - УКАЗАТЕЛЬ на первый элемент старого массива
	mv t4 s3 # t4 - УКАЗАТЕЛЬ на первый элемент нового массива
	
	li t2 0 # кол-во считанных чисел с изначального массива
	li a1 0 # количество чисел в новом массиве
	j loop_new
	
	loop_new:
	bgeu t2 t1 new_arr_end
	
	lw t3 (t5) # выгружаем число с array
	addi t5 t5 4
	addi t2 t2 1
	bne t0 t3 add_numb # если числа не совпадают, то добавляем в массив, иначе нет
	j loop_new
	
	add_numb: # Если число ок, то добавляем его в стек
	addi a1 a1 1
	sw t3 (t4)
	addi t4 t4 4
	j loop_new
	
	new_arr_end:
	pop(ra) # Восстанавливаем регистр возврата
	push(a1) # Показываю, что я умею пользоваться стеком :)
	ret
	
	
	
