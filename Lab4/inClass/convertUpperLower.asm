Include Irvine32.inc

.data
inputstring db 300 DUP(0)
lengthofstr dd ?
upperstr db 300 DUP(0)
lowerstr db 300 DUP(0)
prompt1 db "Please Enter a String:",0
prompt2 db "Do you want to convert to uppercase or lowercase?",0
prompt3 db "Enter 1 for Lowercase or 2 for Uppercase:",0
.code
main PROC
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	call usrinput
	call choice
	exit
main ENDP

; uses edx, ecx, eax
; at end of proc inputstring will equal the user input.
; stores length in lengthofstr variable
usrinput PROC
	mov edx, offset prompt1
	call WriteString
	mov edx, offset inputstring
	mov ecx, sizeof inputstring
	call Crlf
	call ReadString
	mov lengthofstr, eax
	call Crlf
	ret
usrinput ENDP

; uses edx, eax
; at end of proc eax will equal 1 if user wants to convert to lowercase
; eax will equal 2 if they want to convert to uppercase
choice PROC
	startChoice:
		mov edx, offset prompt2
		call WriteString
		call Crlf
		mov edx, offset prompt3
		call WriteString
		call Crlf
		call Readint
		cmp eax, 1
			je endChoice
		cmp eax, 2
			je endChoice
		jmp startChoice
	endChoice:
	ret
choice ENDP

tolower PROC
	mov ecx, lengthofstr
	mov esi, offset inputstr
	mov edi, offsettolower
	Joseph:
		cmp [esi], 'a'
		jge checkz
		cmp[esi], 



		checkz:
		cmp [esi] 'z'
		jle lowercase
		
		uppercase:


		lowercase:
		mov ebx, [esi]	; no mem, mem
		mov [edi], ebx
		inc esi
		inc edi
		loop Joseph
	ret
tolower ENDP

END MAIN