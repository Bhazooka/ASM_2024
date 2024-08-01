; Author: Your Name
; Practical Assignment 02
; Course: Computer Science 3B
; Assignment date: 2024-08-01
; Deadline: 2024-08-01 17h05

.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
; Input variables and answers
HR0 DWORD ?
HR1 DWORD ?
HR2 DWORD ?
HR3 DWORD ?
HR4 DWORD ?
avgHR DWORD ?
sumHR DWORD ?
maxHR DWORD ?
integerPart DWORD ?
decimalPart DWORD ?
newLine BYTE 10, 0
; String command prompts
strHRprompt BYTE "Please type the value for HR", 0
strColon BYTE ":", 0
strAvgHR BYTE "Average Heart Rate (rounded up): ", 0
strAvgBefore BYTE "Average Heart Rate (before rounding): ", 0
strMaxHR BYTE "Maximum Heart Rate: ", 0
strQuit BYTE "Type a zero to quit, any other number to run again: ", 0

.CODE
_start:
    ; Initialize the counter
    MOV ecx, 0

InputHR:
    ; Prompt the user
    INVOKE OutputStr, ADDR strHRprompt
    INVOKE OutputStr, ADDR strColon
    INVOKE InputInt
    MOV edx, eax ; Store input in edx

    CMP ecx, 0
    JE StoreHR0
    CMP ecx, 1
    JE StoreHR1
    CMP ecx, 2
    JE StoreHR2
    CMP ecx, 3
    JE StoreHR3
    CMP ecx, 4
    JE StoreHR4
    JMP InputHR ; Continue asking if invalid input

StoreHR0:
    MOV HR0, edx
    JMP IncCounter
StoreHR1:
    MOV HR1, edx
    JMP IncCounter
StoreHR2:
    MOV HR2, edx
    JMP IncCounter
StoreHR3:
    MOV HR3, edx
    JMP IncCounter
StoreHR4:
    MOV HR4, edx

IncCounter:
    INC ecx
    CMP ecx, 5
    JL InputHR ; Continue inputting if less than 5
    JMP Calculate

Calculate:
    ; Calculate sum of heart rates
    MOV eax, HR0
    ADD eax, HR1
    ADD eax, HR2
    ADD eax, HR3
    ADD eax, HR4
    MOV sumHR, eax

    ; Calculate average heart rate (before rounding)
    MOV eax, sumHR
    MOV ebx, 5
    XOR edx, edx
    DIV ebx
    MOV integerPart, eax
    MOV decimalPart, edx

    ; Output average before rounding with decimal
    INVOKE OutputStr, ADDR strAvgBefore
    MOV eax, integerPart
    INVOKE OutputInt, eax
    MOV eax, decimalPart
    ; Convert decimal part to ASCII (divide by 10 to get first decimal place)
    MOV ebx, 10
    DIV ebx
    ADD al, '0'  ; Convert to ASCII
    INVOKE OutputStr, ADDR newLine

    ; Calculate average heart rate (rounded up)
    MOV eax, sumHR
    MOV ebx, 5
    XOR edx, edx
    DIV ebx
    CMP edx, 0
    JZ SkipRound
    INC eax
SkipRound:
    MOV avgHR, eax

    ; Calculate maximum heart rate
    MOV eax, HR0
    MOV edx, eax
    MOV eax, HR1
    CMP eax, edx
    JLE UpdateMaxHR
    MOV edx, eax
UpdateMaxHR:
    MOV eax, HR2
    CMP eax, edx
    JLE UpdateMaxHR2
    MOV edx, eax
UpdateMaxHR2:
    MOV eax, HR3
    CMP eax, edx
    JLE UpdateMaxHR3
    MOV edx, eax
UpdateMaxHR3:
    MOV eax, HR4
    CMP eax, edx
    JLE Done
    MOV edx, eax
Done:
    MOV maxHR, edx

OutputResults:
    ; Output average heart rate (rounded up)
    INVOKE OutputStr, ADDR strAvgHR
    MOV eax, avgHR
    INVOKE OutputInt, eax
    INVOKE OutputStr, ADDR newLine

    ; Output maximum heart rate
    INVOKE OutputStr, ADDR strMaxHR
    MOV eax, maxHR
    INVOKE OutputInt, eax
    INVOKE OutputStr, ADDR newLine

    ; Prompt to continue or quit
    INVOKE OutputStr, ADDR strQuit
    INVOKE InputInt
    CMP eax, 0
    JE ExitProgram
    JMP _start

ExitProgram:
    ; Exit the program
    INVOKE ExitProcess, 0

Public _start
END