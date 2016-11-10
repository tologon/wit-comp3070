TITLE Chapter 6 Exercise -- Summing array elements in a range (6_2.asm)

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 2. Summing array elements in a range
;
; Program will implement a procedure that computes the sum of array elements between two given values.

.data
; Array used for calculation.
array BYTE 5, 5, 6, 7, 9, 10, 3, 15

; Defines the range for the sum.
lower BYTE 5
higher BYTE 9
.code
main PROC
	mov esi, offset array
	mov eax, lower
	mov ebx, higher
	call RangeSum
	call DumpRegs
	exit
main ENDP

RangeSum PROC

	ret
RangeSum ENDP

END main