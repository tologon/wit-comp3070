TITLE In class: sum values in an array up to a certain number

; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov

INCLUDE Irvine32.inc

.data
array DWORD 100 DUP (?)
s1 BYTE "How many numbers would you like to input?:", 0
s2 BYTE "Please Enter Number:", 0
s3 BYTE "Up to what number would you like me to add?:", 0
sizeIn DWORD ?
total DWORD 0
.code
main PROC
	call UserIn
	call sumElements
	exit
main ENDP

; Uses edx, eax, ecx, esi
; Asks user how many inputs they want to enter, then prompts to enter all numbers
; stores in array
UserIn PROC uses edx eax ecx esi
	mov edx, 0
	mov esi, offset array
	mov edx, offset s1
	call WriteString
	call ReadInt
	mov sizeIn, eax
	mov ecx, eax
	mov edx, offset s2
	Jose:
		call Crlf
		call WriteString
		call ReadInt
		mov [esi], eax
		add esi, type array
		loop Jose
	ret
UserIn ENDP

; this procedure uses ECX, ESI, EAX
; it stores result in EAX register
sumElements PROC
	mov edx, offset s3
	call WriteString
	call ReadInt
    mov ecx, eax
    mov esi, offset array
    mov eax, 0
    sum:
        add eax, [esi]
        add esi, type array
    loop sum
	mov total, eax
	call printStuff
	;call WriteInt
	;call Crlf
    ret
sumElements ENDP

;this procudure uses ECX, ESI, EAX
    printStuff PROC
    mov ecx, sizeIn
    mov esi, offset array
    mov eax, 0
    JoseTwo:
        mov ax, [esi]
        Call WriteInt
        Call crlf
        add esi, type array
        loop JoseTwo

    mov eax, 0
    mov eax, total
    Call WriteInt
    Call crlf
    ret
	printStuff ENDP

END main