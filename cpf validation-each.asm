
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h 
.DATA
num DB 00d, 05d, 07d, 02d, 03d, 07d, 00d, 02d, 03d,

.CODE
lea ax, num

msg DB "Os digitos verificadores do seu CPF sao: ", 24h


print: lea dx, msg
        mov ah, 09h
        int 21h
      
primeiro_digito:
    mov al, 3
    mov bl, 2
    mov dx, 0
    mul bl 
    add dx, ax
    
    mov al, 2
    inc bl
    mul bl
    add dx, ax
    
    mov al, 0
    inc bl
    mul bl
    add dx, ax
    
    mov al, 7
    inc bl
    mul bl
    add dx, ax
    
    mov al, 3
    inc bl
    mul bl
    add dx, ax
    
    mov al, 2
    inc bl
    mul bl
    add dx, ax
    
    mov al, 7
    inc bl
    mul bl
    add dx, ax
    
    mov al, 5
    inc bl
    mul bl
    add dx, ax
    
    mov al, 0
    inc bl
    mul bl
    add dx, ax
    
modulo:
    mov ax, dx
    mov dx, 0
    mov bx, 11
    div bx

    cmp dx, 2        

    jl menor_que_2
    
maiorIgual_a_2:
    mov bl, 11
    sub bx, dx
          
    mov ax, bx
    add ax, 30h ;converter para decimal
    mov dx, ax
    mov ah, 02h  
    int 21h 
    
    cmp si, 1   
    jl segundo_digito
    jmp 
    
menor_que_2:
    mov al, 0
    
segundo_digito:
    mov si, 1

    mov ax, bx
    mov bl, 2
    mov dx, 0
    mul bl
    add dx, ax

    mov al, 3
    inc bl
    mul bl 
    add dx, ax
    
    mov al, 2
    inc bl
    mul bl
    add dx, ax
    
    mov al, 0
    inc bl
    mul bl
    add dx, ax
    
    mov al, 7
    inc bl
    mul bl
    add dx, ax
    
    mov al, 3
    inc bl
    mul bl
    add dx, ax
    
    mov al, 2
    inc bl
    mul bl
    add dx, ax
    
    mov al, 7
    inc bl
    mul bl
    add dx, ax
    
    mov al, 5
    inc bl
    mul bl
    add dx, ax
    
    mov al, 0
    inc bl
    mul bl
    add dx, ax
    
    jmp modulo

ret




