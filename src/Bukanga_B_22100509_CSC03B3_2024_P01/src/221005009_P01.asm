;	Author: B Bukanga
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
    distanceMeters          DWORD   ?
    distanceKilometers      DWORD   ?
    stride                  DWORD   ?
    stepcount               DWORD   ?
    decimal                 DWORD   ?

    ; 
    strDistanceMeters          BYTE   "The distance in Meters is: ", 0
    strDistanceKilometers      BYTE   "The distance in Kilomiters is: ", 0
    strStride                  BYTE   "Enter the Stride in cm: ", 0
    strStepcount               BYTE   "Enter the Steps: ", 0
    strNL                      BYTE   10, 0
    strDecimal                 BYTE   ".",0

.CODE
_start:

    ; getting values for stride
    INVOKE OutputStr, ADDR strStride
    INVOKE InputInt
    mov stride, EAX

    ; getting values for count
    INVOKE OutputStr, ADDR strStepcount
    INVOKE InputInt
    mov stepcount, EAX

    ; (stride * stepcount)
    mov eax, stride
    imul eax, stepcount

    ; divide by 100
    mov ebx, 100
    cdq
    idiv ebx
    mov distanceMeters, eax

    ; display Distance in M
    INVOKE OutputStr, ADDR strDistanceMeters
    INVOKE OutputInt, distanceMeters
    INVOKE OutputStr, ADDR strDecimal
    INVOKE OutputInt, edx
    INVOKE OutputStr, ADDR strNL

    ; (distanceMeters)/1000
    mov eax, distanceMeters
    mov ebx, 1000
    cdq
    idiv ebx
    mov distanceKilometers, eax

    ; Display distance in KM
    INVOKE OutputStr, ADDR strDistanceKilometers
    INVOKE OutputInt, distanceKilometers
    INVOKE OutputStr, ADDR strDecimal
    INVOKE OutputInt, edx
    INVOKE OutputStr, ADDR strNL


	INVOKE ExitProcess, 0
Public _start
END
