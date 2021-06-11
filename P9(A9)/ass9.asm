%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data 
msg1 db 10,"src blk",10,13                              ;initialing the display message 
msg1len equ $-msg1                                        ;initializing the lenth of message 
msg2 db 10,"dest blk",10,13 
msg2len equ $-msg2 
srcblk db 10h,20h,30h,40h,50h                        ;storing variables in source block 
cnt equ 05h                                                       ;count is equal to 5 as 5 variables declared 
space db " "                                                       ;space between the variables to be displayed 
spacelen equ $-space                                         ;initializing length of space 

section .bss                                                         ;storing the array of data/reserving space for the data 
ans resb 4                                                            ;reserve buffer ans of 4-bytes(8-bits each) 
destblk resb 5                                                     ;reserve buffer destblk of 5-bytes 

section .text 
global  _start                                                       ;starting of the main program 
_start: 
	print msg1,msg1len                                ;displaying the msg1 
 	 mov rsi,srcblk                                        ;move contents of source blk to rsi 
	call disp_block                                        ;calling procedure disp_block 
	cld                                                            ;clear direction flag 
	mov rcx,02h                                             ; move 02h into rcx register
	mov rsi,srcblk                                          ;move contents of the source blk to the rsi 
	mov rdi,destblk                                     ;shift 2 positions in the source blk and move the                                                                                                            
                                                                             ;contents in to rdi 
   
	rep movsb                                              ;repeat move string byte 
    mov rcx,03h                                             ; move 02h into rcx register
	mov rsi,srcblk                                          ;move contents of the source blk to the rsi 
	mov rdi,destblk+2	
    rep movsb
print msg2,msg2len                                 ;displaying the msg2 
	mov rsi,destblk                                        ;move contents of destblk into rsi 
	call disp_block                                        ;calling procedure disp_block 
	mov rax,60                                              ;exit system call 
	xor rdi,rdi                                                ;clearing rdi(by using xor)so that we get 0 in destblk 
	syscall                                                      ;interrupt for kernel in 64-bit 

disp_block:                                                          ;procedure disp_block 
	   mov rbp,cnt                                          ;base pointers 
back:     
	mov al,[rsi]                                              ;move contents of rsi to al 
	push rsi                                                   ;push contents of rsi 
	call disp_8                                               ;calling the disp_8 procedure 
	print space,1                                            ;intialize one byte foe space                    
	pop rsi                                                     ;pop contents of rsi 
	 inc rsi                                                     ;increment rsi by 1 
	 dec rbp                                                   ;decrement cnt through rbp 
	 jnz back                                                  ;jump to loop back if not zero 
	 ret                                                           ;return 

disp_8:	                                                                ;procedure disp_8 
 	mov rsi,ans+1                                         ; move the contents of ans buffer into rsi
	   mov rcx,2                                            ;move 2 into the rcx register

back1:	                                                              ;loop back1
 	   mov rdx,0                                            ;clear rdx
	   mov rbx,16                                          ;move 16 into rbx register
	   div rbx                                                 ;divide rax rfegister by rbx register
	   cmp dl,09h                                          ;compare the contents of dl register with 09h
	   jbe add_30                                          ;if compared value is below(less) than add 30h 
	   add dl ,07h                                          ;add 07h to dl register
	   
add_30:	                                                   ;add_30 label
               add dl,30h	                                       ;add 30h to the contents of dl register 
	   mov[rsi],dl                                         ;move contents of dl into rsi
	   dec rsi                                                ;decrement rsi
	   dec rcx                                               ;decrement rcx
	   jnz back1                                           ;jump if not zero to loop back1
	   print ans,2                                         ;print the result
	   ret  
