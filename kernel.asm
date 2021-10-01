org 0x8600
jmp 0x0000:main

.data:

  TOP_RIGHT     db "...BBBBBB/..BBBBBBBB/..RRRRRRRR/.RBBBBOOBO/R.BOBOOOBO/R.BOOOOOOOO/..BBOOOOOO/....OOOOOO/..OWWOOOW/.OOOWWOWWOO/OOOOWWWWWWOO/RRRWWWWWWWRRRRROOBBBBBBOORRROWWBWBWWWOO",0
  TOP_LEFT      db "....BBBBBB/...BBBBBBBB/...RRRRRRRR/...OBOOBBBBR/...OBOOOBOB.R..OOOOOOOOB.R...OOOOOOBB/...OOOOOO/....WOOOWWO/..OOWWOWWOOO..OOWWWWWWOOOORRRWWWWWWWRRRROOBBBBBBOORROOWWWBWBWWORR",0
  PUNCH_RIGHT   db "...BBBBBB/..BBBBBBBB/..RRRRRRRR/.RBBBBOOBO/R.BOBOOOBO/R.BOOOOOOOO/..BBOOOOOO/....OOOOOO/..OWWOOOW/.OOOWWOWWOORR.OORRWWWWWOOR.ORRRWWWWWO/...BBBBBBB/...WWBWBWWW/",0
  PUNCH_LEFT    db "....BBBBBB/...BBBBBBBB/...RRRRRRRR/...OBOOBBBBR/...OBOOOBOB.R..OOOOOOOOB.R...OOOOOOBB/...OOOOOO/....WOOOWWO/RROOWWOWWOOO/ROOWWWWWRROO/..OWWWWWRRRO/...BBBBBBB/..WWWBWBWW/",0
  LEGS_OPEN     db "..WWWWWWWWW/.WWWW...WWWW/OOOOO...OOOOO",0
  LEGS_CLOSED   db "..WWWWWWWWW/...WWWWWWW/...OOOOOOO/",0

  wins          db " WINS", 0
  over          db "PRESS R", 0

  player_1      db "P1", 0
  player_2      db "P2", 0
  
  P1_X          dw 0        ;posicao x inicial
  P1_Y          dw 145      ;posicao y inicial
  P1_SIDE       db 'R'      ;direita ou esquerda
  P1_PUNCH      db 0        ;murro
  P1_FRAME      db 1        ;pernas
  P1_LIFE       db 100      ;life
  ;f1_shield    db 0        ;escudo

  P2_X          dw 290      ;posicao x inicial
  P2_Y          dw 145      ;posicao y inicial
  P2_SIDE       db 'L'      ;direita ou esquerda
  P2_PUNCH      db 0        ;murro
  P2_FRAME      db 1        ;pernas
  P2_LIFE       db 100      ;life
  ;f2_shield    db 0        ;escudo

  hit           db  0
  cur_player    db  0
  cur_life      db  0

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
  
vga:
  mov ah, 0
  mov al, 13h
  int 10h
ret

putchar:
  mov ah, 0x0e
  int 10h
ret
  
getchar:
  mov ah, 0x00
  int 16h
ret

prints:             ; mov si, string
  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
ret

string_pos:
	mov ah, 02h
	mov bh, 0
	int 10h
ret
 
print_pixel:
  mov ah, 0ch
  mov bh, 0
  int 10h
ret

print_4_pixels:
  call print_pixel
  inc cx
  call print_pixel
  inc dx
  call print_pixel
  dec cx
  call print_pixel
ret

