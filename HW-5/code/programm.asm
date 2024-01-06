
.include "macrolib.asm"

.data
	.align 2
	array:  .space  64
	arrend:

.global main
	.text
	
main:
	print_string("Введите количество чисел от 1 до 10: ")
	jal input_num_elements
	
	print_string("Введите элементы массива в указанном количестве: \n")
	la t5 array # t5 - место для массива
	li t2 0 # t2 - кол-во накопленных чисел
	jal input_nums
	
	la t5 array # t5 - место для массива
	li s3 2147483647 # граница правая инта
	li s4 -2147483647 # граница левая инта
	jal initial_sum
	
	jal data_output
	
	li a7 10
	ecall
	
