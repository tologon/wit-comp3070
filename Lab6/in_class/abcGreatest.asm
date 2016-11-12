TITLE In class: greatest of 3

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc

.data
Atext	db "Enter A: ", 0
Btext	db "Enter B: ", 0
Ctext	db "Enter C: ", 0

Aresult db "A is greatest", 0
Bresult db "B is greatest", 0
Cresult db "C is greatest", 0
.code
main PROC

	mov edx, offset Atext
	call WriteString
	call ReadInt
	mov ecx, eax	; ecx = A
	mov edx, offset Btext
	call WriteString
	call ReadInt
	mov ebx, eax	; ebx = B
	mov edx, offset Ctext
	call WriteString
	call ReadInt	; eax = C

	; ecx = A, ebx = B, eax = C
	cmp ecx, ebx
	jge ACheck
	cmp ebx, eax
	jge greatestB
	jmp greatestC

	ACheck: cmp ecx, eax
			jge greatestA
			jmp greatestC

	greatestA: mov edx, offset Aresult
			   call WriteString
			   call Crlf
			   jmp endProgram
	greatestB: mov edx, offset Bresult
			   call WriteString
			   call Crlf
			   jmp endProgram
	greatestC: mov edx, offset Cresult
			   call WriteString
			   call Crlf
			   jmp endProgram

	endProgram:	exit
main ENDP

END main