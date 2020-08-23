%include "src/assembly/settings.asm"

[ORG BOOTADD]
mov ah, 0
mov al, 03
int 0x10

push word 0x3F8
call initSerial


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

push word 32768
push word COM1
call dumpDec


hang:
    mov ax, 1
    int 16h
    jnz hang

    push ax
    push word COM1
    call writeSerialB

    jmp hang

%include "src/assembly/serial.asm"
%include "src/assembly/string.asm"
%include "src/assembly/stdlib.asm"
%include "src/assembly/stdio.asm"
%include "src/assembly/data.asm"


