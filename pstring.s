.file "pstring.h"

     .section .rodata
format1:	  .string	"invalid input!\n"

 .text	#the beginning of the code.

.globl	pstrlen
        #this function gets pstring and retrun its length
	    .type  pstrlen, @function
pstrlen:
   
   pushq  %rbp            #saving the old frame pointer.
   movq   %rsp,  %rbp     #creating the new frame pointer.
   xorb   %al,  %al       # initilaize al
   movb   (%rdi), %al     # move rdi[0] to al
   leave
   ret

.globl	replaceChar
        #this function gets pstring and two chars and replace the old char in new char
	    .type  replaceChar, @function
replaceChar:
   pushq  %rbp            # saving the old frame pointer.
   movq   %rsp,  %rbp     # creating the new frame pointer.
   xorq   %rax,  %rax     # initilaize rax
   movl   $1,    %ecx     # initilaize ecx - index of the current iteration
    
    # loop until finish iterate on the string
   .L1:
      cmpb $0, (%rdi, %rcx, 1)   # comapre current char to '\0' 
      jz   .L2                   # if equal - finished iteration - go to L2
      cmpb %sil, (%rdi, %rcx, 1) # compare current char to old char (in %rsi)
      je   .L3                   # if equal - replace char - go to L3
      inc  %ecx                  # increment index in 1
      jmp  .L1
     
    # finish label
    .L2: 
      movq %rdi, %rax            # mov the new pstring to rax
      leave
      ret
    
    # replace label
    .L3:
      movb %dl, (%rdi, %rcx, 1)  # replace the new char in pstring
      inc  %ecx                  # increment index in 1
      jmp  .L1                   # jump back to loop


.globl	pstrijcpy
        #this function gets two pstring and two indexes and copy the i-j in src pstring to i-j dest pstring
	    .type  pstrijcpy , @function
pstrijcpy:

   pushq  %rbp            # saving the old frame pointer.
   movq   %rsp,   %rbp    # creating the new frame pointer.
   pushq  %rbx            # backup callee - save %rbx
   xorq   %rax,   %rax    # initilaize rax
   movq   %rdi,   %rbx    # save dest in rbx
   movb   (%rdi), %r8b    # move rdi[0] to r8b
   movb   (%rsi), %r9b    # move rsi[0] to r9b
   cmpb    %r8b,   %dl    # compare i to size of pstring 1
   ja     .L4             # if i above size - finished - go to L4 
   cmpb    %r9b,   %dl    # compare i to size of pstring 2
   ja     .L4             # if i above size - finished - go to L4 
   cmpb    %r8b,   %cl    # compare j to size of pstring 1
   ja     .L4             # if j above size - finished - go to L4 
   cmpb    %r9b,   %cl    # compare j to size of pstring 2
   ja     .L4             # if j above size - finished - go to L4 
   cmpb    %cl,    %dl    # compare i and j
   ja     .L4             # if i > j - finished - go to L4
   xorq   %r8,     %r8    # initilaize r8
   movb   %dl,     %r8b   # index iteration start in i
   xorq   %r9,     %r9    # initilaize r9

   .L5:

      cmpb  %cl, %r8b             # compare index iteration to j
      ja    .L6                   # if index interation above j - finishd - go to L6
      movb  (%rsi,%r8,1), %r9b    # move the char in location %r8 in src to register %rb9  
      movb  %r9b,  (%rbx,%r8,1)   # move the char in %r9 to the r8 index in dest pstring
      inc   %r8                   # increment index in 1 
      jmp   .L5

   .L6:

      movq %rbx, %rax     # mov dest pstring to rax - return value
      popq %rbx            # restore %rbx
      leave
      ret

   .L4:
      
      # call printf - invalid arguments i or j
      movq $format1, %rdi # the string is the first paramter passed to the printf function.
      call printf
      jmp  .L6


.globl	swapCase
        #this function swap lower to upper case and upper to lower case
	    .type  swapCase , @function
