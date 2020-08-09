strcpy:
    push bp
    mov bp, sp
    mov si, [bp + 6]
    mov di, [bp + 4]
    .cpyloop:
        lodsb
        cmp al, 0
        je .end
        stosb
        jmp .cpyloop
    .end:
    pop bp
    ret 4