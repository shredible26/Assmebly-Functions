.data

# array terminated by 0 (which is not part of the array)
xarr:
.word 1, 3, 5, 7, 9, 0
.data

arrow: .asciiz " -> "

.text

main:
    li      $sp,        0x7ffffffc      # initialize $sp

# PROLOGUE
    subu    $sp,        $sp,        8   # expand stack by 8 bytes
    sw      $ra,        8($sp)          # push $ra (ret addr, 4 bytes)
    sw      $fp,        4($sp)          # push $fp (4 bytes)
    addu    $fp,        $sp,        8   # set $fp to saved $ra

    subu    $sp,        $sp,        12  # save s0 and s1 on stack before using them
    sw      $s0,        12($sp)         # push $s0
    sw      $s1,        8($sp)          # push $s1
    sw      $s2,        4($sp)          # push $s2

    la      $s0,        xarr            # load address to s0

main_for:
    lw      $s1,        ($s0)           # use s1 for xarr[i] value
    li      $s2,        0               # use s2 for initial depth (steps)
    beqz    $s1,        main_end        # if xarr[i] == 0, stop.

# save args on stack rightmost one first
    subu    $sp,        $sp,        8   # save args on stack
    sw      $s2,        8($sp)          # save depth
    sw      $s1,        4($sp)          # save xarr[i]

    li      $v0,        1
    move    $a0,        $s1             # print_int(xarr[i])
    syscall 

    li      $v0,        4               # print " -> "
    la      $a0,        arrow
    syscall 

    jal     collatz                     # result = collatz(xarr[i])

    move    $a0,        $v0             # print_int(result)
    li      $v0,        1
    syscall 

    li      $a0,        10              # print_char('\n')
    li      $v0,        11
    syscall 

    addu    $s0,        $s0,        4   # make s0 point to the next element

    lw      $s2,        8($sp)          # save depth
    lw      $s1,        4($sp)          # save xarr[i]
    addu    $sp,        $sp,        8   # save args on stack
    j       main_for

main_end:
    lw      $s0,        12($sp)         # push $s0
    lw      $s1,        8($sp)          # push $s1
    lw      $s2,        4($sp)          # push $s2

# EPILOGUE
    move    $sp,        $fp             # restore $sp
    lw      $ra,        ($fp)           # restore saved $ra
    lw      $fp,        -4($sp)         # restore saved $fp
    jr      $ra                         # return to kernel
# Directory ID: shreyv
# UnivID: 118019727

    .data
    .text
    .globl collatz

# Arguments:
#   $s1 - the number n
#   $s2 - the depth d
# Returns:
#   $v0 - the depth at which n becomes 1
collatz:
    addiu $sp, $sp, -32      # Allocate stack space
    sw $ra, 28($sp)          # Save return address
    sw $s1, 24($sp)         
    sw $s2, 20($sp)          

    li $t1, 1
    beq $s1, $t1, base_case  # Base case: if n == 1

    andi $t0, $s1, 1         # Check if n is odd
    beqz $t0, even_case

    # Odd case: n = 3 * n + 1
odd_case:
    li $t2, 3
    mul $t2, $s1, $t2
    addiu $s1, $t2, 1
    b update_depth

    # Even case: n = n / 2
even_case:
    srl $s1, $s1, 1         

update_depth:
    addiu $s2, $s2, 1        
    jal collatz              
    b return_result

base_case:
    move $v0, $s2            # Return depth

return_result:
    lw $s1, 24($sp)          # Restore $s1
    lw $s2, 20($sp)          # Restore $s2
    lw $ra, 28($sp)          # Restore return address
    addiu $sp, $sp, 32       # Deallocate stack space
    jr $ra                   # Return
