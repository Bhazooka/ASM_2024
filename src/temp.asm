;	Memo for P04
;	Author:     Dr J du Toit

.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

include	io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
	;========================================Input variables =======================================
	inputImage		DWORD			16 DUP (?)
	kernel			DWORD			4  DUP (?)
	outputImage		DWORD			9  DUP (0)
	
	;========================================String prompts=========================================
	strKernelPrompt BYTE 			"Please provide the kernel value ((>=0):",0
	strCutOff		BYTE			"Please provide the CutOff value:",0
	strInputArr		BYTE			"Please input array item at index ",0
	strOutputBefore	BYTE			"The output array before the cutoff is ",10,0
	strOutputAfter	BYTE			"The output array after the cutoff is ",10,0
	strColon		BYTE			":",0
	strNL			BYTE			10,0
	strQuit			BYTE			"Type 0 to quit:",0
	strTab			BYTE			9,0
	strOpenBracket	BYTE			"[",0
	strCloseBracket BYTE			"]",0
	strComma		BYTE			",",0
	
.CODE
_start:
	;Create the stack frame for local variables
	push			ebp
	mov				ebp,esp
	;Local variables
	;row			[ebp-4]
	;col			[ebp-8]
	;cutoff			[ebp-12]
	;rowOffset		[ebp-16]
	;colOffset		[ebp-20]
	sub				esp,20
	;Initialise the local variables
	mov				DWORD PTR [ebp-4],0				;row = 0
	mov				DWORD PTR [ebp-8],0				;col = 0
	
	
	;===================================Get the input array===========================================
InputLoopStart:
	INVOKE			OutputStr, ADDR strInputArr
	INVOKE			OutputStr, ADDR strOpenBracket
	INVOKE			OutputInt, DWORD PTR [ebp-4]
	INVOKE			OutputStr, ADDR strComma
	INVOKE			OutputInt, DWORD PTR [ebp-8]
	INVOKE			OutputStr, ADDR strCloseBracket
	INVOKE			OutputStr, ADDR strColon
	
	; Calculate the 1D array index
	; row * columns + col 
	imul			eax,DWORD PTR [ebp-4],4			; row * 4 (num of cols)
	add 			eax,DWORD PTR [ebp-8]			; index = row * 4 + col 
	imul			eax,4
	; Access the array address
	lea				ebx,inputImage
	add				ebx,eax
	; Get the input
	INVOKE			InputInt
	mov				[ebx],eax
	;if(col!=3) then inc col
	;   else inc row and set col=0
	cmp				DWORD PTR [ebp-8],3
	jne				IncColA
	;if(row==3) then exit the loop
	cmp				DWORD PTR [ebp-4],3
	je				InputLoopEnd
	;row!=3 but col ==3
	inc				DWORD PTR [ebp-4]
	mov				DWORD PTR [ebp-8],0
	jmp				InputLoopStart
	
IncColA:
	inc				DWORD PTR [ebp-8]
	jmp				InputLoopStart
InputLoopEnd:

	;===================================Get the kernel array===========================================
	;Initialise the local variables
	mov				DWORD PTR [ebp-4],0				;row = 0
	mov				DWORD PTR [ebp-8],0				;col = 0
KernelLoopStart:
	INVOKE			OutputStr, ADDR strKernelPrompt
	INVOKE			OutputStr, ADDR strOpenBracket
	INVOKE			OutputInt, DWORD PTR [ebp-4]
	INVOKE			OutputStr, ADDR strComma
	INVOKE			OutputInt, DWORD PTR [ebp-8]
	INVOKE			OutputStr, ADDR strCloseBracket
	INVOKE			OutputStr, ADDR strColon
	
	; Calculate the 1D array index
	; row * columns + col 
	imul			eax,DWORD PTR [ebp-4],2			; row * 2 (num of cols)
	add 			eax,DWORD PTR [ebp-8]			; index = row * 2 + col 
	imul			eax,4							; Get the DWORD offset
	; Access the array address
	lea				ebx,kernel
	add				ebx,eax
	; Get the input
	INVOKE			InputInt
	mov				[ebx],eax
	;if(col!=1) then inc col
	;   else inc row and set col=0
	cmp				DWORD PTR [ebp-8],1
	jne				IncColB
	;if(row==1) then exit the loop
	cmp				DWORD PTR [ebp-4],1
	je				KernelLoopEnd
	;row!=1 but col ==1
	inc				DWORD PTR [ebp-4]
	mov				DWORD PTR [ebp-8],0
	jmp				KernelLoopStart
	