swapCase:
   
   pushq  %rbp            # saving the old frame pointer.
   movq   %rsp,   %rbp    # creating the new frame pointer.
   xorq   %rax,   %rax    # initilaize rax
   movl   $1,     %ecx    # initilaize ecx - index of the current iteration
    
    # loop until finish iterate on the string
   .L7:
      cmpb $0, (%rdi, %rcx, 1)   # comapre current char to '\0' 
      jz   .L8                   # if equal - finished iteration - go to L8

      # check big letter
      .L10: 
       cmpb $65, (%rdi, %rcx, 1)  # compare current char to 'A' (A=65)
       jl   .L9                   # current char less than 'A' - continue in loop - go to L9
       cmpb $90, (%rdi, %rcx, 1)  # compare current char to 'Z' (Z=90)
       ja   .L11                  # current char bigger than 'Z' - move to check lower letter - go to L11
       add  $32, (%rdi, %rcx, 1)  # add 32 to current char - replact to lower case
       jmp  .L9

      # check lower letter
      .L11:
       cmpb $97, (%rdi, %rcx, 1)  # compare current char to 'a' (a=97)
       jl   .L9                   # current char less than 'a' - continue in loop - go to L9
       cmpb $122, (%rdi, %rcx, 1) # compare current char to 'z' (z=122)
       ja   .L9                   # current char bigger than 'z' - continue in loop - go to L9
       sub  $32, (%rdi, %rcx, 1)  # sub 32 to current char - replact to upper case
       jmp  .L9
 
    # finish label
   .L8: 
      movq %rdi, %rax             # mov the new pstring to rax
      leave
      ret

   #  increase index 
   .L9: 
      inc  %ecx                   # increase index
      jmp .L7                     # back to loop


.globl	pstrijcmp
        #this function check which pstring is bigger in lexicographic order
	    .type  pstrijcmp , @function
pstrijcmp:
    
   pushq  %rbp            # saving the old frame pointer.
   movq   %rsp,   %rbp    # creating the new frame pointer.
   xorq   %rax,   %rax    # initilaize rax
   movb   (%rdi), %r8b    # move rdi[0] to r8b
   movb   (%rsi), %r9b    # move rsi[0] to r9b
   cmpb   %r8b,   %dl     # compare i to size of pstring 1
   ja     .L12            # if i above size - finished - go to L12
   cmpb   %r9b,   %dl     # compare i to size of pstring 2
   ja     .L12            # if i above size - finished - go to L12
   cmpb   %r8b,   %cl     # compare j to size of pstring 1
   ja     .L12            # if j above size - finished - go to L12
   cmpb   %r9b,   %cl     # compare j to size of pstring 2
   ja     .L12            # if j above size - finished - go to L12
   cmpb   %cl,    %dl     # compare i and j
   ja     .L12            # if i > j - finished - go to L4
   xorq   %r8,     %r8    # initilaize r8
   movb   %dl,     %r8b   # index iteration start in i
   xorq   %r9,     %r9    # initilaize r9
   pushq  %rbx            # backup callee - save %rbx
   xorq   %rbx,    %rbx   # initilaize rbx               


  .L14:
   
     cmpb  %cl, %r8b             # compare index iteration to j
     ja    .L13                  # if index interation above j - finishd - go to L13
     movb  (%rdi,%r8,1), %bl     # move current char from pstring 1 to %bl
     cmpb  %bl, (%rsi,%r8,1)     # compare char in pstring 1 to char in pstring 2
     je    .L15                  # if the two chars are equal - move to the next char
     sub   (%rsi,%r8,1), %bl     # sub char in pstring 2 from char in pstring 1
     testb  %bl,  %bl            # check if the sub result is negative or positive
     js     .L16                 
     jmp    .L17
    

   # negative result in sub
  .L16:
     movl $-1, %eax               # pstring 1 is small than pstring 2 
     jmp .L13

  # positive result in sub
  .L17:
     movl $1, %eax                # pstring 1 is bigger than pstring 2 
     jmp .L13

  #  increase index 
  .L15: 
      inc  %r8                    # increase index
      jmp .L14                    # back to loop
    
  
  # handle invalid arguments
  .L12:
      # call printf - invalid arguments i or j
      movq $format1, %rdi  # the string is the first paramter passed to the printf function.
      call printf
      movl $-2,  %eax       # put -2 in rax and return
      jmp .L13

  .L13:
      popq %rbx            # restore %rbx
      leave
      ret

    


   