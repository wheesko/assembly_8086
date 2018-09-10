.MODEL small ;sitoje programoje siandien mes padarysme 1aja uzduoti assemblerio kalba so LETS GO
.STACK 100h
.DATA
	msg db "Vesk simbolius: ", '$'
	x db 99,0,99 dup (?)
	dal db ?
	enteris db 0Dh, 0Ah, '$'
.CODE
start:

mov ax, @data
mov ds, ax

mov dx, offset msg
mov ah, 09h
int 21h

mov ah, 0Ah
mov dx, offset x
int 21h

mov ah, 09h
mov dx, offset enteris
int 21h

mov bx, 0
mov si, 0

skaidom:

	mov al, x[si+2]
	mov dal, 10h
	mov bx, 1
	cmp si, word ptr x[bx]
	je endSkaidom
	
	looper:
	
		cmp bx, 3
		je endLooper
		mov al, x[si+2]
		mov ah, 0h
		div dal
		cmp al, 09h
		jbe maziauNegu9
		add al, 37h
		jmp uzrasem
		maziauNegu9:
		add al, 30h
		uzrasem:
		mov dl, al
		mov x[si+2], ah
		mov ah, 02h
		int 21h
		
		mov ah, 0h
		mov al, dal
		mov dal, 10h
		div dal
		mov dal, al
		inc bx
		jmp looper
		
	endLooper:
	
	mov dl, 20h
	mov ah, 02h
	int 21h
	inc si
	jmp skaidom
	
endSkaidom:


mov ax, 4C00h
int 21h
end start