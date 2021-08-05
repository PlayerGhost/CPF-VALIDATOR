
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.DATA
file DB "cpf.txt", 0 ;entrada
msg1 DB "Os digitos verificadores do seu CPF sao validos", 24h
msg2 DB "Os digitos verificadores do seu CPF sao invalidos", 24h

.CODE
    
;Manipulando o arquivo     
lea dx, file
mov al, 0
mov ah, 3dh
int 21h
jc Fim 
mov bx, ax
mov cx, 11
mov ah, 3fh
int 21h
cmp ax, 0
jz  Inicio
mov ah, 3eh
int 21h
    
Inicio:  
mov si, dx     ;Manipulando a entrada
mov dx, 0

mov cl, 9h     ;Inicializa o contador de iteracao da entrada

mov bl, 10     ;Inicializa o contador de que e usado na multiplicacao dos elementos 
mov bh, 1


;Loop de operacoes com a entrada
Processamento: 
mov al, [si]   ;Carrega um caractere da entrada, no segmento al, conforme o valor de si
sub al, 30h    ;Converter de ascii para unsigned, para que a multiplicacao nao precise usar 16 bit
mul bl         ;Multiplica o valor de bl com o valor da entrada presente em al
               
add dx, ax     ;Soma e acumula o resultado da multiplicacao de cada numero da entrada

inc si         ;Incrementa o contador usado para manipular a entrada
dec bl         ;Decrementa o contador usado como peso na multiplicacao dos numeros da entrada
loop Processamento ;Repete o loop ate acabar o contador cx

modulo: 
    mov cl, bh ;Muda de segmento o contador que indica qual dv esta sendo calculado, e se o primeiro dv e valido  
    mov ax, dx ;Obtem o valor acumulado
    
    mov dx, 0  ;Zera o Segmento onde ira ficar o resto da divisao
    mov bx, 11
    div bx     ;Divide o valor acumulado por 11

    cmp dl, 2  ;Verificar se o resto da divisao e igual a 2      

    jl Menor_que_2 ;Se o resto da divisao for menor que 2, pula para a respectiva rotina
    
MaiorIgual_a_2:
    mov bl, 11 ;Executa a operacao de obtencao do dv,
    sub bx, dx ;caso o resto da divisao seja maior ou igual a 2
    
    cmp cl, 1  ;1 caso esteja no primeiro dv e 0 caso esteja no segundo, baseado do valor do contador que foi movido de lugar 
    je  Compare1 
    jmp Compare2
   
Menor_que_2:
    mov bl, 0  ;O dv e 0 caso o resto da divisao seja menor que 2

    cmp cl, 1  ;Mesma logica do label MaiorIgual_a_2 
    je  Compare1
    jmp Compare2

Segundo_dv:
    mov ax, 2  ;Multiplica e acumula ja com o primeiro dv 
    mul bl    
    mov dx, 0
    add dx, ax
    
    ;Reinicializa os contadores e retorna para o loop de processamento   
    sub si, 9
    mov cl, 9h 
    mov bl, 11 ;11 dessa vez, por conta do primeiro dv descoberto
    
    jmp Processamento
    
Compare1:  
    add bl, 30h;Converter para ascii
    cmp bl, [si]
    je  Primeiro_DvValido
    sub bl, 30h;Converter para unsigned novamente
    jmp Segundo_dv
    

Primeiro_DvValido:
    mov bh, 2  ;Agora tambem ira informar que o dv esta correto, para uma futura checagem
    sub bl, 30h;Converter para unsigned novamente
    jmp Segundo_dv   

Compare2:
    cmp cl, 2  ;Verifica se o dv anterior e valido
    je  Compare2_1;Caso seja valido, compara o segundo
    jmp DvInvalido;Caso seja invalido, ja informa ao usuario
    
Compare2_1:
    inc si
    add bl, 30h;Converter para ascii
    cmp bl, [si];Verifica se o segundo dv e valido
    je  DvValido;Informa ao usuario que e valido
    jmp DvInvalido;Informa ao usuario que e invalido
                 
DvValido:
    lea dx, msg1
    mov ah, 09h
    int 21h
    jmp Fim
    
DvInvalido:
    lea dx, msg2
    mov ah, 09h
    int 21h  
                 
Fim:

ret




