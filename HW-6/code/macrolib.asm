#
# Example library of macros.
#

# Печать целого числа x
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

# Печать целого числа x
.macro print_imm_int (%x)
    li a7, 1
    li a0, %x
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

   .macro newline
   print_char('\n')
   .end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

.macro print_str_adr(%x)
	mv a0 %x
	li a7 4
	ecall
.end_macro

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
