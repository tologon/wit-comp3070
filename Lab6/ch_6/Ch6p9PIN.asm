TITLE Validating a PIN (Ch6p9PIN.asm)
;Terrance Curley
;Tologan Emishnakov
;Daniel Zidelis
;Program will check if a PIN is valid. 
;If one of the digits in the pin is outside of the valid range for that digit, the pin will be invalid. 
;the position of the invalid digit will be placed in eax.
;Otherwise 0 will be placed in eax and the program will output that the pin is valid.

INCLUDE Irvine32.inc

.data
;the specified range for each digit in the PIN. 
;any value greater than the low range and less than the high range will be a valid digit.
lowrange BYTE 5, 2, 4, 1, 3
highrange BYTE 9, 5, 8, 4, 6

;position's value is moved into eax if the PIN is invalid. it is incremented each time a digit is valid.
position BYTE 1

;strings to write to console
validstr BYTE "Valid PIN!"
invalidstr1 BYTE "Invalid PIN! The offending digit is in position: ", 0

;inputs to test Validate_PIN
valid1 BYTE 6, 5, 4, 2, 4
valid2 BYTE 9, 3, 6, 1, 5
invalid1 BYTE 8, 1, 5, 8, 3
invalid2 BYTE 2, 2, 2, 2, 2

.code
;Test program
main PROC
	mov eax, 0
	mov ebx, offset valid1
	call Validate_PIN
	call DumpRegs
	
	mov ebx, offset valid2
	call Validate_PIN
	call DumpRegs
	
	mov ebx, offset invalid1
	call Validate_PIN
	call DumpRegs
	
	mov ebx, offset invalid2
	call Validate_PIN
	call DumpRegs

	exit
main ENDP

;Call this procedure after loading ebx with the offset of the PIN (array) you want to validate
;Procedure will output a value of zero into eax if the PIN is valid
;Otherwise eax will contain the position in the array of the first invalid digit of the PIN
;Uses esi and edi for the arrays used for range of each digit
;Uses ecx for a loop count
Validate_PIN PROC Uses esi edi ecx
	mov esi, offset lowrange
	mov edi, offset highrange
	mov ecx, 5
		Jose:
			mov al, [ebx]	;until the end of the proc, eax is used to contain the current digit being checked
			cmp al, [esi]
			jl InvalidDigit
			cmp al, [edi]
			jg InvalidDigit
			inc position	;working with the next digit
			inc ebx
			inc esi
			inc edi
			loop Jose
	mov eax, 0
	mov position, 1
	jmp Return

	InvalidDigit:
	mov al, position
	mov position, 1

	Return:
	ret
Validate_PIN ENDP

END main