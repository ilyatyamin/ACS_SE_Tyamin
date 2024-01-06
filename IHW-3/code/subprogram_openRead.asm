.include "macrolib.asm"
.global open_file

.eqv PACKAGE_SIZE 512


.data
	err_openFile: .asciz "Ошибка открытия файла!"
	err_readFile: .asciz "Ошибка при чтении файла!"

.text
# В регистре a0 - имя открываемого файла
# В регистре a3 - буфер для текста (суммарный буфер)
# Возвращает в a4: 1 если удалось прочитать, 0 если не удалось
open_file:
	li   	a7 1024     	# Системный вызов открытия файла
    	li   	a1 0        	# Открыть для чтения (флаг = 0)
    	ecall             	# Дескриптор файла в a0 или -1)
    	li	s1 -1		# Проверка на корректное открытие
    	beq	a0 s1 er_name	# Ошибка открытия файла
    	mv s4 a0
    	j read_file_temp
    	
er_name:
	li a4 0
	message_dialog(err_openFile, 0)
	ret

read_file_temp:
	li   t0, 0 # количество считанных пакетов по 512
    	mv   a1 a3   # Адрес буфера для читаемого текста
    	li   a2 PACKAGE_SIZE # Размер читаемой порции
    	li t3 20
    	j read_file_loop
    	
   	read_file_loop:
   	mv a0 s4
   	beq t0 t3 end_read
   	li   a7, 63       # Системный вызов для чтения из файла
    	ecall             # Чтение
    	# Проверка на корректное чтение
    	beq  a0 s1 er_read	# Ошибка чтения
    	mv   s2 a0       	# Сохранение длины текста
    	beq s2 zero end_read
    	
    	addi a1 a1 PACKAGE_SIZE
    	addi t0 t0 1
    	j read_file_loop
    	
er_read:
	li a4 0
	message_dialog(err_readFile, 0)
	ret

end_read:
	# Нужно добавить ноль в конец строки (как конец)
	addi a1 a1 1
	sb zero(a1)
	# Файл нужно закрыть
	li   a7 57       # Системный вызов закрытия файла
	ecall             # Закрытие файла
	li a4 1
	ret
