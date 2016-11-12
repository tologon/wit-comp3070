TITLE Quick Sort Procedure (QuickSort.asm)
INCLUDE Irvine32.inc

.data
arr		dd 10, 15, 5, 25, 20, 30
pivot 	dd ?

array 

.code
main PROC
	mov eax, 0
	call printArr
	call Crlf
	call quickSort
	call printArr
	call Crlf

	exit
main ENDP

quickSort PROC
	mov ax, lengthof arr
	div 2
	mov pivot, al
	
	
	ret
quickSort ENDP

printArr PROC
	mov ecx, lengthof arr
	mov esi, offset arr
	Jose:
		mov eax, [esi]
		call WriteDec
		mov al, ' '
		call WriteChar
		add esi, type arr
	loop Jose

	ret
printArr ENDP

END main