IncColB:
	inc				DWORD PTR [ebp-8]
	jmp				KernelLoopStart
KernelLoopEnd:

	;Get the cutoff value:
	INVOKE			OutputStr, ADDR strCutOff
	INVOKE			InputInt
	mov				DWORD PTR [ebp-12],eax
	
	;==========================================Apply the kernel=======================================
	;for(int rowOffset=0;rowOffset<3;rowOffset++)
    ;{
    ;    for(int colOffset=0;colOffset<3;colOffset++)
    ;    {
    ;        for(int row=0;row<2;row++)
    ;        {
    ;            for(int col=0;col<2;col++)
    ;            {
    ;                std::cout << "[" << row+rowOffset << "," << col+colOffset << "],";
    ;                std::cout <<"\t["<< row << ","<< col << "], \t ";
    ;            }
    ;            std::cout << std::endl;
    ;        }
    ;        std::cout << std::endl;
    ;    }
    ;}
	;row			[ebp-4]
	;col			[ebp-8]
	;rowOffset		[ebp-16]
	;colOffset		[ebp-20]
	mov					DWORD PTR [ebp-4],0
	mov					DWORD PTR [ebp-8],0		
	mov					DWORD PTR [ebp-20],0			;colOffset = 0
	
	mov					DWORD PTR [ebp-16],0			;rowOffset = 0
OuterRowLoopStart:
	cmp					DWORD PTR [ebp-16],3			;if(rowOffset>=3) exit OuterRowLoopStart
	jge					OuterRowLoopEnd
	mov					DWORD PTR [ebp-20],0
	OuterColLoopStart:
		cmp				DWORD PTR [ebp-20],3
		jge				OuterColLoopEnd
		mov				DWORD PTR [ebp-4],0
		InnerRowLoopStart:
			cmp			DWORD PTR [ebp-4],2
			jge			InnerRowLoopEnd
			mov			DWORD PTR [ebp-8],0
			InnerColLoopStart:
				cmp		DWORD PTR [ebp-8],2
				jge		InnerColLoopEnd
				;Get the value from the InputArray
				;r=row+rowOffset * 4 + col+colOffset
				;r=eax
				mov		eax,DWORD PTR [ebp-4]
				add		eax,DWORD PTR [ebp-16]
				imul	eax,4
				;col+colOffset
				mov		ebx,DWORD PTR [ebp-8]
				add		ebx,DWORD PTR [ebp-20]
				;r=row+rowOffset * 4 + col+colOffset
				add		eax,ebx 
				;Calulate the memory offset
				imul	eax,4
				
				;We get the base address of the inputImage
				lea		ebx,inputImage
				add		ebx,eax
				mov		ecx,[ebx]		;Stores the value from the input array into temp
				
				;Get the kernel value
				;r=row * 2 + col
				;r=eax
				mov		eax,DWORD PTR [ebp-4]
				imul	eax,2
				;col+colOffset
				mov		ebx,DWORD PTR [ebp-8]
				;r=row * 2 + col
				add		eax,ebx 
				;Calulate the memory offset
				imul	eax,4
				
				;We get the value that is in the kernel
				lea		ebx,kernel
				add		ebx,eax
				mov		eax,[ebx]		;Store the kernel array item in accumulator
				;I[r+offset,c+offset] * k[r,c]
				imul	eax,ecx
				mov		ecx,eax			;Temporarily store the answer in ecx 

				;Store the answer in the output array
				;Get the row value of the output array 
				mov		eax,DWORD PTR [ebp-16]				;rowOffset
				imul	eax,3								;rowOffset * 3
				add		eax,DWORD PTR [ebp-20]				;rowOffset * 3 + colOffset
				imul	eax,4								;Convert to memory spaces
				
				lea		ebx,outputImage
				add		ebx,eax
				add		[ebx],ecx							;outputImage[rowOffset,colOffset] += i[r+rowOffset][c+colOffset] + k[r][c]
				
				
				inc		DWORD PTR [ebp-8]
				jmp		InnerColLoopStart
			InnerColLoopEnd:
			inc			DWORD PTR [ebp-4]
			jmp			InnerRowLoopStart
		InnerRowLoopEnd:
		inc				DWORD PTR [ebp-20]
		jmp				OuterColLoopStart
	OuterColLoopEnd:
	inc					DWORD PTR [ebp-16]
	jmp					OuterRowLoopStart
