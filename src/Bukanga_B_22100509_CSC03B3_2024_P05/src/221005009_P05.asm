;	Author: B Bukanga
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
	;global variables
	LevelArray		DWORD			 5 DUP (?)
	DurationArray   DWORD            5 DUP (?)
	ScoreArray      DWORD            5 DUP (?)

	;user prompts
	ArrayOutput     BYTE            "array is		: ",10,0
	LevelArrayP     BYTE            "Level Array    : ",0
	arrDuration  	BYTE            "Duration Array : ",0
	arrScore     	BYTE            "Score Array    : ",0
    agePrompt       BYTE            "Enter age here (in years): ",0
	HRFPrompt       BYTE            "Enter the HRF value here: ",0
	;Array Display
	ageDisplay      BYTE            "The age is        : ",0
	HRFDisplay      BYTE            "The HRF value is  : ",0
	;Display format
	SemiColon		BYTE			":",0
	NewLine			BYTE			10,0
	OpenBracket	    BYTE			"[",0
	CloseBracket    BYTE			"]",0
	Comma    		BYTE			",",0
	ContinueCode    BYTE            "User, press 0 to exit or any number to resume:",0
	Separate        BYTE            "*",10,0

.CODE
   ;Input function 
   InputFunc PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
	;Create space for local variables
	
	;Backup registers
	;Do not backup eax if its a value returning function 
	push				eax					
	push				ebx
	push				ecx
	push				edx
	pushfd

	mov					ecx,0				;int n=0
InputStart:
	cmp					ecx,[ebp+12]
	jge					InputEnd			;n<10

	lea					ebx,HRFPrompt
	push				ebx 
	call				OutputStr
	push				ecx 				;INVOKE OutputInt,ecx 
	call				OutputInt
	lea					ebx,SemiColon
	push				ebx 
	call				OutputStr
	
	;Calculate address of the array[n]
	imul				eax,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,eax 			;Memory address of array[n]
	call				InputInt
	mov					[ebx],eax			;cin >> array[n]
	
	inc					ecx					;n++ 
	jmp					InputStart
InputEnd:
	
	;Restore registers to original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	pop					eax					;Do not restore eax, if its a value returning function.
	
	;Destroying stack frame
	mov					esp,ebp
	pop					ebp

	;ret uses an operand indicating the number of PARAMETERS
	ret					8
   InputFunc ENDP

   ;_Display function 
   DisplayFunc PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
	;Create space for local variables
	
	;Backup our existing registers
	push				eax					;Do not backup eax if this is a value returning function 
	push				ebx
	push				ecx
	push				edx
	pushfd

	lea					ebx,OpenBracket
	push				ebx 
	call				OutputStr

	mov					ecx,0				;int n=0
OuputStart:
	cmp					ecx,[ebp+12]
	jge					OuputEnd			;n<10
	
	;Calculate the address of the array[n]
	imul				eax,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,eax 			;The memory address of array[n]
	mov					eax,[ebx]
	push				eax 
	call				OutputInt
	mov					eax,[ebp+12]
	dec					eax
	cmp					ecx,eax 
	jge					CompleteFunc
	lea					ebx,Comma
	push				ebx 
	call				OutputStr
CompleteFunc:
	inc					ecx
	jmp					OuputStart
OuputEnd:
    lea					ebx,CloseBracket
	push				ebx 
	call				OutputStr
	;Output a new line character
	lea					ebx,NewLine
	push				ebx 
	call				OutputStr
	
	;Restore the registers to their original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	pop					eax					;Do not restore eax, if this is a value returning function.
	
	;Destroying the stack frame
	mov					esp,ebp
	pop					ebp
	;Return instruction
	;ret uses an operand indicating the number of PARAMETERS
	ret					8
DisplayFunc ENDP	

   ;HealthScore function
   ;inthealthScore(int age,intlevel,intduration,HRFPrompt)
HealthScoreFunc PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
    sub                 esp,24

	;Backup our existing registers
	push				ebx
	push				ecx
	push				edx
	pushfd
	;This is the function code 
     
    ;Firstly accessing the elements of level and duration array...
MultFunc:
	mov             edx, [ebp+12]
	mov             eax, [ebp+16]

	;Multiplying the entries here:
	imul            edx,eax
    mov             [ebp-4], edx

    ;Moving HRF in one of the registers for multiplication purposes:
	mov             ebx,DWORD PTR[ebp+20]
    imul            edx, ebx
	mov             [ebp-8]  ,edx

    ;dealing with the denominator here
     mov           eax, [ebp+8]
	 mov           ebx, 10
	 cdq
	 div           ebx    
	 mov           [ebp-12],eax    ;storinng age/10 here
	 add            eax, 5
	
	mov             [ebp-16],eax
	
	;Dividing to get the HealthScore value here:
	mov             eax, [ebp-8]
	mov				edx,0
	mov             ebx, [ebp-16]
	div             ebx

