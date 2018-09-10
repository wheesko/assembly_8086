.Model small
ORG 100h
.Data
	desk1 dw ?
	desk2 dw ?
	desk3 dw ?
	pirmoBaitai dw ?
	antroBaitai dw ?
	skaiciai1 db 255 dup (?)
	skaiciai2 db 255 dup (?)
	rezultatas db 255 dup (?)
	fileName1 db 255 dup (00h)
	fileName2 db 255 dup (00h)
	fileName3 db 255 dup (00h)
	kiekKartu dw ?
	help db "iveskite duomenu failu pavadinimus, tada rezultatu failo pavadinima", '$'
	paskutinis dw ?
	liekana db ?
.Code
start:
	mov ax, @data
	mov ds, ax
	
	mov ch, 0
	mov cl, es:[0080h] 
	cmp cx, 0
	je neraParametru 
	mov bx, 0081h

ieskomHelp:
	cmp word ptr [es:bx], '?/'
	je yraHelp
	inc bx
	loop ieskomHelp
jmp neradomArbaNera
	

neraParametru:
	mov bx, 30h 
	call klaida

	
yraHelp:
	mov bx, 31h 
	call klaida
suklydo:
	call klaida
proc klaida
	mov ah, 09h
	mov dx, offset help
	int 21h
	mov ax, 4C00h
	int 21h
	ret
endp klaida

neradomArbaNera:
	mov si, 0
	mov cx, 0
	mov bx, 0082h
	mov cl, es:[0080h]
IrasomFailoPav:
	mov dl, [es:bx]
	cmp dl, 20h 
	je go
	mov byte ptr [fileName1+si], dl
	inc bx
	inc si
loop IrasomFailoPav
go:
inc bx
mov dl, [es:bx]
cmp dl, 20h
je go
mov si, 0
jmp yup
IrasomFailoPav1:
	mov dl, [es:bx]
	yup:
	cmp dl, 20h 
	je go1
	mov byte ptr [fileName2+si], dl
	inc bx
	inc si
loop IrasomFailoPav1
go1:
inc bx
mov dl, [es:bx]
cmp dl, 20h
je go1
mov si, 0
jmp yup1
IrasomFailoPav2:
	mov dl, [es:bx]
	yup1:
	cmp dl, 0Dh
	je baigemIrasit
	cmp dl, 20h
	je baigemIrasit
	mov byte ptr [fileName3+si], dl
	inc bx
	inc si
loop IrasomFailoPav2




