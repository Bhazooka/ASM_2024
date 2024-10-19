; B, Bukanga 221005009
; PE2 DLL alternate structure
.386
.MODEL FLAT, stdcall
.STACK 4096

.CODE
LibMain proc hInst:DWORD, dwReason:DWORD, reserved:DWORD
    MOV eax, 1        ; Indicate successful load
    RET
LibMain endp

; int binStringToDecimal(char* binaryStr)
binStringToDecimal PROC
    PUSH ebp             ; Set up stack frame
    MOV ebp, esp
    MOV edx, [ebp+8]     ; EDX holds the binary string address
    MOV eax, 0           ; Clear result (EAX)
    MOV ecx, 0           ; Clear index (ECX)

    ConvertBin:
        MOV bl, [edx+ecx]    ; Load current character
        TEST bl, bl          ; Test for null terminator
        JZ Complete           ; If found, exit


        CMP ecx, 8           ; Limit string length to 8 characters
        JGE Complete

                 
        ; CMP bl, '1'         
        ; JE AddOne           
        ; CMP bl, '0'          
        ; JE ShiftLeft         
        ; MOV eax, -1          
        ; JMP Complete
         
        CMP bl, '1'          ; Check if it's a '1'
        JE AddOne            ; If '1', shift and add 1
        CMP bl, '0'          ; Check if it's a '0'
        JE ShiftLeft         ; If '0', just shift
        MOV eax, -1          ; Invalid character
        JMP Complete

    ShiftLeft:
        SHL eax, 1           ; Shift left (multiply by 2)
        JMP IncChar

    AddOne:
        SHL eax, 1           ; Shift left and add 1
        ADD eax, 1

    IncChar:
        INC ecx              ; Move to next character
        JMP ConvertBin

    Complete:
        MOV esp, ebp         ; Clean up stack
        POP ebp
        RET
binStringToDecimal endp

; int hexStringToDecimal(char* hexStr)
hexStringToDecimal PROC
    PUSH ebp              ; Set up stack frame
    MOV ebp, esp
    MOV edx, [ebp+8]      ; EDX holds the hex string address
    MOV eax, 0            ; Clear result (EAX)
    MOV ecx, 0            ; Clear index (ECX)
    MOV ebx, 0            ; Temporary storage for char value

    ProcessHex:
        ;     MOV bl, [edx+ecx]    
        ; TEST bl, bl         
        ; JZ DoneHex           
        ; CMP ecx, 4           
        ; JGE DoneHex
        ; CMP bl, '0'
        ; JB InvalidHex        
        ; CMP bl, '9'
        ; JLE ConvertDigit     
        ; CMP bl, 'F'
        ; JLE ConvertLetter    
        ; CMP bl, 'A'
        ; JB InvalidHex        
        MOV bl, [edx+ecx]    ; Load current character
        TEST bl, bl          ; Test for null terminator
        JZ DoneHex           ; If found, exit
        CMP ecx, 4           ; Limit string length to 4 characters
        JGE DoneHex
        CMP bl, '0'
        JB InvalidHex        ; Invalid if less than '0'
        CMP bl, '9'
        JLE ConvertDigit     ; If between '0' and '9', it's valid
        CMP bl, 'F'
        JLE ConvertLetter    ; If between 'A' and 'F', it's valid
        CMP bl, 'A'
        JB InvalidHex        ; Invalid if less than 'A'

    InvalidHex:
        MOV eax, -1          ; Invalid character, return error
        JMP DoneHex

    ConvertDigit:
        SUB bl, '0'          ; Convert digit character to numeric value
        JMP ValidHex

    ConvertLetter:
        SUB bl, 'A'          ; Convert letter 'A'-'F' to numeric
        ADD bl, 10           ; Add 10 to get the actual hex value

    ValidHex:
        SHL eax, 4           ; Multiply current result by 16
        ADD eax, ebx         ; Add the current hex digit

    NextHex:
        INC ecx              ; Move to next character
        JMP ProcessHex

    DoneHex:
        MOV esp, ebp         ; Clean up stack
        POP ebp
        RET
hexStringToDecimal endp

END LibMain
