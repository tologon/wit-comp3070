TITLE	Midterm Procedures

; Authors:
; Daniel Zidelis
; Terrance Curley
; Tologon Eshimkanov

INCLUDE Irvine32.inc
.data
darray dd 0, 10, 15

.code
main PROC
	call addtwo
	mov esi, offset darray
	mov eax, [esi]
	call WriteDec
	call Crlf
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