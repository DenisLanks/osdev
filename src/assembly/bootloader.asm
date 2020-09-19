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
    push bp
    mov bp, sp
    sub sp, 512
    pusha
    
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

    add di, 510
    push word [di]
    push word COM1
    call dumpHex

    mov cx, 4
    .partLoop:
        cmp cx, 0
        je .end

        mov di, word [bp + 8]        
        push word [di]
        mov di, word [bp + 6]        
        push word [di]
        push word 0
        call printPart
        
        
        ; push word cx
        ; push word COM1
        ; call dumpDec

        mov di, word [bp + 8]
        add [di], word 1
        mov di, word [bp + 6]
        add [di], word 1
        dec cx
        jmp .partLoop

    .end:
    popa
    add sp, 512
    pop bp
    ret 6
; partentry ptr, option, line
printPart:
    push bp
    mov bp, sp
    
    push word [bp + 8]
    push word 21
    push word 0Fh
    push word headerLine
    call printsAt
    
    .end:
        pop bp
        ret 6

%include "src/assembly/serial.asm"
%include "src/assembly/string.asm"
%include "src/assembly/stdlib.asm"
%include "src/assembly/stdio.asm"
%include "src/assembly/data.asm"


