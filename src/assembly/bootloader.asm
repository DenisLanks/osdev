[ORG 0x500]
mov ax, 0x4F02
mov bx, 0x0115
int 0x10

push word 0x3F8
call initSerial

mov dx, 0x3F8
xor ax, ax
mov al, "Y"
out dx, al

hang:
    jmp hang

%include "src/assembly/serial.asm"