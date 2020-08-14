%include "src/assembly/settings.asm"
[ORG 0x7C00]
mov ah, 42h
xor bx, bx
mov ds, bx
mov si, DAP
int 13h

cmp ah, 0
je BOOTADD
hang:
    jmp hang

DAP:
    .size: db 10h
    .reserved: db 0
    .sectors: dw 1
    .segment: dw BOOTADD
    .offset: dw 0
    .lba: dq 1
times 510 -  ($-$$) db 0
db 0x55
db 0xAA