TITLE	Midterm Procedures

; Procedure D
;
; Initialize an array with 100 bytes; fill the first half of them
; with 55h and the second half with AAh. Print the elements now in
; an alternating fashion, as in 55h, followed by AAh. Use loops.

INCLUDE Irvine32.inc
.data
arrayb	BYTE 100 DUP(?)

.code
main PROC
	mov esi, offset arrayb
	mov ecx, 50
	t1:
		mov BYTE PTR [esi], 55h
		inc esi
		loop t1
	mov esi, offset arrayb+50
	mov ecx, 50
	t2:
		mov BYTE PTR [esi], 0AAh
		inc esi
		loop t2
	mov esi, offset arrayb
	mov edi, offset arrayb+50
	mov ecx, 50
	mov eax, 0
	t3:
		mov al, [esi]
		call WriteHex
		call Crlf
		inc esi
		mov al, [edi]
		call WriteHex
		call Crlf
		inc edi
		loop t3
	exit
main ENDP
END main