; Biblioteca de funções
; Adaptado para 16 bits (.COM) e NASM a partir da biblioteca Irvine32

; o inicio do código deve estar na etiqueta start

section .text
org 0100h
		jmp start

;---------------------------------------------------------
;ReadChar PROC
;
ReadChar:
	mov  ah,1
	int  21h
	ret
;ReadChar ENDP

;--------------------------------------------------------
;ReadHex PROC
;
SECTION .data
HMAX_DIGITS equ 128
Hinputarea  times  HMAX_DIGITS db 0
xbtable     db 0,1,2,3,4,5,6,7,8,9,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,10,11,12,13,14,15
numVal      dw 0
charVal     db 0

SECTION .text
ReadHex:
	push bx
	push cx
	push dx
	push si

	lea   dx,[Hinputarea]
	mov   si,dx		; save in SI also
	mov   cx,HMAX_DIGITS
	call  ReadString		; input the string
	mov   cx,ax           		; save length in CX

	; Start to convert the number.

B4: mov  word [numVal],0		; clear accumulator
	lea   bx,[xbtable]		; translate table

	; Repeat loop for each digit.

B5: mov   al,[si]	; get character from buffer
	cmp al,'F'	; lowercase letter?
	jbe B6	; no
	and al,11011111b	; yes: convert to uppercase

B6:
	sub   al,30h	; adjust for table
	xlat  	; translate to binary
	mov   [charVal],al

	mov   ax,16	; numVal *= 16
	mul   word [numVal]
	mov   [numVal],ax
	movzx ax,[charVal]	; numVal += charVal
	add   [numVal],ax
	inc   si	; point to next digit
	loop  B5	; repeat, decrement counter

	mov  ax,[numVal]	; return binary result
	pop  si
	pop  dx
	pop  cx
	pop  bx
	ret
;ReadHex ENDP


;--------------------------------------------------------
;ReadInt PROC 

SECTION .data
Lsign dw 0
saveDigit dw 0
LMAX_DIGITS equ 80
Linputarea:    times 80 db 0
overflow_msgL: db " <32-bit integer overflow>",0
invalid_msgL:  db " <invalid integer>",0

SECTION .text
ReadInt:
	pusha
	lea   dx,[Linputarea]
	mov   si,dx           		; save offset in SI
	mov   cx,LMAX_DIGITS
	call  ReadString
	mov   cx,ax           		; save length in CX
	mov   word [Lsign],1         		; assume number is positive
	cmp   cx,0            		; greater than zero?
	jne   L1              		; yes: continue
	mov   ax,0            		; no: set return value
	jmp   L10              		; and exit

; Skip over any leading spaces.

L1:	mov   al,[si]         		; get a character from buffer
	cmp   al,' '          		; space character found?
	jne   L2              		; no: check for a sign
	inc   si              		; yes: point to next char
	loop  L1
	jcxz  L8              		; quit if all spaces

; Check for a leading sign.

L2:	cmp   al,'-'          		; minus sign found?
	jne   L3              		; no: look for plus sign

	mov   word [Lsign],-1        		; yes: sign is negative
	dec   cx              		; subtract from counter
	inc   si              		; point to next char
	jmp   L4

L3:	cmp   al,'+'          		; plus sign found?
	jne   L4              		; no: must be a digit
	inc   si              		; yes: skip over the sign
	dec   cx              		; subtract from counter

; Test the first digit, and exit if it is nonnumeric.

L3A:mov  al,[si]		; get first character
	call IsDigit		; is it a digit?
	jnz  L7A		; no: show error message

; Start to convert the number.

L4:	mov   ax,0           		; clear accumulator
	mov   bx,10          		; BX is the divisor

; Repeat loop for each digit.

L5:	mov  dl,[si]		; get character from buffer
	cmp  dl,'0'		; character < '0'?
	jb   L9
	cmp  dl,'9'		; character > '9'?
	ja   L9
	and  dx,0Fh		; no: convert to binary

	mov  [saveDigit],dx
	imul bx		; DX:AX = AX * BX
	mov  dx,[saveDigit]

	jo   L6		; quit if overflow
	add  ax,dx         		; add new digit to AX
	jo   L6		; quit if overflow
	inc  si              		; point to next digit
	jmp  L5		; get next digit

; Overflow has occured, 
; and the sign is negative:

L6: cmp  ax,8000h
	jne  L7
	cmp  byte [Lsign],-1
	jne  L7		; overflow occurred
	jmp  L9		; the integer is valid

; Choose "integer overflow" messsage.

L7:	lea  dx,[overflow_msgL]
	jmp  L8

; Choose "invalid integer" message.

L7A:
	lea  dx,[invalid_msgL]

; Display the error message pointed to by DX.

L8:	call WriteString
	call Crlf
	stc		; set Carry flag
	mov  ax,0            		; set return value to zero
	jmp  L10		; and exit

L9: imul word [Lsign]           		; AX = AX * sign

	mov [saveDigit], ax
	popa
	mov ax, [saveDigit]

L10:ret
;ReadInt ENDP

;--------------------------------------------------------
;ReadString PROC
ReadString:
	push cx		; save registers
	push si
	push cx		; save digit count again
	mov  si,dx		; point to input buffer

L11:	mov  ah,1		; function: keyboard input
	int  21h		; DOS returns char in AL
	cmp  al,0Dh		; end of line?
	je   L12		; yes: exit
	mov  [si],al		; no: store the character
	inc  si		; increment buffer pointer
	loop L11		; loop until CX=0

L12:	mov  byte [si],0		; end with a null byte
	pop  ax		; original digit count
	sub  ax,cx		; AX = size of input string
	pop  si		; restore registers
	pop  cx
	ret
;ReadString ENDP

