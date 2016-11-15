.data
.code
PlaceMines PROC uses ecx esi eax
	mov ecx, 10
	MineLayer:
		mov esi, offset grid
		mov eax, 81
		call RandomRange
		add esi, eax
		call IncCells
		mov eax, 42
		mov [esi], al

		
		loop MineLayer
	ret
PlaceMines ENDP

IncCells PROC uses ebx edx
	mov bl, 9
	div bl				; puts quotient of esi / 9 into al and remainder into ah.
	mov edx, 1			; Required to increment cells by reference
	
		cmp al, 0
		je Lower	
	Upper:
		mov bl, [esi-9]
		cmp bl, 42
		je Lower
		add [esi-9], dl
	
	Lower:
		cmp al, 8
		je Left
		mov bl, [esi+9]
		cmp bl, 42
		je Left
		add [esi+9], dl
	
	Left:
		cmp ah, 0
		je Right
		
		cmp al, 0
		je Left2
		mov bl, [esi-10]
		cmp bl, 42
		je Left2
		add [esi-10], dl
		
		Left2:
		mov bl, [esi-1]
		cmp bl, 42
		je Left3
		add [esi-1], dl
		
		Left3:
		cmp al, 8
		je Right
		mov bl, [esi+8]
		cmp bl, 42
		je Right
		add [esi+8], dl
		
	
	Right:
		cmp ah, 8
		je Done
		
		cmp al,0
		je Right2
		mov bl, [esi-8]
		cmp bl, 42
		je Right2
		add [esi-8], dl
		
		Right2:
		mov bl, [esi+1]
		cmp bl, 42
		je Right3
		add [esi+1], dl
		
		Right3:
		cmp al, 8
		je Done
		mov bl, [esi+10]
		cmp bl, 42
		je Done
		add [esi+10], dl
	
	Done:
	ret
IncCells ENDP

PrintGrid PROC uses eax ecx esi
	mov esi, offset grid
	mov ecx, 9
		Tologon:
			push ecx
			mov ecx, 9
			Tologonsbaby:
				mov al, [esi]
				call WriteChar
				inc esi
				loop Tologonsbaby
			pop ecx
			call Crlf
		
			loop Tologon
	
	ret
PrintGrid ENDP