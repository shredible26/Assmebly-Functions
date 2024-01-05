# Directory ID: shreyv
# UnivID: 118019727

    .data
    .text
    .globl isqrt

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
