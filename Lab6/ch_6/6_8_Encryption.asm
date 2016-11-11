TITLE 6.11 Programming Exercises

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 8. Message Encryption

INCLUDE Irvine32.inc

.data
; Strings to write to console
prompt db "Enter the plain text: ", 0
strEnc db "Cipher text: ", 0
strDec db "Decrypted: ", 0

; The characters that is compared to the string in order to encrypt it.
key db "ABXmv#7", 0

; buffer either will contain the user input string or the encrypted version of that string.
; it is translated back and forth through the program.
buffer db 100 DUP(0)
bufferSize dd ?

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

; Prompts user for input, then stores it in the buffer array
; Also saves the length of the user input in bufferSize
; OUTPUT: user input into buffer, size of input into bufferSize
; USES: edx for location of strings in memory
;	ecx for input loop in readString
;	eax for length of the final input (given by readString)
UserInput PROC uses edx ecx eax
	mov edx, offset prompt
	call WriteString
	mov ecx, lengthof buffer
	mov edx, offset buffer
	call ReadString
	mov bufferSize, eax
	call Crlf
	ret
UserInput ENDP

; Outputs the current content of buffer
; INPUT: edx should contain location of a string labeling the output
; OUTPUT: current contents of buffer is output to console. This will either be the encrypted or decrypted string
;	depending on how the Translate procedure is used.
DisplayMsg PROC
	call WriteString
	mov edx, offset buffer
	call WriteString
	call Crlf
	call Crlf
	ret
DisplayMsg ENDP

; XORs the contents of the buffer with the key to encrypt or decrypt the message.
; OUTPUT: the characters in the buffer will be translated using the key
; USES: esi contains the location of the buffer in memory
;	ebx is used to keep track of how much of the buffer has been translated
;	ecx is used as loop count, either contains the length of the key or the remaining length of the buffer, whichever is smaller.
;	edi points to the key in memory
;	eax is used to xor the characters (avoids mem, mem)
Translate PROC uses esi ebx ecx edi eax
	mov esi, offset buffer
	mov ebx, bufferSize
	
	checkLength:				; checks which
	mov ecx, lengthof key
	cmp ecx, ebx				; if the size of remaining characters in string is less than the length of key
	jl startLoop
	mov ecx, ebx				; then use the remaining length of string for loop count.
	
	startLoop:
	sub ebx, ecx
	mov edi, offset key
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