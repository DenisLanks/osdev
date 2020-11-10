;Serial port parameter
%define sport [bp + 4]
%define char [bp + 6]
%define strptr [bp + 6]
%define num [bp + 6]
%define tmp [bp - 8]

initSerial:
    push bp
    mov bp, sp
    mov bx, sport

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
    mov bx, sport ;Serial Port

    mov dx, bx
    mov bx, char; Character to Write
    mov ax, bx
    out dx, al

    popa
    pop bp
    ret 4

writeSerialSB:
    push bp
    mov bp, sp
    pusha
    mov si, strptr; String Pointer
    .loopchar:
    lodsb
    cmp al, 0
    je .end

    push ax
    push word sport ;Serial Port
    call writeSerialB
    jmp .loopchar
    .end:
    popa
    pop bp
    ret 4

dumpHex:
    push bp
    mov bp, sp
    pusha
    
    mov ax, num
    mov cx, 4
    mov si, hexstr

    .hexloop:
    rol ax, 4
    mov bx, ax
    and bx, 0x0F
    mov bl, [si + bx]
    
    push bx
    push word sport ;Serial Port
    call writeSerialB

    dec cx
    jnz .hexloop

    popa
    pop bp
    ret 4

dumpDec:
    push bp
    mov bp, sp
    push word 0
    push word '00'
    push word '00'
    push word 0
    pusha

    mov es, [bp - 2]
    mov di, bp
    sub di, 2
    std
    mov ax, num
    .decloop:
        cwd
        mov bx, 10
        div bx

        mov tmp, ax
        add dx, 48
        mov ax, dx
        stosb

        mov ax, tmp
        cmp ax, 10
        jge .decloop
        
        add ax, 48
        stosb
        cld
    
    ; mov di, bp
    inc di

    push di
    push word sport
    call writeSerialSB

    popa
    add sp, 8
    pop bp
    ret 4