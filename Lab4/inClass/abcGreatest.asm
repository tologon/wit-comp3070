Include Irvine32.inc

.data
a db ?
b db ?
c db ?

.code
main PROC
	call ReadInt
	mov bl, al		;bl = b
	call ReadInt
	mov cl, al		;cl = c
	call ReadInt	;al = a

	exit
main ENDP

Greatest PROC
	cmp al, bl
	jge compAC
	jl compBC

compAC:
	cmp al, cl
	jge aGreat
	jl cGreat

compBC:
	jge bGreat
	jl cGreat

aGreat:
bGreat:
cGreat:

	ret
Greatest ENDP
ENDMAIN