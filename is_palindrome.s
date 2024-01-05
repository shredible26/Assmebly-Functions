# Directory ID: shreyv
# UnivID: 118019727

    .data
    .text
    .globl is_palindrome
    .globl strlen

# strlen function
# Arguments: 
#   a0 - pointer to the string
# Returns: 
#   v0 - length of the string
strlen:
    move $t0, $a0         
    li $v0, 0             # Initialize length to 0

strlen_loop:
    lb $t1, 0($t0)        # Load a byte from the string
    beqz $t1, strlen_end  
    addi $v0, $v0, 1      # Increment length
    addi $t0, $t0, 1      # Move to the next character
    j strlen_loop         

strlen_end:
    jr $ra                # Return to the caller

# is_palindrome function
# Arguments: 
#   a0 - pointer to the string
# Returns: 
#   v0 
is_palindrome:
    # Prologue
    addi $sp, $sp, -8     
    sw $ra, 4($sp)        
    sw $s0, 0($sp)        

    # Call strlen to get the length of the string
    jal strlen            # Call strlen function
    move $t1, $v0         # Move length to t1

    # Initialize i to 0
    li $s0, 0             # $s0 will hold the value of 'i'

check_loop:
    bge $s0, $t1, check_end # If i >= len, end loop

    # Compare string[i] and string[len - i - 1]
    add $t2, $a0, $s0     # $t2 = address of string[i]
    lb $t3, 0($t2)        # Load byte from string[i]
    sub $t4, $t1, $s0     # Calculate len - i
    addi $t4, $t4, -1     # Calculate len - i - 1
    add $t5, $a0, $t4     # $t5 = address of string[len - i - 1]
    lb $t6, 0($t5)        # Load byte from string[len - i - 1]

    # Check if characters are different
    bne $t3, $t6, not_palindrome # If characters are different, not a palindrome

    # Increment i and continue loop
    addi $s0, $s0, 1      # Increment i
    j check_loop          # Jump back to the start of the loop

not_palindrome:
    # Return 0 (not a palindrome)
    li $v0, 0
    j end_function

check_end:
    # Return 1 (is a palindrome)
    li $v0, 1

end_function:
    # Epilogue
    lw $s0, 0($sp)        # Restore s0 register
    lw $ra, 4($sp)        # Restore return address
    addi $sp, $sp, 8      # Deallocate stack space
    jr $ra                # Return to the caller
