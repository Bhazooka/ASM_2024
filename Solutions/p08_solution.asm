.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
  inputArray DWORD 99, 80, 57, 0, 0, 0, 110  ; Array of 7 doublewords
  arraySize DWORD 7                ; Size of the array
  intResult DWORD ?                ; Variable to store the integer result
  floatResult REAL4 ?              ; Variable to store the floating-point result

.CODE
  calculateIntAverage PROC NEAR32
    push ebp
    mov ebp, esp

    push esi
    push eax
    push edx
	pushfd

    mov esi, OFFSET inputArray  ; Point esi to the start of the array
    mov ecx, arraySize      ; Set the loop counter
    xor eax, eax              ; clear eax

  sumIntLoop:
    add eax, [esi]          ; Add the current element to the sum
    add esi, TYPE inputArray    ; Move to the next element
    loop sumIntLoop            ; Repeat the loop

    ; Divide the sum by the array size
    xor edx, edx            ; Clear edx for division
    div arraySize

    ; Store the integer result
    mov intResult, eax

	popfd
    pop edx
    pop eax
    pop esi

    mov esp, ebp
    pop ebp
    ret
  calculateIntAverage ENDP

  calculateFloatAverage PROC NEAR32
    push ebp
    mov ebp, esp
	pushfd

    push esi

    ; Initialize FPU
    finit

    mov esi, OFFSET inputArray  ; Point esi to the start of the array
    mov ecx, arraySize      ; Set the loop counter
    fldz                    ; Initialize sum to 0.0 on the FPU stack

  sumFloatLoop:
    fild DWORD PTR [esi]    ; Load the current element onto the FPU stack
    fadd                    ; Add it to the sum
    add esi, TYPE inputArray    ; Move to the next element
    loop sumFloatLoop            ; Repeat the loop

    ; Divide the sum by the array size
    fidiv DWORD PTR arraySize 

    ; Store the floating-point result
    fstp floatResult

	popfd
    pop esi

    mov esp, ebp
    pop ebp
    ret
  calculateFloatAverage ENDP

; ===Entry Point===
_start:
  ; Calculate the integer average
  call calculateIntAverage

  ; Calculate the floating-point average
  call calculateFloatAverage

  ; Exit the program
  call ExitProcess

Public _start
END