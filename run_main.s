 .section .rodata
format_in_int: .string	    "%d"
format_in_string: .string	"%s"

 .text	# the beginning of the code.

 .globl	run_main
         # this function scanf two strings, build pstrings and call to func_select
	    .type	run_main, @function
run_main:


    pushq   %rbp                   # saving the old frame pointer.
    pushq   %rbx                   # save rbx
    pushq   %r12                   # save r12
    pushq   %r13                   # save r13
    pushq   %r14                   # save r14
    pushq   %r15                   # save r15
    movq    %rsp,  %rbp            # creating the new frame pointer.
    sub     $8,    %rsp            # straighte stack to 16 for scanf and printf

    # scanf first input - size of pstring 1
    leaq  -8(%rbp), %rsi           # put in rsi the adress of $rbp-8 for scanf
    movq $format_in_int, %rdi      # the string is the first paramter passed to the scanf function.
    movq $0, %rax                  # initiliaze %rax
    call scanf

    xorq %r12, %r12                # initiliaze %r12
    movb -8(%rbp), %r12b           # save size of string 1 

    # scanf string 1
    leaq  -8(%rbp), %rsi           # put in rsi the adress of $rbp-8 for scanf
    movq $format_in_string, %rdi   # the string is the first paramter passed to the scanf function.
    movq $0, %rax                  # initiliaze %rax
    call scanf

    movq -8(%rbp), %r13            # save string 1

    
    # scanf size of pstring 2
    leaq  -8(%rbp), %rsi           # put in rsi the adress of $rbp-8 for scanf
    movq $format_in_int, %rdi      # the string is the first paramter passed to the scanf function.
    movq $0, %rax                  # initiliaze %rax
    call scanf

    xorq %r14,     %r14            # initiliaze %r14
    movb -8(%rbp), %r14b           # save size of string 2 


    # scanf string 2
    leaq  -8(%rbp), %rsi           # put in rsi the adress of $rbp-8 for scanf
    movq $format_in_string, %rdi   # the string is the first paramter passed to the scanf function.
    movq $0, %rax                  # initiliaze %rax
    call scanf

    movq -8(%rbp), %r15            # save string 2

    # scanf option
    leaq  -8(%rbp), %rsi           # put in rsi the adress of $rbp-8 for scanf
    movq $format_in_int, %rdi      # the string is the first paramter passed to the scanf function.
    movq $0, %rax                  # initiliaze %rax
    call scanf

    xorq  %rcx,     %rcx           # initiliaze %rcx
    movb -8(%rbp),  %cl            # save option


    # insert pstring 1 to stack frame
    xorq  %rdx, %rdx                # initiliaze %rdx
    movb  %r12b, %dl                # move size of string 1
    add   $2,   %dl                 # prepare index for the size of stack
    subq  %rdx,  %rsp               # create place to pstring 1
    pushq %r13                      # insert string 1
    pushq %r12                      # insert size
    movq  %rsp, %rbx                # put rbx as pointer to pstring 1

    # insert pstring 2 to stack frame
    xorq  %rdx, %rdx                # initiliaze %rdx
    movb  %r14b, %dl                # move size of string 2
    add   $2,  %dl                  # prepare index for the size of stack
    subq  %rdx,  %rsp               # create place to pstring 2
    pushq %r15                      # insert string 1
    pushq %r14                      # insert size
    
    # call to run func 
    xorq  %rdi, %rdi                # initiliaze %rdi
    movb  %cl,  %dil                # move option for first argument
    movq  %rbx, %rsi                # move pstring 1 as argument
    movq  %rsp, %rdx                # move pstring 2 as argument

    call run_func


    movq %rbp, %rsp
    popq %rbx                       # restore rbx
    popq %r12                       # restore r12
    popq %r13                       # restore r13
    popq %r14                       # restore r14
    popq %r15                       # restore r15
    popq %rbp
    ret

   