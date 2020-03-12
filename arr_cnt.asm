Section .data
title: db "Count of positive and negavite Numbers in an array" ,0x0A
title_len: equ $-title
pos_msg : db "Positive count: " ,0x0A
pos_len: equ $-pos_msg
neg_msg : db "Negative count :" ,0x0A
neg_len: equ $-neg_msg
newline: db 0x0A

array: dw 10,20,30,-10,-20 ;array declaration and initialization
arrcnt: equ 5 ;static array count
pcnt: dw 0   ;positive number count
ncnt dw 0	;negative number count


Section .bss
dis_buffer :resb 2

%macro print 2
mov rax, 1 
mov rdi, 1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

Section .text

global _start
_start:

print title,title_len
mov rsi, array
mov rcx, arrcnt


UP:
  bt word[rsi], 15  ; 15 is sign bit || bt- bit test
  JNC PNEXT
  inc byte[ncnt]
  JMP PSKIP

PNEXT: inc byte[pcnt]

PSKIP: 
inc rsi
inc rsi
loop UP

;Positive count msg display 
   print pos_msg,pos_len
   mov bl,[pcnt]
   CALL HEX_ASCII
   print newline,1

   print neg_msg,neg_len
   mov bl,[ncnt]
   CALL HEX_ASCII

    print newline,1


      mov rax, 60
       mov rdi, 0
        syscall



;hex to ascii procedure
HEX_ASCII:
mov rcx,02
mov rdi ,dis_buffer
dup:
rol bl,04
mov al,bl
and al, 0fh
cmp al,09h
jbe next
add al, 07h
next:
add al,30h
mov [rdi],al
inc rdi
;dec rcs
loop dup

print dis_buffer,2
syscall

ret

