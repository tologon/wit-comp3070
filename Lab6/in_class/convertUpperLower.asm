TITLE In class: Upper-Lower case conversion

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc
.data
regularInput	db 300 DUP(0)
lengthofstr		dd ?
upperInput		db 300 DUP(0)
lowerInput		db 300 DUP(0)
prompt1			db "Please enter a string:", 0
prompt2			db "Do you want to convert to uppercase or lowercase?", 0
prompt3			db "Enter 1 for Lowercase or 2 for Uppercase: ", 0

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
; at end of proc regularInput will equal the user input.
; stores length in lengthofstr variable
usrinput PROC
    mov edx, offset prompt1
    call WriteString
    mov edx, offset regularInput
    mov ecx, sizeof regularInput
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
    call Readint
	cmp eax, 1
	je convertToLower
	cmp eax, 2
	je convertToUpper
	jmp startChoice
   
convertToUpper:
	call toUpper
	call printUpper
	jmp endChoice

convertToLower:
	call toLower
	call printLower
	jmp endChoice

endChoice: 
	ret
choice ENDP

toUpper PROC
	mov eax, 0
	mov ecx, lengthofstr
	mov esi, offset regularInput
	mov edi, offset upperInput
	Jose:
		mov al, [esi]
		cmp al, 'a'
		jge secondCheck
		jmp endOfJose

	secondCheck:
		cmp al, 'z'
		jle changeCase
		jmp endOfJose

	changeCase:
		xor al, 20h
		jmp endOfJose

	endOfJose:
		mov [edi], al
		mov eax, ecx
		inc edi
		inc esi
		loop Jose

	ret
toUpper ENDP

toLower PROC
	mov eax, 0
	mov ecx, lengthofstr
	mov esi, offset regularInput
	mov edi, offset lowerInput
	Jose:
		mov al, [esi]
		cmp al, 'A'
		jge secondCheck
		jmp endOfJose

	secondCheck:
		cmp al, 'Z'
		jle changeCase
		jmp endOfJose

	changeCase:
		add al, 20h
		jmp endOfJose

	endOfJose:
		mov [edi], al
		mov eax, ecx
		inc edi
		inc esi
		loop Jose

	ret
toLower ENDP

printUpper PROC
	mov eax, 0
	mov ecx, lengthofstr	
	mov esi, offset upperInput
	print1:
		mov al, [esi]
		call WriteChar
		inc esi
	loop print1
	call Crlf
	ret
printUpper ENDP

printLower PROC
	mov eax, 0
	mov ecx, lengthofstr	
	mov esi, offset lowerInput
	print2:
		mov al, [esi]
		call WriteChar
		inc esi
	loop print2
	call Crlf
	ret
printLower ENDP
END MAIN