TITLE 6.11 Programming Exercises

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 8. Message Encryption

INCLUDE Irvine32.inc

.data
prompt db "Enter the plain text: ", 0
strEnc db "Cipher text: ", 0
strDec db "Decrypted: ", 0

key db "ABXmv#7", 0

inputString db 100 DUP(0)
inputSize dd ?

.code

main PROC
	call UserInput
	call Translate
	mov edx, offset strEnc
	call DisplayMsg
	call Translate
	mov edx, offset strDec
	call DisplayMsg

	exit
main ENDP

; Prompts user for input, then stores it in the inputString array
; Also saves the length of the user input in inputSize
UserInput PROC uses edx ecx eax
	mov edx, offset prompt
	call WriteString
	mov ecx, 100
	mov edx, offset inputString
	call ReadString
	mov inputSize, eax
	call Crlf
	ret
UserInput ENDP

DisplayMsg PROC
	call WriteString
	mov edx, offset inputString
	call WriteString
	call Crlf
	call Crlf
	ret
DisplayMsg ENDP

Translate PROC
	mov esi, offset inputString
	mov edi, offset key
	mov ebx, inputSize
	
	checkLength:				; checks which
	mov ecx, lengthof key
	cmp ecx, ebx				; if the size of remaining characters in string is less than the length of key
	jl startLoop
	mov ecx, ebx				; then use the remaining length of string for loop count.
	
	startLoop:
	sub ebx, ecx
	Jose:
		mov al, [edi]			; move current part of key into al
		xor [esi], al			; translate using xor
		inc esi
		inc edi
		loop Jose
	cmp ebx, 0					; see if you have converted entire string yet
	jg checkLength				; if not jump back to checklength.
	ret							; otherwise return
Translate ENDP

END main