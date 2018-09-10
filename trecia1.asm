
.MODEL small
.Stack 100h
IntNo = 1h
.Data
  help db "Vytautas Petras Rudys 1k. 3gr. 2 pogr., int 1h apdorojimas, atpazystant inc r/m "
  mInc db "Inc $"
  zingsRez db "Zingsninis interuptas!: $"
  grizau db "grizau is pertraukimo!$"
  dvitaskis db ":$"

  enteris db 13, 10, '$'
  senasCS dw 0
  senasIP dw 0
  regAX dw 0
  regBX dw 0
  regCX dw 0
  regDX dw 0
  regAH db 0
  regBH db 0
  regCH db 0
  regDH db 0
  regAL db 0
  regBL db 0
  regCL db 0
  regDL db 0
  regSI dw 0
  regDI dw 0
  regSP dw 0
  regBP dw 0
  dal dw 0
  dal1 db 0
  dalikl dw 0
  dalikl1 db 0

  baitas1 db 0
  baitas2 db 0
  baitas3 db 0
  baitas4 db 0

  r_AX db "AX$"
  r_CX db "CX$"
  r_DX db "DX$"
  r_BX db "BX$"
  r_SP db "SP$"
  r_BP db "BP$"
  r_SI db "SI$"
  r_DI db "DI$"
  r_AL db "AL$"
  r_CL db "CL$"
  r_DL db "DL$"
  r_BL db "BL$"
  r_AH db "AH$"
  r_CH db "CH$"
  r_DH db "DH$"
  r_BH db "BH$"
  r_BXSI db "[BX+SI]$"
  r_BXDI db "[BX+DI]$"
  r_BPSI db "[BP+SI]$"
  r_BPDI db "[BP+DI]$"
  r_BXSIP db "[BX+SI+$"
  r_BXDIP db "[BX+DI+$"
  r_BPSIP db "[BP+SI+$"
  r_BPDIP db "[BP+DI+$"
  r_SIP db "[SI+$"
  r_DIP db "[DI+$"
  r_BPP db "[BP+$"
  r_BXP db "[BX+$"
  r_wordPtr db "word ptr $"
  r_bytePtr db "byte ptr $"

  kazkas db 0

  AL_lygu db "AL = $"
  CL_lygu db "CL = $"
  BL_lygu db "BL = $"
  DL_lygu db "DL = $"
  AH_lygu db "AH = $"
  CH_lygu db "CH = $"
  BH_lygu db "BH = $"
  DH_lygu db "DH = $"
  SI_lygu db "SI = $"
  DI_lygu db "DI = $"
  BP_lygu db "BP = $"
  SP_lygu db "SP = $"
  AX_lygu db "AX = $"
  BX_lygu db "BX = $"
  CX_lygu db "CX = $"
  DX_lygu db "DX = $"
  ABX_lygu db "[BX] = $"
  ASI_lygu db "[SI] = $"
  ADI_lygu db "[DI] = $"
  ABPSI_lygu db "[BP+SI] = $"
  ABXSI_lygu db "[BX+SI] = $"
  ABPDI_lygu db "[BP+DI] = $"
  ABXDI_lygu db "[BX+DI] = $"



  kiek db 0
  words db 0
  posl db 0
.Code

