.include "macrolib.asm"
.global write_file

.text
# Входные данные: в регистре a0 - название файла (без \n в конце)
# в регистрах a2 - записываемая строка, в регистре a3 - ее длина
write_file:
	li a7 1024 # сделаем новый файл
	li a1 1 # разрешаем запись
	ecall # text decriptor находится сейчас в a0
	
	li a7 64 # запись в файл
	mv a1 a2
	mv a2 a3
	ecall
	
	# Закрыть файл
	li a7 57
	ecall
	
	ret
