TITLE 6.11 Programming Exercises
; _____________________________________________________________________________________________________
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 5. Boolean Calculator (1)
;
; Create a program that functions as a simple boolean calculator for 32-bit integers. It 
; should display a menu that asks the user to make a selection from the following list:
; 1. x AND y
; 2. x OR y
; 3. NOT x
; 4. x XOR y
; 5. Exit program
;
; When the user makes a choice, call a procedure that displays the name of the operation about to
; be performed. You must implement this procedure using the Table-Driven Selection technique,
; shown in Section 6.5.4.
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
			DWORD option_1
optionSize = ($ - calcTable)
			BYTE 2
			DWORD option_2
			BYTE 3
			DWORD option_3
			BYTE 4
			DWORD option_4
			BYTE 5
			DWORD option_5
numOfOptions = ($ - calcTable) / optionSize

prompt1	BYTE "SELECTED: 1. x AND y", 0
prompt2	BYTE "SELECTED: 2. x OR y", 0
prompt3	BYTE "SELECTED: 3. NOT x", 0
prompt4	BYTE "SELECTED: 4. x XOR y", 0
prompt5	BYTE "SELECTED: 5. Exit program", 0
; _________________________________ CODE ______________________________________________________________
.code
main PROC
	call menu				; display menu & ask for input
	call ReadDec			; get user input in eax
	call findMenuOption		; find user option in menu

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
		call WriteString
		call Crlf
		jmp loop3

	loop2:
		add ebx, optionSize
		loop loop1

	loop3:
		ret
findMenuOption ENDP

option_1 PROC
	mov edx, offset prompt1
	ret
option_1 ENDP

option_2 PROC
	mov edx, offset prompt2
	ret
option_2 ENDP

option_3 PROC
	mov edx, offset prompt3
	ret
option_3 ENDP

option_4 PROC
	mov edx, offset prompt4
	ret
option_4 ENDP

option_5 PROC
	mov edx, offset prompt5
	ret
option_5 ENDP
END main