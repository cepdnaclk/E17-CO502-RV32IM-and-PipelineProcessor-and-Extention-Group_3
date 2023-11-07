addi x1, x0, 6
addi x2, x0, 2
addi x3, x0, 50
loop:
    add x4, x4, x1
    add x4, x4, x2
    bne x4, x3, loop