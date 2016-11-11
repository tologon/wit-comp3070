TITLE 6.11 Programming Exercises
; _____________________________________________________________________________________________________
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 6. Boolean Calculator (2)
;
; Continue the solution program from Exercise 5 by implementing the following sequence of steps:
; * Prompt the user for two hexadecimal integers (or sometimes one).
; * AND/OR/XOR them together and display the result in hexadecimal (or NOT if only 1 integer).
; * Display the result.
; _____________________________________________________________________________________________________

INCLUDE Irvine32.inc
.data
prompt	BYTE "Please select one of the options (enter a number):", 10
		BYTE "1. x AND y", 10
		BYTE "2. x OR y", 10
		BYTE "3. NOT x", 10
		BYTE "4. x XOR y", 10
		BYTE "5. Exit program", 0

calcTable	BYTE 1
			DWORD AND_op
optionSize = ($ - calcTable)
			BYTE 2
			DWORD OR_op
			BYTE 3
			DWORD NOT_op
			BYTE 4
			DWORD XOR_op
			BYTE 5
			DWORD EXIT_op
numOfOptions = ($ - calcTable) / optionSize

prompt1	BYTE "SELECTED: 1. x AND y", 0
prompt2	BYTE "SELECTED: 2. x OR y", 0
prompt3	BYTE "SELECTED: 3. NOT x", 0
prompt4	BYTE "SELECTED: 4. x XOR y", 0
prompt5	BYTE "SELECTED: 5. Exit program", 0

promptX BYTE "Enter x: ", 0
promptY BYTE "Enter y: ", 0
result  BYTE "result: ", 0
; _________________________________ CODE ______________________________________________________________
.code
main PROC
	call menu				; display menu & ask for input
	call ReadDec			; get user input in eax
	call findMenuOption		; find user option in menu
	call Crlf
	exit
main ENDP

menu PROC USES edx
	mov edx, offset prompt
	call WriteString
	call Crlf
	call Crlf
	ret
menu ENDP

findMenuOption PROC USES ebx ecx
	mov ebx, offset calcTable
	mov ecx, numOfOptions
	loop1:
		cmp al, [ebx]			; if menu match
		jne loop2				; no: continue
		call NEAR PTR [ebx+1]	; yes: call the procedure
		jmp loop3

	loop2:
		add ebx, optionSize
		loop loop1

	loop3:
		ret
findMenuOption ENDP

AND_op PROC USES edx eax ebx
	mov edx, offset prompt1
	call displaySelection
	mov edx, offset promptX
	call WriteString
	call ReadHex	; get X value
	mov ebx, eax
	mov edx, offset promptY
	call WriteString
	call ReadHex	; get Y value
	AND eax, ebx
	mov edx, offset result
	call WriteString
	call WriteHex	; display the result
	ret
AND_op ENDP

OR_op PROC USES edx eax ebx
	mov edx, offset prompt2
	call displaySelection
	mov edx, offset promptX
	call WriteString
	call ReadHex	; get X value
	mov ebx, eax
	mov edx, offset promptY
	call WriteString
	call ReadHex	; get Y value
	OR eax, ebx
	mov edx, offset result
	call WriteString
	call WriteHex	; display the result
	ret
OR_op ENDP

NOT_op PROC USES edx eax ebx
	mov edx, offset prompt3
	call displaySelection
	mov edx, offset promptX
	call WriteString
	call ReadHex	; get X value
	NOT eax
	mov edx, offset result
	call WriteString
	call WriteHex	; display the result
	ret
NOT_op ENDP

XOR_op PROC USES edx eax ebx
	mov edx, offset prompt4
	call displaySelection
	mov edx, offset promptX
	call WriteString
	call ReadHex	; get X value
	mov ebx, eax
	mov edx, offset promptY
	call WriteString
	call ReadHex	; get Y value
	XOR eax, ebx
	mov edx, offset result
	call WriteString
	call WriteHex	; display the result
	ret
XOR_op ENDP

EXIT_op PROC USES edx
	mov edx, offset prompt5
	call displaySelection
	ret
EXIT_op ENDP

displaySelection PROC
	call WriteString
	call Crlf
	ret
displaySelection ENDP
END main