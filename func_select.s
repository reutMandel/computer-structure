    .section .rodata
    .align 8 # Align address to multiple of 4
.L7:

  .quad .L0 # case 50 or 60      
  .quad .L6 # case 51
  .quad .L2 # case 52
  .quad .L3 # case 53
  .quad .L4 # case 54
  .quad .L5 # case 55

    .text	#the beginning of the code.

# case 50 or 60      
.L0:

   add $10, %eax
   jmp .L8

# case 52
.L2:
   add $20, %eax
   jmp .L8

# case 53
.L3:
   add $20, %eax  
   jmp .L8

# case 54
.L4:
   add $20, %eax
   jmp .L8

# case 55
.L5:
   add $20, %eax
   jmp .L8

# default
.L6:
   add $20, %eax
   jmp .L8


# return
.L8:
   leave
   ret


.globl	run_func
        #this function gets option and two pstrings and call to the specific function by option
	    .type	run_func, @function
run_func:

    pushq   %rbp            #saving the old frame pointer.
    movq    %rsp,  %rbp     #creating the new frame pointer.
    movl    %edi,  %eax 
    sub     $50,   %eax
    cmpl    $10,   %eax
    je      .L0
    cmpl    $5,    %eax
    ja      .L6             # if > 5, goto defualt case
    jmp     *.L7(,%rax,8)

    
