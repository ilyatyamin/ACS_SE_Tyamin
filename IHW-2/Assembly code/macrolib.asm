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


.macro test(%num, %approx_result)
	push(ra)
	lw a2 %num
	jal get_root
	fmv.d ft1 fa0
	
	print_string("Исходное число: ")
	print_int(a2)
	newline
	print_string("Получилось после алгоритма: ")
	print_double(ft1)
	
	newline
	print_string("Должно было (примерно) получиться: ")
	fld ft2 %approx_result t6
	print_double(ft2)
	newline
	pop(ra)
.end_macro