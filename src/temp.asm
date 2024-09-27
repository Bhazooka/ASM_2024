; retool(int*array, int size)
;int*array    [ebp+8]
;int size     [ebp+12]
retool   PROC NEAR32
;Creating the stack frame here:
push         ebp
mov          ebp,esp
;Space for local variables here:

;Backing up registers here:
push        eax
push        ebx
push        edx
push        ecx
pushfd

; =====================================Function code right here: =====================================
;Printing the user prompts
lea                 edx, Prompt2
push                edx
call                OutputStr
lea                 edx, OpenBracket
push                edx
call                OutputStr

mov         ecx,0       ;Staring the counter for the array here
FirstLoop:
cmp        ecx,DWORD PTR [ebp+12]
jge        LoopEnd_
;Accessing array elements here:
imul				eax,ecx,4
mov					ebx,DWORD PTR [ebp+8]
add					ebx,eax 			;The memory address of array[n]
mov					edx,[ebx]
;After getting the value of the array moved into edx, we multiply it but 4
imul                ebx, edx,4
;Printing the array values divided by 4:
push                ebx
call                OutputInt
inc                 ecx
;Comparing the counter before printing the array here:
cmp                 ecx, DWORD PTR[ebp+12]
jge                 LoopEnd_
lea                 ebx, strComma
push                ebx
call                OutputStr
jmp                 FirstLoop
;Loop for the array elements is done:
LoopEnd_:
lea                 edx, CloedBracket
push                edx
call                OutputStr
lea                ebx, strNL
push               ebx
call               OutputStr
; ===================================== ===================================== =============================
;Restoring registers here:
popfd
pop        ecx
pop        edx
pop        ebx
pop        eax

;Destroying the stack frame here:
mov       esp,ebp
pop       ebp
;Since we have two paramters we do the following here:
ret       8
retool    ENDP



















**********************************
************ST2 2023*********
**********************************

retool PROC NEAR32
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
jle         retoolLoopEnd         ; If size <= 0, jump to retoolLoopEnd (no elements to process)

retoolLoopStart:
    ; Accessing array elements here:
    mov         eax, [esi]        ; Load the current array element into EAX (from memory at [esi])
    imul        eax, 4            ; IMPORTANT "poi" "dividing each element in the array by 0.25, is equivalent to multiplying each element by 4
    mov         [esi], eax        ; Store the modified value back into the array at the current position

    ; Loop increment
    add         esi, 4            ; Move to the next array element (each int is 4 bytes)
    dec         ecx               ; Decrement ecx (the length of array/size/counter)
    cmp         ecx, 0
    jg          retoolLoopStart    ; If ecx > 0, jump back to retoolLoopStart to process the next element

retoolLoopEnd:
    ; Loop is done when ecx reaches 0 (since it's the array length)

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

retool ENDP


**********************************
************ST2 2022*********
**********************************

calculate PROC NEAR32
; Creating the stack frame here:
push        ebp                    
mov         ebp, esp    

;Create space for local variables
	sub					esp,4
	;sum				[ebp-4]

; Backing up registers here:                   
push        ebx                    
push        ecx                    
push        edx                    
pushfd                           

; Parameters:
; int size      -> [ebp+8] (length of the array)
; int* array    -> [ebp+12] (address of array)

mov         ecx, [ebp + 8]        ; Load the size into ECX
mov         esi, [ebp + 12]       ; Load the array address into ESI
mov        DWORD PTR [ebp - 4], 0          ; Initialize local variable sum to 0

; Loop condition test
cmp         ecx, 0                 ; Compare the size with 0
jle         calculateEnd           ; If size <= 0, jump to calculateEnd

calculateLoopStart:
    ; Accessing array elements here:
    mov         edx, [esi]        ; Load the current array element into EDX
    imul        edx, 2            ; Multiply the current element by 2
    add         [ebp - 4], edx     ; Add the result to the local variable sum

    ; Loop increment
    add         esi, 4            ; Move to the next array element (each int is 4 bytes)
    dec         ecx               ; Decrement ECX (the size/counter)
    cmp         ecx, 0
    jg          calculateLoopStart ; If ECX > 0, jump back to calculateLoopStart

calculateEnd:
    ; Load the sum into EAX to return
    mov         eax, [ebp - 4]     ; Move the local sum to EAX

; Restoring registers here:
popfd                            
pop         edx                   
pop         ecx                   
pop         ebx                                   

; Destroying the stack frame here:
mov         esp, ebp              
pop         ebp                  

; Since we have two parameters (size and array), ret 8 bytes
ret         8                     

calculate ENDP


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
mov         ebx, 5                ; Store the constant 5 (to subtract from each element) in ebx

; Loop condition test
cmp         ecx, 0                ; Compare the size with 0
jle         pawsLoopEnd              ; If size <= 0, jump to pawsLoopEnd (no elements to process)

pawsLoopStart:
    ; Accessing array elements here:
    mov         eax, [esi]        ; Load the current array element into EAX (from memory at [esi])
    sub         eax, ebx          ; Subtract 5 from the current array element
    mov         [esi], eax        ; Store the modified value back into the array at the current position

    ; Loop increment
    add         esi, 4            ; Move to the next array element (each int is 4 bytes)
    dec         ecx               ; Decrement ecx (the size/counter of remaining elements)
	cmp			ecx,0
    jle         pawsLoopStart         ; If ecx != 0, jump back to pawsLoopStart to process the next element

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
mov         ecx, [ebp + 16]       ; Load the array size into ECX
mov         ebx, [ebp + 12]       ; Load the current index (n) into EBX

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
mov         ecx, [ebp + 16]       ; Load the array size into ECX
mov         ebx, [ebp + 12]       ; Load the current index (n) into EBX

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
