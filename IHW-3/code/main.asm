.include "macrolib.asm"

.data
	warning: .asciz "Внимание! В данной программе можно указывать относительный путь, если установлен флаг в Settings->Derive current working directory. Иначе нужно вводить абсолютный путь. "
	incorrect_input: .asciz "Неверный ввод! Повторите его."

	message1: .asciz "Введите название исходного файла. "
	nameOfTheInputFile: .space 262 # macLenFile = 260 (из документации Windows)

	message2: .asciz "Введите название файла, куда будет сохранен результат."
	nameOfTheOutputFile: .space 262 # macLenFile = 260 (из документации Windows)
	
	get_N: .asciz "Введите число N."
	
	text: .space 10242 # 512*20 + 2
	
	message3: .asciz "Нужно ли выводить результат в консоль? Y, если да, N, если нет."
	usersChoice: .space 3 # "Y", "N"
	
	yes: .asciz "Y"
	
.text
main:
	# Раскомментировать 1 и / или две строчки для запуска тестирования. Тестирование №1 - с помощью подпрограмм, №2 - с помощью макросов
	#jal testing1
	#jal testing2

	message_dialog(warning, 1)
	j start
	start:
	read_string_dialog(message1, nameOfTheInputFile, 260, incorrect_input)
	read_string_dialog(message2, nameOfTheOutputFile, 260, incorrect_input)
	j read_zero_largerZero
	
	read_zero_largerZero:
	read_int_dialog(get_N, s5)
	blez s5 not_corr_inp
	j inp
	
	not_corr_inp:
	message_dialog(incorrect_input, 0)
	j read_zero_largerZero
	
	inp:
	remove_newline(nameOfTheInputFile)
	remove_newline(nameOfTheOutputFile)
	
	openFile(nameOfTheInputFile, text)
	
	#beq a4 zero start
	
	getStrlen(text)
	
	findSubstr(text, s5, a2)
	
	# Надо выделить в куче min(11, N + 2) байт
	li t0 11
	addi t1 s5 2
	min_elem(t0, t1) # вернет в t0 минимальный элемент (11, N + 2)
	mv s6 t0 # в s6 хранится кол-во аллоцированной памяти
	allocate_heap_memory(t0) # вернуло в a0 адрес на аллоцированную память
	mv s4 a0 # указатель на аллоцированную память
	
	createStringIdx(s4, a4, a5, text)
	
	writeFile(nameOfTheOutputFile, s4, s6)
	
	# Спрашиваем у пользователя необходимость выводить результат в консоль
	read_string_dialog(message3, usersChoice, 3, incorrect_input)
	remove_newline(usersChoice)
	la a0 yes
	la a1 usersChoice
	jal strcmp
	beqz a0 pr_screen
	j to_exit
	
	pr_screen:
	mv a0 s4
	li a7 4
	ecall
	j to_exit
	
	to_exit:
	exit
