;
INCLUDE Irvine32.inc

.data
darray dd 0, 10, 15
.code
main PROC
	call addtwo
	exit
main ENDP

addtwo PROC
mov esi, offset darray
mov eax, [esi + 4]
add eax, [esi + 8]
mov [esi], eax

	ret
addtwo ENDP

END main