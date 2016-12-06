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
ClassName		BYTE "HowToPlay", 0
AppName			BYTE "How To Play", 0
ButtonClassName	BYTE "button", 0
x				WORD 35
y				WORD 30
ButtonID		DWORD 0 ; The control ID of the button control
lgfnt           LOGFONT <18,0,0,0,FW_NORMAL,0,0,0,0,0,0,0,0,"Lucida Console"> ; Text font
smiley DWORD ?
resetButtonText BYTE "Reset", 0
flagger DWORD ?
flagButtonText BYTE "F", 0
flagBool BYTE 0
flagMsg BYTE "CURRENTLY IN FLAG MODE", 0
timeValue       BYTE "000", 0
.data?
hInstance	HINSTANCE ?
originalHDC DWORD ?
; ___________________________________ CODE _____________________________________________________
.code
main PROC
	call Randomize
    invoke	GetModuleHandle, NULL
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
    mov		wc.hbrBackground, COLOR_BTNFACE
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
	invoke	UpdateWindow, hwnd
	invoke	ShowWindow, hwnd, SW_SHOWNORMAL
MESSAGES:
    invoke GetMessage, ADDR msg, NULL, NULL, NULL
	cmp eax, 0	; check if main window is closed
	je endProc	; yes: end the program
    invoke TranslateMessage, ADDR msg
    invoke DispatchMessage, ADDR msg
	jmp MESSAGES
endProc:
	mov eax, msg.wParam
    ret
WinMain ENDP
; _______________________________________________________________________________

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
 
	cmp uMsg, WM_PAINT
	je paintWindow
	jmp defaultWindow
destroyWindow:
	invoke PostQuitMessage, NULL
	jmp xorEAX
; TODO: interaction with buttons goes here

paintWindow:
	invoke BeginPaint,hWnd,ADDR ps
	mov hDC,eax
  mov originalHDC, eax
	invoke CreateFontIndirect,ADDR lgfnt
	mov hFont,eax
	invoke SelectObject,hDC,hFont
	mov ecx, 9
	mov x, 35
	mov y, 30
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
	jmp xorEAX
defaultWindow:
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	jmp endProc

xorEAX:
	xor eax, eax
endProc:
    ret
WndProc ENDP


END main