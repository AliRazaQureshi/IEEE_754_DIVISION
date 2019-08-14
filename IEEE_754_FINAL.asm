.data
    Divident: .float -96.0   
    Divisor: .float -32.0
    msg1: .asciiz"***** Division of Real Number Represented via IEEE 754 Format *****"
    msg2: .asciiz"0"
    msg3: .asciiz"InFinity"
    space: .asciiz" "
    X: .asciiz"x"
    power: .asciiz"^"
    result: .asciiz"\nThe Result: "
    undefine: .asciiz"UnDefined!!!!!"
    expo: .asciiz"2"
    next_line: .asciiz"\n"
    Group: .asciiz"\nGroup Members: Ali Raza Qureshi(CS-17116) & Umer(CS-17115)"
    line_1: .asciiz"\n==========================================="
    line_2: .asciiz"\n======================================"
    point: .asciiz"."
    plus: .asciiz"+"
    subtract: .asciiz"-"
    Overflow: .asciiz"Overflow"
    Underflow: .asciiz"Underflow"
.text
.globl main
.ent main
main:
    addi $sp, $sp, -48      #adjusting stack pointer

    #storing register values in stack
    sw $ra, 0($sp) 
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)
    sw $t3, 16($sp)
    sw $t4, 20($sp)
    sw $s0, 24($sp)
    sw $s1, 28($sp)
    sw $s2, 32($sp)
    sw $s3, 36($sp)
    sw $s4, 40($sp)
    sw $s5, 44($sp)

    #print msg1
    li $v0, 4
    la $a0, msg1
    syscall

    #print line_1
    li $v0, 4
    la $a0, line_1
    syscall

    #print next_line
    li $v0, 4
    la $a0, next_line
    syscall

    #print result
    li $v0, 4
    la $a0, result
    syscall

    l.s $f0, Divident        #load Divident value from memory in $f0 reg

    l.s $f1, Divisor       #load Divisor value from memory in $f1 reg

    mfc1 $t0, $f0       #move value from $f0 to $t0

    mfc1 $t1, $f1       #move value from $f1 to $t1

    #Extracting sign bit from reg $t0 and $t1
    srl $s0, $t0, 31
    srl $s1, $t1, 31

    li $t2, 0x7fffff        #load value 0x7fffff to $t2

    #Extracting mantissa from $t0 and $t1
    and $s2, $t0, $t2
    and $s3, $t1, $t2

    #right shifting $t0 and $t1
    srl $s4, $t0, 23
    srl $s5, $t1, 23

    li $t4, 0xff        #load value 0xff to $t4
    
    #Extracting exponent from $s4 and $s5 8-bit value
    and $s4, $s4, $t4
    and $s5, $s5, $t4

    beq $s0, $s1, PLUS      #if $s0 = $s1 jump to PLUS

    #print msg subtract
    li $v0, 4
    la $a0, subtract
    syscall

    j MOVEE     #jump to MOVEE

PLUS:
    #print msg PLUS
    li $v0, 4
    la $a0, plus
    syscall

MOVEE:
    #move value $s2, $s3, $s4, $s5 to $a0, $a1, $a2, $a3
    move $a0, $s2   
    move $a1, $s3
    move $a2, $s4
    move $a3, $s5

    jal ZERO        #jump and link to function ZERO

    #print next_line
    li $v0, 4
    la $a0, next_line
    syscall

    #print Group
    li $v0, 4
    la $a0, Group
    syscall

    #print line_2
    li $v0, 4
    la $a0, line_2
    syscall

    #loading values from stack into registers
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    lw $t3, 16($sp)
    lw $t4, 20($sp)
    lw $s0, 24($sp)
    lw $s1, 28($sp)
    lw $s2, 32($sp)
    lw $s3, 36($sp)
    lw $s4, 40($sp)
    lw $s5, 44($sp)

    addi $sp, $sp, 48       #adjusting stack pointer

    jr $ra
.end main

.globl ZERO
.ent ZERO
ZERO:
    addi $sp, $sp, -4       #adjusting stack pointer

    sw $ra, 0($sp)      #storing register values in stack

    beq $a2, $0, CHECK      #if $a2 = $0 jump to CHECK

inf:jal INFINITY        #jump and link to function INFINITY

    lw $ra, 0($sp)      #loading values from stack into registers

    addi $sp, $sp, 4        #adjusting stack pointer

    jr $ra
    
CHECK:
    beq $a0, $0, Zero       #if $a0 = $0 jump to Zero

    j inf       #jump to inf

Zero:
    bne $a3, $0, Print_zero     #if $a3 != $0 jump to Prnt_Zero

    bne $a1, $0, Print_zero     #if $a1 != $0 jump to Prnt_Zero

    #print undefine
    li $v0, 4
    la $a0, undefine
    syscall

    j RETURN        #jump to RETURN

Print_zero:
    #print msg2
    li $v0, 4
    la $a0, msg2
    syscall

RETURN:
    lw $ra, 0($sp)      #loading values from stack into registers

    addi $sp, $sp, 4        #adjusting stack pointer

    jr $ra
