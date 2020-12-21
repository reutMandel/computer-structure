 # 209163955 Reut Mandel
    .section .rodata
format_in_char: .string	" %c"
format_in_int:  .string	"%d"
format1:	  .string	"first pstring length: %d, second pstring length: %d\n"
format2:	  .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
format3:   .string   "length: %d, string: %s\n"
format4:   .string   "compare result: %d\n"
format5:	  .string	"invalid option!\n"

    .align 8 # Align address to multiple of 8
.JMP_TABLE:

  .quad .OP_50_60   # case 50 or 60      
  .quad .OP_DEFUALT # defualt for 51
  .quad .OP_52      # case 52
  .quad .OP_53      # case 53
  .quad .OP_54      # case 54
  .quad .OP_55      # case 55

    .text	#the beginning of the code.

# case 50 or 60      
.OP_50_60:
   
   movq %rdx,  %rbx     # put pstring 2 in callee save

   # call pstrlen for first pstring
   movq  %rsi,  %rdi    # move pstring 1 to rdi
   movq $0, %rax        # initiliaze %rax
   call pstrlen
   movq  %rax, %rsi     # save size of pstring 1 in %rsi
   
   # call pstrlen for second pstring
   movq  %rbx, %rdi     # move pstring 2 to rdi
   movq  $0, %rax        # initiliaze %rax
   call  pstrlen
   movq  %rax, %rdx     # save size of pstring 2 in %rdx
   
   # printing the two length of the pstrings
   movq	$format1, %rdi # the string is the first paramter passed to the printf function.
   call  printf
   jmp .FINISH_SWITCH

# case 52
.OP_52:

   movq  %rsi, %r12       # save pstring 1 in callee save register
   movq  %rdx, %r13       # save pstring 2 in callee save register

   # call scanf for first char
   movq $format_in_char, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp),        %rsi  # put in rsi the adress of $rbp-8 for scanf
   movq  $0,             %rax  # initiliaze %rax
   call scanf 
   
   xorq  %rbx,    %rbx         # initiliaze %rbx
   movb -8(%rbp), %bl          # save first char in bl

   # call scanf for first char
   movq $format_in_char, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp),        %rsi  # put in rsi the adress of $rbp-8 for scanf
   movq $0, %rax               # initiliaze %rax
   call scanf 

   movb -8(%rbp), %dl          # save scenod char in dl
   movb %bl,  %sil             # move char 1 to sil

    # call to replace char for pstring 1
   movq %r12, %rdi             # move pstring 1 to %rdi
   movq $0, %rax               # initiliaze %rax
   call replaceChar
   movq %rax, %r12             # save new pstring 1 in r12 - callee save

   # call to replace char for pstring 2
   movq %r13, %rdi             # move pstring 1 to %rdi
   movq $0, %rax               # initiliaze %rax
   call replaceChar
   
   # printing the new pstrings after replace char
   leaq  1(%r12),  %rcx        # move new pstring 1 to rcx
   leaq  1(%rax),  %r8         # move new pstring 2 to r8
   movq	$format2, %rdi        # the string is the first paramter passed to the printf function.
   call  printf
   
   jmp .FINISH_SWITCH
   
# case 53
.OP_53:
   
   movq  %rsi, %r12       # save pstring 1 in callee save register
   movq  %rdx, %r13       # save pstring 2 in callee save register
   
   # call scanf for first index (i)
   movq $format_in_int, %rdi    # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp), %rsi          # put in rsi the adress of $rbp-8 for scanf
   movq $0, %rax                # initiliaze %rax
   call scanf 
   
   xorq %rbx, %rbx              # initiliaze %rbx
   movb -8(%rbp), %bl           # save first index (i) in bl

   # call scanf for first index (j)
   movq $format_in_int, %rdi   # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp), %rsi         # put in rsi the adress of $rbp-8 for scanf
   movq $0, %rax               # initiliaze %rax
   call scanf 
   
   movb -8(%rbp), %cl          # save second index (j) in cl
   movb  %bl,     %dl          # move i to dl
   movq  %r12, %rdi            # move pstring 1 to rdi
   movq  %r13, %rsi            # move pstring 2 to rsi
   
   # increase i and j to start index in 1
   inc %dl                     # inc i
   inc %cl                     # inc j  
   
   movq $0, %rax          # initiliaze %rax
   call pstrijcpy

   # printing the new pstrings after replace char
   # print pstring 1 - (after replace)
   xorq   %rsi,  %rsi     # initilaize rsi
   movb  (%rax),   %sil   # move size of pstring 1 to sil 
   leaq  1(%rax),  %rdx   # move new pstring 1 to rdx          
   movq	$format3, %rdi   # the string is the first paramter passed to the printf function.
   call  printf

   # print pstring 2 - without change
   xorq   %rsi,  %rsi     # initilaize rsi
   movb  (%r13),   %sil   # move size of pstring 2 to sil 
   leaq  1(%r13),  %rdx   # move new pstring 1 to rdx      
   movq	$format3, %rdi   # the string is the first paramter passed to the printf function.
   call  printf   

   jmp .FINISH_SWITCH