start:

  mov ax, @data
  mov ds, ax

  mov ah, 09h
  mov dx, offset help
  int 21h
  call spausdinamEnteri

  mov ax, 0
  mov es, ax

  mov ax, es:[4]
  mov bx, es:[6]
  mov senasCS, bx
  mov senasIP, ax

  mov ax, cs
	mov bx, offset IncProc

	mov es:[4], bx
	mov es:[6], ax

  pushf ;PUSH SF
  pop ax
  or ax, 0100h ;0000 0001 0000 0000 (TF=1, kiti lieka kokie buvo)
  push ax
  popf

  inc al
  inc al
  inc bl
  inc ah
  inc bh
  mov kazkas, 0000h
  inc word ptr [bp+si]
  inc byte ptr [si]
  inc word ptr [bx+di]
  inc word ptr kazkas
  inc byte ptr kazkas
  inc word ptr [bx+di+0111h]
  inc byte ptr [bx+di+1111h]
  inc word ptr [bp+si+11h]





  pushf
  pop  ax
  and  ax, 0FEFFh
  push ax
  popf

  mov ax, senasIP
  mov bx, senasCS
  mov es:[4], ax
  mov es:[6], bx

  mov ah, 4Ch
  int 21h

  proc IncProc
    mov regAL, al
    mov regBL, bl
    mov regCL, cl
    mov regDL, dl
    mov regAH, ah
    mov regBH, bh
    mov regCH, ch
    mov regDH, dh
    mov regSP, sp
    mov regBP, bp
    mov regSI, si
    mov regDI, di

    pop si ;pasiemam cs
    pop di ;pasiemam ip
    push di
    push si

    mov ax, cs:[si]
    mov bx, cs:[si+2]

    mov baitas1, al
		mov baitas2, ah
    mov baitas3, bl
    mov baitas4, bh

    cmp al, 0FEh
    jb grizti_is_pertraukimoH
    push ax
    or ah, 11000111b
    cmp ah, 11000111b
    jne grizti_is_pertraukimoH
    pop ax
    jmp endgrizti
    grizti_is_pertraukimoH:
      call grizti_is_pertraukimo
    endgrizti:
    call spausdinamEnteri
    mov ah, 09h
    mov dx, offset zingsRez
    int 21h
    mov dal, 1000h
    mov ax, di      ;spausdinam cs
    call spausdinamW

    mov ah, 2
		mov dl, ":"
		int 21h

    mov ax, si       ;spausdinam ip
    call spausdinamW

    call spausdinamSpace

    mov ah, baitas1
    mov al, baitas2
    call spausdinamw





    mov dx, 0
    mov al, baitas2
    mov ah, 0h
    mov dal, 40h
    div dal
    mov posl, al


    mov dx, 0
    mov ah, 0h
    mov al, baitas1
    mov dal, 2h
    div dal
    mov words, ah



    cmp posl, 3h
    je ciaposl3
    jmp neposl3
    ciaposl3:
    call posl3
    neposl3:

    cmp posl, 01h
    je ciaposl1
    jmp neposl1
    ciaposl1:
    call posl2
    neposl1:

    cmp posl, 2h
    je ciaposl2
    jmp neposl2
    ciaposl2:
    call posl2
    neposl2:

    cmp posl, 00h
    je ciaposl0
    jmp neposl0
    ciaposl0:
    call posl0
    neposl0:

    proc posl3
      call spausdinamSpace
      mov ah, 09h
      mov dx, offset mInc
      int 21h
      cmp words, 1h
      je zodziaiH
      nezodziai:
        cmp baitas2, 0C0h
        je ciaAl
        cmp baitas2, 0C1h
        je ciaCl
        cmp baitas2, 0C2h
        je ciaDl
        cmp baitas2, 0C3h
        je ciaBl
        cmp baitas2, 0C4h
        je ciaAHH
        jmp halfwayy

        ciaAL:
          mov ah, 09h
          mov dx, offset r_AL
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset AL_lygu
          int 21h

          mov al, regAL
          call spausdinamB


          call grizti_is_pertraukimo
        ciaCL:
          mov ah, 09h
          mov dx, offset r_CL
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset CL_lygu
          int 21h

          mov al, regCL
         call spausdinamB
          call grizti_is_pertraukimo
        ciaDL:
          mov ah, 09h
          mov dx, offset r_DL
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset DL_lygu
          int 21h

          mov al, regDL
          call spausdinamB
          call grizti_is_pertraukimo
          zodziaiH:
          jmp zodziai
        ciaBL:
          mov ah, 09h
          mov dx, offset r_BL
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset BL_lygu
          int 21h

          mov al, regBL
          call spausdinamB
          call grizti_is_pertraukimo
          ciaAHH:
          jmp ciaAH
          halfwayy:
          cmp baitas2, 0C5h
          je ciaCH
          cmp baitas2, 0C6h
          je ciaDH
          cmp baitas2, 0C7h
          je ciaBH

        ciaAH:
          mov ah, 09h
          mov dx, offset r_AH
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset AH_lygu
          int 21h

          mov al, regAH
          call spausdinamB
          call grizti_is_pertraukimo

        ciaCH:
          mov ah, 09h
          mov dx, offset r_CH
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset CH_lygu
          int 21h

          mov al, regCH
          call spausdinamB
          call grizti_is_pertraukimo
        ciaDH:
          mov ah, 09h
          mov dx, offset r_DH
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset DH_lygu
          int 21h

          mov al, regDH
          call spausdinamB
          call grizti_is_pertraukimo
        ciaBH:
          mov ah, 09h
          mov dx, offset r_BH
          int 21h

          call spausdinamSpace

          mov ah, 09h
          mov dx, offset BH_lygu
          int 21h

          mov al, regBH
          call spausdinamB
          call grizti_is_pertraukimo

      zodziai:
      cmp baitas2, 0C0h
      je ciaAX
      cmp baitas2, 0C1h
      je ciaCX
      cmp baitas2, 0C2h
      je ciaDX
      cmp baitas2, 0C3h
      je ciaBX
      cmp baitas2, 0C4h
      je ciaSPH
      jmp halfwayy1

      ciaAX:
        mov ah, 09h
        mov dx, offset r_AX
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset AX_lygu
        int 21h

        mov ax, regAX
          call spausdinamW
        call grizti_is_pertraukimo
      ciaCX:
        mov ah, 09h
        mov dx, offset r_CX
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset CX_lygu
        int 21h

        mov ax, regCX
          call spausdinamW
        call grizti_is_pertraukimo
        ciaSPH:
        jmp ciaSP
      ciaDX:
        mov ah, 09h
        mov dx, offset r_DX
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset DX_lygu
        int 21h

        mov ax, regDX
          call spausdinamW
        call grizti_is_pertraukimo
      ciaBX:
        mov ah, 09h
        mov dx, offset r_BX
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BX_lygu
        int 21h

        mov ax, regBX
          call spausdinamW
        call grizti_is_pertraukimo
        halfwayy1:
        cmp baitas2, 0C5h
        je ciaBP
        cmp baitas2, 0C6h
        je ciaSI
        cmp baitas2, 0C7h
        je ciaDI
      ciaSP:
        mov ah, 09h
        mov dx, offset r_SP
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset SP_lygu
        int 21h

        mov ax, regSP
          call spausdinamW
        call grizti_is_pertraukimo
      ciaBP:
        mov ah, 09h
        mov dx, offset r_BP
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BP_lygu
        int 21h

        mov ax, regBP
          call spausdinamW
        call grizti_is_pertraukimo
      ciaSI:
        mov ah, 09h
        mov dx, offset r_SI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset SI_lygu
        int 21h

        mov ax, regSI
          call spausdinamW
        call grizti_is_pertraukimo
      ciaDI:
        mov ah, 09h
        mov dx, offset r_DI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset DI_lygu
        int 21h

        mov ax, regDI
          call spausdinamW
        call grizti_is_pertraukimo


      call grizti_is_pertraukimo
      ret
      endp posl3
    proc posl0

      cmp baitas2, 6h
      je reikiadaug
      jmp nereik
      reikiadaug:

            mov al, baitas3
            call spausdinamB
            mov al, baitas4
            call spausdinamB


            nereik:
            call spausdinamSpace
            mov ah, 09h
            mov dx, offset mInc
            int 21h
            cmp words, 1h
            je zodziai1
            cmp baitas1, 0FFh
            je zodziai1
            nezodziai1:
            mov ah, 09h
            mov dx, offset r_bytePtr
            int 21h
            jmp go
      zodziai1:
        mov ah, 09h
        mov dx, offset r_wordPtr
        int 21h
      go:

      cmp baitas2, 000h
      je ciaBXSI
      cmp baitas2, 001h
      je ciaBXDI
      cmp baitas2, 002h
      je ciaBPSI

      jmp halfwayyy

      ciaBXSI:
        mov ah, 09h
        mov dx, offset r_BXSI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BX_lygu
        int 21h

        mov ax, regBX
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset SI_lygu
        int 21h

        mov ax, regSI
        call spausdinamW




        call grizti_is_pertraukimo
        ciaBXDI:
        mov ah, 09h
        mov dx, offset r_BXDI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BX_lygu
        int 21h

        mov ax, regBX
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset DI_lygu
        int 21h

        mov ax, regDI
        call spausdinamW

        call grizti_is_pertraukimo
      ciaBPSI:
        mov ah, 09h
        mov dx, offset r_BPSI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BP_lygu
        int 21h

        mov ax, regBP
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset SI_lygu
        int 21h

        mov ax, regSI
        call spausdinamW

        call grizti_is_pertraukimo


      ciaBPDI:
        mov ah, 09h
        mov dx, offset r_BPDI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BP_lygu
        int 21h

        mov ax, regBP
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset DI_lygu
        int 21h

        mov ax, regDI
        call spausdinamW

        call grizti_is_pertraukimo
        halfwayyy:
        cmp baitas2, 003h
        je ciaBPDI
        cmp baitas2, 004h
        je ciaSI1
        cmp baitas2, 005h
        je ciaDI1
        cmp baitas2, 006h
        je ciaTA
        cmp baitas2, 007h
        je ciaBX1H

      ciaSI1:
        mov ah, 09h
        mov dx, offset r_SI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset SI_lygu
        int 21h

        mov ax, regSI
        call spausdinamW
        call grizti_is_pertraukimo

      ciaDI1:
        mov ah, 09h
        mov dx, offset r_DI
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset DI_lygu
        int 21h

        mov ax, regDI
        call spausdinamW
        call grizti_is_pertraukimo
        ciaBX1H:
        jmp ciaBX1
      ciaTA:


        mov ah, 02h
        mov dl, "["
        int 21h

        mov ah, 02h
        mov dl, "0"
        int 21h

        mov al, baitas4
        call spausdinamB

        mov al, baitas3
        call spausdinamB

        mov ah, 02h
        mov dl, "h"
        int 21h

        mov ah, 02h
        mov dl, "]"
        int 21h

        call spausdinamSpace

        mov ah, 02h
        mov dl, "["
        int 21h

        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB

        mov ah, 02h
        mov dl, "]"
        int 21h
        mov ah, 02h
        mov dl, "="
        int 21h
        mov ah, offset cs:[baitas4]
        mov al, offset cs:[baitas3]
        call spausdinamw

        call grizti_is_pertraukimo
      ciaBX1:
        mov ah, 09h
        mov dx, offset r_BX
        int 21h

        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BX_lygu
        int 21h

        mov ax, regBX
        call spausdinamW
        call grizti_is_pertraukimo




        call grizti_is_pertraukimo

      ret
    endp posl0

    proc posl2
      cmp posl, 1h
      je baito1
      mov kiek, 2
      mov al, baitas3
      call spausdinamB
      mov al, baitas4
      call spausdinamB
      jmp nereik11
      baito1:
      mov kiek, 1
      mov al, baitas3
      call spausdinamB
      nereik11:
      call spausdinamSpace
      mov ah, 09h
      mov dx, offset mInc
      int 21h
      cmp baitas1, 0FFh
      je zodziai11
      nezodziai11:
        mov ah, 09h
        mov dx, offset r_bytePtr
        int 21h
        jmp go1
      zodziai11:
        mov ah, 09h
        mov dx, offset r_wordPtr
        int 21h
        go1:
      cmp baitas2, 080h
      je ciaBXSIP
      cmp baitas2, 081h
      je ciaBXDIP
      cmp baitas2, 082h
      je ciaBPSIPH
      cmp baitas2, 040h
      je ciaBXSIP
      cmp baitas2, 041h
      je ciaBXDIP
      cmp baitas2, 042h
      je ciaBPSIPH

      jmp halfwayyyy

      ciaBXSIP:
        mov ah, 09h
        mov dx, offset r_BXSIP
        int 21h

        cmp kiek, 1h
        je tik0
        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB
        jmp ok0
        tik0:
        mov al, baitas3
        call spausdinamB
        ok0:
        mov ah, 02h
        mov dl, "h"
        int 21h
        mov ah, 02h
        mov dl, "]"
        int 21h
        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BX_lygu
        int 21h

        mov ax, regBX
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset SI_lygu
        int 21h

        mov ax, regSI
        call spausdinamW





        call grizti_is_pertraukimo
          ciaBPSIPH:
          jmp ciaBPSIP
        ciaBXDIP:
        mov ah, 09h
        mov dx, offset r_BXDIP
        int 21h
        cmp kiek, 1h
        je tik2
        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB
        jmp ok2
        tik2:
        mov al, baitas3
        call spausdinamB
        ok2:
        mov ah, 02h
        mov dl, "h"
        int 21h
        mov ah, 02h
        mov dl, "]"
        int 21h
        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BX_lygu
        int 21h

        mov ax, regBX
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset DI_lygu
        int 21h

        mov ax, regDI
        call spausdinamW

        call grizti_is_pertraukimo
      ciaBPSIP:
        mov ah, 09h
        mov dx, offset r_BPSIP
        int 21h
        cmp kiek, 1h
        je tik3
        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB
        jmp ok3
        tik3:
        mov al, baitas3
        call spausdinamB
        ok3:
        mov ah, 02h
        mov dl, "h"
        int 21h
        mov ah, 02h
        mov dl, "]"
        int 21h
        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BP_lygu
        int 21h

        mov ax, regBP
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset SI_lygu
        int 21h

        mov ax, regSI
        call spausdinamW

        call grizti_is_pertraukimo


      ciaBPDIP:
        mov ah, 09h
        mov dx, offset r_BPDIP
        int 21h
        cmp kiek, 1h
        je tik4
        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB
        jmp ok4
        tik4:
        mov al, baitas3
        call spausdinamB
        ok4:
        mov ah, 02h
        mov dl, "h"
        int 21h
        mov ah, 02h
        mov dl, "]"
        int 21h
        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BP_lygu
        int 21h

        mov ax, regBP
        call spausdinamW

        call spausdinamSpace


        mov ah, 09h
        mov dx, offset DI_lygu
        int 21h

        mov ax, regDI
        call spausdinamW

        call grizti_is_pertraukimo
        halfwayyyy:
        cmp baitas2, 083h
        je ciaBPDIP
        cmp baitas2, 084h
        je ciaSIP
        cmp baitas2, 085h
        je ciaDIP
        cmp baitas2, 043h
        je ciaBPDIP
        cmp baitas2, 044h
        je ciaSIP
        cmp baitas2, 045h
        je ciaDIP
        jmp lastStand

      ciaSIP:
        mov ah, 09h
        mov dx, offset r_SIP
        int 21h
        cmp kiek, 1h
        je tik5
        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB
        jmp ok5
        tik5:
        mov al, baitas3
        call spausdinamB
        ok5:
        mov ah, 02h
        mov dl, "h"
        int 21h
        mov ah, 02h
        mov dl, "]"
        int 21h
        call spausdinamSpace

        mov ah, 09h
        mov dx, offset SI_lygu
        int 21h

        mov ax, regSI
        call spausdinamW
        call grizti_is_pertraukimo

      ciaDIP:
        mov ah, 09h
        mov dx, offset r_DIP
        int 21h
        cmp kiek, 1h
        je tik6
        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB
        jmp ok6
        tik6:
        mov al, baitas3
        call spausdinamB
        ok6:
        mov ah, 02h
        mov dl, "h"
        int 21h
        mov ah, 02h
        mov dl, "]"
        int 21h
        call spausdinamSpace

        mov ah, 09h
        mov dx, offset DI_lygu
        int 21h

        mov ax, regDI
        call spausdinamW
        call grizti_is_pertraukimo
      ciaBPP:
      mov ah, 09h
      mov dx, offset r_BPP
      int 21h
      cmp kiek, 1h
      je tik8
      mov al, baitas4
      call spausdinamB
      mov al, baitas3
      call spausdinamB
      jmp ok8
      tik8:
      mov al, baitas3
      call spausdinamB
      ok8:
      mov ah, 02h
      mov dl, "h"
      int 21h
      mov ah, 02h
      mov dl, "]"
      int 21h
      call spausdinamSpace

      mov ah, 09h
      mov dx, offset BP_lygu
      int 21h

      mov ax, regBP
      call spausdinamW
      call grizti_is_pertraukimo

      lastStand:
      cmp baitas2, 086h
      je ciaBPP
      cmp baitas2, 087h
      je ciaBXP
      cmp baitas2, 046h
      je ciaBPP
      cmp baitas2, 047h
      je ciaBXP



      ciaBXP:
        mov ah, 09h
        mov dx, offset r_BXP
        int 21h
        cmp kiek, 1h
        je tik7
        mov al, baitas4
        call spausdinamB
        mov al, baitas3
        call spausdinamB
        jmp ok7
        tik7:
        mov al, baitas3
        call spausdinamB
        ok7:
        mov ah, 02h
        mov dl, "h"
        int 21h
        mov ah, 02h
        mov dl, "]"
        int 21h
        call spausdinamSpace

        mov ah, 09h
        mov dx, offset BX_lygu
        int 21h

        mov ax, regBX
        call spausdinamW
        call grizti_is_pertraukimo




        call grizti_is_pertraukimo

      ret


      ret
    endp posl2






  proc grizti_is_pertraukimo




    mov  al, regAL
    mov  bl, regBL
    mov  cl, regCL
    mov  dl, regDL
    mov  ah, regAH
    mov  bh, regBH
    mov  ch, regCH
    mov  dh, regDH
    mov  sp, regSP
    mov  bp, regBP
    mov  si, regSI
    mov  di, regDI
    IRET
