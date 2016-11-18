; All credit to KIP IRVINE for the Randomize, Random32, and RandomRange Procedures
; I have moved those procedures to this include file for compatibility with the MASM32 Libraries

INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\user32.inc
INCLUDE \masm32\include\kernel32.inc
.data
sysTime SYSTEMTIME <>

grid	BYTE 9 DUP(48)
rowSize	= ($ - grid)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)
		BYTE 9 DUP(48)

.code
PlaceMines PROC uses ecx esi eax
	mov ecx, 10
	MineLayer:
		mov esi, offset grid
		mov eax, 81
		call RandomRange
		add esi, eax
		call IncCells
		mov eax, 42
		mov [esi], al

		
		loop MineLayer
	ret
PlaceMines ENDP

IncCells PROC uses ebx edx
	mov bl, 9
	div bl				; puts quotient of esi / 9 into al and remainder into ah.
	mov edx, 1			; Required to increment cells by reference
	
		cmp al, 0
		je Lower	
	Upper:
		mov bl, [esi-9]
		cmp bl, 42
		je Lower
		add [esi-9], dl
	
	Lower:
		cmp al, 8
		je Left
		mov bl, [esi+9]
		cmp bl, 42
		je Left
		add [esi+9], dl
	
	Left:
		cmp ah, 0
		je Right
		
		cmp al, 0
		je Left2
		mov bl, [esi-10]
		cmp bl, 42
		je Left2
		add [esi-10], dl
		
		Left2:
		mov bl, [esi-1]
		cmp bl, 42
		je Left3
		add [esi-1], dl
		
		Left3:
		cmp al, 8
		je Right
		mov bl, [esi+8]
		cmp bl, 42
		je Right
		add [esi+8], dl
		
	
	Right:
		cmp ah, 8
		je Done
		
		cmp al,0
		je Right2
		mov bl, [esi-8]
		cmp bl, 42
		je Right2
		add [esi-8], dl
		
		Right2:
		mov bl, [esi+1]
		cmp bl, 42
		je Right3
		add [esi+1], dl
		
		Right3:
		cmp al, 8
		je Done
		mov bl, [esi+10]
		cmp bl, 42
		je Done
		add [esi+10], dl
	
	Done:
	ret
IncCells ENDP

;--------------------------------------------------------
Randomize PROC
;
; Re-seeds the random number generator with the current time
; in seconds. Calls GetSystemTime, which is accurate to 10ms.
; Receives: nothing
; Returns: nothing
; Last update: 09/06/2002
;--------------------------------------------------------
	  pushad

	  INVOKE GetSystemTime,OFFSET sysTime
	  movzx eax,sysTime.wMilliseconds
	  mov   seed,eax

	  popad
	  ret
Randomize ENDP

;--------------------------------------------------------------
RandomRange PROC
;
; Returns an unsigned pseudo-random 32-bit integer
; in EAX, between 0 and n-1. Input parameter:
; EAX = n.
; Last update: 09/06/2002
;--------------------------------------------------------------
	 push  ebx
	 push  edx

	 mov   ebx,eax  ; maximum value
	 call  Random32 ; eax = random number
	 mov   edx,0
	 div   ebx      ; divide by max value
	 mov   eax,edx  ; return the remainder

	 pop   edx
	 pop   ebx

	 ret
RandomRange ENDP

;--------------------------------------------------------------
Random32  PROC
;
; Generates an unsigned pseudo-random 32-bit integer
;   in the range 0 - FFFFFFFFh.
; Receives: nothing
; Returns: EAX = random integer
; Last update: 7/11/01
;--------------------------------------------------------------
.data
seed  DWORD 1
.code
	  push  edx
	  mov   eax, 343FDh
	  imul  seed
	  add   eax, 269EC3h
	  mov   seed, eax    ; save the seed for the next call
	  ror   eax,8        ; rotate out the lowest digit (10/22/00)
	  pop   edx

	  ret
Random32  ENDP