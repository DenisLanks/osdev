itoa:
%define num [bp + 4]
%define outstr [bp + 6]
%define tmp [bp - 8]

push bp
mov bp, sp
push word 0
push word '00'
push word '00'
push word 0
pusha

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

inc di

push di
push word outstr
call strcpy

popa
add sp, 8
pop bp
ret 4