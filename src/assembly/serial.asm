initSerial:
    push bp
    mov bp, sp
    mov bx, [bp + 4]

    ;Disable all interrupts
    mov dx, bx
    inc dx
    xor ax, ax
    out dx, al

    ;Enable DLAB
    mov dx, bx
    add dx, 3
    mov al, 0x80
    out dx, al

    ;Set divisor to 3
    mov dx, bx
    mov al, 3
    out dx, al

    ;Set bit parity
    mov dx, bx
    add dx, 3
    mov al, 3
    out dx, al

    ;Set FIFO
    mov dx, bx
    add dx, 2
    mov al, 0xC7
    out dx, al

    ;Enable all interrupts, IRQs enabled, RTS/DSR set
    mov dx, bx
    add dx, 4
    mov al, 0x0B
    out dx, al

    pop bp
    ret 2

writeSerialB:
    push bp
    mov bp, sp
    pusha
    mov bx, [bp + 4] ;Serial Port

    mov dx, bx
    mov bx, [bp + 6]; Character to Write
    mov ax, bx
    out dx, al

    popa
    pop bp
    ret 4

writeSerialSB:
    push bp
    mov bp, sp
    pusha
    mov si, [bp + 6]; String Pointer
    .loopchar:
    lodsb
    cmp al, 0
    je .end

    push ax
    push word [bp + 4] ;Serial Port
    call writeSerialB
    jmp .loopchar
    .end:
    popa
    pop bp
    ret 4
