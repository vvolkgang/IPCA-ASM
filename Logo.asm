;		+---------------------------------------+ 
;		| Logo - Mostra o Logotipo				|
;		+---------------------------------------+

ShowLogo:
	call 	NewLine
	call 	NewLine
	call 	NewLine
	
	jmp		loopBegin
	;mostra linha 1
	;lea 	dx,[line1]
	;call 	WriteString
	;call 	NewLine
	;mostra linha 2
	;lea 	dx,[line2]	
	;call 	WriteString
	;call 	NewLine
		
	;mostra linha 3
	;lea 	dx,[line3]
	;call 	WriteString
	;call 	NewLine

	;ret
	
	
	
loopBegin:	
	;Render automatico do logo NAO funciona
	mov		cx,	[totalLines]
	mov 	DI, 0
	mov	bx, 0
	
logoLoop:
	lea 	dx, [line1 + bx ]
	call 	WriteString
	call 	NewLine
	add		bx, [lineLen]
	loop	logoLoop
	
	ret
;-----------------	
section .data
	line1   	db 	" __         __     __  __     ______   																",0
				db  "/\ \       /\ \   /\ \/ /    /\  ___\  																",0
				db	"\ \ \____  \ \ \  \ \  _"-.  \ \  __\  																",0
				db	" \ \_____\  \ \_\  \ \_\ \_\  \ \_____\																",0
				db	"  \/_____/   \/_/   \/_/\/_/   \/_____/																",0
                db  "                    																					",0
				db  "																										",0
				db  "																										",0
				db  "																										",0
				db  "                                                                                                       ",0
				db	" ______  					 _   _           _ _                    ___             _                   ",0
				db	"/\  __ \  					| \ | |         (_) |         ___      |_  |           | |                  ",0
				db	"\ \  __ \ 					|  \| | ___  ___ _| | __ _   ( _ )       | | ___  _ __ | |__   _____      __",0
				db	" \ \_\ \_\					| . ` |/ _ \/ __| | |/ _` |  / _ \/\     | |/ _ \| '_ \| '_ \ / _ \ \ /\ / /",0
				db	"  \/_/\/_/					| |\  | (_) \__ \ | | (_| | | (_>  < /\__/ / (_) | | | | | | | (_) \ V  V / ",0
				db	"							\_| \_/\___/|___/_|_|\__,_|  \___/\/ \____/ \___/|_| |_|_| |_|\___/ \_/\_/  ",0
				db  "																										",0
				db	"												_   _   _   _   _   _   _   _   _   _   _  				",0
				db	"											   / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 				",0
				db	"											  ( P | r | o | d | u | c | t | i | o | n | s )				",0
				db	"											   \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 				",0
				db	"   _____     ______     ______     ______   															",0
				db  " /\  == \   /\  __ \   /\  ___\   /\  ___\  															",0
				db  " \ \  __<   \ \ \/\ \  \ \___  \  \ \___  \ 															",0
				db  "  \ \_____\  \ \_____\  \/\_____\  \/\_____\															",0
				db  "	\/_____/   \/_____/   \/_____/   \/_____/															",0
	lineLen 	dw 	104
	totalLines 	dw	26
	currentLine	db	0
