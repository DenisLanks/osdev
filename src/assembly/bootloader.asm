%include "src/assembly/settings.asm"

[ORG BOOTADD]
mov ax, 0x4F02
mov bx, 0x0115
int 0x10

push word 0x3F8
call initSerial

push word msg
push word tgt
call strcpy

push word tgt
push word 0x3F8
call writeSerialSB

hang:
    jmp hang

%include "src/assembly/serial.asm"
%include "src/assembly/string.asm"
msg: db "Hello from Bootloader",0
tgt: db "000000000000000000000",0