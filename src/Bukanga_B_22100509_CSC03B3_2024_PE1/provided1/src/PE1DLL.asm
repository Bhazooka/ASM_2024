; Author: B, Bukanga; 221005009
; PE1 DLL starter file
.386
.MODEL FLAT, stdcall
.STACK 4096
include io.inc

.CODE

; Entry point function for the DLL
DllEntryPoint proc hInst:DWORD, reason:DWORD, reserved:DWORD
    mov eax, 1
    ret
DllEntryPoint ENDP

; Function to compute the aliquot sum of a number
aliquotSum PROC NEAR32
    ; setup stack frame
    push ebp
    mov ebp, esp
    push esi
    push edi

    ; Initialize registers
    xor eax, eax                         ; Clear eax for safety
    xor esi, esi                         ; Set esi to 0 (to store sum of divisors)
    mov edi, 1                           ; Set divisor (edi) to 1

calculateDivisors:
    mov eax, [ebp+8]                     ; Load n into eax
    cmp edi, eax                         ; Compare divisor with n
    jge done                             ; If divisor >= n, we are done

    mov edx, 0                           ; Clear edx for division
    div edi                              ; eax = n / edi, edx = n % edi

    test edx, edx                        ; Check if remainder is 0 (i.e., a divisor)
    jnz skip                             ; If remainder is not 0, skip

    add esi, edi                         ; Add the divisor to the sum

skip:
    inc edi                              ; Move to the next divisor
    jmp calculateDivisors                ; Repeat for next divisor

done:
    mov eax, esi                         ; Move the sum of divisors into eax (the return value)

    ; Epilogue - restore stack and registers
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret 4                                ; Clean stack and return
aliquotSum ENDP

; Function to classify the number based on its aliquot sum
classify PROC NEAR32
    ; Prologue - setup stack frame
    push ebp
    mov ebp, esp
    push esi

    ; Calculate aliquot sum
    mov eax, [ebp+8]                     ; Load the input number (n) into eax
    push eax                             ; Push n as an argument for aliquotSum
    call aliquotSum                      ; Call aliquotSum, result is in eax
    mov esi, eax                         ; Store aliquot sum in esi
    mov eax, [ebp+8]                     ; Reload n into eax

    ; Compare aliquot sum with n
    cmp esi, eax
    jl deficient                         ; If sum < n, number is deficient (-1)
    je perfect                           ; If sum == n, number is perfect (0)
    jmp abundant                         ; If sum > n, number is abundant (1)

deficient:
    mov eax, -1                          ; Set result to -1 for deficient
    jmp done

perfect:
    mov eax, 0                           ; Set result to 0 for perfect
    jmp done

abundant:
    mov eax, 1                           ; Set result to 1 for abundant

done:
    ; Epilogue - restore stack and registers
    pop esi
    mov esp, ebp
    pop ebp
    ret 4                                ; Clean stack and return
classify ENDP

end DllEntryPoint
