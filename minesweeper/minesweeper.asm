TITLE	Minesweeper

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc

.data
; access grid cells using the following: [base + index],
; where base is held in a base register
; and index is held in an index register.
grid	BYTE 1, 2, 3
rowSize	= ($ - grid)
		BYTE 4, 5, 6
		BYTE 7, 8, 9

x	BYTE ?
y	BYTE ?
promptXY BYTE "Enter X & Y values (-1 to end):", 0
Xvalue	BYTE "X value: ", 0
Yvalue	BYTE "Y value: ", 0

.code
main PROC
	INPUT:
		call getInput
		cmp x, -1
		jle FINISH_IT

		;call printX
		;call printY

		mov eax, 0
		mov al, x
		mov edx, rowSize
		mul dl

		movzx esi, y
		mov ebx, OFFSET grid	; table offset
		add ebx, eax			; row offset
		mov al, [ebx + esi]
		call WriteDec
		call Crlf
		jmp INPUT

	FINISH_IT:
		exit
main ENDP

printX PROC USES eax
	mov edx, offset Xvalue
	call WriteString
	movzx eax, x
	call WriteDec
	call Crlf
	ret
printX ENDP

printY PROC USES eax
	mov edx, offset Yvalue
	call WriteString
	movzx eax, y
	call WriteDec
	call Crlf
	ret
printY ENDP

getInput PROC USES eax edx
	mov eax, 0
	mov edx, OFFSET promptXY
	call WriteString
	call Crlf
	call ReadInt	; get X
	cmp al, 0
	jge CHECK1
	mov x, -1
	jmp END_PROC

	CHECK1:
		mov x, al
		call ReadInt	; get Y
		cmp al, 0
		jge CHECK2
		mov x, -1
		jmp END_PROC

	CHECK2:
		mov y, al

	END_PROC:
		ret
getInput ENDP
END main