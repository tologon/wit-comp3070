TITLE Chapter 6 Exercise -- Summing array elements in a range (6_2.asm)

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 2. Summing array elements in a range
;
; Program will implement a procedure that computes the sum of array elements between two given values (inclusive).

INCLUDE Irvine32.inc

.data
; Array used for calculation.
array dd 5, 5, 6, 7, 9, 10, 3, 15

; Defines the range for the sum.
lower dd 5
upper dd 9
.code

; Test the RangeSum procedure
main PROC
	mov esi, offset array
	mov ecx, lengthof array
	mov ebx, lower
	mov edx, upper
	call RangeSum
	; Check the value in eax
	call WriteInt
	call Crlf
	exit
main ENDP

; INPUT - load register values before calling the procedure:
; esi: pointer to double word array containing values
; ecx: length of the array
; ebx: lower part of desired range
; edx: upper part of the desired range
; OUTPUT:
; eax: contains the sum of the numbers in the array that are within the desired range.
RangeSum PROC
	mov eax, 0
	Jose:
		cmp [esi], ebx
		jl endl
		cmp [esi], edx
		jg endl
		
		add eax, [esi]
		
		endl:
		add esi, 4
		loop Jose
	ret
RangeSum ENDP

END main