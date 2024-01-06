.include "macrolib.asm"

.global get_root

.data
	eps: .double 0.0001 # Значение точности. Берем как 1/10000.
	coef1: .double 0.5

.text

# Программа реализована точь в точь с кодом, написанным в C++ (прикрепил к репозиторию)
get_root:
	push(ra)
	li t0 3 # значение, что корень кубический
	fcvt.d.w ft0 t0 # ft0 = 3
	
	fld ft1 eps t6 # загружаем eps в ft1 используя t6 как временный
	
	fcvt.d.w ft2 a2 # преобразовываем число в double
	
	fdiv.d ft3 ft2 ft0 # root = num / rootDegree

	j loop_outer
	
loop_outer: # внешний цикл while
	fsub.d ft4 ft3 ft2 # root - copy
	fabs.d ft4 ft4 # abs (root - copy)
	fge.d t5 ft4 ft1 # abs >= eps
	beqz t5 result
	
	fcvt.d.w ft2 a2 # преобразовываем число в double
	
	li t6 1
	j loop_inner
	
	
loop_inner: # внутренний цикл for
	bge t6 t0 after_loop_inner
	fdiv.d ft2 ft2 ft3
	
	addi t6 t6 1
	j loop_inner
	
after_loop_inner:
	# root = 0.5 * (copy + root)
	fld ft5 coef1 t6 # загружаем 0.5 используя t6
	fadd.d ft6 ft2 ft3
	fmul.d ft3 ft5 ft6 # 0.5 * (copy + root)
	j loop_outer

	
result:
	fmv.d fa0 ft3 # кладем в fa0 результат
	pop(ra)
	ret