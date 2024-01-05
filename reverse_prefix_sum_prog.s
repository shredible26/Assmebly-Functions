   .data
# uint arrays, each terminated by -1 (which is not part of array)
arr0:
   .word 1, 2, 3, 4, -1
arr1:
   .word 2, 3, 4, 5, -1
arr2:
   .word 5, 4, 3, 2,  -1
arr3:
   .word 1, 2, 1, 2, 1, 2, 3, 1, 2, 3, 1, 2, 3, 4, -1
overflow:
   .word 1, 1, 1, 1, 2147483646, -1

   .text

# main(): ##################################################
#   process_array(arr0)
#   process_array(arr1)
#   process_array(arr2)
#   process_array(arr3)
#   process_array(arr4)
#
main:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   la   $a0, arr0
   jal  process_array
   la   $a0, arr1
   jal  process_array
   la   $a0, arr2
   jal  process_array
   la   $a0, arr3
   jal  process_array
   la   $a0, overflow
   jal  process_array

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
## end main ################################################

# process_array(uint* arr): #################################
#   print_array(arr)
#   reverse_prefix_sum(arr)
#   print_array(arr)
#
process_array:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 4        # save s0 on stack before using it
   sw   $s0, 4($sp)

   move $s0, $a0           # use s0 to save a0
   jal  print_array
   move $a0, $s0
   jal  reverse_prefix_sum
   move $a0, $s0
   jal  print_array

   lw   $s0, -8($fp)       # restore s0 from stack

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
## end process_array #######################################

# print_array(uint arr): ########################################
#   uint x
#   while (-1 != (x = *arr++)):
#     printf("%d ", x)
#   printf("\n")
#
print_array:
   # use t0 to hold arr. use t1 to hold *arr
   move $t0, $a0
print_array_while:
   lw   $t1, ($t0)
   beq  $t1, -1, print_array_endwhile
   move $a0, $t1           # print_int(*arr)
   li   $v0, 1
   syscall
   li   $a0, 32            # print_char(' ')
   li   $v0, 11
   syscall
   addu $t0, $t0, 4
   b    print_array_while
print_array_endwhile:
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   jr   $ra
## end print_array #########################################
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
