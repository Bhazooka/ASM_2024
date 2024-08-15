;	Author: B Bukanga
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section global variables
.DATA
;Constant variables
HR		        DWORD		3 DUP (?)
HRF             DWORD       3 DUP (?)

;User prompts 
strAge          BYTE        "Enter age: ",0
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
Restart         BYTE        "User, press 0 to exit or any number to resume:",0

.CODE
_start:
	 ;Create the stack frame for local variables
	push			ebp
	mov				ebp,esp
	;Local variables
	;Age			          [ebp-4]
	;RHR			          [ebp-8]
	;CMul			          [ebp-12]
	;(HRi – RHR)              [ebp-16]
    ;(HRi – RHR) × CMul       [ebp-20]
	;(220 - age)              [ebp-24]
	;(220-age)-RHR            [ebp -26]
	;HRF(i)                   [ebp -30]
	sub				          esp,30           ;Since we only need space for only 3 variables here

	;Getting input values from the user
InputLoopStart:
	INVOKE          OutputStr, ADDR strAge
	;Storing the age value into stack
	INVOKE          InputInt               ;ask age
	mov             [ebp-4], eax           ;Storing age
    ;Asking for RHR value from user
	INVOKE          OutputStr, ADDR strRHR
	INVOKE          InputInt
	mov             [ebp-8], eax           ;Storing the RHR
    ;Asking CMul value from user:
    INVOKE          OutputStr, ADDR strCMul
	INVOKE          InputInt
	mov             [ebp-12] ,eax              ;Storing the CMul value in the right variable
    ;Asking the user for the HRarray inputs
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
;Firstly accessing the array values for the array HR:
mov                 ecx, 0
HRElements:
	lea				ebx,HR 					;Calculate the memory array offset using the formulae: (ecx * 4) + baseaddress
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array
    mov             edx, [ebx]

    ;Substracting:  HR[i]-RHR
	sub             edx,[ebp-8] 
    mov             [ebp-16],edx     ;[ebp-16] = edx = HR[i]-RHR
	mov             edx, DWORD PTR [ebp-12]
	imul            edx, DWORD PTR [ebp-16]
    mov             [ebp-20], edx    ;[ebp-20] = (HR[i]-RHR)*Cmul
	mov             edx, 220
    sub             edx, [ebp-4]
	mov            [ebp-24], edx   ;[ebp-24] = (220 - age)
    mov            edx, [ebp-24]
	sub            edx, [ebp-8]    ; (220 - age) - RHR
	mov            [ebp -26], edx  ; [ebp-26] = (220 - age)-RHR
	cdq
	mov             eax, [ebp-20]
	mov             ebx, [ebp -26]
	div             ebx
    mov             [ebp -30], eax  ;[ebp -30] has the HRF_i
	;Storing the array values here:
	lea				ebx,HRF					;Calculate the memory array offset using the formulae: (ecx * 4) + baseaddress
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array
    mov             edx, [ebp -30]
    mov             [ebx], edx
	inc             ecx
	cmp             ecx, 3
	jl              HRElements

;Displaying the values
;Printing the age
INVOKE              OutputStr, ADDR AgeValue
INVOKE              OutputInt, DWORD PTR [ebp-4]
INVOKE              OutputStr, ADDR EndLine
;Printing the RHR value here:
INVOKE              OutputStr, ADDR RHRValue
INVOKE              OutputInt, DWORD PTR [ebp-8]
INVOKE              OutputStr, ADDR EndLine
;Printing the CMul value here:
INVOKE              OutputStr, ADDR CMulValue
INVOKE              OutputInt, DWORD PTR [ebp-12]
INVOKE              OutputStr, ADDR EndLine
;Printing the HR array values here:
INVOKE              OutputStr, ADDR HRValues
INVOKE              OutputStr, ADDR OpenBracket
mov                 ecx, 0
DisplayHRArrayLoop:
	lea				ebx,HR 					   ;Calculate the memory array offset using the formulae: (ecx * 4) + baseaddress
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array
	INVOKE			OutputInt,[ebx]			   ;Output the array item at the index
	cmp				ecx,2                      ;Comparing the values
	je				AddComma
	INVOKE			OutputStr, ADDR Comma
AddComma:
	inc				ecx
	cmp 		   	ecx,3 
	jl				DisplayHRArrayLoop
	INVOKE			OutputStr, ADDR ClosedBracket
    INVOKE          OutputStr, ADDR EndLine

;Printing the HRF array values here_:
INVOKE              OutputStr, ADDR HRFValues
INVOKE              OutputStr, ADDR OpenBracket
mov                 ecx, 0
DisplayHRFArray:
	lea				ebx,HRF 				   ;Calculate the memory array offset using the formulae: (ecx * 4) + baseaddress
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array
	INVOKE			OutputInt,[ebx]			   ;Output the array item at the index
	cmp				ecx,2                      ;Comparing the values
	je				InsertComma
	INVOKE			OutputStr, ADDR Comma
InsertComma:
	inc				ecx
	cmp 		   	ecx,3 
	jl				DisplayHRFArray
	INVOKE			OutputStr, ADDR ClosedBracket
    INVOKE          OutputStr, ADDR EndLine
    INVOKE          OutputStr, ADDR Restart
	INVOKE          InputInt
	cmp             eax, 0
	je              ExitProgram     
    jmp             _start
ExitProgram:
    ;Destroy stack frame
	mov				esp,ebp
	pop				ebp
    

	INVOKE ExitProcess, 0
Public _start
END