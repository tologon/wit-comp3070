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
	
	mov start1, 0
	mov ax, lengthof arr	; end = length of array		
	mov end1, ax
	call mergeSort
	call PrintArr
	call Crlf
	exit
main ENDP

; start1 contains current array beginning
; end1 contains current array ending
mergeSort PROC
	call printValues
	mov ax, end1
	mov bx, start1
	sub ax, bx
	cmp al, 1			; if current array size is 0 or 1
	jle	endProc			; yes: return the array (base case)

	mov ax, end1		; no: further split array
	add ax, bx			; end1 + start1
	shr ax, 1			; stored in AX, mid = (start1 + end1) / 2
	dec ax

	mov cx, end1		; preserve end1 value for right subarray
	mov end1, ax		; end1 = mid - 1
	call mergeSort		; left subarray

	mov bx, end1
	mov end2, bx		; move end1 to end2
	mov bx, start1
	mov start2, bx		; move start1 to start2

	inc ax
	mov start1, ax		; start1 = mid
	mov end1, cx		; end1 = end of the current array
	call mergeSort		; right subarray

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

printValues PROC USES eax ebx
	movzx eax, start1
	movzx ebx, end1
	call DumpRegs
	ret
printValues ENDP

END MAIN