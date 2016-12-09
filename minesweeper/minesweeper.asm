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
y				WORD 30
ButtonID		DWORD 0 ; The control ID of the button control
lgfnt           LOGFONT <18,0,0,0,FW_NORMAL,0,0,0,0,0,0,0,0,"Lucida Console"> ; Text font
smiley DWORD ?
resetButtonText BYTE "Reset", 0
flagger DWORD ?
flagButtonText BYTE "F", 0
flagBool BYTE 0
flagMsg BYTE "FLAG MODE", 0
noFlagMsg BYTE "         ", 0
timeValue       BYTE "000", 0

howToPlay DWORD ?
ID_HOW_TO_PLAY_BUTTON DWORD 0FAh
howToPlayButtonText BYTE "How-To-Play", 0
gameInstructions	BYTE 9, 9, 9, "        Minesweeper", 10
					BYTE "Goal:", 10
					BYTE "Uncover all of the empty squares in the map, while avoiding the 10 mines hidden", 32
					BYTE "on the map, in the quickest time possible. The game is won if all the safe squares", 32
					BYTE "are uncovered, and the game will result in a loss if a mine is tripped.", 10, 10
					BYTE "Numbers on board:", 10
					BYTE "Each number tells you how many mines are in the 8 spaces surrounding that specific space.", 32
					BYTE "This information can be used to deduce which adjacent spaces are safe, and ", 32
					BYTE "which could have bombs.", 10, 10
					BYTE "Counter Bar:", 10 
					BYTE "Displays the number of mines still hidden on the map, and the timer keeps track of", 32
					BYTE "how many seconds it takes to clear the board.", 0
					BYTE "Flag Mode:", 10, 10
					BYTE "To place flags, press the F button which will put you into flag mode. Once in flag",10
					BYTE "mode you will be able to place flags to mark where you believe there are mines", 10
					BYTE "Reset Button:", 10, 10
					BYTE "Click the smiling face button located above the map in the middle of the screen",10
					BYTE "in order to reset the map and start a new game", 10

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
    ;mov	    wc.lpszMenuName, OFFSET MenuName
    mov		wc.lpszClassName, OFFSET ClassName
    invoke	LoadIcon, NULL, IDI_APPLICATION
    mov		wc.hIcon, eax
    mov		wc.hIconSm, eax
    invoke	LoadCursor, NULL, IDC_ARROW
    mov		wc.hCursor, eax
    invoke	RegisterClassEx, addr wc
;---------- [Center the window] ----------
      INVOKE     GetSystemMetrics, SM_CXSCREEN
         sub     eax, 350
         shr     eax, 1
        push     eax
      INVOKE     GetSystemMetrics, SM_CYSCREEN
         sub     eax, 300
         shr     eax, 1
         pop     ebx
;---------- [Create the Main Window] ----------
    invoke	CreateWindowEx, WS_EX_CLIENTEDGE, ADDR ClassName, \
				ADDR AppName, WS_OVERLAPPEDWINDOW, \
				ebx, eax, \
				250, 290, NULL, NULL, hInst ,NULL
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
; This procedure generates grid in forms of buttons (that's the best solution
; we have so far). This grid acts as a outer layer in the game.
generateButtons PROC USES ecx ebx hWnd:HWND
; _______________________________________________________________________________
	invoke	GetModuleHandle, NULL
	; RESET BUTTON **************************************************************
	mov esi, offset smiley
	invoke CreateWindowEx, NULL, ADDR ButtonClassName, ADDR resetButtonText, \
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
			100, 4, 52, 20, hWnd, 500, [esi], NULL
	; FLAG BUTTON ***************************************************************
	mov esi, offset flagger
	invoke CreateWindowEx, NULL, ADDR ButtonClassName, ADDR flagButtonText, \
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
			35, 4, 20, 20, hWnd, 501, [esi], NULL
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

	; HOW-TO-PLAY BUTTON ********************************************************
	add y, 5
	add x, 45
	mov esi, OFFSET howToPlay
	invoke CreateWindowEx, NULL, ADDR ButtonClassName, ADDR howToPlayButtonText, \
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
			x, y, 92, 20, hWnd, ID_HOW_TO_PLAY_BUTTON, [esi], NULL
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
	cmp uMsg, WM_TIMER
	je updateTimer
	cmp uMsg, WM_COMMAND
	je checkCommand
	cmp uMsg, WM_PAINT
	je paintWindow
	jmp defaultWindow

destroyWindow:
	invoke PostQuitMessage, NULL
	jmp xorEAX

