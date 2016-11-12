TITLE Quick Sort Procedure (QuickSort.asm)
INCLUDE Irvine32.inc

.data
arr		dd 10, 15, 5, 25, 20, 30
pivot 	dd ?

array 

.code
main PROC
	call printArr
	call Crlf
	call quickSort
	call printArr
	call Crlf

	exit
main ENDP

quickSort PROC
	call sumArr
	div 2
	mov pivot, al
	mov ecx, lengthof arr
	mov esi, offset arr
	Jose:
		cmp [esi], al
		
		loop Jose
	
	ret
quickSort ENDP

sumArr PROC
	mov ecx, lengthof arr
	mov esi, offset arr
	mov eax, 0
	sum:
		add eax, [esi]
		add esi type arr
		loop sum
	
	ret
sumArr ENDP

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