print_fighter:
  push cx
  push dx

  mov ax, 0
  push ax

  .loop1:
    pop ax
    cmp ax, 34
    jge .print_fighter_over
    inc ax
    inc ax
    push ax

    mov bx, 0
    push bx

    cmp ax, 30
    je .legs

    jmp .loop2

    .legs:
      mov si, di
      jmp .loop2

  .loop2:
    pop bx
    cmp bx, 26
    jge .loop1
    inc bx
    inc bx

    pop ax
    pop dx
    pop cx
    push cx
    push dx
    push ax
    push bx

    add cx, bx
    add dx, ax

    lodsb

    cmp byte[cur_player], 1
    je .color_1

    cmp byte[cur_player], 2
    je .color_2

    .color_1:
      cmp al, 'B'
      je .BLACK
      
      cmp al, 'R'
      je .RED

      cmp al, 'O'
      je .BROWN

      cmp al, 'W'
      je .WHITE

      cmp al, 'G'
      je .GREEN

      cmp al, 'Y'
      je .YELLOW

      cmp al, '/'
      je .end_line

      jmp .next

    .color_2:
      cmp al, 'B'
      je .RED
      
      cmp al, 'R'
      je .LIGHT_RED

      cmp al, 'O'
      je .WHITE

      cmp al, 'W'
      je .GREEN

      cmp al, 'G'
      je .GREEN

      cmp al, 'Y'
      je .YELLOW

      cmp al, '/'
      je .end_line

      jmp .next

    .end_line:
      pop bx
      jmp .loop1

    .BLACK:
      mov al, black
      call print_4_pixels
      jmp .next

    .RED:
      mov al, red
      call print_4_pixels
      jmp .next

    .BROWN:
      mov al, brown
      call print_4_pixels
      jmp .next

    .WHITE:
      mov al, white
      call print_4_pixels
      jmp .next

    .GREEN:
      mov al, green
      call print_4_pixels
      jmp .next

    .YELLOW:
      mov al, yellow
      call print_4_pixels
      jmp .next

    .LIGHT_GREY:
      mov al, light_grey
      call print_4_pixels
      jmp .next

    .LIGHT_GREEN:
      mov al, light_green
      call print_4_pixels
      jmp .next

    .LIGHT_RED:
      mov al, light_red
      call print_4_pixels
      jmp .next

    .next:
      jmp .loop2

  .print_fighter_over:
    pop dx
    pop cx
ret

select_f1:
  cmp byte[P1_SIDE], 'R'
  je .select_RIGHT

  cmp byte[P1_SIDE], 'L'
  je .select_LEFT

  .select_RIGHT:
    cmp byte[P1_PUNCH], 1
    je .RIGHT_PUNCH

    .RIGHT_MOVE:
      mov si, TOP_RIGHT
      jmp .select_legs

    .RIGHT_PUNCH:
      mov si, PUNCH_RIGHT
      jmp .legs_OPEN

  .select_LEFT:
    cmp byte[P1_PUNCH], 1
    je .LEFT_PUNCH

    .LEFT_MOVE:
      mov si, TOP_LEFT
      jmp .select_legs

    .LEFT_PUNCH:
      mov si, PUNCH_LEFT
      jmp .legs_OPEN

  .select_legs:
    cmp byte[P1_FRAME], 1
    je .legs_OPEN

    .legs_CLOSED:
      mov di, LEGS_CLOSED
      jmp .select_f1_over
    
    .legs_OPEN:
      mov di, LEGS_OPEN
      jmp .select_f1_over

  .select_f1_over:
    mov byte[cur_player], 1
ret

select_f2:
  cmp byte[P2_SIDE], 'R'
  je .select_RIGHT

  cmp byte[P2_SIDE], 'L'
  je .select_LEFT

  .select_RIGHT:
    cmp byte[P2_PUNCH], 1
    je .RIGHT_PUNCH

    .RIGHT_MOVE:
      mov si, TOP_RIGHT
      jmp .select_legs

    .RIGHT_PUNCH:
      mov si, PUNCH_RIGHT
      jmp .legs_OPEN

  .select_LEFT:
    cmp byte[P2_PUNCH], 1
    je .LEFT_PUNCH

    .LEFT_MOVE:
      mov si, TOP_LEFT
      jmp .select_legs

    .LEFT_PUNCH:
      mov si, PUNCH_LEFT
      jmp .legs_OPEN

  .select_legs:
    cmp byte[P2_FRAME], 1
    je .legs_OPEN

    .legs_CLOSED:
      mov di, LEGS_CLOSED
      jmp .select_f1_over
    
    .legs_OPEN:
      mov di, LEGS_OPEN
      jmp .select_f1_over

  .select_f1_over:
    mov byte[cur_player], 2
ret

floor:
	push cx
	push dx

	mov ax, 0
	push ax

	.loop1:
		pop ax
		cmp ax, 20
		jge .floor_over
		inc ax
		push ax

		mov bx, 0
		push bx
		jmp .loop2

	.loop2:
		pop bx
		cmp bx, 320
		je .loop1
		inc bx
		
		pop ax
		pop dx
		pop cx
		push cx
		push dx
		push ax
		push bx

		add cx, bx
		add dx, ax

    add ax, dx
    sub ax, cx

    cmp ax, 0
    jge .darker

    mov al, light_red
		call print_pixel
    jmp .loop2

    .darker:
      mov al, red
      call print_pixel
      jmp .loop2

	.floor_over:
		pop dx
		pop cx
