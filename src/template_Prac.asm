
**********************************
******EXAM MAIN 2023 PaperA****** ; Iterative
**********************************
leftShift PROC NEAR32
    ; Creating the stack frame
    push        ebp                    
    mov         ebp, esp              

    ; Backing up registers
    push        eax                    
    push        ebx                    
    push        ecx                    
    push        edx                    
    pushfd                           

    ; Parameters:
    ; int* arrRef   -> [ebp+8] (address of array)
    ; int n         -> [ebp+12] (current index)
    ; int size      -> [ebp+16] (length of the array)

    mov         esi, [ebp + 8]        ; Load the array address (arrRef) into ESI
    mov         ebx, [ebp + 12]       ; Load the current index (n) into EBX
    mov         ecx, [ebp + 16]       ; Load the array size into ECX

    ; Base case: Check if n >= size
    cmp         ebx, ecx              ; Compare n with size
    jge         leftShiftEnd           ; If n >= size, jump to leftShiftEnd

    ; Perform left shift: Accessing array elements
    mov         eax, [esi + ebx * 4]  ; Load the current array element into EAX
    shl         eax, 4                 ; Left shift the element by 4 bits
    mov         [esi + ebx * 4], eax   ; Store the modified value back into the array

    ; Recursive call: Prepare parameters for the next call
    inc         ebx                    ; Increment the index (n)
    push        ecx                    ; Push size
    push        ebx                    ; Push the new index (n)
    push        esi                    ; Push the array address (arrRef)
    call        leftShift              ; Call the recursive leftShift function

leftShiftEnd:
    ; Exit code: Restore registers
    popfd                            
    pop         edx                    
    pop         ecx                    
    pop         ebx                    
    pop         eax                    

    ; Destroying the stack frame
    mov         esp, ebp              
    pop         ebp                   

    ; Return with 12 bytes popped from stack
    ret         12                     
leftShift ENDP

**********************************
******EXAM MAIN 2023 PaperB****** ; iterative
**********************************

.Data 

three	REAL4 or DWORD  3.0 

slice PROC NEAR32
    ; Create the stack frame
    push        ebp                    
    mov         ebp, esp              

    ; Backup registers 
    push        eax                    
    push        ebx                    
    push        ecx                    
    push        edx 
	pushfd

    ; Parameters:
    ; int* intArray -> [ebp+8] (address of array)
    ; int count      -> [ebp+12] (length of the array)

    mov         esi, [ebp + 8]        ; Load the array address (intArray) into ESI
    mov         ecx, [ebp + 12]       ; Load the array size (count) into ECX

    ; Initialize FPU
    finit                              ; Initialize the Floating Point Unit

    ; Loop condition test
    cmp         ecx, 0                 ; Compare the count with 0
    jle         sliceLoopEnd            ; If count <= 0, jump to sliceLoopEnd (no elements to process)

sliceLoopStart:
    ; Accessing array elements here:
    mov         eax, [esi]             ; Load the current array element into EAX
    fild        dword ptr [esi]        ; Load integer into FPU stack
    fld         dword ptr [three]      ; Load 3.0 into the FPU stack
    fdiv                                ; Divide the value by 3
    fstp        dword ptr [esi]        ; Store the result back into the array

    ; Loop increment
    add         esi, 4                  ; Move to the next array element (each int is 4 bytes)
    dec         ecx                     ; Decrement ecx (the size/counter of remaining elements)
    cmp         ecx, 0                  ; Check if we have more elements to process
    jg          sliceLoopStart          ; If ecx > 0, jump back to sliceLoopStart to process the next element

sliceLoopEnd:
    ; Loop is done when ecx reaches 0

    ; Restore the registers here in reverse order
	popfd
    pop         edx                     ; Restore edx
    pop         ecx                     ; Restore ecx
    pop         ebx                     ; Restore ebx
    pop         eax                     ; Restore eax

    ; Destroy the stack frame here
    mov         esp, ebp              
    pop         ebp                   

    ; Return with no value
    ret            8                     
slice ENDP

**********************************
******EXAM MAIN 2023 PaperC****** ; Recursive
**********************************

