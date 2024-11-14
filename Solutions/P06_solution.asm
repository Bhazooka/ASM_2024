.386
.model flat
.stack 4096

ExitProcess proto near32 stdcall, dwExitCode:dword

.data
    stepCountArray      DD 1000, 2000, 3000, 0, 500, 60, 7000   ; Define an array with 7 32-bit integers
    arraySize           DWORD 7                                 ; Store the number of elements in the array
    stepCountSum        DWORD ?                                 ; Variable to store the sum of array elements
    stepCountAverage    DWORD ?                                 ; Variable to store the average of array elements

.code
_start:
	; Save registers
	push ebp
	MOV ebp, esp

    ; Initialize global variables
    mov ecx, [arraySize]            ; Load number of elements into ecx
    lea ebx, [stepCountArray]       ; Load address of the array into ebx

    ; Call the recursive function
    call RecursiveStepCount

    ; Calculate average
    mov eax, [stepCountSum]         ; Load the sum into eax
    cdq                             ; Sign extend eax into edx:eax for division
    mov ecx, [arraySize]            ; Load number of elements into ecx
    div ecx                         ; Divide edx:eax by ecx, quotient in eax
    mov [stepCountAverage], eax     ; Store the result in the 'stepCountAverage' variable

	; Release registers
	MOV esp, ebp
	POP ebp

    invoke ExitProcess, 0

Public _start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Recursive function to sum the elements of an array    ;
; Arguments:                                            ;
;   ebx - pointer to the current element of the array   ;
;   ecx - number of elements left to process            ;
; Returns:                                              ;            
;   eax - sum of the array elements                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RecursiveStepCount proc
	; Save registers
	PUSH ebp
	MOV  ebp, esp
	PUSH edx
	PUSH ecx
	PUSH ebx
	PUSHFD

    ; Check if there are no elements left to process
    cmp ecx, 0
    je baseCase                 ; If ecx is 0, jump to baseCase

    ; Recursive case
    push ebx                    ; Save ebx on the stack
    push ecx                    ; Save ecx on the stack

    ; Decrement the index and update ecx
    dec ecx                     ; Decrement the number of elements

    ; Move to the next element
    add ebx, 4                  ; Move to the next element (4 bytes)
    
    call RecursiveStepCount     ; Recursively call the function

    ; Restore ebx and ecx
    pop ecx                     ; Restore ecx (number of elements)
    pop ebx                     ; Restore ebx (pointer to array)

    ; Add the current element to the result
    mov eax, [ebx]              ; Load the current element into eax
    add [stepCountSum], eax     ; Add the current element to the result

baseCase:
	; Release registers
	POPFD          
	POP	ebx
	POP	ecx
	POP	edx
	MOV	esp, ebp
	POP	ebp
    ret 8                       ; Return to caller

RecursiveStepCount endp

end