ret

print_life:
	push cx
	push dx

	mov ax, 0
	push ax

	.loop1:
		pop ax
		cmp ax, 10
		jge .over
		inc ax
		push ax

		mov bx, 0
		push bx
		jmp .loop2

	.loop2:
		pop bx
		cmp bl, byte[cur_life]
		je .loop1
		inc bx
		
		pop ax
		pop dx
		pop cx
		push cx
		push dx
		push ax
		push bx

    add cx, bx
		add dx, ax

    cmp byte[cur_life], 60
    jle .yellow

    mov al, light_green
		call print_pixel
    jmp .loop2

    .yellow:
      cmp byte[cur_life], 30
      jle .red

      mov al, yellow
		  call print_pixel
      jmp .loop2

      .red:
        mov al, red
		    call print_pixel
        jmp .loop2 

	.over:
		pop dx
		pop cx
ret

erase_life:
  mov cx, -1
  mov dx, 8

	push cx
	push dx

	mov ax, 0
	push ax

	.loop1:
		pop ax
		cmp ax, 10
		jge .over
		inc ax
		push ax

		mov bx, 0
		push bx
		jmp .loop2

	.loop2:
		pop bx
		cmp bx, 320
		je .loop1
		inc bx
		
		pop ax
		pop dx
		pop cx
		push cx
		push dx
		push ax
		push bx

    add cx, bx
		add dx, ax

    mov al, light_grey
		call print_pixel
    jmp .loop2

	.over:
		pop dx
		pop cx
ret

erase_character:
	push cx
	push dx

	mov ax, 0
	push ax

	.loop1:
		pop ax
		cmp ax, 35
		jge .erase_character_over
		inc ax
		push ax

		mov bx, 0
		push bx
		jmp .loop2

	.loop2:
		pop bx
		cmp bx, 27
		je .loop1
		inc bx
		
		pop ax
		pop dx
		pop cx
		push cx
		push dx
		push ax
		push bx

		add cx, bx
		add dx, ax

    mov al, dark_grey
		call print_pixel

		jmp .loop2

	.erase_character_over:
		pop dx
		pop cx
ret

erase_both:
  mov cx, word[P1_X]
  mov dx, word[P1_Y]
  call erase_character

  mov cx, word[P2_X]
  mov dx, word[P2_Y]
  call erase_character

ret

print_p1:
  call select_f1
      
  mov cx, word[P1_X]
  mov dx, word[P1_Y]
  mov byte[cur_player], 1
  call print_fighter

  cmp byte[P1_PUNCH], 0
  je .ok
  
  mov byte[P1_PUNCH], 1

  .ok:
    mov byte[P1_PUNCH], 0
ret

print_p2:
  call select_f2
      
  mov cx, word[P2_X]
  mov dx, word[P2_Y]
  mov byte[cur_player], 2
  call print_fighter

  cmp byte[P2_PUNCH], 0
  je .ok
  
  mov byte[P2_PUNCH], 1

  .ok:
    mov byte[P2_PUNCH], 0
ret

hitbox: 
  mov cx, word[P1_X]
  add cx, 26
  mov dx, word[P2_X]
  add dx, 26

  cmp word[P1_X], dx
  jge .not_hit

  cmp cx, word[P2_X]
  jle .not_hit

  .hit:
    mov byte[hit], 1
    ret

  .not_hit:
    mov byte[hit], 0
ret

life_bars:
  call erase_life

  mov cx, -1
  mov dx, 8
  mov al, byte[P1_LIFE]
  mov byte[cur_life], al
  call print_life

  mov cx, 219
  mov dx, 8
  mov al, byte[P2_LIFE]
  mov byte[cur_life], al
  call print_life
ret

background:
  mov ah, 06h
  xor al, al
  xor cx, cx
  mov dx, 184FH
  mov bh, dark_grey
  int 10h
ret

top_bar:

  mov ah, 06h
  xor al, al
  xor cx, cx
  mov dh, 1
  mov dl, 40
  mov bh, black
  int 10h

  mov ah, 06h
  xor al, al
  mov ch, 0
  mov cl, 13
  mov dh, 1
  mov dl, 26
  mov bh, dark_grey
  int 10h

