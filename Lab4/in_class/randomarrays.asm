
INCLUDE Irvine32.inc

.data
output1 BYTE "arrayB ", 0
output2 BYTE "arrayW ", 0
output3 BYTE "arrayDW ", 0

arrayb BYTE 5 DUP(?)
arrayw WORD 5 DUP(?)
arraydw DWORD 5 DUP(?)
.code
main PROC
	call Randomize
	mov ecx, 5
	mov esi, offset arrayb
	mov edi, offset arrayw
	mov ebx, offset arraydw
	Jose:
		call Random32
		mov [esi], al
		mov [edi], ax
		mov [ebx], eax
		inc esi
		add edi, 2
		add ebx, 4
		loop Jose
	mov ecx, 5
	mov esi, offset arrayb
	mov edi, offset arrayw
	mov ebx, offset arraydw

	mov edx, offset output1
	mov eax, 12
	call SetTextColor
	call WriteString
	call Crlf
	mov edx, offset output2
	mov eax, 11
	call SetTextColor
	call WriteString
	call Crlf
	mov edx, offset output3
	mov eax, 10
	call SetTextColor
	call WriteString
	call Crlf
	mov edx, 0
	Jose2:
		mov eax, 0
		add dl, 10
		call Gotoxy
		mov al, 12
		call SetTextColor
		mov al, [esi]
		call WriteHex
		add dh, 1
		call Gotoxy
		mov ax, 11
		call SetTextColor
		mov ax, [edi]
		call WriteHex
		add dh, 1
		call Gotoxy
		mov eax, 10
		call SetTextColor
		mov eax, [ebx]
		call WriteHex
		add dh, 1
		call Gotoxy
		inc esi
		add edi, 2
		add ebx, 4
		mov dh, 0
		loop Jose2

		mov eax, 15
		call SetTextColor
	call Crlf

	exit
main ENDP
END main