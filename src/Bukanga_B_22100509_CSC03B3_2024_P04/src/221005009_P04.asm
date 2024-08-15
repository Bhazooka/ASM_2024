;	Author: B Bukanga
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; Global variables
.DATA
;Constant variables
HR		        DWORD		3 DUP (?)
HRF             DWORD       3 DUP (?)

;String Prompts
strAge          BYTE        "Enter age (in years): ",0
strRHR          BYTE        "Enter RHR value: ",0
strCMul         BYTE        "Enter CMul value: ",0
strHR           BYTE        "Enter HR value at index ",0
AgeValue        BYTE        "Age value is: ",0
RHRValue        BYTE        "RHR value is: ",0
CMulValue       BYTE        "CMul value is: ",0
HRValues        BYTE        "The HR array values are: ",10,0
HRFValues       BYTE        "The HRF array values are: ",10,0
EndLine         BYTE        10,0
ClosedBracket   BYTE        "]",0
OpenBracket     BYTE        "[",0
SemiColon       BYTE        ":",0
Comma           BYTE        ",",0
ContinueCode    BYTE        "User, press 0 to exit or any number to resume:",0
.CODE
_start:
	;Create the stack frame for local variables
	push			ebp
	mov				ebp,esp
	;Local variables
	;Age			[ebp-4]
	;RHR			[ebp-8]
	;CMul			[ebp-12]
	sub				esp,12           ;Since we only need space for only 3 variables here

	;Getting input values from the user
InputLoopStart:
	INVOKE          OutputStr, ADDR strAge
	;Storing the age value into stack
	INVOKE          InputInt               ;Taking the age
	mov             [ebp-4], eax           ;Storing the age
    ;Asking for the RHR value from user
	INVOKE          OutputStr, ADDR strRHR
	INVOKE          InputInt
	mov             [ebp-8], eax           ;Storing the RHR in
    ;Asking for the CMul value from the user:
    INVOKE          OutputStr, ADDR strCMul
	INVOKE          InputInt
	mov             [ebp-12] ,eax              ;Storing the CMul value in the right variable
    ;Asking the user for the arrayHR inputs
	mov             ecx,0
HRArrayLoop:
	INVOKE			OutputStr, ADDR strHR
	INVOKE			OutputInt, ecx
	INVOKE			OutputStr, ADDR SemiColon
	lea             ebx, HR                ;Getting ebx to point to HR array
	imul            eax, ecx, 4
	add             ebx, eax
	INVOKE          InputInt
	mov             [ebx],eax
	inc             ecx
	cmp             ecx,3
	jl              HRArrayLoop

;Displaying the values
;Printing age
INVOKE              OutputStr, ADDR AgeValue
INVOKE              OutputInt, DWORD PTR [ebp-4]
INVOKE              OutputStr, ADDR EndLine
;Printing RHR value
INVOKE              OutputStr, ADDR RHRValue
INVOKE              OutputInt, DWORD PTR [ebp-8]
INVOKE              OutputStr, ADDR EndLine
;Printing CMul value
INVOKE              OutputStr, ADDR CMulValue
INVOKE              OutputInt, DWORD PTR [ebp-12]
INVOKE              OutputStr, ADDR EndLine
;Printing the HR array values
INVOKE              OutputStr, ADDR HRValues
INVOKE              OutputStr, ADDR OpenBracket
mov                 ecx, 0
_OutputHRArrayLoop:
	lea				ebx,HR 					;Calculate the memory array offset using the formulae: (ecx * 4) + baseaddress
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array
	INVOKE			OutputInt,[ebx]				;Output the array item at the index
	cmp				ecx,2                      ;Comparing the values
	je				_InsertComma
	INVOKE			OutputStr, ADDR Comma
_InsertComma:
	inc				ecx
	cmp 		   	ecx,3 
	jl				_OutputHRArrayLoop
	INVOKE			OutputStr, ADDR ClosedBracket
    INVOKE          OutputStr, ADDR EndLine
;Printing the HRF array values here_:
INVOKE              OutputStr, ADDR HRFValues
INVOKE              OutputStr, ADDR OpenBracket
mov                 ecx, 0
_OutputHRFArray:
	lea				ebx,HRF 					;Calculate the memory array offset using the formulae: (ecx * 4) + baseaddress
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array
	INVOKE			OutputInt,[ebx]				;Output the array item at the index
	cmp				ecx,2                      ;Comparing the values
	je				_Comma
	INVOKE			OutputStr, ADDR Comma
_Comma:
	inc				ecx
	cmp 		   	ecx,3 
	jl				_OutputHRFArray
	INVOKE			OutputStr, ADDR ClosedBracket
    INVOKE          OutputStr, ADDR EndLine
    INVOKE          OutputStr, ADDR ContinueCode
	INVOKE          InputInt
	cmp             eax, 0
	je              _Exit     
    jmp             _start
_Exit:
    ; Destroy the stack frame
	mov				esp,ebp
	pop				ebp
	INVOKE ExitProcess, 0
Public _start
END