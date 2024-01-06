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

.macro print_double(%x)
	li a7, 3
	fmv.d fa0 %x
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

# Макрос для копирования строки
.macro str_copy(%old_str, %memr, %num)
	li t0 0
	j loop_strn
	
loop_strn:
	beq t0 %num end # если превышаем кол-во нужных символов (число), то end
	lb t1 (%old_str)
	sb t1 (%memr) # сохраняем символ в новую строку
	
	beqz    t1 end # если строка закончилась, то выходим
	addi t0 t0 1 # переходим к следующему символу
	addi    %old_str %old_str 1
	addi    %memr %memr 1
	j loop_strn # цикл
end:
.end_macro

.macro min_elem(%elem1, %elem2)
	ble %elem1 %elem2 e1
	mv t0 %elem1
	j end_min
	
	e1:
	mv t0 %elem2
	j end_min
	
	end_min:
.end_macro

.macro allocate_heap_memory(%N)
	mv a0 %N
	li a7 9
	ecall
.end_macro

# Чтение строки с консоли / диалогового окна
.macro read_string_dialog(%message, %addr_buffer, %max_char_numb, %error)
	j get_str
	
	get_str:
	la a0 %message
	la a1 %addr_buffer
	li a2 %max_char_numb
	li a7 54
	ecall
	bne a1 zero not_correct
	j end
	
	not_correct:
	message_dialog(%error, 0)
	j get_str
	
	end:
.end_macro

.macro read_int_dialog(%message, %x)
	push(a0)
	la a0 %message
   	li a7 51
   	ecall
   	mv %x, a0
   	pop(a0)
.end_macro

.macro message_dialog(%message, %type)
	la a0 %message
	li a1 %type
	li a7 55
	ecall
.end_macro

.macro remove_newline(%str)
	li t4 '\n'
	la t5 %str
	j loop_nl
	
	loop_nl:
	lb	t6  (t5)
	beq t4	t6 replace
	addi t5 t5 1
	j loop_nl
	
	replace:
    	sb zero (t5)
.end_macro

.macro print_str_adr(%x)
	mv a0 %x
	li a7 4
	ecall
.end_macro

.macro openFile(%nameOfTheInputFile, %text)
	la a0 %nameOfTheInputFile
	la a3 %text
	jal open_file
.end_macro

.macro getStrlen(%text)
	la a0 %text
	jal strlen
	# результат в a2
.end_macro

.macro findSubstr(%text, %N, %len_text_register)
	la a0 %text
	mv a1 %N 
	add a2 %len_text_register zero
	jal text_handler
.end_macro

.macro createStringIdx(%memory, %idx1, %idx2, %text)
	mv a1 %memory
	mv a2 %idx1
	mv a3 %idx2
	la a4 %text
	jal create_str
.end_macro

.macro writeFile(%nameFile, %strToWrite, %lenStr)
	la a0 %nameFile
	mv a2 %strToWrite
	mv a3 %lenStr
	jal write_file
.end_macro


.macro tester1(%nameInput, %nameOutput, %text_testMem, %N)
	push(ra)
	
	la a0 %nameInput
	la a3 %text_testMem
	jal open_file
	
	la a0 %text_testMem
	jal strlen
	
	la a0 %text_testMem
	mv a1 %N 
	add a2 a2 zero
	jal text_handler
	
	# Надо выделить в куче min(11, N + 2) байт
	li t0 11
	addi t1 %N 2
	min_elem(t0, t1) # вернет в t0 минимальный элемент (11, N + 2)
	mv s6 t0 # в s6 хранится кол-во аллоцированной памяти
	allocate_heap_memory(t0) # вернуло в a0 адрес на аллоцированную память
	mv s4 a0 # указатель на аллоцированную память
	
	mv a1 s4
	mv a2 a4
	mv a3 a5
	la a4 %text_testMem
	jal create_str
	
	la a0 %nameOutput
	mv a2 s4
	mv a3 s6
	jal write_file
	
	print_string("Тест из тестирования №1 пройден успешно!\n")
	pop(ra)
.end_macro

.macro tester2(%nameInput, %nameOutput, %text_testMem, %N)
	push(ra)
	openFile(%nameInput, %text_testMem)
	getStrlen(%text_testMem)
	
	findSubstr(%text_testMem, %N, a2)
	
	# Надо выделить в куче min(11, N + 2) байт
	li t0 11
	addi t1 %N 2
	min_elem(t0, t1) # вернет в t0 минимальный элемент (11, N + 2)
	mv s6 t0 # в s6 хранится кол-во аллоцированной памяти
	allocate_heap_memory(t0) # вернуло в a0 адрес на аллоцированную память
	mv s4 a0 # указатель на аллоцированную память
	
	createStringIdx(s4, a4, a5, %text_testMem)
	
	writeFile(%nameOutput, s4, s6)
	
	print_string("Тест из тестирования №2 пройден успешно!\n")
	pop(ra)
.end_macro
