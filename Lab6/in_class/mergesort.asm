TITLE Merge sort

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc
.data
arr		DWORD 10, 5, 30, 25, 20, 15
start1	WORD ?
start2	WORD ?
end1	WORD ?
end2    WORD ?
two     BYTE 2
tmp1	DWORD ?
tmp2	DWORD ?
; _________________________________ CODE _________________________________
.code
main PROC
	call printArr
	call Crlf
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	
	mov ax, lengthof arr-1	; end = length of array
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
	;call DumpRegs

	cmp ax, bx		; if current array size is 0 or 1 (compare end & start of current array)
	jle endProc		; yes: return the array (base case)

	; no: further split array
	mov cx, ax		; do operations in AX, preserving CX = end, BX = start
	add ax, bx		; end1 + start1
	div two			; stored in AX, mid = (start1 + end1) / 2
	mov ah, 0		; clear AH from any remainder values created by DIV above

	push bx			; push start of the left subarray
	push ax			; push end of the left subarray
	push cx			; push value in ECX, otherwise it would be overwritten
	call mergeSort	; left subarray
	pop cx
	pop ax
	pop bx
	mov start1, bx
	mov end1, ax
	
	inc ax
	mov bx, ax
	mov ax, cx
	push bx			; push start of the right subarray
	push ax			; push end of the right subarray
	push cx			; push value in ECX, otherwise it would be overwritten
	call mergeSort	; right subarray
	pop cx
	pop ax
	pop bx
	mov start2, bx
	mov end2, ax

	call merge

endProc:
	ret
mergeSort ENDP

merge PROC USES esi eax ebx ecx edx
	movzx ecx, start1	; ecx = start1
	movzx edx, start2	; edx = start2
	cmp cx, dx			; if start1 == start2
	je endProc			; yes: then end merge
	mov esi, offset arr	; no: get corresponding values in array

getValues:
	mov eax, edx		; eax = start2
	call convertIndex
	mov ebx, eax		; save index to ebx
	mov eax, ecx		; eax = start1
	call convertIndex

	mov tmp1, eax
	mov tmp2, ebx
	mov ax, [esi+eax]
	mov bx, [esi+ebx]
	;call DumpRegs

	cmp ax, bx		; compare start1 and start2
	jl increment	; jump to increment start1
	jg switch		; jump to switch values & increment start2
	jmp endProc		; jump to the end of procedure

increment:
	inc cx
	cmp cx, dx
	je endProc
	cmp cx, end1
	jge endProc
	jmp getValues

switch:
	;call DumpRegs
	push ecx
	push edx
	mov ecx, eax
	mov edx, ebx
	mov eax, tmp1
	mov ebx, tmp2
	mov [esi+eax], ecx
	mov [esi+ebx], edx
	;call printArr
	;call Crlf
	pop edx
	pop ecx
	inc dx
	cmp cx, dx
	je endProc
	cmp dx, end2
	jge endProc
	jmp getValues

endProc:
	;call DumpRegs
	ret
merge ENDP

; uses value in EAX register
; converts regular index into one
; that matches type of an array.
convertIndex PROC USES ecx
	mov cl, type arr
	mul cl
	ret
convertIndex ENDP

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