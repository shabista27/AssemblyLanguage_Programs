%macro iomodule 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

%macro myprintf 1
mov rdi,formatpf
sub rsp,8
movsd xmm0,[%1]
mov rax,1
call printf
add rsp,8
syscall
%endmacro

%macro myscanf 1
mov rdi,formatsf
mov rax,0
mov rsi,%1
call scanf
%endmacro

     %macro exit 0
        mov rax,60
        mov rdi,0
        syscall
        %endmacro
        
section .data
        pf1:db "%1f +i %1f",10,0
        pf2:db "%1f -i %1f",10,0
        fmt dq "0.05f",0xa,0x0
        formatpi:db "%d",10,0
        formatpf:db "%1f",10,0
        formatsf:db "%1f",0
        imaginary db "roots are imaginary",0xa
        menu db 0xa,"Enter value of a,b,c:",0xa
        mlen equ $-menu
        four dq 4.0
        two dq 2.0
        zero dq 0x0
     
section .bss
        A resq 1
        B resq 1
        C resq 1
        desci resq 1
        temp resq 1
        ff1 resq 1
        ff2 resq 1
        
        root1 resq 1  
        ta resq 1
        root2 resq 1
        bs resq 1
        fac resq 1
        rdesci resq 1
        real1 resq 1
        imag1 resq 1
        
section .text
        extern printf
        extern scanf
        global main
        main:
                iomodule 1,1,menu,mlen
                myscanf A
                myscanf B
                myscanf C
                myprintf A
                myprintf B
                myprintf C
                
                fld qword[B]
                fmul st0,st0
                fstp qword[bs]
                
                fld qword[A]
                fmul qword[C]
                fmul qword[four]
                fstp qword[fac]
                
                fld qword[two]
                fmul qword[A]
                fstp qword[ta]
                
                fld qword[bs]
                fsub qword[fac]
                fstp qword[desci]
                
    p:
        btr qword[desci],63
        jnc real_root
        jmp img
        
    real_root:
                finit
                fld qword[desci]
                fsqrt
                fstp qword[rdesci]
                
                fldz
                fsub qword[B]
                fadd qword[rdesci]
                fdiv qword[ta]
                
                fstp qword[root1]
                myprintf root1 
                
                fldz
                fsub qword[B]
                fsub qword[rdesci]
                fdiv qword[ta]
                fstp qword[root2]
                myprintf root2
                exit
              
     img:
                finit
                fld qword[desci]
                fsqrt
                fstp qword[rdesci]
                
                fldz
                fsub qword[B]
                fadd qword[rdesci]
                fdiv qword[ta]
                fstp qword[real1]
                fsub qword[desci]
                fld qword[desci]
                fdiv qword[ta]
                fstp qword[imag1]
                
                mov rdi,ff1
                sub rsp,8
                movq xmm0,[real1]
                movq xmm1,[imag1]
                mov rax,2
                call printf
                add rsp,8
                
                mov rdi,ff2
                sub rsp,8
                movq xmm0,[real1]
                movq xmm1,[imag1]
                mov rax,2
                call printf
                add rsp,8
                exit 
               
                
