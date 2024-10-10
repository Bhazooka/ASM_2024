.386
.MODEL FLAT, stdcall
.STACK 4096
Include io.inc
.CODE

; DLL entry point
LibEntry proc instance:DWORD, reason:DWORD, reserved:DWORD
    xor eax, eax      ; Clear EAX
    inc eax           ; Set EAX to 1
    ret               ; Return
LibEntry ENDP

; Perform calculation: ((a + b) * multiplier) / divisor, then square the result
calculateResult PROC
    PUSH EBP          ; Save base pointer
    MOV EBP, ESP      ; Set up stack frame
    SUB ESP, 0        

    ; Save Registers
    PUSH EBX          
    PUSH ESI          
    PUSH EDI          
    PUSHFD            

    mov esi, [ebp+8]  ; Load first operand (a) into ESI
    add esi, [ebp+12] ; Add second operand (b) to ESI

    mov edi, [ebp+16] ; Load multiplier into EDI
    imul esi, edi     ; Multiply (a + b) by multiplier

    mov ecx, [ebp+20] ; Load divisor into ECX
    xor edx, edx      ; Clear EDX for division
    mov eax, esi      ; Move result to EAX for division
    div ecx           ; Divide EAX by divisor

    imul eax, eax     ; Square the quotient

    ; Restore flags
    POPFD             
    POP ESI           
    POP EDI           
    POP EBX           

    ; resotre stack
    MOV ESP, EBP      
    POP EBP           

    RET               ; Return result in EAX
calculateResult ENDP

end LibEntry
