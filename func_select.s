    .section .rodata
format_in_char: .string	" %c"
format_in_int:  .string	" %d"
format1:	  .string	"first pstring length: %d, second pstring length: %d\n"
format2:	  .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
format3:   .string   "length: %d, string: %s\n"
format4:   .string   "compare result: %d\n"
format5:	  .string	"invalid input!\n"


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
   sub   $16, %rsp        # place for the chars

    # call scanf for first char
   movq $format_in_char, %rdi  # the string is the first paramter passed to the scanf function.
   movb -1(%rbp),   %sil  # mov first place to %rsi 
   movq $0, %rax          # initiliaze %rax
   call scanf 

   xorb %bl, %bl     
   movb %sil, %bl        # save first char in rbx

   # call scanf for first char
   movq $format_in_char, %rdi  # the string is the first paramter passed to the scanf function.
   movb -1(%rbp),   %sil       # mov first place to %rsi 
   movq $0, %rax               # initiliaze %rax
   call scanf 

   movb %sil, %dl              # move char 2 to rdx
   movb %bl,  %sil             # move char 1 to rsi

    # call to replace char for pstring 1
   movq %r12, %rdi        # move pstring 1 to %rdi
   movq $0, %rax          # initiliaze %rax
   call replaceChar
   movq %rax, %r12        # save new pstring 1 in r12 - callee save

   # call to replace char for pstring 2
   movq %r13, %rdi        # move pstring 1 to %rdi
   movq $0, %rax          # initiliaze %rax
   call replaceChar
   
   # printing the new pstrings after replace char
   leaq  1(%r12),  %rcx      # move new pstring 1 to rcx
   leaq  1(%rax),  %r8       # move new pstring 2 to rcx
   movq	$format2, %rdi      # the string is the first paramter passed to the printf function.
   call  printf
   
   jmp .FINISH_SWITCH
   
# case 53
.OP_53:
   
   movq  %rsi, %r12       # save pstring 1 in callee save register
   movq  %rdx, %r13       # save pstring 2 in callee save register
   sub   $16,  %rsp       # place for the input chars

   # call scanf for first index (i)
   movq $format_in_int, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp),       %rsi  # mov first place to %rsi 
   movq $0, %rax              # initiliaze %rax
   call scanf 
   
   xorq %rbx, %rbx
   movl %esi, %ebx            # save first index (i) in rbx

   # call scanf for first index (j)
   movq $format_in_int, %rdi # the string is the first paramter passed to the scanf function.
   movl -4(%rbp),       %esi # mov first place to %rsi 
   movq $0, %rax             # initiliaze %rax
   call scanf 
   
   movl  %esi, %ecx       # move j to rcx 
   movl  %ebx, %edx       # move i to ebx
   movq  %r12, %rdi       # move pstring 1 to rdi
   movq  %r13, %rsi       # move pstring 2 to rsi
   
   # increase i and j to start index in 1
   inc %ecx
   inc %edx  

   call pstrijcpy

   # printing the new pstrings after replace char
   movb  (%rax), %sil     # move size of pstring 1 to rsi 
   leaq  1(%rax), %rdx    # move new pstring 1 to rdx          
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
   sub   $16,  %rsp       # place for the char

   # call scanf for first index (i)
   movq $format_in_int, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -8(%rbp),       %rsi  # mov first place to %rsi 
   movq $0, %rax              # initiliaze %rax
   call scanf 
   
   xorq %rbx, %rbx
   movl %esi, %ebx            # save first index (i) in rbx

   # call scanf for first index (j)
   movq $format_in_int, %rdi # the string is the first paramter passed to the scanf function.
   movl -4(%rbp),       %esi # mov first place to %rsi 
   movq $0, %rax             # initiliaze %rax
   call scanf 
   
   movl  %esi, %ecx       # move j to rcx 
   movl  %ebx, %edx       # move i to ebx
   movq  %r12, %rdi       # move pstring 1 to rdi
   movq  %r13, %rsi       # move pstring 2 to rsi
   
   # increase i and j to start index in 1
   inc %ecx
   inc %edx  

   call pstrijcmp

   # printing the compare reulst
   movl  %eax,     %esi   # move reult of compare to rsi        
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
   leave
   ret


.globl	run_func
        #this function gets option and two pstrings and call to the specific function by option
	    .type	run_func, @function
run_func:

    pushq   %rbp            # saving the old frame pointer.
    movq    %rsp,  %rbp     # creating the new frame pointer.
    movl    %edi,  %eax     
    sub     $50,   %eax     # sub 10 from option
    cmpl    $10,   %eax     # compare option to 10
    je      .OP_50_60       # if equal - option is 60 - go to OP_50_60
    cmpl    $5,    %eax     # compare option to 5
    ja      .OP_DEFUALT     # if > 5, goto defualt case
    jmp     *.JMP_TABLE(,%rax,8)

    
