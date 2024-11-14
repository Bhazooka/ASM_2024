.386
.model flat
.stack 4096

INCLUDE io.inc

ExitProcess proto NEAR32 stdcall, dwExitCode:dword

.data
    ;Data declarations
    prompt db "Enter a string: ", 0             ;Prompt message for user input
    userInputStr db 200 dup(0)                     	;Buffer to store user input
    reversedStr db 200 dup(0)                   ;Buffer to store the reversed string
    outputMsg db "Reversed string: ", 0        	;Message to display before the reversed string
	searchChar db '$'							;Variable for char to be searched
    replaceChar db ','							;Variable for the replacement char
    newLine db 13, 10, 0                        ;Newline characters for formatting output
	
.code
main proc
    ;Main program logic

    ;Display prompt and get user input
    push offset prompt                          ;Push the address of the prompt message onto the stack
    call OutputStr                                	;Call the OutputStr procedure to display the prompt
    push 199                                   	;Push the maximum number of characters to read
    push offset userInputStr                        ;Push the address of the input buffer onto the stack
    call InputStr                                 	;Call the InputStr procedure to read user input

    ;Replace the characters
    call replaceCharacters

    ;Reverse the input string
    call reverseString                          ;Call the reverseString procedure to reverse the input

    ;Display the reversed string
    push offset outputMsg                       ;Push the address of the output message onto the stack
    call OutputStr                                	;Call OutputStr to display the output message
    push offset reversedStr                     ;Push the address of the reversed string onto the stack
    call OutputStr                                	;Call OutputStr to display the reversed string
    push offset newLine                         ;Push the address of the newline characters onto the stack
    call OutputStr                                	;Call OutputStr to print a newline

    ;Exit the program
    call ExitProcess                      ;Call ExitProcess to terminate the program

main endp

replaceCharacters proc
	;Procedure to character replacement
	
    mov esi, offset userInputStr 					;Point esi to the start of the text
    mov al, searchChar   						;Load the search character into al
    mov bl, replaceChar  						;Load the replace character into bl

replaceLoop:
    cmp byte ptr [esi], 0 						;Check for the end of the string
    je done

    cmp byte ptr [esi], al 						;Compare the current character with the search character
    jne nextChar           						;If not equal, move to the next character

    mov byte ptr [esi], bl 						;Replace the character

nextChar:
    inc esi
    jmp replaceLoop

done:
    ret
replaceCharacters endp

reverseString proc
    ;Procedure to reverse a string in-place

    ;Find the length of the input string
    xor ecx, ecx                               	;Initialize a counter to 0
    lea esi, userInputStr                           ;Load the address of the input string into esi
    jmp check_end1                             	;Jump to the loop condition check

    loop_start1:                               	;Loop to iterate through the input string
        inc ecx                                	;Increment the counter
        inc esi                                	;Move to the next character in the input string

    check_end1:                                	;Check for the end of the string
        cmp byte ptr [esi], 0                  	;Compare the current character with the null terminator
        jne loop_start1                         ;If not null, continue the loop

    
    lea esi, userInputStr                           ;Reset esi to point to the start of the input string
    lea edi, reversedStr                        ;Load the address of the reversed string buffer into edi
    add edi, ecx                               	;Move edi to the end of the reversedStr buffer
    dec edi                                    	;Decrement edi to point to the last valid character position

    jmp check_end2                             	;Jump to the loop condition check

    loop_start2:                              	;Loop to reverse the string
        mov al, [esi]                           ;Move the character from the input string to al
        mov [edi], al                           ;Move the character from al to the reversed string buffer
        inc esi                                	;Move to the next character in the input string
        dec edi                                	;Move to the previous character position in the reversed string buffer
        dec ecx                                	;Decrement the counter

    check_end2:                                	;Check for the end of the loop
        cmp ecx, 0                              ;Compare the counter with 0
        jg loop_start2                          ;If the counter is greater than 0, continue the loop

    
    mov byte ptr [edi], 0                      	;Add the null terminator to the reversed string

    ret                                         ;Return from the procedure
reverseString endp

		_start: 
        call main

Public _start
END