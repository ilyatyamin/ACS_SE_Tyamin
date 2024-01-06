.include "macrolib.asm"

.data
str1: 	.asciz "Hello"
str2:	.space 7

str3: 	.asciz "No space for this string"
str4:	.space 10

str5:	.asciz "The number is too large"
str6:	.space 25

str7:	.space 102
str8:	.space 102

str9:	.asciz ""
str10:	.space 3

.text
main:
	# Тест №1
	la a0 str1
	la a1 str2
	li a2 5
	jal strncpy
	la a1 str2
	print_string("Должно быть: Hello\nРезультат:")
	print_str_adr(a1)
	newline
	
	# Тест №2
	la a0 str3
	la a1 str4
	li a2 8
	str_copy(a0, a1, a2)
	la a1 str4
	print_string("Должно быть: No space\nРезультат:")
	print_str_adr(a1)
	newline
	
	# Тест №3
	la a0 str5
	la a1 str6
	li a2 100
	str_copy(a0, a1, a2)
	la a1 str5
	print_string("Должно быть: The number is too large\nРезультат:")
	print_str_adr(a1)
	newline
	
	# Тест №4
	la a0 str9
	la a1 str10
	li a2 1
	str_copy(a0, a1, a2)
	la a1 str10
	print_string("Должно быть: \nРезультат:")
	print_str_adr(a1)
	newline
	
	# Тест №5
	print_string("Чтение с консоли: (до 100 символов))")
	la a0 str7
	li a1 102
	li a7 8
	ecall
	jal strlen # в a2 запишется кол-во символов
	la a0 str7
	la a1 str8
	str_copy(a0, a1, a2)
	la a1 str8
	print_str_adr(a1)
	newline
	
	exit
