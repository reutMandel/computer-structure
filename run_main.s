# 209163955 Reut Mandel
 .section .rodata
format_in_int: .string	    "%d"
format_in_string: .string	"%s"

 .text	# the beginning of the code.

 .globl	run_main
         # this function scanf two strings, build pstrings and call to func_select
	    .type	run_main, @function
run_main:


    pushq   %rbp                    # saving the old frame pointer.
    movq    %rsp,  %rbp             # creating the new frame pointer.
    sub     $512,  %rsp             # allocate for two pstrings

    # scanf first input - size of pstring 1
    leaq  -256(%rbp), %rsi          # put in rsi the adress of $rbp-256 for scanf
    movq $format_in_int, %rdi       # the string is the first paramter passed to the scanf function.
    movq $0, %rax                   # initiliaze %rax
    call scanf

    # scanf string 1
    leaq  -255(%rbp), %rsi          # put in rsi the adress of $rbp-255 for scanf
    movq $format_in_string, %rdi    # the string is the first paramter passed to the scanf function.
    movq $0, %rax                   # initiliaze %rax
    call scanf
    
    # scanf size of pstring 2
    leaq  -512(%rbp), %rsi          # put in rsi the adress of $rbp-512 for scanf
    movq $format_in_int, %rdi       # the string is the first paramter passed to the scanf function.
    movq $0, %rax                   # initiliaze %rax
    call scanf


    # scanf string 2
    leaq  -511(%rbp), %rsi         # put in rsi the adress of $rbp-511 for scanf
    movq $format_in_string, %rdi   # the string is the first paramter passed to the scanf function.
    movq $0, %rax                  # initiliaze %rax
    call scanf


    # scanf option
    sub   $16,      %rsp           # allocate for the option input in stack
    leaq 8(%rsp),   %rsi           # put in rsi the adress of $rbp-8 for scanf
    movq $format_in_int, %rdi      # the string is the first paramter passed to the scanf function.
    movq $0, %rax                  # initiliaze %rax
    call scanf

    # call run cunction
    xorq  %rdi, %rdi               # initiliaze %rdi
    movb 8(%rsp),  %dil            # save option in first argument for functiom
    leaq -256(%rbp), %rsi          # move pstring 1 as argument
    leaq -512(%rbp), %rdx          # move pstring 2 as argument

    call run_func

    movq %rbp, %rsp
    popq %rbp
    ret

   