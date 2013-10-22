;		+---------------------------------------+ 
;		| Exercicio 1 - Verificar ocorrencias	|
;		+---------------------------------------+
;
;	-Verifica a ocorrencia de um caracter numa string.
;	-Ambos os dados sao introduzidos pelo utilizador.

Ex1:
	
	;INT 10h  ; Forma martelada para limpar a janela
	;mov      ax, 3
    ;int      10h
	
	call	NewLine
	call	NewLine
	lea		DX,[introStr] 
	call	WriteString 			;Apresenta a string inicial que pede um
	
	mov 	CX, 1 					;Restringe o numero de caracteres que ira ser lido para 1
	lea 	DX,[charInput] 			;inicializa o buffer da string
	call 	ReadString 
	
	call	NewLine
	lea 	DX,[fraseStr]			;Imprime o pedido de introducao de uma string
	call 	WriteString
	
	mov 	CX, 100 					;Restringe o numero de caracteres que ira ser lido para 50
	lea 	DX,[frase] 				;inicializa o buffer da string
	call 	ReadString 
	
	mov 	[fraseStrLength], AX 	;guarda o numero de caracteres da frase
	mov 	CX, AX 					;inicializa o contador do ciclo
	mov 	DI,0 					;Inicializa o contador dos caracteres
	mov		bl,[charInput]
	
checkCharCicle:
	
	cmp bl, [frase + DI]
	JNE diffChar
	inc byte [ocorrencias]
diffChar:
	inc DI
	loop checkCharCicle
	
	call 	NewLine
	lea     dx, [nCharsStr]			; imprime o numero de palavras
	call    WriteString
	mov		ah,0
	mov		al,[ocorrencias]		; converte para byte
	call  	WriteDec
	
	call	NewLine
	call	NewLine
	
	ret
;-----------------	
section .data
	;strings to show
	introStr	db "Introduza um caracter> ",0
	fraseStr	db "Introduza uma frase> ",0
	nCharsStr	db "Numero de caracteres encontrados> ",0
	
	;data holders
	frase: times 100 	db 0
	charInput			db " ",0
	
	fraseStrLength  	dw 0
	ocorrencias			db 0	