.end ZERO


.globl INFINITY
.ent INFINITY
INFINITY:
    addi $sp, $sp, -4       #adjusting stack pointer

    sw $ra, 0($sp)      #storing register values in stack

    beq $a3, $0, CHECK_1        #if $a3 = $0 jump to CHECK_1

divis:jal DIVISION      #jump and link to function DIVISION

    lw $ra, 0($sp)      #loading values from stack into registers

    addi $sp, $sp, 4        #adjusting stack pointer

    jr $ra

CHECK_1:
    beq $a1, $0, infinity       #if $a1 = $0 jump to infinity

    j divis     #jump to divis

infinity:
    #print msg3
    li $v0, 4
    la $a0, msg3
    syscall

    jr $ra
.end INFINITY

.globl DIVISION
.ent DIVISION
DIVISION:
    addi $sp, $sp, -72      #adjusting stack pointer

    #storing register values in stack
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)
    sw $t3, 16($sp)
    sw $t4, 20($sp)
    sw $t5, 24($sp)
    sw $t6, 28($sp)
    sw $s0, 32($sp)
    sw $s1, 36($sp)
    sw $s2, 40($sp)
    sw $s3, 44($sp)
    sw $s4, 48($sp)
    sw $s5, 52($sp)
    sw $s6, 56($sp)
    sw $t7, 60($sp)
    sw $t8, 64($sp)
    sw $s7, 68($sp)

    #move values from $a0, $a1, $a2, $a3 to $s0, $s1, $s2, $s3
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3

    li $t1, 0x800000        #load value 0x800000 to $t1

    #making 23bit value to 24bit value
    or $s0, $s0, $t1 #24bit
    or $s1, $s1, $t1 #24bit

    addi $s5, $0, 1

ADJUST_1:
    addi $t0, $0, 10

    slt $t2, $s0, $s1       #if numerator < denominator set $t2 to 1

    beq $t2, $0, PERFORM        #if $t2 = $0 jump to PERFORM

    mult $s0, $t0       #multiply $s0 and $t0

    mflo $s0        #move lower value to $s0

    addi $s2, $s2, -1       #decrementing exponent

    j ADJUST_1      #jump to ADJUST_1

PERFORM:
    sub $s4, $s2, $s3       #dividing exponents

    addi $t0, $s4, 127      #adding biased value

    move $a0, $t0

    jal UNDER_OVER

    bne $v0, $0, END_DIV 

    div $s0, $s1        #divide $s0 by $s1

    mflo $t3        #move quotient to $t3

    move $a0, $t3

    jal BINARY

    mfhi $t4        #move remainder to $t4

    #initializing
    addi $t2, $0, 10
    addi $s6, $0, 0
    addi $s7, $0, 0
    addi $t8, $0, 0

RECHECK:
    slti $t6, $s6, 2        #loop incrementor

    beq $t6, $0, EXPONENT       #if $t6 = $0 jump to EXPONENT

    slt $t5, $t4, $s1       #if numerator < denominator set $t5 to 1

    beq $t4, $0, REM        #if $t4 = $0 jump to REM

    bne $t5, $0, REM_CHECK      #if $t5 = $0 jump to REM_CHECK

REM:
    div $t4, $s1        #divide $t4 by $s1

    mflo $t3        #move quotient to $t3

    mfhi $t4        #move remainder to $t4
    
    beq $t8, $0, REMAINDER      #if $t8 = $0 jump to REMAINDER

    add $s7, $s7, $t3 

    addi $s6, $s6, 1        #incermenting loop variable 

    j RECHECK       #jump to RECHECK

REMAINDER:    
    add $s7, $0, $t3

    mult $s7, $t2       #multiply $s7 by $t2

    mflo $s7        #move lower to $s7

    addi $t8, $t8, 1        #incermenting $t8 by 1

    j REM       #jump to REM

REM_CHECK:
    mult $t4, $t2       #multiply $t4 by $t2

    mflo $t4        #move lower value to $t4

    slt $t5, $t4, $s1       #if numerator < denominator set $t5 to 1

    beq $t5, $0, JUMP       #if $t5 = $0 jump to JUMP

    #print integer
    li $v0, 1
    move $a0, $0
    syscall

JUMP:j RECHECK      #jump to RECHECK

PRINT:
    #print integer
    li $v0, 1
    move $a0, $t4
    syscall

    addi $t8, $t8, 1

EXPONENT:
    move $a0, $s7       #move $s7 to $a0

    jal REM_BINARY      #jump and link to function REM_BINARY
    
    #print space
    li $v0, 4
    la $a0, space
    syscall

    #print X
    li $v0, 4
    la $a0, X
    syscall

    #print space
    li $v0, 4
    la $a0, space
    syscall

    #print expo
    li $v0, 4
    la $a0, expo
    syscall

    #print power
    li $v0, 4
    la $a0, power
    syscall

    #print integer
    li $v0, 1
    move $a0, $s4
    syscall

