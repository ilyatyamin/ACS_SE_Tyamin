.include "macrolib.asm"
.global strcmp, strlen

.text
# На вход две строки: в a0 и a1. Нв выход в регистре a0 ответ: 0 если равны, иначе 1
strcmp:
loop_strcmp:
    lb      t0 (a0)     # Загрузка символа из 1-й строки для сравнения
    lb      t1 (a1)     # Загрузка символа из 2-й строки для сравнения
    beqz    t0 end_strcmp      # Конец строки 1
    beqz    t1 end_strcmp      # Конец строки 2
    bne     t0 t1 end_strcmp   # Выход по неравенству
    addi    a0 a0 1     # Адрес символа в строке 1 увеличивается на 1
    addi    a1 a1 1     # Адрес символа в строке 2 увеличивается на 1
    j       loop_strcmp
end_strcmp:
    sub     a0 t0 t1    # Получение разности между символами
    ret
    
   
# Нв вход одна строка в a0. Ее длина (выход) - в a2
strlen:
    li      t0 0        # Счетчик
loop_strlen:
    lb      t1 (a0)   # Загрузка символа для сравнения
    beqz    t1 end_strlen
    addi    t0 t0 1		# Счетчик символов увеличивается на 1
    addi    a0 a0 1		# Берется следующий символ
    j       loop_strlen
end_strlen:
	mv a2 t0
	ret