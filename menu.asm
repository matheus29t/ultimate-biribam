org 0x7E00
jmp 0x0000:start

;MENU SCREEN TEXT
TITLE 		db "BOLAGUDE", 			0
SUB_TITLE 	db "ULTIMATE BIRIBAM", 	0
START 		db " START", 			0
CONTROLS 	db " CONTROLS", 		0

;CONTROLS SCREEN TEXT
CONTROLS_TITLE	db "[ === CONTROLS === ]", 		0
PLAYER_1 		db "[ PLAYER 1 ]", 				0
PLAYER_2 		db "[ PLAYER 2 ]", 				0
LEFT 			db "LEFT:    ",					0
RIGHT 			db "RIGHT:   ",					0
ATTACK			db "ATTACK:  ", 				0
P1_L			db "[A]",   					0
P1_R			db "[D]",  						0
P1_A			db "[E]", 						0
P2_L			db "[J]",   					0
P2_R			db "[L]",  						0
P2_A			db "[O]", 						0
PRESS_ENTER		db "PRESS [ENTER] TO START",	0

;COLORS
black         equ 0
blue          equ 1
green         equ 2
cyan          equ 3
red           equ 4
magenta       equ 5
brown         equ 6
light_grey    equ 7
dark_grey     equ 8
light_blue    equ 9
light_green   equ 10
light_cyan    equ 11
light_red     equ 12
light_magenta equ 13
yellow        equ 14
white         equ 15

start:
	call vga
	call square
	call start_screen

	jmp exit

start_screen:
     
	mov bl, red 
	call string_color 

	mov dh, 5
	mov dl, 16
	call string_pos

	mov si, TITLE
	mov bl, white
	call prints

	mov dh, 6
	mov dl, 12
	call string_pos

	mov bl, light_red
	mov si, SUB_TITLE
	call prints

	call menu

	cmp cx, 2
	je controls_screen

	call game_screen

controls_screen:

	call vga

	mov dh, 2
	mov dl, 10
	call string_pos
	mov bl, yellow
	mov si, CONTROLS_TITLE
	call prints	

	mov bl, red

	mov dh, 7
	mov dl, 4
	call string_pos
	mov si, PLAYER_1
	call prints	

	mov dh, 7
	mov dl, 24
	call string_pos
	mov si, PLAYER_2
	call prints	

	mov bl, white

	;P1 CONTROLS

	mov dh, 11
	mov dl, 4
	call string_pos
	mov si, LEFT
	call prints	
	mov si, P1_L
	call prints

	mov dh, 13
	mov dl, 4
	call string_pos
	mov si, RIGHT
	call prints	
	mov si, P1_R
	call prints

	mov dh, 15
	mov dl, 4
	call string_pos
	mov si, ATTACK
	call prints	
	mov si, P1_A
	call prints

	;P2 CONTROLS

	mov dh, 11
	mov dl, 24
	call string_pos
	mov si, LEFT
	call prints	
	mov si, P2_L
	call prints

	mov dh, 13
	mov dl, 24
	call string_pos
	mov si, RIGHT
	call prints	
	mov si, P2_R
	call prints

	mov dh, 15
	mov dl, 24
	call string_pos
	mov si, ATTACK
	call prints	
	mov si, P2_A
	call prints

	;BOTTO TEXT

	mov dh, 22
	mov dl, 9
	call string_pos
	mov si, PRESS_ENTER
	call prints

	call wait_for_confirmation
		
ret

wait_for_confirmation:
		
	call getchar
		
	cmp al, 13
	jne wait_for_confirmation	

	call game_screen

menu:
	
	mov dh, 13
	mov dl, 9
	call string_pos

	mov bl, white
	mov al, '*'
	call putchar

	mov si, START
	call prints

	mov dh, 14
	mov dl, 10
	call string_pos

	mov si, CONTROLS
	call prints

	mov cx, 1
	call print_selection

ret

print_selection:
	
	call getchar

	cmp al, 's'
	je .down

	cmp al, 'w'
	je .up

	cmp al, 13
	jne print_selection

	ret

	.down:
		cmp cx, 2
		je .up

		mov dh, 13
		mov dl, 9
		call string_pos

		mov al, 0
		call putchar

		mov dh, 14
		mov dl, 9
		call string_pos

		mov bl, white
		mov al, '*'
		call putchar

		mov cx, 2
		jmp print_selection

	.up:
		cmp cx, 1
		je .down

		mov dh, 13
		mov dl, 9
		call string_pos

		mov bl, white
		mov al, '*'
		call putchar

		mov dh, 14
		mov dl, 9
		call string_pos

		mov al, 0
		call putchar

		mov cx, 1
		jmp print_selection

ret

vga:
  mov ah, 0
  mov al, 13h
  int 10h
ret

square:
	mov ah, 06h
	xor al, al     
	mov ch, 22
	mov cl, 0
	mov dh, 30
	mov dl, 40
	mov bh, red 
	int 10H
ret

getchar:
  mov ah, 0x00
  int 16h
ret

string_pos:
	mov ah, 02h
	mov bh, 0
	int 10h
ret

string_color:
	mov ah, 0xb  
	mov bh, 0 
	int 10h
ret

print_pixel:
  mov ah, 0ch
  mov bh, 0
  int 10h
ret

putchar:
  mov ah, 0x0e
  int 10h
ret

prints:
  .loop:
    lodsb
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
ret

delay:
	mov bp, 350
	mov dx, 350
	delay2:
		dec bp
		nop
		jnz delay2
	dec dx
	jnz delay2

ret

game_screen:

	mov ax,0x860
	mov es,ax
	xor bx,bx		


	mov ah, 0x02	
	mov al,8		
	mov dl,0		


	mov ch,0
	mov cl,7
	mov dh,0	
	int 13h
	jc game_screen	

break:	
	jmp 0x8600 		

exit:
