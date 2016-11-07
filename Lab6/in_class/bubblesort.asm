INCLUDE Irvine32.inc
.data
arr			dd 10, 15, 5, 25, 20
count1		dd ?
count2		dd ?
counttemp	dd ?

.code
main PROC
	call PrintArr
	call BubbleSort
	call Crlf
	call PrintArr
	call Crlf

	exit
main ENDP

BubbleSort PROC
	mov count1, lengthof arr
	mov count2, lengthof arr
	mov ecx, count1
	Outer:
		mov counttemp, ecx
		mov esi, offset arr
		mov edi, offset arr + type arr
		mov ecx, count2
		Woody:
			mov eax, [esi]
			mov ebx, [edi]
			cmp eax, ebx
			jl SWITCH
			JMP NEXT

		SWITCH:
			xchg eax, ebx
			mov [esi], eax
			mov [edi], ebx
		NEXT:
			add esi, type arr
			add edi, type arr
			loop Woody
			mov ecx, counttemp
		loop Outer
		ret
BubbleSort ENDP

PrintArr PROC
	mov ecx, lengthof arr
	mov esi, offset arr
	Jose:
		mov eax, [esi]
		call WriteDec
		mov al, ' '
		call WriteChar
		add esi, type arr
	loop Jose

	ret
PrintArr ENDP

END MAIN