END_DIV:
    #loading values from stack into registers
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    lw $t3, 16($sp)
    lw $t4, 20($sp)
    lw $t5, 24($sp)
    lw $t6, 28($sp)
    lw $s0, 32($sp)
    lw $s1, 36($sp)
    lw $s2, 40($sp)
    lw $s3, 44($sp)
    lw $s4, 48($sp)
    lw $s5, 52($sp)
    lw $s6, 56($sp)
    lw $t7, 60($sp)
    lw $t8, 64($sp)
    lw $s7, 68($sp)

    addi $sp, $sp, 72       #adjusting stack pointer

    jr $ra
.end DIVISION

###################     NORMALIZATION    ############################
.globl BINARY
.ent BINARY
BINARY:
    addi $sp, $sp, -44      #adjusting stack pointer

    #storing register values in stack
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)
    sw $t3, 16($sp)
    sw $t4, 20($sp)
    sw $s1, 24($sp)
    sw $s2, 28($sp)
    sw $s3, 32($sp)
    sw $s4, 36($sp)
    sw $s5, 40($sp)

    li $t1, 0x80000000      #loading 32 bit value in $t1

    move $s1, $a0

    addi $s2, $0, 0

    addi $s3, $0, 0

    addi $t3, $0, 1
FIND:
    and $t2, $s1, $t1       #checking each bit

    bne $t2, $0, BITS       #if $t2 != $0 jump to BITS

    srl $t1, $t1, 1         #shift right by 1

    addi $s2, $s2, 1

    j FIND      #jump to FIND

BITS:
    #print integer
    li $v0, 1
    move $a0, $t3
    syscall

    #print space
    li $v0, 4
    la $a0, space
    syscall

    #print point
    li $v0, 4
    la $a0, point
    syscall

    addi $s3, $s3, 32
    
    sub $s4, $s3, $s2

    addi $s4, $s4, -1

    addi $s5, $0, 1

#loop is generated inorder to find each bit and print in binary Format
LOOP_1:
    slt $t4, $s5, $s4

    beq $t4, $0, QUIT

    srl $t1, $t1, 1

    and $t2, $s1, $t1

    beq $t2, $0, ZERO_1 

    li $v0, 1
    move $a0, $t3
    syscall

    j INCREMENT

ZERO_1:
    #print Zero
    li $v0, 1
    move $a0, $0
    syscall 

INCREMENT:
    addi $s5, $s5, 1

    j LOOP_1

QUIT:
    #loading values from stack into registers
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    lw $t3, 16($sp)
    lw $t4, 20($sp)
    lw $s1, 24($sp)
    lw $s2, 28($sp)
    lw $s3, 32($sp)
    lw $s4, 36($sp)
    lw $s5, 40($sp)

    addi $sp, $sp, 44       #adjusting stack pointer

    jr $ra
.end BINARY

.globl REM_BINARY
.ent REM_BINARY
REM_BINARY:
    addi $sp, $sp, -40      #adjusting stack pointer

    #storing register values in stack
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)
    sw $t3, 16($sp)
    sw $t4, 20($sp)
    sw $s0, 24($sp)
    sw $s1, 28($sp)
    sw $t5, 32($sp)
    sw $t6, 36($sp)

    move $s0, $a0

    addi $t0, $0, 100

    addi $t5, $0, 100

    addi $s1, $0, 1

    addi $t2, $0, 2

    addi $t3, $0, 0

    addi $t4, $0, 0

AGAIN_1:
    slti $t4, $t3, 7

    beq $t4, $0, QUIT_1

    mult $s0, $t2

    mflo $s0

    slt $t1, $s0, $t0

    beq $t1, $0, ONE_1

    li $v0, 1
    move $a0, $0
    syscall

    j MULTI 

ONE_1:
    li $v0, 1
    move $a0, $s1
    syscall

MULTI:
    slt $t6, $s0, $t5

    beq $t6, $0, SUBT

    addi $t3, $t3, 1

    j AGAIN_1 

SUBT:
    addi $s0, $s0, -100

    addi $t3, $t3, 1

    j AGAIN_1

QUIT_1:
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    lw $t3, 16($sp)
    lw $t4, 20($sp)
    lw $s0, 24($sp)
    lw $s1, 28($sp)
    lw $t5, 32($sp)
    lw $t6, 36($sp)

    addi $sp, $sp, 40

    jr $ra
.end REM_BINARY

.globl UNDER_OVER
.ent UNDER_OVER
UNDER_OVER:
    addi $sp, $sp, -16

    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $s0, 12($sp)

    addi $s0, $0, 0

    slti $t0, $a0, 255        

    bne $t0, $0, check

    li $v0, 4
    la $a0, Overflow
    syscall

    addi $s0, $0, 1

    j exit
check:
    slti $t1, $a0, 0

    beq $t1, $0, exit 

    li $v0, 4
    la $a0, Underflow
    syscall

    addi $s0, $0, 1
exit:
    move $v0, $s0

    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $s0, 12($sp)

    addi $sp, $sp, 16

    jr $ra
.end UNDER_OVER













    