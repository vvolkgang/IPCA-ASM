;		+---------------------------------------+ 
;		| Exercicio 2 - String Aleatoria		|
;		+---------------------------------------+
;
;	-Cria uma string de 10 caracteres aleatorios.
;	-Os caracteres podem ser maiusculos ou minusculos.

Ex2:
	;push	ax
	mov		cx,	[finalStrLen]					; inicializa o ciclo
	mov 	DI, 0						; variavel de controlo do ciclo
	
stringLoop:
	;push	DI
	mov 	dx, 0
	call 	Random						;Cria um numero aleatorio de 16bits e mete-o em AX
	
	
	
	mov		bx, 2
	div 	bx							;divide AX por 2, resultado ficara em AL e o resto em AH

	;+-------
	;|Compara o resto da divisao, caso seja 0 cria uma letra maiuscula
	;|caso contrario cria uma letra minuscula
	;+-------
	mov		bx, 0
	cmp 	dx, 0 						;verifica se o resto da divisao e 0
	je		upperCase					;se ah == 0, cria uma letra maiscula
	jmp		lowerCase 					;caso contrario, se for 1, cria uma minuscula
	
	;+-------
	;|	A tabela ASCII ira ser usada para conseguir uma letra aleatoria
	;|	Para tal, tira-se partido de uma formula:
	;|			(random() mod ((MAX+1)-MIN)) + MIN
	;|	Onde random() gera numeros aleatorios sem sinal de 16bits
	;|	
	;|	A formula para as letras maisculas fica:
	;|			(random() mod ((90+1)-65)) + 65 <=>
	;|			<=>(random() mod 26) + 65
	;|	A formula para as letras minusculas fica:
	;|			(random() mod ((122+1)-97)) + 97 <=>
	;|			<=> (random() mod 26) + 97
	;+-------
upperCase:
	;DEBUG
	call	NewLine
	
	;lea		dx, [debug1]
	;call	WriteString
	;END DEBUG
	
	mov 	dx, 0
	call 	Random
	call 	NewLine
	call	WriteDec
	mov		bx, 26
	div 	bx
	add 	dx, 65							;AH fica com o ascii code do char a ser introduzido na string
	
	
	
	;pop		DI
	
	call	NewLine
	mov		ax, DI
	call	WriteDec
	
	
	mov 	byte [finalStr + DI], dl
	inc 	DI
	
	;call printString DEBUG
	
	loop 	stringLoop
	jmp printString
lowerCase:
	;DEBUG

	;lea		dx, [debug2]
	;call	WriteString
	;END DEBUG
	
	mov 	dx, 0
	call 	Random
	call	WriteDec
	call 	NewLine
	mov		bx, 26
	div 	bx
	add 	dx, 97							;AH fica com o ascii code do char a ser introduzido na string
	
	;pop		DI
	call	NewLine
	mov		ax, DI
	call	WriteDec
	mov 	byte [finalStr + DI], dl				;Adiciona AH à string final
	
	;call printString ;DEBUG

	inc 	DI

	
	
	loop 	stringLoop					;Volta ao inicio
printString:
	call 	NewLine
	call 	NewLine
	lea		dx,[finalStr] 
	call	WriteString
	;pop 	ax 	
	ret

section .data

    finalStr		db "----------------------------------------",0
	finalStrLen		dw 40 				; numero de palavras
	i				db 0
	
	
	;DEBUG
	debug1		db "ENTROU UPPER CASE",0
	debug2		db "ENTROU LOWER CASE",0
