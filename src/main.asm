org 0x7C00
bits 16

main:
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

write:
    mov si, startmsg
    xor bh, bh

.loop:
    lodsb
    or al, al
    jz .exit

    mov ah, 0Eh
    int 10h

    jmp .loop

.exit:
    xor ah, ah
    int 16h

type_routine:
    mov ax, 13h
    int 10h

    xor bl, bl

    mov al, BYTE [color]

    xor cx, cx
    xor cx, cx

    jmp .draw_color_icon

.loop:
    xor ah, ah
    int 16h

    cmp al, 'd'
    je .toggle_drawing
    
    cmp al, 'c'
    je .inc_color

    cmp al, 'v'
    je .dec_color

    cmp al, 'h'
    je .move_left

    cmp al, 'l'
    je .move_right

    cmp al, 'j'
    je .move_down

    cmp al, 'k'
    je .move_up
    jmp .loop

.inc_color:
    inc BYTE [color]
    jmp .draw_color_icon

.dec_color:
    dec BYTE [color]
    jmp .draw_color_icon

.draw_color_icon:
    push cx
    push dx

    mov cx, 316
    mov dx, 197

    mov ah, 0Ch
    mov al, BYTE [color]

.loop_x:
    cmp cx, 319
    je .step_y

    int 10h
    inc cx
    jmp .loop_x

.step_y:
    cmp dx, 199
    je .exit_icon

    sub cx, 3
    inc dx

    jmp .loop_x

.exit_icon:
    pop dx
    pop cx
    jmp .loop

.move_left:
    dec cx
    jmp .draw

.move_right:
    inc cx
    jmp .draw

.move_up:
    dec dx
    jmp .draw

.move_down:
    inc dx
    jmp .draw

.toggle_drawing:
    cmp BYTE [is_enabled], 0
    je .disable
.enable:
    mov BYTE [is_enabled], 0
    jmp .loop
.disable:
    mov BYTE [is_enabled], 1
    jmp .loop

.draw:
    cmp BYTE [is_enabled], 1
    je .loop

    mov ah, 0Ch
    mov al, BYTE [color]
    int 10h
    jmp .loop

is_enabled: db 0
color: db 1
startmsg: db "C, V - Change Color, HJKL to move, D lift pen; Press any key to enter", 0

times 510-($-$$) db 0
dw 0AA55h
