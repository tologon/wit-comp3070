TITLE	Midterm Procedures

; Procedure C
;
; Fill a 200 word array with values 0-100 in even numbered memory locations
; and -50 to +49 in odd numbered memory locaations. Assume that
; the first location of the array is even numbered.

INCLUDE Irvine32.inc
.data
arrayw	WORD	202 DUP(?)

.code
main PROC
	mov esi, offset arrayw
	mov ecx, lengthof arrayw
	mov eax, 0
	mov ebx, -50
	tologon:
		mov [esi], ax
		call WriteInt
		call Crlf
		add esi, 2
		inc ax
		mov [esi], bx
		mov edx, eax
		movsx eax, bx
		call WriteInt
		call Crlf
		mov eax, edx
		inc bx
		add esi, 2
		dec ecx
		loop tologon
	exit
main ENDP
END main