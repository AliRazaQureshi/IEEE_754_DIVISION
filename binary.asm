.data
    value:  .word 2147483648
.text
.globl main
.ent main
main:
    la $t0, value

    lw $t1, 0($t0)

    addi $s1, $0, 49

    addi $s2, $0, 0

    addi $t3, $0, 1
FIND:
    and $t2, $s1, $t1

    bne $t2, $0, BITS

    srl $t1, $t1, 1

    addi $s2, $s2, 1

    j FIND

BITS:
    addi $s3, $s3, 32
    
    sub $s4, $s3, $s2

    add $s7, $0, $s4

    addi $s4, $s4, -1

    sllv $t4, $t3, $s4

BIN:
    slt $s5, $s6, $s7

    beq $s5, $0, QUIT

    and $t5, $s1, $t4

    bne $t5, $0, ONE

    li $v0, 1
    move $a0, $0
    syscall

    j INCREMENT

ONE:
    li $v0, 1
    move $a0, $t3
    syscall

INCREMENT:
    srl $t4, $t4, 1

    addi $s6, $s6, 1

    j  BIN


QUIT:
    jr $ra
.end main