
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.DATA
num DB 01d, 01d, 01d, 04d, 04d, 04d, 07d, 07d, 07d, ;entrada
msg DB "Os digitos verificadores do seu CPF sao: ", 24h

; Movendo segmento de dado para onde esta o numero
.CODE
TextoSaida:
    lea dx, msg
    mov ah, 09h
    int 21h
     
lea ax, num
   
mov si, ax     ;Manipulando a entrada 

mov cl, 9h     ;Inicializa o contador de iteracao da entrada

mov bl, 10     ;Inicializa o contador de que e usado na multiplicacao dos elementos 
mov dh, 1

;Loop de operacoes com a entrada
Processamento:    
mov al, [si]   ;Carrega um caractere da entrada, no segmento al, conforme o valor de si
mul bl         ;Multiplica o valor de bl com o valor da entrada presente em al
               
add bh, al     ;Soma e acumula o resultado da multiplicacao de cada numero da entrada

inc si         ;Incrementa o contador usado para manipular a entrada
dec bl         ;Decrementa o contador usado como peso na multiplicacao dos numeros da entrada
loop Processamento ;Repete o loop ate acabar o contador cx

modulo:
    mov al, bh ;Obtem o valor acumulado
    mov cl, dh ;Muda de segmento o contador que indica qual dv esta sendo calculado
    mov dx, 0  ;Zera o Segmento onde ira ficar o resto da divisao
    mov bx, 11
    div bx     ;Divide o valor acumulado por 11

    cmp dl, 2  ;Verificar se o resto da divisao e igual a 2      

    jl Menor_que_2 ;Se o resto da divisao for menor que 2, pula para a respectiva rotina
    
MaiorIgual_a_2:
    mov bl, 11 ;Executa a operacao de obtencao do dv,
    sub bx, dx ;caso o resto da divisao seja maior ou igual a 2
          
    mov ax, bx
    add ax, 30h;converter para decimal
    mov dx, ax
    
    mov ah, 02h 
    int 21h    ;Imprimir o dv
    
    cmp cl, 1  ;1 caso esteja no primeir dv e 0 caso esteja no segundo, baseado do valor do contador que foi movido de lugar 
    jge Segundo_dv
    jl Fim
   
Menor_que_2:
    mov al, 0  ;O dv e 0 caso o resto da divisao seja menor que 2
    add ax, 30h;converter para decimal
    mov dx, ax
    
    mov ah, 02h 
    int 21h    ;Imprimir o dv
    
      
    cmp cl, 1  ;Mesma logica do label MaiorIgual_a_2 
    jge Segundo_dv
    jl Fim

Segundo_dv:
    mov al, 2  ;Multiplica e acumula ja com o primeiro dv 
    mul bl
    add bh, al
    
    ;Reinicializa os contadores e retorna para o loop de processamento       
    lea ax, num ;Recarrega a entrada no segmento
    mov si, ax
    mov cl, 9h 
    mov bl, 11  ;11 dessa vez, por conta do primeiro dv descoberto
    
    jmp Processamento

Fim:

ret




