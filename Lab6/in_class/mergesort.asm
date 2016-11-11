TITLE Merge sort

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc
.data
arr		DWORD 10, 15, 5, 25, 20, 30
start1	WORD ?
start2	WORD ?
end1	WORD ?
end2	WORD ?
; _________________________________ CODE _________________________________
.code
main PROC
	call printArr
	call Crlf
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	
	mov ax, lengthof arr	; end = length of array
	mov bx, 0				; start of an array
	push bx					; push start of an array	
	push ax					; push end of an array
	call mergeSort
	call PrintArr
	call Crlf
	exit
main ENDP

; before the start of PROC, the registers have the following values:
; AX = end of current array
; BX = start of current array
mergeSort PROC
	call DumpRegs

	sub ax, bx		; get the size of current array
	cmp ax, 0		; if current array size is 0 or 1
	jle	endProc		; yes: return the array (base case)

	add ax, bx		; no: further split array (i.e. cancel subtraction)
	mov cx, ax		; do operations in AX, preserving CX = end, BX = start
	add ax, bx		; end1 + start1
	shr ax, 1		; stored in AX, mid = (start1 + end1) / 2
	dec cx

	push bx			; push start of the left subarray
	push ax			; push end of the left subarray
	call mergeSort	; left subarray
	
	;call DumpRegs
	inc ax
	mov bx, ax
	mov ax, cx
	push bx			; push start of the right subarray
	push ax			; push end of the right subarray
	call mergeSort	; right subarray

	; here will go final call to merge procedure that merges both subarrays

endProc:
	
	ret
mergeSort ENDP

merge PROC
	ret
merge ENDP

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

END MAIN