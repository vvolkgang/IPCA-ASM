%include 'arq2010.asm'
%include 'Logo.asm'
%include 'Ex1.asm'
%include 'Ex2.asm'

start:
	;call prepareTile
	call ShowLogo

	call NewLine
	
choiceCicle:	
	
	call printMenu
	cmp ax, 1
	je Ex1
	cmp ax, 2
	je Ex2
	cmp ax, 3
	je Ex1
	cmp ax, 4
	je exit
	jmp choiceCicle
	
exit:	
	call	prepareTile
	mov 	AH,4CH 	;Desliga
	INT 	21h

	
printMenu:
	call printChoice1
	call printChoice2
	call printChoice3
	call printChoice4
	
	call printChoose
	ret
printChoice1:
	lea dx,[choice1Str] 
	call WriteString
	call NewLine
	ret
printChoice2:
	lea dx,[choice2Str] 
	call WriteString
	call NewLine
	ret	
printChoice3:
	lea dx,[choice3Str] 
	call WriteString
	call NewLine
	ret	
printChoice4:
	lea dx,[choice4Str] 
	call WriteString
	call NewLine
	ret	
printChoose:
	call NewLine
	lea dx,[chooseStr]
	call WriteString
	
	call ReadInt
	ret

prepareTile:
	MOV AH,09         ; FUNCTION 9
	MOV AL,35        ; CARDINAL ASCII
	MOV BL,0AH ; Background = Black = 0, Foreground = Green = A
	;MOV CX,07D0H      ; 2000 CARACTERS
	INT 10H              ; INTERRUPT 10 -> BIOS
	ret
	
section .data
	choice1Str	db 	"1- Ex1 - Verificar ocorrencias",0
	choice2Str	db 	"2- Ex2 - String Aleatoria",0
	choice3Str	db 	"3- Ex3 - ...",0
	choice4Str	db 	"4- Be a bitch, take the blue pill and GTFO!",0
	chooseStr	db	"Choose your destiny> ",0