ret

main:
  xor ax, ax
  mov ds, ax
  mov es, ax

  .begin:

  call vga

  call background
  call top_bar

  mov cx, -1
  mov dx, 180
  call floor

  mov dh, 0
  mov dl, 5
  call string_pos
  mov si, player_1
  call prints

  mov dh, 0
	mov dl, 33
	call string_pos

	mov si, player_2
	call prints

  xor cx, cx
  xor dx, dx

  call print_p1
  call print_p2
  call life_bars

  .loop:
    cmp byte[P1_LIFE], 0
    je .end_game_2

    cmp byte[P2_LIFE], 0
    je .end_game_1

    call getchar

    cmp al, 'a'
    je .left_1

    cmp al, 'd'
    je .right_1

    cmp al, 'e'
    je .punch_1

    cmp al, 'j'
    je .left_2

    cmp al, 'l'
    je .right_2

    cmp al, 'o'
    je .punch_2

    jmp .loop

    .left_1:
      mov byte[P1_SIDE], 'L'

      call erase_both

      mov dx, word[P1_X]
      add dx, -5

      cmp dx, 0
      jle .not_ok_l1

      jmp .ok_l1

      .not_ok_l1:
        jmp .refresh_1
      
      .ok_l1:
        add word[P1_X], -5
        jmp .refresh_1

    .right_1:
      mov byte[P1_SIDE], 'R'
      
      call erase_both

      mov dx, word[P1_X]
      add dx, 31

      cmp dx, 320
      jge .not_ok_r1

      jmp .ok_r1

      .not_ok_r1:
        jmp .refresh_1

      .ok_r1:
        add word[P1_X], 5
        jmp .refresh_1

    .punch_1:
      mov byte[P1_PUNCH], 1
      call erase_both

      call hitbox
      cmp byte[hit], 0
      je .refresh_1

      add byte[P2_LIFE], -5
      call life_bars

      jmp .refresh_1

    .refresh_1:
      cmp byte[P1_FRAME], 1
      je .CLOSE_1

      cmp byte[P1_FRAME], 2
      je .OPEN_1

      .CLOSE_1:
        mov byte[P1_FRAME], 2
        jmp .done_1

      .OPEN_1:
        mov byte[P1_FRAME], 1
        jmp .done_1

      .done_1:
        call print_p2
        call print_p1
        jmp .loop

    .left_2:
      mov byte[P2_SIDE], 'L'

      call erase_both

      mov dx, word[P2_X]
      add dx, -5

      cmp dx, 0
      jle .not_ok_l2

      jmp .ok_l2

      .not_ok_l2:
        jmp .refresh_2
      
      .ok_l2:
        add word[P2_X], -5
        jmp .refresh_2

    .right_2:
      mov byte[P2_SIDE], 'R'

      call erase_both

      mov dx, word[P2_X]
      add dx, 31

      cmp dx, 320
      jge .not_ok_r2

      jmp .ok_r2

      .not_ok_r2:
        jmp .refresh_2

      .ok_r2:
        add word[P2_X], 5
        jmp .refresh_2

    .punch_2:
      mov byte[P2_PUNCH], 1
      call erase_both

      call hitbox
      cmp byte[hit], 0
      je .refresh_2

      add byte[P1_LIFE], -5
      call life_bars
      jmp .refresh_2

    .refresh_2:
      cmp byte[P2_FRAME], 1
      je .CLOSE_2

      cmp byte[P2_FRAME], 2
      je .OPEN_2

      .CLOSE_2:
        mov byte[P2_FRAME], 2
        jmp .done_2

      .OPEN_2:
        mov byte[P2_FRAME], 1
        jmp .done_2

      .done_2:
        call print_p1
        call print_p2
        jmp .loop

  .end_game_1:
    mov si, player_1
    jmp .redo

  .end_game_2:
    mov si, player_2
    jmp .redo

  .redo:
    mov dh, 5
	  mov dl, 17
	  call string_pos
    call prints
    mov si, wins
    call prints

    mov dh, 10
	  mov dl, 17
	  call string_pos
    mov si, over
    call prints
    .read:
    call getchar 

    cmp al, 'r'
    je 0x7E00
    jmp .read

jmp $

times 63*512-($-$$) db 0