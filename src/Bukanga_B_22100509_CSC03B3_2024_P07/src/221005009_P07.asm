
;	Author: B Bukanga
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

.DATA
	reqInput			BYTE	"Enter string: ", 0
	displayOutput		BYTE	"Reversed string: ", 0
	searchChar			BYTE	"!",0
	replaceChar			BYTE	"#",0
	NL					BYTE	10, 0
	strInput			BYTE	50 DUP(0)

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.CODE
replaceCharfunction PROC NEAR32
; registers to backup
	PUSH ebp
	MOV ebp, esp
	PUSH eax
	PUSH ebx
	PUSH ecx
	PUSH edx
	PUSH esi
	PUSHFD
	
	MOV esi, [ebp+8]		; String Parameter address
	MOV al, searchChar    	; Character searcgh
	MOV bl, replaceChar  	; char replace

changeLoop:
	MOV dl, BYTE PTR [esi] 
	CMP dl, 0              
	JE done                
	CMP dl, al             	; Compare character with searchChar
	JNE dontDisplayReplace       ; skip replacement if not equal
	MOV BYTE PTR [esi], bl 	; Replace char

dontDisplayReplace:
	INC esi                ; Move to the next character in the string
	JMP changeLoop       ; Repeat the loop
	done:
	; restoring flag registers
	POPFD
	POP esi
	POP edx
	POP ecx
	POP ebx
	POP eax
	; Destroying stack frame
	MOV esp, ebp
	POP ebp

	RET 4                  ; Clean up the stack and return (4 bytes - 1 parameter)
replaceCharfunction ENDP

functionToReverseString PROC NEAR32
; Function setup
	; Create stack frame
	PUSH ebp
	MOV ebp, esp

	; Backing up general registers
	PUSH eax
	PUSH ebx
	PUSH ecx
	PUSH edx
	PUSH esi
	PUSH edi
	PUSHFD
	
	; Load string memory address
	MOV esi, [ebp+8]
	; Finding null terminator
	MOV edi, esi            ; Copy start address to EDI

reverseEndSymbol:
	CMP BYTE PTR [edi], 0 
	JE ReverseBeginning  ; swap for 0
	INC edi               
	JMP reverseEndSymbol	; jump to function call

ReverseBeginning:
	DEC edi

swapReversed:
	CMP esi, edi        ; compare pointers
	JGE complete       ; if statement
	MOV al, [esi]		; Swap the characters at ESI and EDI
	MOV bl, [edi]
	MOV [esi], bl
	MOV [edi], al		; Move the pointers inward
	INC esi
	DEC edi

	JMP swapReversed	; call function

complete:
	POPFD
	POP edi
	POP esi
	POP edx
	POP ecx
	POP ebx
	POP eax
	; Destroying stack frame
	MOV esp, ebp
	POP ebp
	;
    RET 4                      ; Return and clean up stack
functionToReverseString ENDP

_start:
; Creating stack frame
	PUSH 	ebp
	MOV		ebp, esp
; Inputs
	INVOKE 	OutputStr, ADDR reqInput
	PUSH	50
	LEA		ebx, strInput
	PUSH	ebx
	CALL	InputStr
; replace characters
	LEA		eax, strInput
	PUSH	eax
	CALL	replaceCharfunction
; reversing characters
	LEA		eax, strInput
	PUSH	eax
	CALL	functionToReverseString
	; backing up value
	MOV		ebx, eax
	; Output
	INVOKE	OutputStr, ADDR displayOutput
	INVOKE 	OutputStr, ebx
	INVOKE OutputStr, ADDR NL
	MOV		esp, ebp
	POP		ebp
	INVOKE ExitProcess, 0
Public _start
END