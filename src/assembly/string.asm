%define LF 0Ah
%define CR 0Dh
%define source [bp + 6]
%define destination [bp + 4]
strcpy:
    push bp
    mov bp, sp
    pusha
    xor ax, ax
    mov es, ax
    mov si, source
    mov di, destination
    .cpyloop:
        lodsb
        cmp al, 0
        je .end
        stosb
        jmp .cpyloop
    .end:
    popa
    pop bp
    ret 4