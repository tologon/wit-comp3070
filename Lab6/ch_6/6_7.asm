TITLE 6.11 Programming Exercises

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 7. Probabilities and Colors

INCLUDE Irvine32.inc
.data 
valRand dd ?
promptA db "This is a random string ",0
.code	
main PROC
	mov ecx, 20
	Jose:
	mov eax, 10
	Call RandomRange 
	mov valRand, eax
	cmp valRand,4
	jge checkGreen
	cmp valRand, 3
	je checkBlue
	cmp valRand, 3
	jl checkWhite
	Loop Jose

	checkGreen: 
		Call WriteDec
		Call crlf
		mov eax, 3
		Call SetTextColor
		mov edx, offset promptA
		Call WriteString
		Call Crlf

	checkBlue:
		Call WriteDec
		Call crlf
		mov eax, 1
		Call SetTextColor
		mov edx, offset promptA
		Call WriteString
		Call Crlf

	checkWhite:
		Call WriteDec
		Call crlf
		mov eax, 15
		Call SetTextColor
		mov edx, offset promptA
		Call WriteString
		Call Crlf
	exit
main Endp
END main