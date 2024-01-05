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
