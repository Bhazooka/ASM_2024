; Author: Baraka Bukanga
; Fitness Rewards Calculation Template
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; Allocate 4096 bytes for stack

INCLUDE io.inc

; Prototype for exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
    ; test values
    fitnessRewards  DWORD 5, 15, 9, 24, 0, 4, 54
    NL			    BYTE  10, 0
    strReward       BYTE "Rewards for Fitness Goals: ", 0
    strCPUAve       BYTE "CPU Integer Daily Avg: ", 0
    strFPUAve       BYTE "FPU Float Daily Avg: ", 0
    ; Display format
	SemiColon		BYTE			":",0
	OpenBracket	    BYTE			"[",0
	CloseBracket    BYTE			"]",0
	Comma    		BYTE			",",0

    ; Variables to store the calculated results
    averageInt DWORD 0
    averageFloat DD 0.0
    totalDays DWORD 7  ; num of days in fitness rewards array

.CODE
_start:
    ; Display rewards string
    push OFFSET strReward
    call OutputStr
    ; Display fitness reward
    lea ESI, fitnessRewards
    mov ECX, totalDays
displayrewardloop_:
    push [ESI]
    call OutputInt
    push OFFSET NL
    call OutputStr
    ADD ESI, 4
    loop displayrewardloop_
    ; Output newline before averages
    push OFFSET NL
    call OutputStr
    ; call integer average function
    call calcAve
    ; Output integer average string
    push OFFSET strCPUAve
    call OutputStr
    ; Output integer average result
    push averageInt
    call OutputInt
    ; Output new line
    push OFFSET NL
    call OutputStr
    ; call the floating-point average function
    call calcFloatAve
    ; Output the floating-point average string
    push OFFSET strFPUAve
    call OutputStr
    ; Output the floating-point average result
    push averageFloat
    call OutputFloat

calcAve PROC ;calculate integer average
    mov EAX, 0           ; Clear EAX for sum calculation
    mov ECX, totalDays   ; ECX used as loop counter
    lea ESI, fitnessRewards  ; Load the address of the fitnessRewards array into ESI

calcnumloop_:
    add EAX, [ESI]       ; Add each element of the array to EAX
    add ESI, 4           ; move to the next array element (DWORD size = 4 bytes)
    loop calcnumloop_

    ; Calculate the average by dividing the sum in EAX by totalDays (7)
    mov EBX, totalDays
    cdq                  ; Sign-extend EAX into EDX:EAX for division
    idiv EBX             ; Integer division: EAX = EAX / EBX, remainder in EDX
    mov averageInt, EAX  ; Store the integer average in averageInt
    RET
calcAve ENDP

;calc the floating-point average
calcFloatAve PROC
    FLDZ                 ; Load 0.0
    mov ECX, totalDays   ; ECX used as the loop counter

    lea ESI, fitnessRewards  ; Load the address of the fitnessRewards array into ESI

calcfloatloop_:
    FILD DWORD PTR [ESI]  ; Load integer value into FPU
    FADD                 ; Add it to the current sum
    ADD ESI, 4           ; move to the next array element
    loop calcfloatloop_

    FILD DWORD PTR totalDays ; Load totalDays into FPU
    FDIV                     ; Perform floating-point division

    FSTP averageFloat        ; Store the result in averageFloat
    RET
calcFloatAve ENDP

INVOKE ExitProcess, 0

PUBLIC _start  
END      