%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data
title db "-------factorial program-------",0x0A
db "enter the number :",0x0A
title_len equ $-title
factmsg db "Factorial is:",0x0A
factmsg_len equ $-factmsg
cnt db 00H
cnt2 db 02H
num_cnt db 00H

section .bss
number resb 2
factorial resb 8

section .text
global _start
_start:
        scall 1,1,title,title_len
        scall 0,0,number,2

        mov rsi,number
        call AtoH

        mov byte[num_cnt],bl
        dec byte[num_cnt]

        mov rax,00H
        mov al,bl
TOP:
        push rax
        dec rax
        cmp rax,01H
        jnbe TOP

        mov al,01H
FACTLOOP:
        pop rbx
        mul bx
        dec byte[num_cnt]
        jnz FACTLOOP

mov bx,ax
        conversion:
                mov rdi,factorial
                call HtoA_value

        scall 1,1,factmsg,factmsg_len
        scall 1,1,factorial,8

        ;Exit system call
        mov rax,60
        mov rdi,0
        syscall


;------------------------------ascii to hexadecimal conversion---------------
AtoH:
        mov byte[cnt],02H
        mov bx,00H
        
hup:
        rol bl,04
        mov al,byte[rsi]
        cmp al,39H
        jbe HNEXT
        SUB al,07H
HNEXT:
        SUB al,30H
        add bl,al
        INC rsi
        DEC byte[cnt]
        JNZ hup
        ret

;-------------------hex to ascii conversion------------------------
HtoA_value:
        mov byte[cnt2],08H
        
aup1:
        rol ebx,04
        mov cl,bl
        and cl,0FH
        CMP cl,09H
        jbe ANEXT1
        ADD cl,07H
        
ANEXT1:
        ADD cl,30H
        mov byte[rdi],cl
        INC rdi
        dec byte[cnt2]
        JNZ aup1
        ret





























































































