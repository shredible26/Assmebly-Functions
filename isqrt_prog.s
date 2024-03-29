   .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 12
   .word 225
   .word 169
   .word 16
   .word 25
   .word 100
   .word 81
   .word 99
   .word 121
   .word 144
   .word 0 

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", isqrt(*j))
#     j++
#
main:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, xarr          # use s0 for j. init to xarr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # if *j == 0 go to main_end
   move $a0, $s1           # result (in v0) = isqrt(*j)
   jal  isqrt              # 
   move $a0, $v0           # print_int(result)
   li   $v0, 1
   syscall
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   addu $s0, $s0, 4        # j++
   b    main_while
main_end:
   lw   $s0, -8($fp)       # restore s0
   lw   $s1, -12($fp)      # restore s1

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main #################################################
    .data
    .text
    .globl isqrt

# isqrt function
# Arguments:
#   a0 - the number n
# Returns:
#   v0 - integer square root of n
isqrt:
    # Prologue
    addiu $sp, $sp, -40
    sw $ra, 36($sp)
    sw $fp, 32($sp)
    move $fp, $sp
    sw $a0, 40($fp)

    # Check if n < 2
    lw $v0, 40($fp)
    slti $t0, $v0, 2
    bnez $t0, return_n

    # Recursive case: n >= 2
    lw $a0, 40($fp)
    sra $a0, $a0, 2
    jal isqrt
    sll $v0, $v0, 1
    addiu $v1, $v0, 1

    # Check if (small+1)^2 > n
    mul $t1, $v1, $v1
    lw $t2, 40($fp)
    mflo $t1
    slt $t0, $t2, $t1
    beqz $t0, return_large

    # Return small
    move $v0, $v0
    j end_function

return_n:
    lw $v0, 40($fp)
    j end_function

return_large:
    move $v0, $v1

end_function:
    # Epilogue
    move $sp, $fp
    lw $ra, 36($sp)
    lw $fp, 32($sp)
    addiu $sp, $sp, 40
    jr $ra
