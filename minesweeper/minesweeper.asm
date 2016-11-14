TITLE	Minesweeper

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc
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

PlaceMines PROC uses ecx esi eax
	mov ecx, 10
	MineLayer:
		mov esi, offset grid
		mov eax, 81
		call RandomRange
		add esi, eax
		call IncCells
		mov eax, 42
		mov [esi], eax
		
		loop MineLayer
	ret
PlaceMines ENDP

IncCells PROC uses ebx edx
	mov bl, 9
	div bl
	mov edx, 1			; Required to increment cells by reference
	
		cmp al, 0
		je Lower	
	Upper:
		mov ebx, [esi-9]
		cmp ebx, 42
		je Lower
		add [esi-9], edx
	
	Lower:
		cmp al, 8
		je Left
		mov ebx, [esi+9]
		cmp ebx, 42
		je Left
		add [esi+9], edx
	
	Left:
		cmp ah, 0
		je Right
		
		cmp al, 0
		je Left2
		mov ebx, [esi-10]
		cmp ebx, 42
		je Left2
		add [esi-10], edx
		
		Left2:
		mov ebx, [esi-1]
		cmp ebx, 42
		je Left3
		add [esi-1], edx
		
		Left3:
		cmp al, 8
		je Right
		mov ebx, [esi+8]
		cmp ebx, 42
		je Right
		add [esi+8], edx
		
	
	Right:
		cmp ah, 8
		je Done
		
		cmp al,0
		je Right2
		mov ebx, [esi-8]
		cmp ebx, 42
		je Right2
		add [esi-8], edx
		
		Right2:
		mov ebx, [esi+1]
		cmp ebx, 42
		je Right3
		add [esi+1], edx
		
		Right3:
		cmp al, 8
		je Done
		mov ebx, [esi+10]
		cmp ebx, 42
		je Done
		add [esi+10], edx
	
	Done:
	ret
IncCells ENDP

END main