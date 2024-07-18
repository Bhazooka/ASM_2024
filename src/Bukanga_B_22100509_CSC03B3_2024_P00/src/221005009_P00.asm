;	Author: B Bukanga
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
    ARH         DWORD 161
    Duration    DWORD 109
    Steps       DWORD 12323
    Calories    DWORD ?    
    
.CODE
_start:
    ; ARH * Duration / 100
    mov EAX, ARH
    imul EAX, Duration
    cdq     ; Prepare for division
    mov ECX, 100
    idiv ECX
    mov EBX, EAX
    ; Steps / 20
    mov EAX, Steps
    CDQ             ; Prepare for division
    mov ECX, 20
    idiv ECX        ;
    ; Adding the two values
    add EAX, EBX
    ; Store the final value in the calories
    mov Calories, EAX

	INVOKE ExitProcess, 0
Public _start
END