;Restore the registers to their original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	
	;Destroying the stack frame
	mov					esp,ebp
	pop					ebp
	;Return instruction
	;ret uses an operand indicating the number of PARAMETERS
	ret					8
HealthScoreFunc ENDP	

   
_start:
	;Main is here______________________________________________
    ;Create the stack frame for local variables
	push			          ebp
	mov			              ebp,esp
    sub                       esp, 20
    
	;Prompting the user here for the age and the hrf value:
	INVOKE                    OutputStr, ADDR agePrompt
	INVOKE                    InputInt
	mov                       [ebp-4],eax
	INVOKE                    OutputStr, ADDR HRFPrompt
    INVOKE                    InputInt
	mov                       [ebp-8],eax

RestartFunction:
	; input(&userArray,length);
	; Calling the input function for the level array 
	INVOKE              OutputStr, ADDR Separate
	INVOKE              OutputStr, ADDR LevelArrayP
	INVOKE              OutputStr, ADDR NewLine
	lea					ebx,LevelArray
	mov					eax,5 
	push				eax
	push				ebx 
	call				InputFunc

	; input(&userArray,length);
	; Calling the input function for the Duration array 
	INVOKE              OutputStr, ADDR Separate
	INVOKE              OutputStr, ADDR arrDuration
	INVOKE              OutputStr, ADDR NewLine
	lea					ebx,DurationArray
	mov					eax,5 
	push				eax
	push				ebx 
	call				InputFunc
	
    ;Displaying the age and the HRF using the normal integer output here:
	INVOKE              OutputStr, ADDR Separate
    INVOKE              OutputStr, ADDR ageDisplay
    INVOKE              OutputInt, DWORD PTR [ebp-4]
    INVOKE              OutputStr, ADDR NewLine
    INVOKE              OutputStr, ADDR HRFDisplay
	INVOKE              OutputInt, DWORD PTR [ebp-8]
    INVOKE              OutputStr, ADDR NewLine

	; display(&userArray,length);
	; Displaying the Level Array
	INVOKE              OutputStr, ADDR LevelArrayP
	lea					ebx,LevelArray
	mov					eax,5 
	push				eax
	push				ebx 
	call				DisplayFunc

	; display(&userArray,length);
	; Displaying the Duration Array
	INVOKE              OutputStr, ADDR arrDuration
	lea					ebx,DurationArray
	mov					eax,5 
	push				eax
	push				ebx 
	call				DisplayFunc


;Placing the values inside of healthscore function
 ;Firstly accessing the elements of level and duration array...
    mov             ecx, 0
IndexThroughArray:
    cmp             ecx,5
	je              DisplayArrValues
	lea				ebx,LevelArray 			   ;Making ebx to point to the HR array here
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array   
    mov             edx,[ebx]
    mov             [ebp-12], edx

    lea				ebx,DurationArray 		   ;Making ebx to point to the HR array here
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array   
	mov             edx,[ebx]
    mov             [ebp-16], edx
   
	; display(&userArray,length);
	; Displaying the Duration Array
	mov                 [ebp-20], ecx
	mov					ecx,[ebp-4]  
	mov					ebx,[ebp-12]           ;Moving the level array value here
	mov                 edx,[ebp-16]           ;Moving the Duration array value here
	mov					eax,[ebp-8]
	push				eax
	push				ebx 
	push                edx
	push                ecx
	call				HealthScoreFunc
	mov                 edx, eax
	mov                 ecx, [ebp-20]
	;Storing the values from healthScore function to the score array
    lea				ebx,ScoreArray 			   ;Making ebx to point to the HR array here
	imul			eax,ecx,4                  ;EAX = ECX*4
	add				ebx,eax                    ;EBX = EBX + EAX, to move to the correct index in the array   
    mov             [ebx], edx
	inc             ecx
	jmp                  IndexThroughArray
	DisplayArrValues:
   
    ;; display(&userArray,length);
	; Displaying the Score Array
	INVOKE              OutputStr, ADDR arrDuration
	lea					ebx,ScoreArray
	mov					eax,5 
	push				eax
	push				ebx 
	call				DisplayFunc
    INVOKE              OutputStr, ADDR Separate  
	;Handling the events when the user needs to exit the code here:
	INVOKE              OutputStr, ADDR ContinueCode
	INVOKE              InputInt
	cmp                 eax, 0
    je                  EndProgram
    jmp                 _start
EndProgram:
	INVOKE ExitProcess, 0
Public _start
END