createWindow:
	call PlaceMines
	invoke generateButtons, hWnd
	invoke SetTimer,hWnd,222,1000,NULL
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
	jmp updateTimer
	;jmp xorEAX

defaultWindow:
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	jmp endProc

; Checks if button is the reset button or the flag button, reacts accordingly
; Else if it is a normal button ,check if you are in flag mode
buttonClick:
	mov eax, wParam
	cmp eax, 500
	je resetWindow
	cmp eax, 501
	je toggleFlag
	cmp eax, ID_HOW_TO_PLAY_BUTTON
	je displayHowToPlay
	shr eax, 16
	cmp flagBool, 1
	je flagButton		;if in flag mode, flag the mine
	cmp ax, BN_CLICKED
	je removeButton		;otherwise remove the button (floods if zero)
	jmp endProc

displayHowToPlay:
	invoke MessageBox, NULL, ADDR gameInstructions, ADDR howToPlayButtonText, MB_OK 
	jmp xorEAX

;Turn flag mode on if it is currently off; Turn it off if it is currently on.
toggleFlag:
	cmp flagBool, 0
	je setflagMode
		mov flagBool, 0
		invoke BeginPaint,hWnd,ADDR ps
		invoke CreateFontIndirect,ADDR lgfnt
		mov hFont,eax
		invoke SelectObject,originalHDC,hFont
		mov esi, offset noFlagMsg
		invoke TextOut,originalHDC,75,210,esi,9
	jmp endProc

	setflagMode:
		mov flagBool, 1
		invoke BeginPaint,hWnd,ADDR ps
		invoke CreateFontIndirect,ADDR lgfnt
		mov hFont,eax
		invoke SelectObject,originalHDC,hFont
		mov esi, offset flagMsg
		invoke TextOut,originalHDC,75,210,esi,9
	jmp endProc

flagButton:
	mov eax, wParam	;wParam is th button clicked
	call placeFlag
	; TODO: HERE draw bitmap on top of button clicked (at wParam)
	; you may need to calculate pixels based on the index of the button clicked
	; I believe the index is stored in eax, or possibly the e part (why you shift right 16).
	; so divide this by 9, add quotient to x pixels, remainder to y pixels
	; also adjust for size of buttons (remember they are 20 x 20).
	; GOOD LUCK WITH THAT TOLOGON
	jmp endProc

removeButton:
	mov eax, wParam
	call removeButtons
	jmp endProc

; clear buttons, re-generate them, 
; reset values to default, and generate a new game grid
resetWindow:
	call clearGrid
	call clearButtons
	call resetVisitedCells
	call PlaceMines
	mov x, 35
	mov y, 30
	mov ButtonID, 0
	mov flagBool, 0
	invoke generateButtons, hWnd
	; RESET TIMER - START ------------------
	call resetTimeValue
	jmp updateTimer
	; RESET TIMER - END ------------------

updateTimer:
	push eax
	push esi
	invoke BeginPaint,hWnd,ADDR ps
	invoke CreateFontIndirect,ADDR lgfnt
	mov hFont,eax
	invoke SelectObject,originalHDC,hFont
	
	mov esi, OFFSET timeValue
	invoke TextOut,originalHDC,182,6,esi,4
	invoke EndPaint,hWnd, ADDR ps
	call updateTimeValue
	pop esi
	pop eax
	jmp endProc

xorEAX:
	xor eax, eax
endProc:
    ret
WndProc ENDP

updateTimeValue PROC
	mov eax, [esi+2]
	inc eax
	cmp al, '9'
	jg resetFirstAddSecond
	mov [esi+2], eax
	jmp endProc

resetFirstAddSecond:
	mov eax, '0'
	mov [esi+2], eax
	mov eax, [esi+1]
	inc eax
	cmp al, '9'
	jg resetSecondAddThird
	mov [esi+1], eax
	jmp endProc

resetSecondAddThird:
	mov eax, '0'
	mov [esi+1], eax
	mov [esi+2], eax
	mov eax, [esi]
	inc eax
	cmp al, '9'
	jg resetThird
	mov [esi], eax
	jmp endProc

resetThird:
	mov eax, '0'
	mov [esi], eax
	jmp endProc

endProc:
	ret
updateTimeValue ENDP

resetTimeValue PROC uses EAX ESI
	mov eax, '0'
	mov esi, OFFSET timeValue
	mov [esi], eax
	mov [esi+1], eax
	mov [esi+2], eax
	ret
resetTimeValue ENDP
END main
