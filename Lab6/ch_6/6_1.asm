TITLE 6.11 Programming Exercises

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 1. Filling an Array
;
; Create a procedure that fills an array of doublewords with N random integers, making sure the
; values fall within the range j...k, inclusive. When calling the procedure, pass a pointer to the
; array that will hold the data, pass N, and pass the values of j and k. Preserve all register values
; between calls to the procedure. Write a test program that calls the procedure twice, using different
; values for j and k. Verify your results using a debugger.

INCLUDE Irvine32.inc

.data
promptSize	db	"Please enter size of array (1-500): ", 0
promptRange	db	"Please enter range values (j < k):", 0
N			dd	?
j			dd	?
k			dd	?
arrayN		dd	500 DUP(?)

.code
main PROC
	call userSize
	call randomize
	mov ecx, 2
	Jose:
		call userRange
		call randomizeArray
		loop Jose
	call Crlf
	exit
main ENDP

; ask user for array's size.
; continously ask for the size until
; the size is within range of 1 to 500.
userSize PROC USES edx eax
	askInput:
		mov edx, offset promptSize
		call WriteString
		call ReadInt
		cmp eax, 1
		jge upperLimit
		jmp askInput

	upperLimit:
		cmp eax, 500
		jle exitInput
		jmp askInput

	exitInput:
		mov N, eax
		ret
userSize ENDP

; ask user for range values.
; continously ask for the range values until
; first value (j) is less than second value (k).
userRange PROC USES edx eax ebx
	askInput:
		mov edx, offset promptRange
		call WriteString
		call Crlf
		call ReadInt	; get j value
		mov ebx, eax
		call ReadInt	; get k value
		cmp ebx, eax
		jl exitInput
		jmp askInput

	exitInput:
		mov j, ebx
		mov k, eax
		inc k	; because k has to be inclusive
		;call DumpRegs
		ret
userRange ENDP

randomizeArray PROC USES ecx esi
	mov ecx, N
	mov esi, offset arrayN
	overArray:
		call BetterRandomRange	; eax = new random value (between j & k)
		mov [esi], eax			; store random value in array
		call WriteInt
		mov al, ' '
		call WriteChar
		add esi, type arrayN
		loop overArray
	call Crlf
	ret
randomizeArray ENDP

BetterRandomRange PROC
	mov eax, k
	mov ebx, j
	sub eax, ebx
	call RandomRange
	add eax, ebx
	;call DumpRegs
	ret
BetterRandomRange ENDP
END main