; Authors: Daniel Zidelis, Terrance Curley, Tologon Eshimkanov
;
; Exercise 4. College Registration
;
;Using the College Registration example from Section 6.7.3 as a starting point, do the following:
;Recode the logic using CMP and conditional jump instructions (instead of the .IF and
; .ELSEIF directives).
;Perform range checking on the credits value; it cannot be less than 1 or greater than 30. If an
; invalid entry is discovered, display an appropriate error message.
;Prompt the user for the grade average and credits values.
; Display a message that shows the outcome of the evaluation, such as “The student can register”
;or “The student cannot register”.
;---------------------------------------------------------------------------------------
INCLUDE Irvine32.inc
.data 
gradeAverage WORD 275	; test value
credits WORD 12			; test value
OkToRegister BYTE ?

registryOkMSG db "The student can register", 0
registryFailMSG db "The student cannot register", 0
getAverageMSG db "Please enter the grade average : ", 0
getCreditsMSG db "Please enter the number of credits : ", 0
creditErrorL db "Not a valid amount of credits! Needs to be more than 1", 0
creditErrorG db "Not a valid amount of credits! Needs to be less than 30", 0
.code	
main PROC
	mov OkToRegister, 0
	call getGradeAverage
	call getCreditsPro
	call creditCheckerPro
	cmp OkToRegister, 0
	je Failed

	mov edx, offset registryOkMSG
	JMP mainDone

	Failed:
		mov edx, offset registryFailMSG
	
	mainDone:
		Call WriteString
		Call crlf
	exit
main Endp

; This procedure prompts the user to enter the grade average
; and then stores the amount to variable gradeAverage
getGradeAverage PROC
	mov edx, offset getAverageMSG 
	Call WriteString
	Call ReadDec
	mov gradeAverage, ax
	Call crlf
ret
getGradeAverage ENDP

;This procedure promts the user to enter the amount of credits
;and then stores the amount into variable credits
getCreditsPro PROC
	mov edx, offset getCreditsMSG
	call WriteString
	Call ReadDec
	mov credits, ax
	Call crlf
ret
getCreditsPro ENDP

;This procedure determines if the student is okay to register
;by comparing gradeAverage and or the amounts of credit the student
;has
registerPro PROC
	cmp gradeAverage, 350
	jg trueCheck			; .IF gradeAverage > 350
	cmp gradeAverage, 250	; .ELSEIF (gradeAverage > 250) && (credits <= 16)
	jg andCheck
	cmp credits, 12			; .ELSEIF (credits <= 12)
	jle checkCredits
	trueCheck:
		mov OkToRegister, 1
	andCheck:		;	( && (credits <= 16))
		cmp credits, 16
		jle checkCredits
	checkCredits:
		mov OkToRegister, 1
	ret
registerPro ENDP

;This procedure checks if the credits are in a valid range
; and displays a message if they are not
creditCheckerPro PROC
	cmp credits, 1
	jl invalidCreditsL
	cmp credits, 30
	jg invalidCreditsG					; greater than 1 and less than 30 -> valid credits
	call registerPro
	JMP endCCheck
	
	invalidCreditsG:
	mov edx, offset creditErrorG	; if credits are greater than 30
	call WriteString
	call Crlf
	mov OkToRegister, 0
	JMP endCCheck
	
	invalidCreditsL:
		mov edx, offset creditErrorL
		Call WriteString
		Call Crlf
		mov OkToRegister, 0
	endCCheck:
	ret
creditCheckerPro ENDP

END main