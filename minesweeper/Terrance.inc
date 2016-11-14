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