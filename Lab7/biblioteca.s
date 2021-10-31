




.text:

puts:
    addi sp, sp, -4
    sw ra, 0(sp)
    mv t6, a0
    li t1, 0

    loop:
        lb t2, (t6) 
        addi t1, t1, 1
        addi t6, t6, 1
        beq t2, zero, cont_puts
        j loop
cont_puts:
    addi t6, t6, -1
    sb '/n', (t6)
    #_write:
    li a0, 1            # file descriptor = 1 (stdout)
    lb a1, (a0)    # buffer
    mv a2, t1           # size
    li a7, 64           # syscall write (64)
    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    ret



gets:
    mv t1, a0

    li a0, 0 # file descriptor = 0 (stdin)
    lb a1, (t1) #  buffer
    li a2, 256 # size 
    li a7, 63 # syscall read (63)
    ecall

    ret



atoi:
#PRECISA FAZER AINDA
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

time:
    addi sp, sp, -16
    mv a1, sp
    addi sp, sp, -16
    mv a0, sp

    li a7, 169 # chamada de sistema gettimeofday
    ecall

    lw a0, 8(a0)
    lw a1, (a1)

    addi sp, sp, 32
    ret

sleep:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    mv t2, a0

    jal time
    mv t0, a0

    loop_sleep:
    jal time
    sub t1, a0, t1
    blt t1, t2, loop_sleep

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


approx_sqrt:
    addi sp, sp, -4
    sw ra, 0(sp)

    mv t6, a0#numero eh guardado em t6
    li t0, 0

    li t2, 2
    mv t3, t6
    div t6, t6, t2
    
    loop_sqrt:
        li t5, 2
        div a4, t3, t6 # guarda c =k/numero
        add t6, t6, a4 #guarda k` = k + c
        div t6, t6, t5 #guarda k`` = k`/2

        addi t0,t0, 1
        blt t0, a1, loop_sqrt
    
    mv a0, t6
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

imageFilter:

exit:
    li a7, 93           # syscall exit
    ecall  
