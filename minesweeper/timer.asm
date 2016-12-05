TITLE Timer
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;count up timer for minesweeper
; 
.386
.model flat,stdcall
.stack 4096 
ExitProcess PROTO, dwExitCode:DWORD
INCLUDE Irvine32.inc
.data
seconds dd 0
minutes dd 0
.code
main PROC
	mov eax, 0
	mov seconds, eax
	mov minutes, 0
	Jose:
		call Clrscr
		mov eax, seconds
		inc eax
		mov seconds, eax
		cmp seconds, 100
		jge display
		cmp seconds, 10
		jge addZeroDisplay
		jl addTwoZeroDisplay

		addZeroDisplay:
			mov eax, 0
			Call WriteDec
			mov eax, seconds
			Call WriteDec
			jmp final

		addTwoZeroDisplay:
			mov  eax, 0
			Call WriteDec
			Call WriteDec
			mov eax, seconds
			Call WriteDec
			jmp final

		display:
			mov eax, seconds
			call WriteDec
			jmp final
		final: 
			mov eax, 700
			Call Delay

	Loop Jose
main ENDP


END main