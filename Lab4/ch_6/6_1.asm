TITLE 6.11 Programming Exercises

; 1. Filling an Array
;
; Create a procedure that fills an array of doublewords with N random integers, making sure the
; values fall within the range j...k, inclusive. When calling the procedure, pass a pointer to the
; array that will hold the data, pass N, and pass the values of j and k. Preserve all register values
; between calls to the procedure. Write a test program that calls the procedure twice, using different
; values for j and k. Verify your results using a debugger.

INCLUDE Irvine32.inc
.data
promptSize	db	"Please enter size of array (1-500): ", 0
N			dd	?
j			db	?
k			db	?
arrayN		dd	500 DUP(?)

.code
main PROC
	call userInput
	call randomize
	mov ecx, 2
	Jose:
		call randomizeArray
		loop Jose
	call Crlf
	exit
main ENDP

; ask user for array's size.
; continously ask for the size until
; the size is within range of 1 to 500.
userInput PROC USES edx eax
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
userInput ENDP

randomizeArray PROC
	ret
randomizeArray ENDP
END main