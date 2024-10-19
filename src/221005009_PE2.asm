; Author: Baraka Bukanga
; PE2 DLL - Binary and Hexadecimal to Decimal Conversion
.386
.MODEL FLAT, stdcall
.STACK 4096

.CODE

; LibMain function - Checks DLL load status
LibMain proc instance:DWORD, reason:DWORD, unused:DWORD
	mov eax, 1
  ret
LibMain ENDP

; --------------------------------------
; binStringToDecimal
; Converts binary string to decimal
; Input: pointer to binary string (char*)
; Output: decimal integer or -1 if invalid input
binStringToDecimal PROC NEAR32
    push ebp
    mov  ebp, esp
    mov  esi, [ebp+8]      ; esi points to the binary string (char*)

    xor  eax, eax          ; eax will hold the result (decimal value)
    xor  ebx, ebx          ; ebx will be the multiplier (2^position)

    ; Loop through the string and convert
check_binary:
    mov  al, byte ptr [esi] ; get the current char
    cmp  al, 0              ; check if end of string
    je   end_binary         ; if end, jump to the end

    ; Check if the character is '0' or '1'
    cmp  al, '0'
    je   is_zero
    cmp  al, '1'
    je   is_one

    ; Invalid character found
    mov  eax, -1
    jmp  done_binary

is_zero:
    shl  ebx, 1             ; multiply the current result by 2
    inc  esi                ; move to the next character
    jmp  check_binary

is_one:
    shl  ebx, 1             ; multiply the current result by 2
    inc  ebx                ; add 1 for the '1' bit
    inc  esi                ; move to the next character
    jmp  check_binary

end_binary:
    mov  eax, ebx           ; store the final decimal result in eax

done_binary:
    pop  ebp
    ret
binStringToDecimal ENDP

; --------------------------------------
; hexStringToDecimal
; Converts hexadecimal string to decimal
; Input: pointer to hexadecimal string (char*)
; Output: decimal integer or -1 if invalid input
hexStringToDecimal PROC NEAR32
    push ebp
    mov  ebp, esp
    mov  esi, [ebp+8]      ; esi points to the hex string (char*)

    xor  eax, eax          ; eax will hold the result (decimal value)
    xor  ebx, ebx          ; ebx will be the multiplier (16^position)

    ; Loop through the string and convert
check_hex:
    mov  al, byte ptr [esi] ; get the current char
    cmp  al, 0              ; check if end of string
    je   end_hex            ; if end, jump to the end

    ; Check if the character is a valid hex digit (0-9, A-F)
    cmp  al, '0'
    jl   invalid_hex
    cmp  al, '9'
    jle  is_digit

    cmp  al, 'A'
    jl   invalid_hex
    cmp  al, 'F'
    jle  is_upper_hex

invalid_hex:
    mov  eax, -1            ; invalid character, return -1
    jmp  done_hex

is_digit:
    sub  al, '0'            ; convert char '0'-'9' to 0-9
    shl  eax, 4             ; shift result left by 4 (multiply by 16)
    add  eax, ebx           ; add current hex digit to result
    inc  esi                ; move to the next character
    jmp  check_hex

is_upper_hex:
    sub  al, 'A'            ; convert char 'A'-'F' to 0-5
    add  al, 10             ; convert to its correct decimal value (A = 10)
    shl  eax, 4             ; shift result left by 4 (multiply by 16)
    add  eax, ebx           ; add current hex digit to result
    inc  esi                ; move to the next character
    jmp  check_hex

end_hex:
    mov  eax, ebx           ; store the final decimal result in eax

done_hex:
    pop  ebp
    ret
hexStringToDecimal ENDP

END LibMain
