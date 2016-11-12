TITLE Quick Sort Procedure (QuickSort.asm)
INCLUDE Irvine32.inc

.data
arr		dd 10, 15, 5, 25, 20, 30
pivot 	dd ?
endval	dd ?


array 

.code
main PROC
	call printArr
	call Crlf
	mov esi, offset arr
	mov ecx, lengthof arr
	mov endval, sizeof arr
	mov eax, 0
	call quickSort
	call printArr
	call Crlf

	exit
main ENDP

quickSort PROC
	push eax
	push ebx
	mov eax, lengthof arr
	mov ebx, 2
	div ebx
	mov pivot eax
	pop ebx
	pop eax

	mov ecx, lengthof arr
	mov esi, offset arr
	Jose:
		mov eax, [esi]
		cmp eax, pivot
		jg MoveUpper
		
		MoveUpper:
		xchg eax, [esi+endval]
		
		loop Jose
	
	
	endSort:
	ret
quickSort ENDP

printArr PROC
	Jose2:
		mov eax, [esi]
		call WriteDec
		mov al, ' '
		call WriteChar
		add esi, type arr
	loop Jose2

	ret
printArr ENDP

END main