# case 54
.OP_54:
   
   movq %rdx,  %rbx     # put pstring 2 in callee save

   # call swapCase for first pstring
   movq  %rsi,  %rdi    # move pstring 1 to rdi
   movq $0, %rax        # initiliaze %rax
   call swapCase
   movq  %rax, %r12     # save new pstring 1 in %r12
   
   # call swapCase for second pstring
   movq  %rbx, %rdi     # move pstring 2 to rdi
   movq  $0, %rax       # initiliaze %rax
   call  swapCase
   movq  %rax, %rbx     # save new pstring 2 in %rdx
   
   # printing pstring 1
   movq	$format3, %rdi   # the string is the first paramter passed to the printf function.
   xorq   %rsi,  %rsi     # initilaize rsi
   movb  (%r12), %sil     # move size of pstring 1 to rsi     
   leaq  1(%r12), %rdx    # move new pstring 1 to rdx 
   call  printf

   # printing pstring 2
   movq	$format3, %rdi    # the string is the first paramter passed to the printf function.
   xorq   %rsi,  %rsi      # initilaize rsi
   movb  (%rbx),   %sil    # move size of pstring 1 to rsi     
   leaq  1(%rbx),  %rdx    # move new pstring 1 to rdx 
   call  printf

   jmp .FINISH_SWITCH

# case 55
.OP_55:
  
   movq  %rsi, %r12       # save pstring 1 in callee save register
   movq  %rdx, %r13       # save pstring 2 in callee save register

   # call scanf for first index (i)
   movq $format_in_int, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp),       %rsi  # put in rsi the adress of $rbp-8 for scanf
   movq $0, %rax              # initiliaze %rax
   call scanf 
   
   xorq %rbx, %rbx            # initiliaze %rbx
   movb -8(%rbp), %bl         # save first index (i) in bl

   # call scanf for first index (j)
   movq $format_in_int, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp),       %rsi  # put in rsi the adress of $rbp-8 for scanf
   movq $0, %rax              # initiliaze %rax
   call scanf 
   
   movb -8(%rbp), %cl         # save second index (j) in cl
   movb  %bl,     %dl         # move i to dl
   movq  %r12, %rdi           # move pstring 1 to rdi
   movq  %r13, %rsi           # move pstring 2 to rsi
   
   # increase i and j to start index in 1
   inc %dl                    # inc i
   inc %cl                    # inc j  
   
   movq $0, %rax              # initiliaze %rax
   call pstrijcmp

   # printing the compare reulst
   xorq   %rsi,  %rsi     # initilaize rsi
   movl   %eax,  %esi     # move reult of compare to rsi        
   movq	$format4, %rdi   # the string is the first paramter passed to the printf function.
   call  printf

   jmp .FINISH_SWITCH

# default
.OP_DEFUALT:
   
   # print invalid input
   movq	$format5, %rdi   # the string is the first paramter passed to the printf function.
   call  printf

   jmp .FINISH_SWITCH

# return
.FINISH_SWITCH:
   
   movq %rbp, %rsp
   popq %rbx              # restore %rbx
   popq %r12              # restore %r12
   popq %r13              # restore %r13
   popq %rbp
   ret


.globl	run_func
        #this function gets option and two pstrings and call to the specific function by option
	    .type	run_func, @function
run_func:

    pushq   %rbp            # saving the old frame pointer.
    pushq   %rbx            # backup callee - save %rbx
    pushq   %r12            # backup callee - save %r12
    pushq   %r13            # backup callee - save %r13
    movq    %rsp,  %rbp     # creating the new frame pointer.
    sub     $8,    %rsp     # straighte stack to 16 for scanf and printf
    movl    %edi,  %eax     # move option argument to temp register
    sub     $50,   %eax     # sub 10 from option
    cmpl    $10,   %eax     # compare option to 10
    je      .OP_50_60       # if equal - option is 60 - go to OP_50_60
    cmpl    $5,    %eax     # compare option to 5
    ja      .OP_DEFUALT     # if > 5, goto defualt case
    jmp     *.JMP_TABLE(,%rax,8)

    
