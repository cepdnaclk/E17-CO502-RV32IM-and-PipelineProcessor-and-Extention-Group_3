addi x1, x0, 60
addi x2, x2, 26
jal x0, l2
l1:
    addi x1, x0, 4
    addi x2, x0, 5
    addi x3, x0, 7
    addi x4, x0, 9
l2:
    sub x5, x1, x2
    jal x0, l1