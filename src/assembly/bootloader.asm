%include "src/assembly/settings.asm"

[ORG BOOTADD]
mov ah, 0
mov al, 03
int 0x10
call setup

push word 0
push word 32
push word 0Eh
push word title
call printsAt

push word 4
push word 21
push word 0Fh
push word headerPart
call printsAt

push word 5
push word 21
push word 0Fh
push word headerLine
call printsAt

push word 24
push word 21
push word 0Fh
push word msgInfo
call printsAt

mov ah, 02
mov bh, 0
mov dh, 24
mov dl, 22
int 10h

hang:
    mov ax, 1
    int 16h
    jnz hang

    push ax
    push word COM1
    call writeSerialB

    jmp hang

setup:
    push word 0x3F8
    call initSerial

    call printDisk

    ret

printDisk:
    push bp
    mov bp, sp
    push word 6 ;current line
    push word 1 ;option

    xor ax, ax
    mov al, NUMHD
    mov bx, 6
    xor cx, cx

    .diskloop:
        cmp al, cl
        je .end

        mov dx, 0x80
        add dx, cx
        
        mov di, bp
        sub di, 2
        push word di
        sub  di,2
        push word di
        push dx
        call printDiskData

        inc cx
        jmp .diskloop
    
    .end:
    add sp, 4
    pop bp
    ret

printDiskData:
    %define line [bp + 8]
    %define option [bp + 6]
    push bp
    mov bp, sp
    sub sp, 512 ;reserve sector space
    pusha
    
    ;load first sector
    mov ah, 02
    mov al, 01
    mov cx, 1
    mov dh, 0
    mov dl, [bp + 4]
    xor bx, bx
    mov es, bx
    mov di, bp
    sub di, 512
    mov bx, di
    int 13h
    ;offset to first partition entry
    add di, 446
    mov bx, di

    ; push word es
    ; push word COM1
    ; call dumpHex

    ; push word [bx]
    ; push word COM1
    ; call dumpHex

    mov cx, 4 ;loop counter
    .partLoop:
        cmp cx, 0
        je .end

        add di, 4
        mov al, [di]
        cmp al, 0
        je .nextrec
        
        ; push word cx
        ; push word COM1
        ; call dumpDec

        mov si, word line        
        push word [si]
        mov si, word option        
        push word [si]
        push word bx
        call printPart
        
        

        mov si, word line
        add [si], word 1
        mov si, word option
        add [si], word 1
        .nextrec:
            dec cx
            add bx, 16
            mov di, bx
            jmp .partLoop

    .end:
    popa
    add sp, 512
    pop bp
    ret 6
; partentry ptr, option, line
printPart:
    %define option [bp + 6]
    push bp
    mov bp, sp
    pusha
    mov si, [bp + 4]
    add si, 4

    push word [bp + 8]
    push word 21
    push word 0Fh
    push word option
    call printDecAt

    ; xor ax, ax
    ; mov al, [si]
    ; push word ax
    ; push word COM1
    ; call dumpHex

    xor ax, ax
    mov al, [si]
    push word [bp + 8]
    push word 47
    push word 0Fh
    push ax
    call printDecAt
    
    .end:
        popa
        pop bp
        ret 6

printDecAt:
    %define num [bp + 4]
    %define color [bp + 6]
    %define col [bp + 8]
    %define row [bp + 10]
    push bp
    mov bp, sp
    push word 0
    push word 0
    push word 0
    pusha
    push es

    ; push word col
    ; push word COM1
    ; call dumpDec

    mov di, bp
    sub di, 6
    push di
    push word num
    call itoa

    ; mov di, sp
    ; push word di
    ; push word COM1
    ; call writeSerialSB

    mov di, bp
    sub di, 6
    push word row
    push word col
    push word color
    push di
    call printsAt

    pop es
    popa
    add sp, 6
    pop bp
    ret 8
%include "src/assembly/serial.asm"
%include "src/assembly/string.asm"
%include "src/assembly/stdlib.asm"
%include "src/assembly/stdio.asm"
%include "src/assembly/data.asm"