grow PROC NEAR32
    ; Creating the stack frame
    push        ebp                    
    mov         ebp, esp              

    ; Backing up registers
    push        eax                    
    push        ebx                    
    push        ecx                    
    push        edx                    
    pushfd                           

    ; Parameters:
    ; int* arrRef   -> [ebp+8] (address of array)
    ; int n         -> [ebp+12] (current index)
    ; int size      -> [ebp+16] (length of the array)

    mov         esi, [ebp + 8]        ; Load the array address (arrRef) into ESI
    mov         ebx, [ebp + 12]       ; Load the current index (n) into EBX
    mov         ecx, [ebp + 16]       ; Load the array size into ECX

    ; Base case: Check if n >= size
    cmp         ebx, ecx              ; Compare n with size
    jge         growEnd                ; If n >= size, jump to growEnd

    ; Perform multiplication: Accessing array elements
    mov         eax, [esi + ebx * 4]  ; Load the current array element into EAX
    mov         edx, 5                 ; Load 5 into EDX
    imul        eax, edx               ; Multiply the element by 5
    mov         [esi + ebx * 4], eax   ; Store the modified value back into the array

    ; Recursive call: Prepare parameters for the next call
    inc         ebx                    ; Decrement the index (n)
    push        ecx                    ; Push size
    push        ebx                    ; Push the new index (n)
    push        esi                    ; Push the array address (arrRef)
    call        grow                   ; Call the recursive grow function

growEnd:
    ; Exit code: Restore registers
    popfd                            
    pop         edx                    
    pop         ecx                    
    pop         ebx                    
    pop         eax                    

    ; Destroying the stack frame
    mov         esp, ebp              
    pop         ebp                   

    ; Return with 12 bytes popped from stack
    ret         12                     
grow ENDP

**********************************
******EXAM MAIN 2022 PaperB******
**********************************

rightShift PROC NEAR32
    ; Creating the stack frame
    push        ebp                    
    mov         ebp, esp              

    ; Backing up registers
    push        eax                    
    push        ebx                    
    push        ecx                    
    push        edx                    
    pushfd                           

    ; Parameters:
    ; int* arrRef   -> [ebp+8] (address of array)
    ; int n         -> [ebp+12] (current index)
    ; int size      -> [ebp+16] (length of the array)

    mov         esi, [ebp + 8]        ; Load the array address (arrRef) into ESI
    mov         ebx, [ebp + 12]       ; Load the current index (n) into EBX
    mov         ecx, [ebp + 16]       ; Load the array size into ECX

    ; Base case: Check if n >= size
    cmp         ebx, ecx              ; Compare n with size
    jge         rightShiftEnd          ; If n >= size, jump to rightShiftEnd

    ; Perform right shift: Accessing array elements
    mov         eax, [esi + ebx * 4]  ; Load the current array element into EAX
    shr         eax, 2                 ; Arithmetic right shift the element by 2 bits
    mov         [esi + ebx * 4], eax   ; Store the modified value back into the array

    ; Recursive call: Prepare parameters for the next call
    inc         ebx                    ; Decrement the index (n)
    push        ecx                    ; Push size
    push        ebx                    ; Push the new index (n)
    push        esi                    ; Push the array address (arrRef)
    call        rightShift             ; Call the recursive rightShift function

rightShiftEnd:
    ; Exit code: Restore registers
    popfd                            
    pop         edx                    
    pop         ecx                    
    pop         ebx                    
    pop         eax                    

    ; Destroying the stack frame
    mov         esp, ebp              
    pop         ebp                   

    ; Return with 12 bytes popped from stack
    ret         12                     
rightShift ENDP

**********************************
************EXAM  2021*********
**********************************

plif PROC NEAR32
    ; Create the stack frame
    push        ebp                    
    mov         ebp, esp              

    ; Backup registers
    push        eax                    
    push        ebx                    
    push        ecx                    
    push        edx                    
    pushfd                           

    ; Parameters:
    ; int* arrRef -> [ebp+8] (address of array)
    ; int size     -> [ebp+12] (length of the array)

    mov         esi, [ebp + 8]        ; Load the array address (arrRef) into ESI
    mov         ecx, [ebp + 12]       ; Load the array size (size) into ECX

    ; Loop condition test
    cmp         ecx, 0                 ; Compare size with 0
    jle         plifEnd                ; If size <= 0, jump to plifEnd

plifLoopStart:
    ; Perform logical left shift: Accessing array elements
    mov         eax, [esi]             ; Load the current array element into EAX
    shl         eax, 3                  ; Logical left shift the element by 3 bits
    mov         [esi], eax              ; Store the modified value back into the array

    ; Loop increment
    add         esi, 4                  ; Move to the next array element (each int is 4 bytes)
    dec         ecx                     ; Decrement the size counter
	cmp			ecx,0
    jg          plifLoopStart           ; If ecx > 0, jump back to plifLoopStart

plifEnd:
    ; Exit code: Restore registers
    popfd                            
    pop         edx                    
    pop         ecx                    
    pop         ebx                    
    pop         eax                    

    ; Destroy the stack frame
    mov         esp, ebp              
    pop         ebp                   

    ; Return with no value
    ret         8                   
plif ENDP


**********************************
************EXAM SSA 2020*********
**********************************

