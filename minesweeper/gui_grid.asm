TITLE Minesweeper
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
; ____________________________ SETTINGS & LIBRARIES ____________________________________________
.model flat,stdcall ; required directives
option casemap:none	; required property

INCLUDE Grid32.inc
; ____________________________ DATA & DEFINITIONS ______________________________________________
WinMain			PROTO	:DWORD
generateButtons	PROTO	:DWORD

.data 
ClassName		BYTE "SimpleWinClass", 0 
AppName			BYTE "Minesweeper", 0 
ButtonClassName	BYTE "button", 0 
x				WORD 35
y				WORD 20
ButtonID		DWORD 0 ; The control ID of the button control
lgfnt           LOGFONT <14,0,0,0,FW_NORMAL,0,0,0,0,0,0,0,0,"Lucida Console"> ; Text font

.data?
hInstance	HINSTANCE ?
CommandLine	LPSTR ?
hButtons DWORD 81 DUP(?)
; ___________________________________ CODE _____________________________________________________
.code
main PROC
    invoke	GetModuleHandle, NULL
	call PlaceMines
    mov		hInstance, eax
    invoke	WinMain, hInstance
    invoke	ExitProcess, eax
main ENDP

; _____________________________________________________________________________
; This procedure serves two purposes:
; 1. It initializes the main window
; 2. It receives messages and dispatches them to related controls like buttons
WinMain PROC hInst:HINSTANCE
; _____________________________________________________________________________
    LOCAL	wc:WNDCLASSEX 
    LOCAL	msg:MSG 
    LOCAL	hwnd:HWND 
    mov		wc.cbSize, SIZEOF WNDCLASSEX 
    mov		wc.style, CS_HREDRAW or CS_VREDRAW 
    mov		wc.lpfnWndProc, OFFSET WndProc 
    mov		wc.cbClsExtra, NULL 
    mov		wc.cbWndExtra, NULL 
    push	hInst 
    pop		wc.hInstance 
    mov		wc.hbrBackground, COLOR_BTNFACE+1 
    ;mov	wc.lpszMenuName, OFFSET MenuName 
    mov		wc.lpszClassName, OFFSET ClassName 
    invoke	LoadIcon, NULL, IDI_APPLICATION 
    mov		wc.hIcon, eax 
    mov		wc.hIconSm, eax 
    invoke	LoadCursor, NULL, IDC_ARROW 
    mov		wc.hCursor, eax 
    invoke	RegisterClassEx, addr wc 
    invoke	CreateWindowEx, WS_EX_CLIENTEDGE, ADDR ClassName, \ 
				ADDR AppName, WS_OVERLAPPEDWINDOW, \ 
				CW_USEDEFAULT, CW_USEDEFAULT, \ 
				250, 280, NULL, NULL, hInst ,NULL 
    mov		hwnd, eax 


MESSAGES:
    invoke GetMessage, ADDR msg, NULL, NULL, NULL

	cmp eax, 0	; check if main window is closed
	je endProc	; yes: end the program

    invoke TranslateMessage, ADDR msg 
    invoke DispatchMessage, ADDR msg

	invoke	UpdateWindow, hwnd
	invoke	ShowWindow, hwnd, SW_SHOWNORMAL 

	jmp MESSAGES

endProc:
	mov eax, msg.wParam
    ret 
WinMain ENDP

; _______________________________________________________________________________
; This procedure generates grid in forms of buttons (that's the best solution
; we have so far). This grid acts as a outer layer in the game.
generateButtons PROC USES ecx ebx hWnd:HWND
; _______________________________________________________________________________
	mov ecx, 9	; OUTER LOOP
	mov esi, OFFSET hButtons
	mov edi, OFFSET grid
MARCO:
	push ecx	; keep outer counter for later
	mov ecx, 9	; INNER LOOP
	POLO:
		push ecx	; saving ECX value on stack just to be safe
		push esi
		invoke	GetModuleHandle, NULL
		pop esi
		mov	[esi], eax ; unique handle for a button
		; 3 lines below creates a button at (x, y) coordinates and its 20x20 size
		invoke CreateWindowEx, NULL, ADDR ButtonClassName, NULL, \
				WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
				x, y, 20, 20, hWnd, ButtonID, [esi], NULL

		mov [esi], eax
		add esi, type hButtons	; increment to the next item in array
		add ButtonID, type hButtons ; use button ID to increment into array later on
		add x, 20	; move X value to right by 20 pixels
		pop ecx		; returning (from stack) saved value of ECX
		loop POLO
	pop ecx		; bring outer counter to continue
	add y, 20	; move Y value to right by 20 pixels
	mov x, 35	; reset X to default value
	loop MARCO
	
	ret
generateButtons ENDP

; _____________________________________________________________
; This procedure receives messages and acts accordingly.
; For example, on button click, it will delete it and display
; cell's value behind that button.
WndProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
; _____________________________________________________________
	LOCAL hDC:DWORD
	LOCAL hFont:DWORD
	LOCAL ps:PAINTSTRUCT
	cmp uMsg, WM_DESTROY
	je destroyWindow
	cmp uMsg, WM_CREATE
	je createWindow
	cmp uMsg, WM_COMMAND
	je checkCommand
	cmp uMsg, WM_PAINT
	je paintWindow
	jmp defaultWindow

destroyWindow:
	invoke PostQuitMessage, NULL
	jmp xorEAX

createWindow:
	invoke generateButtons, hWnd
	jmp xorEAX

; TODO: interaction with buttons goes here
checkCommand:
	cmp lParam, 0
	jne buttonClick
	;invoke DestroyWindow, hWnd
	jmp xorEAX
	
paintWindow:
	invoke BeginPaint,hWnd,ADDR ps
	mov hDC,eax
	invoke CreateFontIndirect,ADDR lgfnt
	mov hFont,eax
	invoke SelectObject,hDC,hFont
	mov ecx, 9
	mov x, 35
	mov y, 20
	mov esi, offset grid
	JoseMineSupplier:
		push ecx
		mov ecx, 9
		JoseMineLayer:
			invoke TextOut,hDC,x,y,esi,1
			inc esi
			add x, 20
			loop JoseMineLayer
		add y, 20
		mov x, 35
		pop ecx
		loop JoseMineSupplier

defaultWindow:
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	jmp endProc

buttonClick:
	mov eax, wParam
	shr eax, 16
	cmp ax, BN_CLICKED
	je removeButton
	jmp endProc

removeButton:
	mov esi, OFFSET hButtons
	mov ebx, wParam
	mov edx, [esi+ebx]
	invoke DestroyWindow, [esi+ebx]

xorEAX:
	xor eax, eax
endProc:
    ret 
WndProc ENDP
END main