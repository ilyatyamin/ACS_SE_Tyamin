# Печать целого числа x
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

# Ввод целого числа с консоли в регистр a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro


# Ввод целого числа с консоли в указанный регистр, НО НЕ a0
.macro read_int(%x)
   push	(a0)
   li a7, 5
   ecall
   mv %x, a0
   pop	(a0)
.end_macro

# Печать массива x длины y
.macro print_mas(%x, %y)
.text
   li t6 0
   j loop_print_mas
   
   loop_print_mas:
   beq t6 %y end_print_mas
   lw t5 (%x)
   addi %x %x 4
   addi t6 t6 1
   print_int(t5)
   print_char(' ')
   j loop_print_mas
   
   end_print_mas:
.end_macro

# Печать строки x
   .macro print_string (%x)
   .data
str:
   .asciz %x
   .text
   push (a0)
   li a7, 4
   la a0, str
   ecall
   pop	(a0)
   .end_macro

# Печать символа x
   .macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
   .end_macro

# Перевод на новую строку
   .macro newline
   print_char('\n')
   .end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# Сохранение заданного регистра на стеке (команда push)
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр (команда pop)
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

# Сравнение двух массивов 
.macro compare_arrays(%arr1, %num_arr1, %arr2, %num_arr2)
	push(ra)
	la t3 %arr1
	la t4 %arr2
	li t5 %num_arr1
	mv t6 %num_arr2
	bne t5 t6 not_equal
	li t6 0
	j comp
	
	comp:
	bgeu t6 t5 they_equal
	lw t1 (t3)
	lw t2 (t4)
	addi t6 t6 1
	addi t3 t3 4
	addi t4 t4 4
	bne t1 t2 not_equal
	j comp
	
	
	they_equal:
	pop(ra)
	print_string("\nOK! The arrays are equal \n")
	j end_compare_mass
	
	not_equal:
	pop(ra)
	print_string("\nIt's not equal!\n")
	j end_compare_mass
	
	end_compare_mass:
.end_macro

# Макрос для тестировки
.macro test(%input, %num_input, %output, %number, %correct, %num_correct)
	# ИМИТАЦИЯ работы main
	# Аналогично работе main
	la s1 %input
	li s0 %num_input
	li s2 %number
	print_string("\nTEST\n")
	print_string("Тестирующий массив: ")
	print_mas(s1, s0) 
	print_string("\nЧисло для удаления: ")
	print_int(s2)
	print_string("\nКакой должен получиться: ")
	la s3 %correct
	li s5 %num_correct
	print_mas(s3, s5)
	newline
	
	la s1 %input
	la s3 %output
	push(ra)
	push(s0)
	push(s2)
	jal make_new_array
	pop(s4)

	
	print_string("Массив после обработки: ")
	
	print_mas(s3, s4) 
	
	la s1 %input
	la s3 %output
	compare_arrays(%correct, %num_correct, %output, s4)
	
	pop(ra)
	newline
	newline
.end_macro 

