.include "macrolib.asm"
.global testing1, testing2

.data 
	input_test1_1: .asciz "tests1/1.in"
	input_test2_1: .asciz "tests1/2.in"
	input_test3_1: .asciz "tests1/3.in"
	input_test4_1: .asciz "tests1/4.in"
	input_test5_1: .asciz "tests1/5.in"
	input_test6_1: .asciz "tests1/6.in" # doesn't exist
	
	output_test1_1: .asciz "tests1/1.out"
	output_test2_1: .asciz "tests1/2.out"
	output_test3_1: .asciz "tests1/3.out"
	output_test4_1: .asciz "tests1/4.out"
	output_test5_1: .asciz "tests1/5.out"
	output_test6_1: .asciz "tests1/6.out" # doesn't exist
	
	input_test1_2: .asciz "tests2/1.in"
	input_test2_2: .asciz "tests2/2.in"
	input_test3_2: .asciz "tests2/3.in"
	input_test4_2: .asciz "tests2/4.in"
	input_test5_2: .asciz "tests2/5.in"
	input_test6_2: .asciz "tests2/6.in" # doesn't exist
	
	output_test1_2: .asciz "tests2/1.out"
	output_test2_2: .asciz "tests2/2.out"
	output_test3_2: .asciz "tests2/3.out"
	output_test4_2: .asciz "tests2/4.out"
	output_test5_2: .asciz "tests2/5.out"
	output_test6_2: .asciz "tests2/6.out" # doesn't exist

	text_testMem: .space 10242 # 512*20 + 2
.text
testing1:
	push(ra)
	li s5 5
	tester1(input_test1_1, output_test1_1, text_testMem, s5) # обычный тест
	
	li s5 10
	tester1(input_test2_1, output_test2_1, text_testMem, s5) # not found
	
	li s5 22
	tester1(input_test3_1, output_test3_1, text_testMem, s5) # файл слишком большой
	
	li s5 10
	tester1(input_test4_1, output_test4_1, text_testMem, s5) # файл пустой
	
	li s5 3
	tester1(input_test5_1, output_test5_1, text_testMem, s5) # обычный тест
	pop(ra)
	ret


testing2:
	push(ra)
	
	li s5 5
	tester2(input_test1_2, output_test1_2, text_testMem, s5) # обычный тест
	
	li s5 10
	tester2(input_test2_2, output_test2_2, text_testMem, s5) # not found
	
	li s5 22
	tester2(input_test3_2, output_test3_2, text_testMem, s5) # файл слишком большой
	
	li s5 10
	tester2(input_test4_2, output_test4_2, text_testMem, s5) # файл пустой
	
	li s5 3
	tester2(input_test5_2, output_test5_2, text_testMem, s5) # обычный тест
	
	pop(ra)
	ret