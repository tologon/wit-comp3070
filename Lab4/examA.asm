TITLE	Midterm Procedures
; Authors:
; Daniel Zidelis
; Terrance Curley
; Tologon Eshimkanov
; A. eax = -dword1 +- (ebx - ecx) - 1

INCLUDE Irvine32.inc
.data
dword1 DWORD 25

.code
main PROC
	mov ebx, 5
	mov ecx, 3
	call calculate
	exit
main ENDP

calculate PROC
	mov eax, dword1
	neg eax				; cannot neg dword1, because immediate operand is not allowed.
	sub ebx, ecx
	neg ebx
	add eax, ebx
	dec eax
	call WriteInt		; should display -25 + -(5 - 3) - 1 = -28
	call Crlf
	ret
calculate ENDP
END main