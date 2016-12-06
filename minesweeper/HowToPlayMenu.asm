_TITLE Minesweeper
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
; ____________________________ SETTINGS & LIBRARIES ____________________________________________
.model flat,stdcall ; required directives
option casemap:none	; required property
INCLUDE Grid32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000
; ____________________________ DATA & DEFINITIONS ______________________________________________
WinHowTo			PROTO	:DWORD
generateButtons	PROTO	:DWORD
.data
HowToPlayTest	Byte "MineSweeper",0
line1	BYTE "Minesweeper", 10
line2	BYTE "Goal:", 10
line3	BYTE "Uncover all of the empty squares in the map, while avoiding the 10 mines hidden", 10
line4	BYTE "on the map, in the quickest time possible. The game is won if all the safe squares", 10
line5	BYTE "are uncovered, and the game will result in a loss if a mine is tripped.", 10
line6   BYTE " ", 10
line7	BYTE "Numbers on board:",10
line8	BYTE "Each number tells you how many mines are in the 8 spaces surrounding that specific",10
line9	BYTE "space. This information can be used to deduce which adjacent spaces are safe, and ",10
line10	BYTE "which could have bombs.",10
line11	BYTE " ",10
line12  BYTE "Counter Bar:",10 
line13	BYTE "Displays the number of mines still hidden on the map, and the timer keeps track of",10
line14	BYTE "how many seconds it takes to clear the board.",0

buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE "howtoplay.txt"
fileHandle HANDLE ?
ClassName		BYTE "HowToPlay", 0
AppName			BYTE "How To Play", 0
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
    invoke	WinHowTo, hInstance
    invoke	ExitProcess, eax
main ENDP
; _____________________________________________________________________________
; This procedure serves two purposes:
; 1. It initializes the main window
; 2. It receives messages and dispatches them to related controls like buttons
WinHowTo PROC hInst:HINSTANCE
; _____________________________________________________________________________
    LOCAL	wc:WNDCLASSEX
    LOCAL	msg:MSG
    LOCAL	hwnd:HWND
    mov		wc.cbSize, SIZEOF WNDCLASSEX
    mov		wc.style, CS_HREDRAW or CS_VREDRAW
    mov		wc.lpfnWndProc, OFFSET WndHTPProc
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
				1100, 700, NULL, NULL, hInst ,NULL
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
WinHowTo ENDP
; _______________________________________________________________________________

; _____________________________________________________________
; This procedure displays the How To Play directions by printing
; them to the window line by line and changing the x, and y 
; coordinates to display it in a neat and orderly way
WndHTPProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
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
	mov esi, offset line1
	mov ecx, SIZEOF line1
	Jose1:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose1
	add y, 30
	mov x, 40
	mov esi, offset line2
	mov ecx, SIZEOF line2
	Jose2:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose2
	add y,30
	mov x, 40
	mov esi, offset line3
	mov ecx, SIZEOF line3
	Jose3:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose3
	add y,30
	mov x, 40
	mov esi, offset line4
	mov ecx, SIZEOF line4
	Jose4:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose4
	add y,30
	mov x, 40
	mov esi, offset line5
	mov ecx, SIZEOF line5
	Jose5:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose5
	add y,30
	mov x, 40
	mov esi, offset line6
	mov ecx, SIZEOF line6
	Jose6:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose6
	add y,30
	mov x, 40
	mov esi, offset line7
	mov ecx, SIZEOF line7
	Jose7:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose7
	add y,30
	mov x, 40
	mov esi, offset line8
	mov ecx, SIZEOF line8
	Jose8:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose8
	add y,30
	mov x, 40
	mov esi, offset line9
	mov ecx, SIZEOF line9
	Jose9:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose9
	add y,30
	mov x, 40
	mov esi, offset line10
	mov ecx, SIZEOF line10
	Jose10:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose10
	add y,30
	mov x, 40
	mov esi, offset line11
	mov ecx, SIZEOF line11
	Jose11:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose11
	add y,30
	mov x, 40
	mov esi, offset line12
	mov ecx, SIZEOF line12
	Jose12:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose12
	add y,30
	mov x, 40
	mov esi, offset line13
	mov ecx, SIZEOF line13
	Jose13:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose13
	add y,30
	mov x, 40
	mov esi, offset line14
	mov ecx, SIZEOF line14
	Jose14:
	invoke TextOut, hDC, x, y, esi, 1
	add x, 12
	inc esi
	Loop Jose14

	jmp xorEAX
defaultWindow:
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	jmp endProc

xorEAX:
	xor eax, eax
endProc:
    ret
WndHTPProc ENDP

END main