; Author: B Bukanga
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
    HR0     DWORD   ?
    HR1     DWORD   ?
    HR2     DWORD   ?
    HR3     DWORD   ?
    HR4     DWORD   ?
    Total   DWORD   ?   ; To store the total before the division
    Average DWORD   ?
    RoundedAverage  DWORD   ?
    Maximum DWORD   ?
    choice  DWORD   ?   ; To store the user's choice

    strHR0  BYTE "Enter Heart Rate 0: ", 0
    strHR1  BYTE "Enter Heart Rate 1: ", 0
    strHR2  BYTE "Enter Heart Rate 2: ", 0
    strHR3  BYTE "Enter Heart Rate 3: ", 0
    strHR4  BYTE "Enter Heart Rate 4: ", 0
    strTotal BYTE "Total: ", 0
    strAverage BYTE "Average Heart Rate: ", 0
    strRoundAverage BYTE "Rounded Average Heart Rate: ", 0
    strMaximum BYTE "Maximum: ", 0
    strContinue BYTE "Press 0 to quit and 1 to continue: ", 0
    strNL   BYTE    10,0
    strDecimal BYTE ".", 0

.CODE
_start:
    ; Get user inputs
    INVOKE  OutputStr, ADDR strHR0
    INVOKE  InputInt
    mov     HR0,    eax

    INVOKE  OutputStr, ADDR strHR1
    INVOKE  InputInt
    mov     HR1,    eax

    INVOKE  OutputStr, ADDR strHR2
    INVOKE  InputInt
    mov     HR2,    eax

    INVOKE  OutputStr, ADDR strHR3
    INVOKE  InputInt
    mov     HR3,    eax

    INVOKE  OutputStr, ADDR strHR4
    INVOKE  InputInt
    mov     HR4,    eax

    ; Calculate total
    mov     eax, HR0
    add     eax, HR1
    add     eax, HR2
    add     eax, HR3
    add     eax, HR4
    mov     Total, eax

    ; Calculate average (Total / 5)
    mov     eax, Total
    mov     ebx, 5
    cdq
    idiv    ebx
    mov     Average, eax

    ; Output average before rounding with decimal part
    INVOKE  OutputStr, ADDR strAverage
    INVOKE  OutputInt, Average

    ; Calculate decimal part for Average
    mov     eax, edx
    mov     ebx, 5
    cdq
    idiv    ebx
    INVOKE  OutputStr, ADDR strDecimal
    INVOKE  OutputInt, eax
    INVOKE  OutputStr, ADDR strNL

    ; Calculate rounded average
    mov     eax, Total
    mov     ebx, 50
    cdq
    div    ebx
    mov     RoundedAverage, eax
    test    edx, edx  ; Check if remainder is 0
    jz      NoRound
    inc     RoundedAverage

NoRound:
    ; Output rounded average
    INVOKE  OutputStr, ADDR strRoundAverage
    mov     eax, RoundedAverage
    INVOKE  OutputInt, eax
    INVOKE  OutputStr, ADDR strNL

    ; Calculate maximum heart rate
    mov     eax, HR0
    mov     edx, eax
    mov     eax, HR1
    cmp     eax, edx
    jle     CheckHR2
    mov     edx, eax
CheckHR2:
    mov     eax, HR2
    cmp     eax, edx
    jle     CheckHR3
    mov     edx, eax
CheckHR3:
    mov     eax, HR3
    cmp     eax, edx
    jle     CheckHR4
    mov     edx, eax
CheckHR4:
    mov     eax, HR4
    cmp     eax, edx
    jle     SetMax
    mov     edx, eax
SetMax:
    mov     Maximum, edx

    ; Output maximum heart rate
    INVOKE  OutputStr, ADDR strMaximum
    mov     eax, Maximum
    INVOKE  OutputInt, eax
    INVOKE  OutputStr, ADDR strNL

    ; Ask the user if they want to continue or quit
    INVOKE  OutputStr, ADDR strContinue
    INVOKE  InputInt
    mov     choice, eax
    cmp     choice, 0
    je      ExitLoop   ; Jump to exit if the choice is 0
    cmp     choice, 1
    jne     _start     ; If the choice is not 1, re-prompt the user

    ; Loop back to _start for another iteration
    jmp     _start

ExitLoop:
    INVOKE ExitProcess, 0

Public _start
END
