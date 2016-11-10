TITLE Chapter 6 Exercise -- Summing array elements in a range (6_2.asm)

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 2. Summing array elements in a range
;
; Program will implement a procedure that computes the sum of array elements between two given values.


.data
; Array used for calculation.
array dd 5, 5, 6, 7, 9, 10, 3, 15

; Defines the range for the sum.
lower dd 5
upper dd 9
.code
main PROC
	mov eax, 0
	mov esi, offset array
	mov ecx, lengthof array
	mov ebx, lower
	mov edx, upper
	call RangeSum
	call DumpRegs
	exit
main ENDP

; INPUT - load register values before calling the procedure:
; esi: pointer to array
; ecx: length of array
; ebx: lower part of desired range
; edx: upper part of the desired range
; OUTPUT:
; eax will contain the sum of the numbers in the array that are in the desired range.
RangeSum PROC
	
	Jose:
	ret
RangeSum ENDP

END main