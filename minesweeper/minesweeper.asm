TITLE	Minesweeper

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc
INCLUDE Terrance.inc
; _____________________ DATA _________________________________
.data
; access grid cells using the following: [base + index],
; where base is held in a base register
; and index is held in an index register.
; by default a cell has the value of 48, ascii value for zero
grid	BYTE 9 DUP(48)
rowSize	= ($ - grid)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)

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
	mov edx, OFFSET firstPrompt
	call WriteString
	call Crlf
	call PlaceMines
	call PrintGrid
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

; assuming x and y variables are set, this procedure
; sets the value (stored in eax) in (x, y) cell on the grid.
; USES: x, y, eax (but really only uses value in AL)
setCellValue PROC
	push eax				; save for later use
	mov eax, 0
	mov al, x
	mov edx, rowSize
	mul dl

	movzx esi, y
	mov ebx, OFFSET grid	; table offset
	add ebx, eax			; row offset
	pop eax					; get original value
	mov [ebx + esi], al
	ret
setCellValue ENDP

END main