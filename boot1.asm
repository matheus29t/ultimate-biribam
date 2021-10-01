org 0x07C00;
jmp 0x0000:start; 

start:
	xor ax, ax
	mov ds, ax

reset:
	mov ah,0		
	mov dl,0		
	int 13h			
	jc reset 

load_Boot2:

	mov ax,0x50		
	mov es,ax
	xor bx,bx	

	mov ah, 0x02	
	mov al,1		
	mov dl,0		

	mov ch,0		
	mov cl,2	
	mov dh,0		
	int 13h
	jc load_Boot2	

break:	
	jmp 0x00500 		

end: 
times 510-($-$$) db 0		
dw 0xaa55					