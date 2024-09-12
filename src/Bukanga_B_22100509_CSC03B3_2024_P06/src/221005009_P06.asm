;   Author:     B Bukanga
;   Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
include io.inc

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
    strStepCountArr db 'Step Count Array:', 0
    strStepCountSum db 'Step Count Sum:', 0
    strStepCountAve db 'Step Count Average:', 0
    strResult db 'Result: ', 0 
    newline db 13, 10, 0

    stepCountSum dd 0
    stepCountAverage dd 0
    numDays dd 7

    stepCountArray dd 10, 20, 30, 40, 50, 60, 70 ; Test values
; point of this assembly program
.CODE
_start:
    ; Display the values used
    INVOKE OutputStr, addr strStepCountArr
    lea esi, [stepCountArray]    ; Load address of the step count array
    mov ecx, 7                  ; Number of elements in the array
ArrayOutput:
    mov eax, [esi]              ; Get the next step count
    INVOKE OutputInt, eax       ; Output the integer value
    INVOKE OutputStr, addr newline ; Newline after each value
    add esi, 4                  ; Move to the next element
    loop ArrayOutput          ; Repeat for all elements

    ; Initialize registers
    mov ecx, 0                   ; Index counter for recursion
    lea esi, [stepCountArray]    ; Load address of the step count array
    mov [stepCountSum], 0        ; Initialize stepCountSum to 0

    ; Call recursive function to calculate sum
    call RecursiveFunction
    ; calculate average
    mov eax, [stepCountSum]      ; Load stepCountSum into eax
    mov ebx, [numDays]           ; Load number of days into ebx
    cdq                          ; Convert double to quad for division
    div ebx                      ; Divide eax by ebx
    mov [stepCountAverage], eax   ; Store result in stepCountAverage

    ; Display Step Count Sum
    INVOKE OutputStr, addr strStepCountSum
    mov eax, [stepCountSum]
    INVOKE OutputInt, eax

    ; Display Step Count Average
    INVOKE OutputStr, addr strStepCountAve
    mov eax, [stepCountAverage]
    INVOKE OutputInt, eax

; Recursive function calculates step count sum
RecursiveFunction:
    ; if index >= 7
    cmp ecx, 7
    jge _BaseCase
    ; Calculate address of current element
    mov eax, [esi + ecx*4]   ; Get step count at index ecx
    add [stepCountSum], eax  
    ; Recursive call
    inc ecx                  ; Increment index
    call RecursiveFunction  ; Recursive call

_BaseCase:
    ret                      ; Return from function

    INVOKE ExitProcess, 0

Public _start
END