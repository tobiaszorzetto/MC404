.globl _start

.bss
lista_xy: .skip 0x16
lista_numeros: .skip 0x1c


.data

input1: .asciz "+1042 -2042\n"
input2: .asciz "6823 4756 6047 9913\n"

.text


_write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, lista_xy    # buffer
    li a2, 10           # size
    li a7, 64           # syscall write (64)
    ecall
    
    li a0, 0            # exit code
    li a7, 93           # syscall exit
    ecall

_read:

    li a0, 0 # file descriptor = 0 (stdin)
    la a1, input1 #  buffer
    li a2, 20 # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63 # syscall read (63)
    ecall
    ret
    


_int_to_string:
    #numero guardado em t6
    #chars guardados em a4, a5, a6 e a7
    li t3, 1000
    div a4, t6, t3
    mul t4, t3, a4
    sub t6, t6, t4
    addi a4, a4, 48

    li t3, 100
    div a5, t6, t3
    mul t4, t3, a5
    sub t6, t6, t4
    addi a5, a5, 48

    li t3, 10
    div a6, t6, t3
    mul t4, t3, a6
    sub t6, t6, t4
    addi a6, a6, 48

    mv a7, t6
    addi a7,a7,48 
    
    ret

_string_to_int: 
    #endereco da string em s1
    #guarda o numero em t6
    li t3, 10
    
    lb a4, 0(s2) # a4  = endereco a0 + 0
    li t6, 1000
    addi a4, a4, -48
    mul a4, a4, t6 # multiplica pela unidade respectiva da posicao decimal
    
    lb a5, 1(s2) # a5  = endereco s2 + 1
    li t6, 100
    addi a5, a5, -48
    mul a5, a5, t6 # multiplica pela unidade respectiva da posicao decimal
    
    
    lb a6, 2(s2) # a6  = endereco s2 + 2
    li t6, 10
    addi a6, a6, -48
    mul a6, a6, t6
    
    
    lb a7, 3(s2)
    li t6, 1
    addi a7, a7, -48
    mul a7, a7, t6
    

    li t6, 0 # onde vai ser guardado o nomero
    add t6, t6, a4
    add t6,t6, a5
    add t6, t6, a6
    add t6,t6, a7

    ret

_guardar_X:
    jal _int_to_string

    sb a4, (s4)
    sb a5, 1(s4)
    sb a6, 2(s4)
    sb a7, 3(s4)
    li t3, 10
    sb t3, 4(s4)
    addi s4, s4, 5



    j _write
    
_calcular_raiz_quadrada:
    #numero eh guardado em t6
    beq t0, t4, _guardar_X #loop de t1 e t3 sao parametros de comparacao
    addi t0,t0, 1

    li t5, 2
    div a4, t3, t6 # guarda c =k/numero
    add t6, t6, a4 #guarda k` = k + c
    div t6, t6, t5 #guarda k`` = k`/2
    j _calcular_raiz_quadrada


_calcular_X:
    lw a1, (s3)
    mv a2, s10
    
    mul a1, a1, a1
    mul a2, a2, a2

    sub t6, a1, a2

    li t0, 0
    li t4, 11

    
    li t2, 2
    mv t3, t6
    div t6, t6, t2

    j _calcular_raiz_quadrada

_calcular_Y:
    lw a1, (s3)
    lw a2, 16(s3)
    mv t3, a2
    lw a3, 4(s3)

    mul a1, a1, a1 #todos ao quadrado
    mul a2, a2, a2
    mul a3, a3, a3

    add t6, a1, a2
    sub t6, t6, a3

    div t6, t6, t3
    li t3, 2
    div t6, t6, t3
    mv s10, t6

    jal _int_to_string

    sb a4, (s4)
    sb a5, 1(s4)
    sb a6, 2(s4)
    sb a7, 3(s4)
    li t3, 32
    sb t3, 4(s4)
    addi s4, s4, 5
    
    j _calcular_X
    

_cont2:
    j _calcular_Y


_calcular_distancia_tempo:

    lw t6, (s1)
    sub t6, t5 , t6
    
    li t3, 3
    mul t6, t6, t3 
    li t3, 10
    div t6, t6, t3
    sw t6, (s1)

    addi t0, t0, 1
    addi s1, s1, 4
    beq t0, t4, _cont2
    j _calcular_distancia_tempo

_cont1:

    mv s1, s3
    lw t5, 12(s1)
    li t0, 0
    li t4, 3
    j _calcular_distancia_tempo

_calcular_satelites:

    jal _string_to_int ### ta errado -> precisa apontar pro input1

    
    sw t6, (s1)
    
    
    addi t0, t0,1
    addi s2, s2, 6 #sinais ainda nao mexidos
    addi s1, s1, 4
    beq t0, t4, _cont1
    j _calcular_satelites

_cont0:
#fazer Yb e Xc aqui
    
    la s2, input1
    addi s2, s2, 1
    li t0, 0
    li t4, 2
    j _calcular_satelites
/*
    
*/
_pegar_tempo:
    jal _string_to_int

    li t3, 0
    li t3, 1
    sw t6, (s1)  
    addi s2, s2, 5
    addi t0, t0, 1
    addi s1, s1, 4
    
    bge t0, t1, _cont0
    j _pegar_tempo
    
    

_start:
    la s1, lista_numeros # [0:3] distancias / [4:5] Yb, Xc
    mv s3, s1 # s3 sera o inicio fixo da lista
    la s2, input2
    la s4, lista_xy
    li t0, 0
    li t1, 4
    j _pegar_tempo

_end: 
    