paws   PROC NEAR32
; Creating the stack frame here:
push        ebp                   
mov         ebp, esp              

; Backing up registers here:
push        eax                   
push        ebx                   
push        ecx                   
push        edx                   
pushfd                           

; Parameters:
; int* arrRef   -> [ebp+8] (address of array)
; int size      -> [ebp+12] length (length of the array)

mov         esi, [ebp + 8]        ; Load the array address (arrRef) into esi
mov         ecx, [ebp + 12]       ; Load the array size (size) into ecx


; Loop condition test
cmp         ecx, 0                ; Compare the size with 0
jle         pawsLoopEnd              ; If size <= 0, jump to pawsLoopEnd (no elements to process)

pawsLoopStart:
    ; Accessing array elements here:
    mov         eax, [esi]        ; Load the current array element into EAX (from memory at [esi])
    sub         eax, 5          ; Subtract 5 from the current array element
    mov         [esi], eax        ; Store the modified value back into the array at the current position

    ; Loop increment
    add         esi, 4            ; Move to the next array element (each int is 4 bytes)
    dec         ecx               ; Decrement ecx (the size/counter of remaining elements)
	cmp			ecx,0
    jg         pawsLoopStart         ; If ecx != 0, jump back to pawsLoopStart to process the next element

pawsLoopEnd:
    ; Loop is done when ecx reaches 0 (since its the array length)

; Restoring registers here:
popfd                            
pop         edx                   
pop         ecx                  
pop         ebx                   
pop         eax                  

; Destroying the stack frame here:
mov         esp, ebp              
pop         ebp                  

; Since we have two parameters (arrRef and size), ret 8 bytes
ret         8                     

paws   ENDP


**********************************
************EXAM SSSA 2020*********
**********************************

tros PROC NEAR32
; Creating the stack frame here:
push        ebp                    
mov         ebp, esp              

; Backing up registers here:
push        eax                    
push        ebx                    
push        ecx                    
push        edx                    
pushfd                           

; Parameters:
; int* arrRef   -> [ebp+8] (address of array)
; int n         -> [ebp+12] (current index)
; int size      -> [ebp+16] (length of the array)

mov         esi, [ebp + 8]        ; Load the array address (arrRef) into ESI
mov         ebx, [ebp + 12]       ; Load the current index (n) into EBX
mov         ecx, [ebp + 16]       ; Load the array size into ECX


; Base case: Check if n >= size
cmp         ebx, ecx              ; Compare n with size
jge         trosEnd                ; If n >= size, jump to trosEnd (base case)

; Perform add: Accessing array elements here:
mov         eax, [esi + ebx * 4]  ; Load the current array element into EAX (from memory at [esi + ebx * 4])
add         eax, 7                 ; Add 7 to the current element
mov         [esi + ebx * 4], eax   ; Store the modified value back into the array at the current position

; Recursive call: Prepare parameters for the next call
inc         ebx                    ; Increment the index (n)
push        ecx                    ; Push size
push        ebx                    ; Push the new index (n)
push        esi                    ; Push the array address (arrRef)
call        tros                   ; Call the recursive tros function

; Exit code: Restore registers here
trosEnd:
popfd                            
pop         edx                   
pop         ecx                   
pop         ebx                   
pop         eax                   

; Destroying the stack frame here:
mov         esp, ebp              
pop         ebp                  

; Since we have three parameters (arrRef, n, size), ret 12 bytes
ret         12                    

tros ENDP


**********************************
************EXAM MAIN 2020*********
**********************************

ekam PROC NEAR32
; Creating the stack frame here:
push        ebp                    
mov         ebp, esp              

; Backing up registers here:
push        eax                    
push        ebx                    
push        ecx                    
push        edx                    
pushfd                           

; Parameters:
; int* arrRef   -> [ebp+8] (address of array)
; int n         -> [ebp+12] (current index)
; int size      -> [ebp+16] (length of the array)

mov         esi, [ebp + 8]        ; Load the array address (arrRef) into ESI
mov         ebx, [ebp + 12]       ; Load the current index (n) into EBX
mov         ecx, [ebp + 16]       ; Load the array size into ECX

; Base case: Check if n >= size
cmp         ebx, ecx              ; Compare n with size
jge         ekamEnd                ; If n >= size, jump to ekamEnd (base case)

; Perform multiply: Accessing array elements here:
mov         eax, [esi + ebx * 4]  ; Load the current array element into EAX (from memory at [esi + ebx * 4])
imul        eax, 2                 ; Multiply the current element by 2
mov         [esi + ebx * 4], eax   ; Store the modified value back into the array at the current position