jmp BaigemIrasit
	klaidaSkaitant:
	mov ah, 09h
	mov dx, offset help
	int 21h
	mov ax, 4c00h
	int 21h

	BaigemIrasit:
	mov liekana, 00h
	mov ah, 3Dh ;atidarom 1 duomenu faila
	mov al, 0h
	mov dx, offset fileName1
	int 21h
	jc klaidaSkaitant
	mov desk1, ax
	
	mov ah, 3Dh	;atidarom 2 duomenu faila
	mov al, 0h
	mov dx, offset fileName2
	int 21h
	jc klaidaSkaitant
	mov desk2, ax
	
	mov ah, 3ch ;sukuriam rezultatu faila
	mov cx, 0h
	mov dx, offset fileName3
	int 21h
	jc klaidaSkaitant
	mov desk3, ax

	mov ah, 42h
	mov bx, desk1
	mov dx, 0h
	mov al, 2h
	int 21h
	mov pirmoBaitai, ax
	mov ah, 42h
	mov bx, desk2
	mov dx, 0h
	mov al, 2h
	int 21h
	mov antroBaitai, ax
	jmp skaitom

	skaitom:
		cmp pirmoBaitai, 255
		jle baigesiPirmas
		cmp antroBaitai, 255
		jle baigesiAntrasH
		sub pirmoBaitai, 255
		sub antroBaitai, 255
		mov ah, 42h
		mov bx, desk1
		mov dx, pirmoBaitai
		mov al, 0h
		int 21h
		mov ah, 42h
		mov bx, desk2
		mov dx, antroBaitai
		mov al, 0h
		int 21h
		mov ah, 3fh
		mov bx, desk1
		mov cx, 255
		mov dx, offset skaiciai1
		mov ah, 3fh
		mov bx, desk1
		mov cx, 255
		mov dx, offset skaiciai2
		mov cx, 255
		sumuojam:
			mov bx,cx
			mov ah, skaiciai1[bx-1]
			mov dh, skaiciai2[bx-1]
			call sum
			push bx
		loop sumuojam
        inc kiekKartu
		jmp skaitom
		jmp halfway
		baigesiAntrasH:
		jmp baigesiAntras
		halfway:
		baigesiPirmas:
			cmp antroBaitai, 255
			jle baigesiAbuH
			sub antrobaitai, 255
			
			mov ah, 42h
			mov bx, desk2
			mov dx, antroBaitai
			mov al, 0h
			int 21h
			
			mov ah, 42h
			mov bx, desk1
			mov dx, 0h
			mov al, 0h
			int 21h
			
			mov ah, 3Fh
			mov bx, desk2
			mov cx, 255
			mov dx, offset skaiciai2
			int 21h
			
			mov ah, 3Fh
			mov bx, desk1
			mov cx, pirmoBaitai
			mov dx, offset skaiciai1
			int 21h
			
			mov cx, 255
			sumuojam2:
					cmp pirmoBaitai, 0
					je nuliai
					mov bx, pirmoBaitai
					mov dh, skaiciai1[bx-1]
					mov bx, 0
					dec pirmoBaitai
					jmp nenuliai
					nuliai:
					mov dh, 30h
					nenuliai:
					mov bx, cx
					mov ah, skaiciai2[bx-1]
					call sum
					push bx
			loop sumuojam2
			inc kiekKartu
			jmp baigesiPirmas
			
			jmp halfway1
			baigesiAbuH:
			jmp baigesiAbu
			halfway1:
			
		
		baigesiAntras:
			cmp pirmoBaitai, 255
			jle baigesiAbu
			sub pirmoBaitai, 255
			
			mov ah, 42h
			mov bx, desk1
			mov dx, pirmoBaitai
			mov al, 0h
			int 21h
			
			mov ah, 42h
			mov bx, desk2
			mov dx, 0h
			mov al, 0h
			int 21h
			
			mov ah, 3Fh
			mov bx, desk1
			mov cx, 255
			mov dx, offset skaiciai1
			int 21h
			
			mov ah, 3Fh
			mov bx, desk2
			mov cx, antroBaitai
			mov dx, offset skaiciai2
			int 21h
			
			mov cx, 255
			sumuojam3:
					cmp antroBaitai, 0
					je nuliai1
					mov bx, antroBaitai
					mov dh, skaiciai2[bx-1]
					mov bx, 0
					dec antroBaitai
					jmp nenuliai1
					nuliai1:
					mov dh, 30h
					nenuliai1:
					mov bx, cx
					mov ah, skaiciai1[bx-1]
					call sum
					push bx
			loop sumuojam3
			inc kiekKartu
			jmp baigesiAntras
			
		
		baigesiAbu:
			
			mov ah, 42h
			mov bx, desk1
			mov dx, 0h
			mov al, 0h
			int 21h
		
			mov ah, 42h
			mov bx, desk2
			mov dx, 0h
			mov al, 0h
			int 21h
		
			mov ah, 3fh
			mov bx, desk1
			mov cx, pirmoBaitai
			mov dx, offset skaiciai1
			int 21h
		
			mov ah, 3fh
			mov bx, desk2
			mov cx, antroBaitai
			mov dx, offset skaiciai2
			int 21h
		
			mov ax, pirmoBaitai
			mov bx, antroBaitai
			cmp ax, bx
			jg pirmamDaugiau
			jl antramDaugiau
			mov cx, pirmoBaitai
			mov paskutinis, cx
			sumuojam7:
				mov bx, cx
				mov ah, skaiciai1[bx-1]
				mov dh, skaiciai2[bx-1]
				call sum
				push bx
			loop sumuojam7
	
			jmp baigemSkaityt
			pirmamDaugiau:
				mov cx, pirmoBaitai
				mov paskutinis, cx
				sumuojam8:
					cmp antroBaitai, 0
					je nuliai2
					mov bx, antroBaitai
					mov dh, skaiciai2[bx-1]
					mov bx, 0
					dec antroBaitai
					jmp nenuliai2
					nuliai2:
					mov dh, 30h
					nenuliai2:
					mov bx, cx
					mov ah, skaiciai1[bx-1]
					call sum
					
					push bx
				loop sumuojam8
				jmp baigemSkaityt
			antramDaugiau:
				mov cx, antroBaitai
				mov paskutinis, cx
				sumuojam9:
					cmp pirmoBaitai, 0
					je nuliai3
					mov bx, pirmoBaitai
					mov dh, skaiciai1[bx-1]
					mov bx, 0
					dec pirmoBaitai
					jmp nenuliai3
					nuliai3:
					mov dh, 30h
					nenuliai3:
					mov bx, cx
					mov ah, skaiciai2[bx-1]
					call sum
					
					push bx
				loop sumuojam9
				jmp baigemSkaityt
	proc sum
		sub ah, 30h
		sub dh, 30h
		mov bh, 0h
		add bh, liekana
		add bh, dh
		add bh, ah
		cmp bh, 2h
		mov liekana, 0h
		je Abu1Liekana0
		cmp bh, 3h
		je Abu1Liekana1
		jmp PriskiriamReiksme
		Abu1Liekana0:
			mov bh, 0h
			mov liekana, 1h
			jmp PriskiriamReiksme
		Abu1Liekana1:
			mov bh, 1h
			mov liekana, 1h
			jmp PriskiriamReiksme
		PriskiriamReiksme:
		add bh, 30h
		mov bl, bh
		mov bh, 0
		ret
	endp sum
	baigemSkaityt:
	mov bh, liekana
	cmp bh, 0
	je rasomp
	push 0031h
	inc paskutinis
	rasomp:
	mov cx, paskutinis
	mov bx, 0
	
	rasom:
		pop dx
		mov rezultatas[bx], dl
		inc bx
	loop rasom
	mov ah, 40h
	mov bx, desk3
	mov cx, paskutinis
	mov dx, offset rezultatas
	int 21h
	
	mov si, kiekKartu
	rasom2:
	cmp si, 0
	je baigem
		mov cx, 255
		mov bx, 0
		rasom3:
			pop dx
			mov rezultatas[bx], dl
			inc bx
		loop rasom3
			mov ah, 40h
			mov bx, desk3
			mov cx, 255
			mov dx, offset rezultatas
			int 21h
		dec si
		jmp rasom2
	baigem:
	mov ah, 3Eh
	mov bx, desk1
	int 21h
    jc klaidaUzdarant

	mov ah, 3Eh
	mov bx, desk2
	int 21h
	jc klaidaUzdarant

	mov ah, 3Eh
	mov bx, desk3
	int 21h
	jc klaidaUzdarant
	
	jmp pabaiga
	klaidaUzdarant:
	mov ah, 09h
	mov dx, offset help
	int 21h
	mov ax, 4c00h
	int 21h
	
	pabaiga:
	
	mov ax, 4c00h
	int 21h
end start