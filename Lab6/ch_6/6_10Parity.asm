TITLE Chapter 6 Exercise 10 -- Parity Checking
INCLUDE Irvine32.inc

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Program will implement a procedure that checks if the parity of an array is odd or even.
; It does so by deciding of the total sum of bits (bitwise) is odd or even.
; The procedure will be tested on two byte arrays, one odd and one even.

.data
oddarr db 11010101b, 10001000b, 10010001b, 10101010b, 10000001b, 10000000b, 00010001b, 01010101b, 00001000b, 11111110b	; 31 bits
evenarr db 10000100b, 10101000b, 10011011b, 10001010b, 10000000b, 10010000b, 00010101b, 01010001b, 00001000b, 11010110b	; 28 bits

.code
main PROC
	mov esi, offset oddarr
	mov ecx, lengthof oddarr
	call CheckParity
	call DumpRegs
	call Crlf
	
	mov esi, offset evenarr
	mov ecx, lengthof evenarr
	call CheckParity
	call DumpRegs
	call Crlf

	exit
main ENDP

; INPUT:
; esi is set to the location of the array being checked
; ecx is set to the length of the array
; OUTPUT:
; eax will have the value of 1 (true) if the parity of the array is even, or 0 (false) if the parity is odd.
; USES: 
; ebx to flip the value of eax between true and false.
; edx to hold value of current byte
CheckParity PROC uses ebx edx
	mov eax, 1				; Procedure places value of 1 in eax if parity is even, so 1 is the default (parity is even if all bytes are zero)
	mov ebx, 0				
	mov edx, 0				; edx
	Jose:
		mov dl, [esi]
		XOR dl, 0			; parity flag is set if even, cleared if odd.
		JPE next			; if current byte is even, the overall parity will not change, so move on to next byte.
		
		xchg al, bl			; if current byte is odd, this will change the value of the overall parity from 1 to 0, or 0 to 1.
		
		next:
		inc esi
		loop Jose
	ret
CheckParity ENDP

END main