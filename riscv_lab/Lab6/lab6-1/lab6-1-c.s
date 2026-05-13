# lab6-1-c.s

#---------------------- data segment ---------------------#

    .data   # Data declarations go in this section
msg1:       .asciz "Exception with cause "
msg2:       .asciz " due to "
msg3:       .asciz " occured at address "

ermsg1:     .asciz "Load access fault"        # (ucause code: 5)
ermsg2:     .asciz "Load address misaligned"  # (ucause code: 4)
ermsg3:     .asciz "Illegal instruction"      # (ucause code: 2)


#---------------------- text segment ---------------------#
    .text
    .globl main
main:
    csrsi  ustatus, 1        # Set interrupt enable (instr: csrrsi x0, ustatus, 1)
    la     t0, exception_handler  # t0 <-- trap handler address
    csrw   t0, utvec         # Set utvec with trap handler address (instr: csrrw x0, utvec, t0)

    li     x9, 0x100       
    lw     x5, 0(x9)         # Exception due to Load access fault (ucause code: 5)
    
    li     a7, 10            # Done, terminate program (exit 0)
    ecall                    # au revoir...

exception_handler:

    la a0, msg1
    li a7, 4
    ecall
    
    csrr t1, ucause
    add a0, x0, t1
    li a7, 1
    ecall
    
    la a0, msg2
    li a7, 4
    ecall
    
    li t2, 5
    li t3, 4
    li t4, 2
    
    csrr t1, ucause
    beq t1, t2, ucause5
    beq t1, t3, ucause4
    beq t1, t4, ucause2
    
ucause5:
    la a0, ermsg1
    li a7, 4
    ecall
    j next
ucause4:
    la a0, ermsg2
    li a7, 4
    ecall
    j next
ucause2:
    la a0, ermsg3
    li a7, 4
    ecall
    j next
next:
    la a0, msg3
    li a7, 4
    ecall
    
    csrr t5, uepc
   
    add a0, x0, t5
    li a7, 1
    ecall
    
    addi t5, t5, 4
    csrw t5, uepc
    uret

#----------------------- End of File ---------------------#
