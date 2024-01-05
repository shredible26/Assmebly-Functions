    .data
    .text
    .globl reverse_prefix_sum

# reverse_prefix_sum function
# Arguments:
#   a0 - pointer to the array arr
# Returns:
#   v0 - sum of the array elements from the current position to the end
reverse_prefix_sum:
    # Prologue
    addi $sp, $sp, -16    # Allocate stack space for saved registers
    sw $ra, 12($sp)       # Save return address
    sw $a0, 8($sp)        # Save pointer to arr (a0)
    sw $a1, 4($sp)        # Save argument a1 (temporary)
    sw $a2, 0($sp)        # Save argument a2 (temporary)

    # Base case: if *arr == -1
    lw $t0, 0($a0)        # Load the value at *arr
    li $t1, -1
    beq $t0, $t1, end_function  # If *arr is -1, return 0

    # Recursive case
    addiu $a0, $a0, 4     # Increment array pointer
    jal reverse_prefix_sum # Recursive call
    lw $t2, -4($a0)       # Load the previous element (*arr)

    # Calculate new value and update array using unsigned addition
    addu $v0, $v0, $t2    # Add the current element to the result (unsigned)
    sw $v0, -4($a0)       # Store the result back in the array

    # Epilogue
    lw $a2, 0($sp)        # Restore argument a2
    lw $a1, 4($sp)        # Restore argument a1
    lw $a0, 8($sp)        # Restore pointer to arr (a0)
    lw $ra, 12($sp)       # Restore return address
    addiu $sp, $sp, 16    # Deallocate stack space
    jr $ra                # Return to caller

end_function:
    move $v0, $zero       # Return 0 for base case
    # Epilogue (same as above)
    lw $a2, 0($sp)        # Restore argument a2
    lw $a1, 4($sp)        # Restore argument a1
    lw $a0, 8($sp)        # Restore pointer to arr (a0)
    lw $ra, 12($sp)       # Restore return address
    addiu $sp, $sp, 16    # Deallocate stack space
    jr $ra                # Return to caller
