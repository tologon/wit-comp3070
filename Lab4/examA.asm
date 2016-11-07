;A. eax = -dword1 +- (ebx - ecx) - 1
INCLUDE Irvine32.inc

.data
dword1 = 25
.code
main PROC
mov ebx, 5
mov ecx, 3
	exit
main ENDP

calculate PROC
	neg dword1
	mov eax, dword1
	sub ebx, ecx
	add eax, ebx
	dec eax
	ret
calculate ENDP

END main