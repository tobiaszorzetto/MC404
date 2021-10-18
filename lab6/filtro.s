
.globl _start

.bss
input_adress: .skip 0x4000F  # buffer
pixel: .skip 0x20

.data

input_file: .asciz "imagem.pgm"

.text

_setPixel:
    
    mv a0, t1 #coordenada x do pixel
    mv a1, t2 # coordenada y do pixel
    
    
    beq zero, t1, _pintar_de_preto
    beq zero, t2, _pintar_de_preto
    li s9, 1
    sub s9, s10, s9
    beq s9, t1, _pintar_de_preto

    li s9, 1
    sub s9, s11, s9
    beq s9, t2, _pintar_de_preto

    
_fazer_matriz:
    li t3, 0

    mv t4, s2
    li t5, 1
    sub s8, t4, t5
    lbu t5, (s8)
    sub t3, t3 , t5

    lbu t5, (t4)
    li s9, 8
    mul t5, t5, s9
    add t3, t3, t5

    lbu t5, 1(t4)
    sub t3, t3, t5

    sub t4, s2, s10
    li t5, 1
    sub s8, t4, t5
    lbu t5, (s8)
    sub t3, t3, t5 

    lbu t5, (t4)
    sub t3, t3, t5

    lbu t5, 1(t4)
    sub t3, t3, t5

    add t4, s2, s10
    li t5, 1
    sub s8, t4, t5
    lbu t5, (s8)
    sub t3, t3 , t5

    lbu t5, (t4)
    sub t3, t3, t5

    lbu t5, 1(t4)
    sub t3, t3, t5

    
    blt t3, zero, _pintar_de_preto
    li s9, 255
    bgt t3, s9, _pintar_de_branco


_ajustar_a2:
    li t4, 16
    li a2, 0
    div t4, t3, t4
    li s9, 268435456
    mul s9, s9, t4
    add a2, a2, s9
    li s9, 1048576
    mul s9, s9, t4
    add a2, a2, s9
    li s9, 4096
    mul s9, s9, t4
    add a2, a2, s9
    li s9, 16
    mul s9, s9, t4
    sub t4, t3, s9

    li s9, 256
    mul s9, s9, t4
    add a2, a2, s9
    li s9, 65536
    mul s9, s9, t4
    add a2, a2, s9
    li s9, 16777216
    mul s9, s9, t4
    add a2, a2, s9

    addi a2, a2, 255 
    
    li a7, 2200
    ecall
    ret

_pintar_de_branco:
    li a2, 0xFFFFFFFF
    li a7, 2200
    ecall
    j _cont_pintar
_pintar_de_preto:
    li a2, 0x000000FF
    li a7, 2200
    ecall
    j _cont_pintar

_string_to_int_2: 

    lb a5, 1(s2) 
    li t6, 10
    addi a5, a5, -48
    mul a5, a5, t6
    
    lb a6, 2(s2)
    li t6, 1
    addi a6, a6, -48
    mul a6, a6, t6
    
    li t6, 0 # onde vai ser guardado o nomero
    add t6,t6, a5
    add t6, t6, a6
    
    ret 

_string_to_int: 
    
    lb a5, 0(s2) # a5  = endereco s2 + 1
    li t6, 100
    addi a5, a5, -48
    mul a5, a5, t6 # multiplica pela unidade respectiva da posicao decimal
    
    lb a6, 1(s2) # a6  = endereco s2 + 2
    li t6, 10
    addi a6, a6, -48
    mul a6, a6, t6
    
    lb a7, 2(s2)
    li t6, 1
    addi a7, a7, -48
    mul a7, a7, t6
    
    li t6, 0 # onde vai ser guardado o nomero
    add t6,t6, a5
    add t6, t6, a6
    add t6,t6, a7
    ret 

_start:
_open:
    la a0, input_file    # endereço do caminho para o arquivo
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # modo
    li a7, 1024          # syscall open 
    ecall
_read:
    la a1, input_adress #  buffer
    li a2, 262159 # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63 # syscall read (63)
    ecall
_guardar_dados:
    la s2, input_adress
    
    addi s2, s2, 3
    lbu s4, 2(s2)
    li s5, 10
    beq s4, s5, _jump_n
    li s5, 32
    beq s4, s5, _jump_n
    jal _string_to_int
    addi s2, s2, 4
    j _cont
_jump_n:
    jal _string_to_int_2
    addi s2, s2, 3
_cont:
    mv s10, t6 # largura
    lb s4, 2(s2)
    li s5, 10
    beq s4, s5, _jump_n_2
    li s5, 32
    beq s4, s5, _jump_n_2
    jal _string_to_int
    addi s2, s2, 8
    j _cont_2
_jump_n_2:
    jal _string_to_int_2
    addi s2, s2, 7
_cont_2:
    mv s11, t6 #altura

_setCanvasSize:
    mv a0, s10
    mv a1, s11
    li a7, 2201
    ecall

_pintar:
    li t2, 0
_loop_t2:
    li t1, 0
    #addi s2, s2, 1
_loop_t1:
    li s4, 10
    bne s4, s3, _cont_loop 
    addi s2, s2, 1
_cont_loop:
    jal _setPixel
_cont_pintar:
    addi s2, s2, 1
    addi t1,t1,1
    bgt s10,t1, _loop_t1 # if t1 < s10 then _loop_t1
    addi t2, t2, 1
    bgt s11,t2, _loop_t2 # if t0 < t2 then _loop_t2
_end:
    li a0, 0            # exit code
    li a7, 93           # syscall exit
    ecall  
