TITLE Minesweeper
; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
; ____________________________ SETTINGS & LIBRARIES _____________________________________________________________
.model flat,stdcall ; required directives
option casemap:none	; required property

INCLUDE Grid32.inc
; ____________________________ DATA & DEFINITIONS _______________________________________________________________
.data
; [windows VARIABLES]
originalHDC DWORD ?
hInstance HINSTANCE ?
timeValue BYTE "000", 0
AppName BYTE "Minesweeper", 0
WindowClassName BYTE "WindowsClass", 0
lgfnt LOGFONT <18,0,0,0,FW_NORMAL,0,0,0,0,0,0,0,0,"Lucida Console"> ; Text font
; -----------------------------------------------------------------------------

; [grid buttons VARIABLES]
x WORD 35
y WORD 30
ButtonID DWORD 0
generateButtonsHandle DWORD ?
ButtonClassName	BYTE "Button", 0
; ------------------------------

; [reset/smiley VARIABLES]
smiley DWORD ?
resetButtonText BYTE "^_^", 0
; ---------------------------

; [flag VARIABLES]
flagger DWORD ?
flagBool BYTE 0
flagMsg BYTE "FLAG ON", 0
flagButtonText BYTE "F", 0
noFlagMsg BYTE "       ", 0
; -------------------------

; [WndProc local VARIABLES]
WndProc_hDC DWORD 0
WndProc_hFont DWORD 0
; -------------------

; [WinMain local VARIABLES]
WinMain_hwnd HWND 0
; -----------------

; [how-to-play VARIABLES]
howToPlay DWORD ?
ID_HOW_TO_PLAY_BUTTON DWORD 0FAh
howToPlayButtonText BYTE "How-To-Play", 0
instructions BYTE 9, 9, 9, "        Minesweeper", 10
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
; ___________________________________ CODE ______________________________________________________________________
.code
main PROC
  call    Randomize
  invoke  GetModuleHandle, NULL
  mov     hInstance, eax
  call    WinMain
  invoke  ExitProcess, eax
main ENDP

; _____________________________________________________________________________
; This procedure serves two purposes:
; 1. It initializes the main window
; 2. It receives messages and dispatches them to related controls like buttons
WinMain PROC
; _____________________________________________________________________________
  ; Local variables below must be initialized that way in order for the rest
  ; of code in this procedure to work. There is no simple work around that.
  ; We've taken out all other local variables that didn't crash the program.
  LOCAL   wc:WNDCLASSEX
  LOCAL   msg:MSG
  mov     wc.cbSize, SIZEOF WNDCLASSEX
  mov     wc.style, CS_HREDRAW or CS_VREDRAW
  mov     wc.lpfnWndProc, OFFSET WndProc
  mov     wc.cbClsExtra, NULL
  mov     wc.cbWndExtra, NULL
  push    hInstance
  pop     wc.hInstance
  mov     wc.hbrBackground, COLOR_BTNFACE
  mov     wc.lpszClassName, OFFSET WindowClassName
  invoke  LoadIcon, NULL, IDI_APPLICATION
  mov     wc.hIcon, eax
  mov     wc.hIconSm, eax
  invoke  LoadCursor, NULL, IDC_ARROW
  mov     wc.hCursor, eax
  invoke  RegisterClassEx, ADDR wc
  ; [CENTER THE WINDOW]
  invoke  GetSystemMetrics, SM_CXSCREEN
  sub     eax, 350
  shr     eax, 1
  push    eax
  invoke  GetSystemMetrics, SM_CYSCREEN
  sub     eax, 300
  shr     eax, 1
  pop     ebx
  ; [CREATE THE WINDOW]
  invoke  CreateWindowEx, WS_EX_CLIENTEDGE, ADDR WindowClassName, \
          ADDR AppName, WS_OVERLAPPEDWINDOW, \
          ebx, eax, \
          250, 290, NULL, NULL, hInstance ,NULL
  mov     WinMain_hwnd, eax
  invoke  UpdateWindow, WinMain_hwnd
  invoke  ShowWindow, WinMain_hwnd, SW_SHOWNORMAL

MESSAGES:
  invoke  GetMessage, ADDR msg, NULL, NULL, NULL
  cmp     eax, 0	; check if main window is closed
  je      endProc	; yes: end the program

  invoke  TranslateMessage, ADDR msg
  invoke  DispatchMessage, ADDR msg
	jmp MESSAGES

endProc:
  mov eax, msg.wParam
  ret
WinMain ENDP

