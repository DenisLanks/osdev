%include "src/assembly/settings.asm"

[ORG BOOTADD]
mov ax, 0x4F02
mov bx, 0x0115
int 0x10

push word 0x3F8
call initSerial

push word "Y"
push word 0x3F8
call writeSerialB

hang:
    jmp hang

%include "src/assembly/serial.asm"