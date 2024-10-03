; Assembly program to calculate integer and floating-point averages
; Author: [Your Name]
; Student Number: [Your Student Number]
; Date: 2024-10-03
; Module: CSC03B3 - P08

.386
.MODEL FLAT
.STACK 4096

INCLUDE io.inc  ; Include the I/O routines

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
    ; Array with 7 days' fitness rewards
    inputArray DWORD 5, 15, 9, 24, 0, 4, 54

    ; Variables to store results
    intResult DWORD 0
    floatResult REAL4 0.0

.CONST
    count DWORD 7  ; Number of elements in the array

.CODE
_start:
    ; Call the integer average function
    CALL calculateIntAverage

    ; Output the integer result
    PUSH intResult
    CALL OutputInt

    ; Output a new line (optional)
    PUSH OFFSET newLine
    CALL OutputStr

    ; Call the floating-point average function
    CALL calculateFloatAverage

    ; Output the floating-point result (corrected precision)
    PUSH floatResult
    CALL OutputFloat

    ; Exit program
    INVOKE ExitProcess, 0

; Function to calculate integer average
calculateIntAverage PROC
    MOV EAX, 0           ; Clear EAX to store the sum
    MOV ECX, count       ; ECX will be used as a counter

    LEA ESI, inputArray  ; Load the address of inputArray into ESI

    calc_int_loop:
        ADD EAX, [ESI]   ; Add each element of the array to EAX
        ADD ESI, 4       ; Move to the next element (DWORD is 4 bytes)
        LOOP calc_int_loop

    ; Calculate the average by dividing the sum in EAX by the count (7)
    MOV EBX, count
    CDQ                  ; Sign-extend EAX into EDX:EAX for division
    IDIV EBX             ; EAX = EAX / EBX, remainder in EDX

    MOV intResult, EAX   ; Store the integer average in intResult
    RET
calculateIntAverage ENDP

; Function to calculate floating-point average
calculateFloatAverage PROC
    FLDZ                 ; Load 0.0 into ST(0) (FPU stack register)
    MOV ECX, count       ; ECX will be used as a counter

    LEA ESI, inputArray  ; Load the address of inputArray into ESI

    calc_float_loop:
        FILD DWORD PTR [ESI]  ; Load integer value into FPU
        FADD                 ; Add to ST(0)
        ADD ESI, 4           ; Move to the next element
        LOOP calc_float_loop

    ; Divide the sum by 7 (stored in ECX)
    FILD DWORD PTR count     ; Load the count (7) into FPU
    FDIV                     ; ST(0) = ST(0) / ST(1)

    FSTP floatResult         ; Store the result in floatResult
    RET
calculateFloatAverage ENDP

.DATA
    newLine BYTE 0Dh, 0Ah, 0

Public _start
END _start