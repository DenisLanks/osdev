%define source [bp + 6]
%define destination [bp + 4]
strcpy:
    push bp
    mov bp, sp
    pusha
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