; _______________________________________________________________________________
; This procedure generates grid in forms of buttons (that's the best solution
; we have so far). This grid acts as a outer layer in the game.
generateButtons PROC uses ECX EBX
; _______________________________________________________________________________
  invoke  GetModuleHandle, NULL
  ; [RESET BUTTON]
  mov     esi, OFFSET smiley
  invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR resetButtonText, \
          WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
          104, 4, 40, 25, generateButtonsHandle, 500, [esi], NULL
  ; [FLAG BUTTON]
  mov     esi, OFFSET flagger
  invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR flagButtonText, \
          WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
          35, 4, 20, 20, generateButtonsHandle, 501, [esi], NULL

  mov ecx, 9	; OUTER LOOP
  mov esi, OFFSET hButtons
  mov edi, OFFSET grid
MARCO:
  push  ecx	; keep outer counter for later
  mov   ecx, 9	; INNER LOOP
  POLO:
    push    ecx	; saving ECX value on stack just to be safe
    push    esi
    invoke  GetModuleHandle, NULL
    pop     esi
    mov	    [esi], eax ; unique handle for a button
    ; 3 lines below creates a button at (x, y) coordinates and its 20x20 size
    invoke  CreateWindowEx, NULL, ADDR ButtonClassName, NULL, \
            WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
            x, y, 20, 20, generateButtonsHandle, ButtonID, [esi], NULL
    mov     [esi], eax
    add     esi, type hButtons ; increment to the next item in array
    add     ButtonID, type hButtons ; use button ID to increment into array later on
    add     x, 20	; move X value to right by 20 pixels
    pop     ecx		; returning (from stack) saved value of ECX
    loop POLO

  pop ecx		; bring outer counter to continue
  add y, 20	; move Y value to right by 20 pixels
  mov x, 35	; reset X to default value
  loop MARCO

  ; [HOW-TO-PLAY BUTTON]
  add     y, 5
  add     x, 85
  mov     esi, OFFSET howToPlay
  invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR howToPlayButtonText, \
          WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
          x, y, 92, 20, generateButtonsHandle, ID_HOW_TO_PLAY_BUTTON, [esi], NULL
  ret
generateButtons ENDP

; _____________________________________________________________
; This procedure receives messages and acts accordingly.
; For example, on button click, it will delete it and display
; cell's value behind that button.
WndProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
; _____________________________________________________________
	; Local variable below must be initialized that way in order for the rest
	; of code in this procedure to work. There is no simple work around that.
	; We've taken out all other local variables that didn't crash the program.
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

	push eax
	mov eax, hWnd
	mov generateButtonsHandle, eax
	pop eax
	call generateButtons

	invoke SetTimer,hWnd,222,1000,NULL
	jmp xorEAX

checkCommand:
	cmp lParam, 0
	jne buttonClick
	jmp xorEAX

paintWindow:
	invoke BeginPaint,hWnd,ADDR ps
	mov WndProc_hDC,eax
  mov originalHDC, eax
	invoke CreateFontIndirect,ADDR lgfnt
	mov WndProc_hFont,eax
	invoke SelectObject,WndProc_hDC,WndProc_hFont
	mov ecx, 9
	mov x, 35
	mov y, 30
	mov esi, offset grid
	JoseMineSupplier:
		push ecx
		mov ecx, 9
		JoseMineLayer:
			invoke TextOut,WndProc_hDC,x,y,esi,1
			inc esi
			add x, 20
			loop JoseMineLayer
		add y, 20
		mov x, 35
		pop ecx
		loop JoseMineSupplier
	jmp updateTimer

defaultWindow:
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	jmp endProc

; Checks if button is the reset button or the flag button, reacts accordingly
; Else if it is a normal button, check if you are in flag mode
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
	invoke MessageBox, NULL, ADDR instructions, ADDR howToPlayButtonText, MB_OK
	jmp xorEAX

;Turn flag mode on if it is currently off; Turn it off if it is currently on.
toggleFlag:
	cmp flagBool, 0
	je setflagMode
		mov flagBool, 0
		invoke BeginPaint,hWnd,ADDR ps
		invoke CreateFontIndirect,ADDR lgfnt
		mov WndProc_hFont,eax
		invoke SelectObject,originalHDC,WndProc_hFont
		mov esi, offset noFlagMsg
		invoke TextOut,originalHDC,35,215,esi,7
	jmp endProc

	setflagMode:
		mov flagBool, 1
		invoke BeginPaint,hWnd,ADDR ps
		invoke CreateFontIndirect,ADDR lgfnt
		mov WndProc_hFont,eax
		invoke SelectObject,originalHDC,WndProc_hFont
		mov esi, offset flagMsg
		invoke TextOut,originalHDC,35,215,esi,7
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

	push eax
	mov eax, hWnd
	mov generateButtonsHandle, eax
	pop eax
	call generateButtons

	; RESET TIMER - START ------------------
	call resetTimeValue
	jmp updateTimer
	; RESET TIMER - END ------------------

updateTimer:
	push eax
	push esi
	invoke BeginPaint,hWnd,ADDR ps
	invoke CreateFontIndirect,ADDR lgfnt
	mov WndProc_hFont,eax
	invoke SelectObject,originalHDC,WndProc_hFont

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
