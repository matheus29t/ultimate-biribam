org 0x500; 
jmp 0x000: start

str1 db 'LOADING STRUCTURES',0
str2 db '>   PROTECTED MODE', 0
str3 db '>   LOADING KERNEL', 0
str4 db '>   RUNNING KERNEL', 0
dot db '.', 0
finalDot db '.', 10, 13 , 0

printString:   
	
	lodsb
	cmp al, 0
	je exit

	mov ah, 0xe
	int 10h	

	mov dx, 100
	call delay 
	
	jmp printString
exit:
ret

delay: 
	mov bp, dx
	back:
	dec bp
	nop
	jnz back
	dec dx
	cmp dx,0    
	jnz back
ret

printDots:
	mov cx, 2

	for:
		mov si, dot
		call printString
		mov dx, 600
		call delay
	dec cx
	cmp cx, 0
	jne for

	mov dx, 1200
	call delay
	mov si, finalDot
	call printString
	
ret


limpaTela:
	mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    mov cx, 2000 
    mov bh, 0
    mov al, 0x20
    mov ah, 0x9
    int 0x10
   
    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
ret

vga:
  mov ah, 0
  mov al, 13h
  int 10h
ret

string_pos:
	mov ah, 02h
	mov bh, 0
	int 10h
ret

start:
	mov bl, 4
	call vga

	mov dh, 6
	mov dl, 10
	call string_pos
	
	mov si, str1
	call printString
	call printDots

	mov dh, 8
	mov dl, 10
	call string_pos

	mov si, str2
	call printString
	call printDots

	mov dh, 10
	mov dl, 10
	call string_pos

	mov si, str3
	call printString
	call printDots

	mov dh, 12
	mov dl, 10
	call string_pos

	mov si, str4
	call printString
	call printDots

	mov dh, 14
	mov dl, 19
	call string_pos

	call printDots

	mov dx, 255
	call delay 

	xor ax, ax
	mov ds, ax

reset:
	mov ah,0		
	mov dl,0		
	int 13h			
	jc reset

load_menu:
	mov ax,0x7E0
	mov es,ax
	xor bx,bx

	mov ah, 0x02
	mov al,4		
	mov dl,0		

	mov ch,0		
	mov cl,3		
	mov dh,0		
	int 13h
	jc load_menu	

break:	
	jmp 0x7E00	

times 510-($-$$) db 0		
dw 0xaa55					