; Recursive call: Prepare parameters for the next call
inc         ebx                    ; Increment the index (n)
push        ecx                    ; Push size
push        ebx                    ; Push the new index (n)
push        esi                    ; Push the array address (arrRef)
call        ekam                   ; Call the recursive ekam function

; Exit code: Restore registers here
ekamEnd:
popfd                            
pop         edx                   
pop         ecx                   
pop         ebx                   
pop         eax                   

; Destroying the stack frame here:
mov         esp, ebp              
pop         ebp                  

; Since we have three parameters (arrRef, n, size), ret 12 bytes
ret         12                    

ekam ENDP


**********************************
**************2021 SSA ST2************
**********************************

.Data
seven   REAL4 or DWORD 7.0                   ; Constant for division

purge PROC NEAR32
    ; Create the stack frame
    push        ebp                    
    mov         ebp, esp              

    ; Backup registers 
    push        eax                    
    push        ebx                    
    push        ecx                    
    push        edx 
    pushfd

    ; Parameters:
    ; int* intArray -> [ebp+8] (address of array)
    ; int count      -> [ebp+12] (length of the array)

    mov         esi, [ebp + 8]        ; Load the array address (intArray) into ESI
    mov         ecx, [ebp + 12]       ; Load the array size (count) into ECX

    ; Initialize FPU
    finit                              ; Initialize the Floating Point Unit

    ; Loop condition test
    cmp         ecx, 0                 ; Compare the count with 0
    jle         purgeLoopEnd            ; If count <= 0, jump to purgeLoopEnd (no elements to process)

purgeLoopStart:
    ; Accessing array elements here:
    mov         eax, [esi]             ; Load the current array element into EAX
    fild        dword ptr [esi]        ; Load integer into FPU stack
    fld         dword ptr [seven]      ; Load 7.0 into the FPU stack
    fdiv                                ; Divide the value by 7
    fstp        dword ptr [esi]        ; Store the result back into the array

    ; Loop increment
    add         esi, 4                  ; Move to the next array element (each int is 4 bytes)
    dec         ecx                     ; Decrement ecx (the size/counter of remaining elements)
    cmp         ecx, 0                  ; Check if we have more elements to process
    jg          purgeLoopStart          ; If ecx > 0, jump back to purgeLoopStart to process the next element

purgeLoopEnd:
    ; Restore the registers here in reverse order
    popfd
    pop         edx                     ; Restore edx
    pop         ecx                     ; Restore ecx
    pop         ebx                     ; Restore ebx
    pop         eax                     ; Restore eax

    ; Destroy the stack frame here
    mov         esp, ebp              
    pop         ebp                   

    ; Return with no value
    ret            8                    
purge ENDP


**********************************
**************2021 Main ST2********
**********************************

.Data
point25  REAL4 or DWORD 0.25

kismet PROC NEAR32
    ; Create the stack frame
    push        ebp                    
    mov         ebp, esp              

    ; Backup registers 
    push        eax                    
    push        ebx                    
    push        ecx                    
    push        edx 
    pushfd

    ; Parameters:
    ; int* intArray -> [ebp+8] (address of array)
    ; int count      -> [ebp+12] (length of the array)

    mov         esi, [ebp + 8]        ; Load the array address (intArray) into ESI
    mov         ecx, [ebp + 12]       ; Load the array size (count) into ECX

    ; Initialize FPU
    finit                              ; Initialize the Floating Point Unit

    ; Loop condition test
    cmp         ecx, 0                 ; Compare the count with 0
    jle         kismetLoopEnd           ; If count <= 0, jump to kismetLoopEnd (no elements to process)

kismetLoopStart:
    ; Accessing array elements here:
    mov         eax, [esi]             ; Load the current array element into EAX
    fild        dword ptr [esi]        ; Load integer into FPU stack
    fld         dword ptr [point25]    ; Load 0.25 into the FPU stack
    fmul                                ; Multiply the value by 0.25
    fstp        dword ptr [esi]        ; Store the result back into the array

    ; Loop increment
    add         esi, 4                  ; Move to the next array element (each int is 4 bytes)
    dec         ecx                     ; Decrement ecx (the size/counter of remaining elements)
    cmp         ecx, 0                  ; Check if we have more elements to process
    jg          kismetLoopStart         ; If ecx > 0, jump back to kismetLoopStart to process the next element

kismetLoopEnd:
    ; Restore the registers here in reverse order
    popfd
    pop         edx                     ; Restore edx
    pop         ecx                     ; Restore ecx
    pop         ebx                     ; Restore ebx
    pop         eax                     ; Restore eax

    ; Destroy the stack frame here
    mov         esp, ebp              
    pop         ebp                   

    ; Return with no value
    ret            8                    
kismet ENDP