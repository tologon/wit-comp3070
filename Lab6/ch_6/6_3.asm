TITLE 6.11 Programming Exercises
; _____________________________________________________________________________________________________
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 3. Test Score Evaluation
;
; Create a procedure named CalcGrade that receives an integer value between 0 and 100, and
; returns a single capital letter in the AL register. Preserve all other register values between calls
; to the procedure. The letter returned by the procedure should be according to the following ranges:
; 90 - 100 -> A
; 80 - 89  -> B
; 70 - 79  -> C
; 60 - 69  -> D
; 0  - 59  -> F
; Write a test program that generates 10 random integers between 50 and 100, inclusive. Each
; time an integer is generated, pass it to the CalcGrade procedure. You can test your program
; by displaying each integer and its corresponding letter grade.
; _____________________________________________________________________________________________________

INCLUDE Irvine32.inc
.data

.code
main PROC
	call Randomize
	mov ecx, 10
	Jose:
		call BetterRandomRange
		call WriteDec
		call PrintTab
		call CalcGrade
		call WriteChar
		call Crlf
		loop Jose

	call Crlf
	exit
main ENDP

; this procedure assumes that value in AL will be an integer between 0 and 100.
; note: if you pass value < 0, it returns F, and if value > 100, it returns A.
CalcGrade PROC
	cmp al, 90
	jge gradeA

	cmp al, 80
	jge gradeB

	cmp al, 70
	jge gradeC

	cmp al, 60
	jge gradeD

	jmp gradeF

	gradeA:
		mov al, 'A'
		jmp endProc
	gradeB:
		mov al, 'B'
		jmp endProc
	gradeC:
		mov al, 'C'
		jmp endProc
	gradeD:
		mov al, 'D'
		jmp endProc
	gradeF:
		mov al, 'F'
	endProc:
		ret
CalcGrade ENDP

PrintTab PROC USES eax
	mov eax, 9
	call WriteChar
	ret
PrintTab ENDP

BetterRandomRange PROC
	mov eax, 101	; use 101 so 100 will be inclusive
	mov ebx, 50
	sub eax, ebx
	call RandomRange
	add eax, ebx
	ret
BetterRandomRange ENDP
END main