.include "macrolib.asm"
.global strncpy, strlen

 .text

# Принимает в a0 - указатель на строку откуда копировать
# Принимает в a1 - указатель на строку куда копировать
# Принимает в a2 - количество символов для копирования
strncpy:
	li t0 0
	j loop_strn
	
loop_strn:
	beq t0 a2 end # если превышаем кол-во нужных символов (число), то end
	lb t1 (a0)
	sb t1 (a1) # сохраняем символ в новую строку
	
	beqz    t1 end # если строка закончилась, то выходим
	addi t0 t0 1 # переходим к следующему символу
	addi    a0 a0 1
	addi    a1 a1 1
	j loop_strn # цикл
end:
	ret
	

strlen:
    li      t0 0        # Счетчик
loop:
    lb      t1 (a0)   # Загрузка символа для сравнения
    beqz    t1 end_l
    addi    t0 t0 1		# Счетчик символов увеличивается на 1
    addi    a0 a0 1		# Берется следующий символ
    b       loop
end_l:
    mv      a2 t0
    ret
fatal_l:
    li      a2 -1
    ret
