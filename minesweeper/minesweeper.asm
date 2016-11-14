TITLE	Minesweeper

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc
INCLUDE Terrance.inc
; _____________________ DATA _________________________________
.data
; access grid cells using the following: [base + index],
; where base is held in a base register
; and index is held in an index register.
grid	BYTE 9 DUP(0)
rowSize	= ($ - grid)
		BYTE 9 DUP(0)
		BYTE 9 DUP(0)
		BYTE 9 DUP(0)
		BYTE 9 DUP(0)
		BYTE 9 DUP(0)
		BYTE 9 DUP(0)
		BYTE 9 DUP(0)
		BYTE 9 DUP(0)

x	BYTE ?
y	BYTE ?
firstPrompt BYTE "Enter X & Y values (-1 to end the loop).", 0
promptX	BYTE "Enter X coordinate: ", 0
promptY	BYTE "Enter Y coordinate: ", 0
cellValue BYTE "Cell value: ", 0 
; _____________________ CODE _________________________________
.code
main PROC
	call Randomize
	call PlaceMines
	mov edx, OFFSET firstPrompt
	call WriteString
	call Crlf
	INPUT:
		call getInput
		cmp x, -1
		jle FINISH_IT

		call printCellValue
		jmp INPUT

	FINISH_IT:
		exit
main ENDP

getInput PROC USES eax edx
	mov eax, 0
	mov edx, OFFSET promptX
	call WriteString
	call ReadInt	; get X
	cmp al, 0
	jge CHECK1
	mov x, -1
	jmp END_PROC

	CHECK1:
		mov x, al
		mov edx, OFFSET promptY
		call WriteString
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

printCellValue PROC
	mov eax, 0
	mov al, x
	mov edx, rowSize
	mul dl

	movzx esi, y
	mov ebx, OFFSET grid	; table offset
	add ebx, eax			; row offset
	mov al, [ebx + esi]

	mov edx, offset cellValue
	call WriteString
	call WriteDec
	call Crlf
	ret
printCellValue ENDP

END main