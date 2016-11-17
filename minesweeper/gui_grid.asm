TITLE Minesweeper
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
; ____________________________ SETTINGS & LIBRARIES ____________________________________________
.model flat,stdcall ; required directives
option casemap:none	; required property

INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\user32.inc
INCLUDE \masm32\include\kernel32.inc
; ____________________________ DATA & DEFINITIONS ______________________________________________
WinMain			PROTO	:DWORD,:DWORD,:DWORD,:DWORD
generateGrid	PROTO	:DWORD, :DWORD, :DWORD, :DWORD

.data 
ClassName		BYTE "SimpleWinClass", 0 
AppName			BYTE "Minesweeper", 0 
MenuName		BYTE "FirstMenu", 0 
ButtonClassName	BYTE "button", 0 
ButtonText		BYTE " ", 0 
x				WORD 20
y				WORD 0

.data?
hInstance	HINSTANCE ? 
CommandLine	LPSTR ? 
hwndButton	HWND ? 

.const 
ButtonID	equ 1	; The control ID of the button control 
IDM_HELLO	equ 1 
IDM_CLEAR	equ 2 
IDM_GETTEXT	equ 3 
IDM_EXIT	equ 4
; ___________________________________ CODE _____________________________________________________
.code
main PROC
    invoke	GetModuleHandle, NULL
    mov		hInstance, eax
    invoke	WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT 
    invoke	ExitProcess, eax
main ENDP

; _____________________________________________________________________________
; This procedure serves two purposes:
; 1. It initializes the main window
; 2. It receives messages and dispatches them to related controls like buttons
WinMain PROC hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
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
    mov		wc.lpszMenuName, OFFSET MenuName 
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
				200, 400, NULL, NULL, hInst ,NULL 
    mov		hwnd, eax 
    invoke	ShowWindow, hwnd,SW_SHOWNORMAL 
    invoke	UpdateWindow, hwnd 
    .WHILE TRUE
        invoke GetMessage, ADDR msg,NULL,0,0 
        .BREAK .IF (!eax) 
        invoke TranslateMessage, ADDR msg 
        invoke DispatchMessage, ADDR msg 
    .ENDW 
    mov     eax,msg.wParam 
    ret 
WinMain endp
; _____________________________________________________________________________

; _______________________________________________________________________________
; This procedure generates grid in forms of buttons (that's the best solution
; we have so far). This grid acts as a outer layer in the game.
generateGrid PROC USES ecx ebx hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
; _______________________________________________________________________________
	mov ecx, 9	; OUTER LOOP
MARCO:
	push ecx	; keep outer counter for later
	mov ecx, 9	; INNER LOOP
	POLO:
		push ecx
		; 3 lines below creates a button at (x, y) coordinates and its 20x20 size
		invoke CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonText, \ 
				WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \ 
				y, x, 20, 20, hWnd, ButtonID, hInstance, NULL
		mov bx, x
		add bx, 20
		mov x, bx
		pop ecx
		loop POLO
	pop ecx
	mov bx, y
	add bx, 20
	mov y, bx
	mov x, 20

	loop MARCO
	ret
generateGrid ENDP
; _______________________________________________________________________________

; _____________________________________________________________
; This procedure receives messages and acts accordingly.
; For example, on button click, it will delete it and display
; cell's value behind that button.
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
; _____________________________________________________________
    .IF uMsg==WM_DESTROY 
        invoke PostQuitMessage,NULL 
    .ELSEIF uMsg==WM_CREATE
		invoke generateGrid, hWnd, NULL, NULL, NULL
        mov  hwndButton,eax 
    .ELSEIF uMsg==WM_COMMAND 
        mov eax,wParam 
        .IF lParam==0 
            .IF  ax==IDM_GETTEXT 
                ;invoke MessageBox,NULL,NULL,ADDR AppName,MB_OK 
            .ELSE 
                invoke DestroyWindow,hWnd 
            .ENDIF 
        .ELSE 
            .IF ax==ButtonID 
                shr eax,16 
                .IF ax==BN_CLICKED 
                    invoke SendMessage,hWnd,WM_COMMAND,IDM_GETTEXT,0 
                .ENDIF 
            .ENDIF 
        .ENDIF 
    .ELSE 
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
        ret 
    .ENDIF 
     xor    eax,eax 
    ret 
WndProc endp
; _____________________________________________________________
END main