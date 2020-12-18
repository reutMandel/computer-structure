    .section .rodata
format1:	  .string	"first pstring length: %d, second pstring length: %d\n"
format_in: .string	" %c"
format2:	  .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"

    .align 8 # Align address to multiple of 8
.L7:

  .quad .L0 # case 50 or 60      
  .quad .L6 # defualt
  .quad .L2 # case 52
  .quad .L3 # case 53
  .quad .L4 # case 54
  .quad .L5 # case 55

    .text	#the beginning of the code.

# case 50 or 60      
.L0:
   
   # call pstrlen for first pstring
   movq  %rsi,  %rdi    # move pstring 1 to rdi
   movq  %rdx,  %rsi    # move pstring 2 to rsi
   call pstrlen
   
   # call pstrlen for second pstring
   movq  %rsi, %rdi     # move pstring 2 to rdi
   movq  %rax, %rsi     # save size of pstring 1 in %rsi
   call  pstrlen
   movq  %rax, %rdx     # save size of pstring 2 in %rdx
   
   # printing the two length of the pstrings
   movq	$format1, %rdi # the string is the first paramter passed to the printf function.
   call  printf
   jmp .L8

# case 52
.L2:

   movq %rsi, %rdi
   movb $97,  %sil
   movb $98,  %dl
   call replaceChar

  /* movq %rsi, %rcx        # move pstring 1 to %rcx
   sub  $16, %rsp         # place for the char
   
   # call scanf for first char
   movq $format_in, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -1(%rbp), %rsi    # leaq %rsp to %rsi 
   movq $0, %rax          # initiliaze %rax
   call scanf 

   movb -1(%rbp), %bl     # insert scanf result to %bl

   # call scanf for second char
   movq $format_in, %rdi  # the string is the first paramter passed to the scanf function.
   leaq -1(%rbp), %rsi    # leaq %rsp to %rsi 
   movq $0, %rax          # initiliaze %rax
   call scanf            
   
   # call to replace char
   movq %rcx, %rdi        # move pstring 1 to %rdi
   movb %sil, %dl         # move new char to %rdx
   movb %bl,  %sil        # move old char to %rsi
   movq $0, %rax          # initiliaze %rax
   //call replaceChar

   */
   
   # printing the new pstrings after replace char
   movq  %rdi,  %rcx
   movq	$format2,  %rdi # the string is the first paramter passed to the printf function.
   call  printf
   jmp .L8

# case 53
.L3:

   movq  %rsi,  %rdi    # move pstring 1 to rdi
   movq  %rdx,  %rsi    # move pstring 2 to rsi
   movb  $2,    %dl
   movb  $1,    %cl
   call pstrijcpy
   jmp .L8

# case 54
.L4:

   movq  %rsi,  %rdi    # move pstring 1 to rdi
   movq  %rdx,  %rsi    # move pstring 2 to rsi
   call  swapCase
   jmp .L8

# case 55
.L5:
  
   movq  %rsi,  %rdi    # move pstring 1 to rdi
   movq  %rdx,  %rsi    # move pstring 2 to rsi
   movb  $1,    %dl
   movb  $3,    %cl
   call pstrijcmp
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

    
