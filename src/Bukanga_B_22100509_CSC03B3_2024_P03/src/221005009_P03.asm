;	Update all of this information to reflect your own details and the prac
;	Author:     222026635,SM , MAHARAJ 
;	Template document
.386
.MODEL FLAT
.STACK 4096

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.inc

; The data section stores all global variables
.DATA
age DWORD ?
inputArray DWORD 8 DUP(?)
outputArray DWORD 8 DUP(?)
maxHeartRate DWORD ?
average DWORD ?
intensitystr BYTE 15 DUP(?), 0
strPromptAge BYTE "Enter age: ", 0
strPromptHR BYTE "Enter heart rate value ", 0
strColon BYTE ": ", 0
strSpace BYTE " ", 0
strNewLine BYTE 13, 10, 0
strInputArray BYTE "Input heart rate values: [", 0
strOutputArray BYTE "Output heart rate percentages: [", 0
strFinalIntensity BYTE "Final intensity: ", 0
strIntensityNone BYTE "none", 0
strIntensityLight BYTE "light", 0
strIntensityModerate BYTE "moderate", 0
strIntensityVigorous BYTE "vigorous", 0
strRightBracket BYTE "]", 0  ; Define the right bracket message
strContinue BYTE "Do you want to continue? (1 to continue, 0 to exit): ", 0

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
PUBLIC _start  
		; Most of your initial code will be under the _start tag.
		; The _start tag is just a memory address referenced by the Public indicator
		; highlighting which functions are available to calling functions.
		; _start gets called by the operating system to start this process.

_start:
    ; Main program loop
    MOV EBX, OFFSET inputArray
    MOV ESI, OFFSET outputArray
    
    ; Prompt for age
    INVOKE OutputStr, ADDR strPromptAge
    INVOKE InputInt
    MOV age, EAX
    
    ; Calculate max heart rate (220 - age)
    MOV EAX, 220
    SUB EAX, age
    MOV maxHeartRate, EAX
    
    ; Get heart rate values and calculate percentages
    MOV ECX, 0
input_loop:
    CMP ECX, 8
    JGE calculate_average
    
    ; Prompt for heart rate value
    INVOKE OutputStr, ADDR strPromptHR
    MOV EAX, ECX
    INC EAX
    INVOKE OutputInt, EAX
    INVOKE OutputStr, ADDR strColon
    INVOKE InputInt
    MOV DWORD PTR [EBX + ECX*4], EAX
    
    ; Calculate percentage
    MOV EAX, DWORD PTR [EBX + ECX*4]
    IMUL EAX, 100
    CDQ
    IDIV maxHeartRate
    CMP EAX, 100
    JLE store_percentage
    MOV EAX, 100
store_percentage:
    MOV DWORD PTR [ESI + ECX*4], EAX
    
    INC ECX
    JMP input_loop

calculate_average:
    ; Calculate average of output array
    MOV ECX, 0
    XOR EAX, EAX
    MOV EBX, OFFSET outputArray
avg_loop:
    CMP ECX, 8
    JGE finalize
    ADD EAX, DWORD PTR [EBX + ECX*4]
    INC ECX
    JMP avg_loop
    
finalize:
    ; Calculate final average
    CDQ
    MOV ECX, 8
    IDIV ECX
    MOV average, EAX
    
    ; Determine intensity message
    CMP EAX, 60
    JL set_none
    CMP EAX, 70
    JL set_light
    CMP EAX, 80
    JL set_moderate
    JMP set_vigorous

set_none:
    LEA EDI, intensitystr
    MOV ECX, LENGTHOF strIntensityNone
    LEA ESI, strIntensityNone
    JMP copy_str

set_light:
    LEA EDI, intensitystr
    MOV ECX, LENGTHOF strIntensityLight
    LEA ESI, strIntensityLight
    JMP copy_str

set_moderate:
    LEA EDI, intensitystr
    MOV ECX, LENGTHOF strIntensityModerate
    LEA ESI, strIntensityModerate

set_vigorous:
    LEA EDI, intensitystr
    MOV ECX, LENGTHOF strIntensityVigorous
    LEA ESI, strIntensityVigorous

copy_str:
    CLD
    REP MOVSB

    ; Display input array
    INVOKE OutputStr, ADDR strNewLine
    INVOKE OutputStr, ADDR strInputArray
    MOV ECX, 8
    MOV EBX, OFFSET inputArray
display_input:
    INVOKE OutputInt, DWORD PTR [EBX]
    DEC ECX
    CMP ECX, 0
    JE display_output
    INVOKE OutputStr, ADDR strSpace
    ADD EBX, 4
    JMP display_input

display_output:
    ; Display output array
    INVOKE OutputStr, ADDR strRightBracket  ; Use the defined strRightBracket
    INVOKE OutputStr, ADDR strNewLine
    INVOKE OutputStr, ADDR strOutputArray
    MOV ECX, 8
    MOV EBX, OFFSET outputArray
display_output_loop:
    INVOKE OutputInt, DWORD PTR [EBX]
    DEC ECX
    CMP ECX, 0
    JE display_intensity
    INVOKE OutputStr, ADDR strSpace
    ADD EBX, 4
    JMP display_output_loop

display_intensity:
    ; Display final intensity message
    INVOKE OutputStr, ADDR strRightBracket  ; Use the defined strRightBracket
    INVOKE OutputStr, ADDR strNewLine
    INVOKE OutputStr, ADDR strFinalIntensity
    INVOKE OutputStr, ADDR intensitystr
    INVOKE OutputStr, ADDR strNewLine
    
    ; Ask the user if they want to continue
    INVOKE OutputStr, ADDR strContinue
    INVOKE InputInt
    CMP EAX, 0
    JE end_program
    JMP _start

end_program:
	; We call the Operating System ExitProcess system call to close the process.
    INVOKE ExitProcess, 0

END _start