OuterRowLoopEnd:

	;============================================Output the output image ======================================================
	INVOKE			OutputStr,ADDR strOutputBefore
	
	;Initialise the local variables
	mov				DWORD PTR [ebp-4],0				;row = 0
	mov				DWORD PTR [ebp-8],0				;col = 0
OutputLoopStart:
	
	; Calculate the 1D array index
	; row * columns + col 
	imul			eax,DWORD PTR [ebp-4],3			; row * 3 (num of cols)
	add 			eax,DWORD PTR [ebp-8]			; index = row * 3 + col 
	imul			eax,4							; Get the DWORD offset
	; Access the array address
	lea				ebx,outputImage
	add				ebx,eax
	mov				eax,[ebx]						;Get the value from the OutputArray
	INVOKE			OutputInt,eax
	INVOKE			OutputStr,ADDR strComma
	INVOKE			OutputStr,ADDR strTab

	;if(col!=1) then inc col
	;   else inc row and set col=0
	cmp				DWORD PTR [ebp-8],2
	jne				IncColC
	;if(row==1) then exit the loop
	cmp				DWORD PTR [ebp-4],2
	je				OutputLoopEnd
	;row!=1 but col ==1
	inc				DWORD PTR [ebp-4]
	mov				DWORD PTR [ebp-8],0
	INVOKE			OutputStr,ADDR strNL
	jmp				OutputLoopStart
	
IncColC:
	inc				DWORD PTR [ebp-8]
	jmp				OutputLoopStart
OutputLoopEnd:
	INVOKE			OutputStr,ADDR strNL
	
	;============================================Output the output image after CutOff ======================================================
	INVOKE			OutputStr,ADDR strOutputAfter
	
	;Initialise the local variables
	mov				DWORD PTR [ebp-4],0				;row = 0
	mov				DWORD PTR [ebp-8],0				;col = 0
OutputLoopStartA:
	
	; Calculate the 1D array index
	; row * columns + col 
	imul			eax,DWORD PTR [ebp-4],3			; row * 3 (num of cols)
	add 			eax,DWORD PTR [ebp-8]			; index = row * 3 + col 
	imul			eax,4							; Get the DWORD offset
	; Access the array address
	lea				ebx,outputImage
	add				ebx,eax
	mov				eax,[ebx]						;Get the value from the OutputArray
	; if(output[r][c]>=cutoff) then eax 1
	;	else eax=0
	cmp				eax,DWORD PTR [ebp-12]
	jge				GreaterThan
	mov				eax,0
	jmp				WriteValue
GreaterThan:
	mov				eax,1
WriteValue:
	INVOKE			OutputInt,eax
	INVOKE			OutputStr,ADDR strComma
	INVOKE			OutputStr,ADDR strTab

	;if(col!=1) then inc col
	;   else inc row and set col=0
	cmp				DWORD PTR [ebp-8],2
	jne				IncColD
	;if(row==1) then exit the loop
	cmp				DWORD PTR [ebp-4],2
	je				OutputLoopEndA
	;row!=1 but col ==1
	inc				DWORD PTR [ebp-4]
	mov				DWORD PTR [ebp-8],0
	INVOKE			OutputStr,ADDR strNL
	jmp				OutputLoopStartA
	
IncColD:
	inc				DWORD PTR [ebp-8]
	jmp				OutputLoopStartA
OutputLoopEndA:
	INVOKE			OutputStr,ADDR strNL
	
	;===================================Loop until the user quits=============================================
	INVOKE			OutputStr, ADDR strQuit
	INVOKE			InputInt
	cmp				eax,0
	jne				_start
	
	; Destroy the stack frame
	mov				esp,ebp
	pop				ebp
	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END


    