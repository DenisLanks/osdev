[ORG 0x7C00]
; mov ah, 02
; mov al, 01
; ;CX := ( ( cylinder and 255 ) shl 8 ) or ( ( cylinder and 768 ) shr 2 ) or sector;
; xor cx, cx
; or cx, 02
; mov dh, 0
; mov bx, 0x500
; mov es, bx
; xor bx, bx

mov ah, 42h
xor bx, bx
mov ds, bx
mov si, DAP
int 13h

cmp ah, 0
je 0x500
hang:
    jmp hang

DAP:
    .size: db 10h
    .reserved: db 0
    .sectors: dw 1
    .segment: dw 0x500
    .offset: dw 0
    .lba: dq 1
times 510 -  ($-$$) db 0
db 0x55
db 0xAA