;-----------------------------------------------
;Isdigit PROC
;
IsDigit:
	 cmp   al,'0'
	 jb    ID1
	 cmp   al,'9'
	 ja    ID1
	 test  ax,0     		; set ZF = 1
ID1: ret
;Isdigit ENDP

;--------------------------------------------------------
;WriteString PROC
WriteString:
	pusha
	push ds           		; set ES to DS
	pop  es
	mov  di,dx        		; ES:DI = string ptr
	call Str_length   		; AX = string length
	mov  cx,ax        		; CX = number of bytes
	mov  ah,40h       		; write to file or device
	mov  bx,1         		; standard output handle
	int  21h          		; call MS-DOS
	popa
	ret
;WriteString ENDP

;---------------------------------------------------------
;Str_length PROC USES di,
Str_length:
;	mov di,pString
	mov ax,0     	; character count
L13:
	cmp byte [di],0	; end of string?
	je  L14	; yes: quit
	inc di	; no: point to next
	inc ax	; add 1 to count
	jmp L13
L14: ret
;Str_length ENDP

;PROC NewLine
NewLine:
Crlf:
SECTION .data
temp db 13,10,0
SECTION .text
	push dx
	mov  dx,temp
	call WriteString
	pop  dx
	ret
;ENDPROC

;PROC Clrscr 
;
Clrscr:
	pusha
	mov     ax,0600h    	; scroll window up
	mov     cx,0        	; upper left corner (0,0)
	mov     dx,184Fh    	; lower right corner (24,79)
	mov     bh,7        	; normal attribute
	int     10h         	; call BIOS
	mov     ah,2        	; locate cursor at 0,0
	mov     bh,0        	; video page 0
	mov     dx,0	; row 0, column 0
	int     10h
	popa
	ret
;Clrscr ENDP


;---------------------------------------------------
;Gotoxy PROC
Gotoxy:
	pusha
	mov ah,2
	mov bh,0
	int 10h
	popa
	ret
;Gotoxy ENDP

;----------------------------------------------------------
;Str_compare PROC USES ax dx si di,
Str_compare:
L15: mov  al,[si]
    mov  dl,[di]
    cmp  al,0    			; end of string1?
    jne  L16      			; no
    cmp  dl,0    			; yes: end of string2?
    jne  L16      			; no
    jmp  L17      			; yes, exit with ZF = 1

L16: inc  si      			; point to next
    inc  di
    cmp  al,dl   			; chars equal?
    je   L15      			; yes: continue loop
                 			; no: exit with flags set
L17: ret
;Str_compare ENDP

;---------------------------------------------------------
;Str_copy PROC USES ax cx si di,
Str_copy:
	push ax
	push cx
	call Str_length 		; AX = length source
	mov cx,ax		; REP count
	inc cx         		; add 1 for null byte
;	mov si,source
;	mov di,target
	cld               		; direction = up
	rep movsb      		; copy the string
	pop cx
	pop ax
	ret
;Str_copy ENDP

;---------------------------------------------------------
;Random PROC 
Random:
        push cx
        push dx
        mov ah,00h
        int 1ah

        mov ax,dx
        xchg al,ah
        sbb ah,al
        adc ax,ax
        ror bx,cl

        ror ax,cl
        mov cx,ds
        adc cx,bx
        adc ax,bx
        xchg ah,bl
        xchg al,ah
        adc al,ah

        pop dx
        pop cx

        ret
;Random ENDP

;---------------------------------------------------------
;Pause PROC 
Pause:
        push ax
	mov ax,2
	call Pause2
        pop ax
   	ret
;Pause ENDP

;---------------------------------------------------------
;Pause2 PROC USES ax
Pause2:
        push ax
        push cx
        push dx
        mov cx,35
	mul cl
	xchg ax,cx
  	mov dx,3dah
loop_pause_1:
loop_pause_2:
      	in al,dx
      	and al,08h
        jnz loop_pause_2
loop_pause_3:
      	in al,dx
      	and al,08h
        jz loop_pause_3
        loop loop_pause_1
        pop dx
        pop cx
        pop ax
   	ret
;Pause2 ENDP



;------------------------------------------------------
;WaitMsg PROC
SECTION .data
waitmsgstr db "Qualquer tecla para continuar...",0
SECTION .text
WaitMsg:
	push dx
	mov  dx,waitmsgstr
	call WriteString
	call ReadChar
	call NewLine
	pop  dx
	ret
;WaitMsg ENDP

;-----------------------------------------------------
;WriteDec PROC
SECTION .data
BUFFER_SIZE equ 6

bufferL times BUFFER_SIZE db 0,0
xtable db "0123456789ABCDEF"

SECTION .text
WriteDec:
	pusha               ; save all 16-bit data registers
	mov   cx,0           ; digit counter
	mov   di,bufferL
	add   di,(BUFFER_SIZE - 1)
	mov   bx,10	; decimal number base

WI1:
	mov   dx,0          ; clear dividend to zero
	div   bx            ; divide AX by the radix

	xchg  ax,dx        ; swap quotient, remainder
	call  AsciiDigit     ; convert AL to ASCII
	mov   [di],al        ; save the digit
	dec   di             ; back up in buffer
	xchg  ax,dx        ; swap quotient, remainder

	inc   cx             ; increment digit count
	or    ax,ax        ; quotient = 0?
	jnz   WI1            ; no, divide again

	; Display the digits (CX = count)
WI3:
	inc   di
	mov   dx,di
	call  WriteString

WI4:
	popa	; restore 16-bit registers
	ret
;WriteDec ENDP


;-----------------------------------------------------
;AsciiDigit PROC private
AsciiDigit:
	push  bx
	mov   bx,xtable
	xlat
	pop   bx
	ret
;AsciiDigit ENDP