endp grizti_is_pertraukimo
    proc spausdinamW
      mov dalikl, ax
      mov dal, 1000h
      mov bx, 1h
      looper:
        cmp bx, 5h
        je endLooper

        mov dx, 0h
        mov ax, dalikl
        div dal
        mov dalikl, dx
        cmp ax, 09h
        jbe maziauNegu9
        add ax, 37h
        jmp uzrasem
        maziauNegu9:
        add ax, 30h
        uzrasem:
        mov dx, ax
        mov ah, 2h
        int 21h

        mov dx, 0h
        mov ax, dal
        mov dal, 10h
        div dal
        mov dal, ax

        inc bx
        jmp looper
        endLooper:
      ret
    endp spausdinamW
    proc spausdinamB
      mov bx, 1h
      mov dalikl1, al
      mov dal1, 10h
      loopit:
        cmp bx, 3h
        je endloopit

        mov al, dalikl1
        mov ah, 0h
        div dal1
        mov dalikl1, ah

        cmp al, 09h
        jbe maziauNegu9_1
        add al, 37h
        jmp uzrasem1
        maziauNegu9_1:
        add al, 30h
        uzrasem1:

        mov dl, al
        mov ah, 02h
        int 21h


        mov al, dal1
        mov ah, 0h
        mov dal1, 10h
        div dal1
        mov dal1, al

        inc bx
        jmp loopit
      endloopit:
      ret
    endp spausdinamB
    proc spausdinamSpace
      mov ah, 2
      mov dl, " "
      int 21h
      ret
    endp spausdinamSpace

  proc spausdinamEnteri
    mov ah, 09
    mov dx, offset enteris
    int 21h
    ret
  endp spausdinamEnteri
endp IncProc

end start
