%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
        
        %macro exit 0
        mov rax,60
        mov rdi,0
        syscall
        %endmacro
        
section .data 
        nline db 10
        nline_len equ $-nline
        
        welmsg db 10,"Welcome to string operations:-"
        welmsg_len equ $-welmsg
        
        openmsg db 10,"File is opened successfully:-"
        openmsg_len equ $-openmsg
        
        closemsg db 10,"File is closed successfully:-"
        closemsg_len equ $-closemsg
        
        errmsg db 10,"Error in opening the file"
        errmsg_len equ $-errmsg

        charmsg db 10,"Occurence of character i:-"
        charmsg_len equ $-charmsg
        
        newmsg db 10,"No.of lines are:-"
        newmsg_len equ $-newmsg
        
        spacemsg db 10,"No.of spaces are:-"
        spacemsg_len equ $-spacemsg
        
        newline db 0xa
        newline_len equ $-newline
        filename db "jspm.txt"
        
section .bss
        buffer resb 200
        cnt1 resb 8
        cnt2 resb 8
        cnt3 resb 8
        bufferlen resb 8
        fdis resb 8
        ans resb 8
        
section .text
global _start
        _start:
                scall 1,1,welmsg,welmsg_len
                scall 2,filename,2,777
                
                mov qword[fdis],rax
                bt rax,63
                jc error
                scall 1,1,openmsg,openmsg_len
                jmp next
                
         error:
                scall 1,1,errmsg,errmsg_len
                exit
                
         next:
                scall 0,[fdis],buffer,200
                mov qword[bufferlen],rax
                mov qword[cnt1],00
                mov qword[cnt2],00
                mov qword[cnt3],00
                mov rsi,buffer
                
         negate:
                xor rbx,rbx
                mov bl,[rsi]
                cmp bl,20h
                je space
                cmp bl,10
                je newline1
                cmp bl,'i'
                je countI
                inc rsi
                dec byte[bufferlen]
                jnz negate
                jmp end
                
         space:
                inc byte[cnt1]
                inc rsi
                dec byte[bufferlen]
                jnz negate
                
         newline1:
                inc byte[cnt2]
                inc rsi
                dec byte[bufferlen]
                jnz negate
                
         countI:
                inc byte[cnt3]
                inc rsi
                dec byte[bufferlen]
                jnz negate
                
         end:
                scall 1,1,spacemsg,spacemsg_len
                mov rax,[cnt1]
                call display
                
                scall 1,1,newmsg,newmsg_len
                mov rax,[cnt2]
                call display
                
                scall 1,1,charmsg,charmsg_len
                mov rax,[cnt3]
                call display
                exit
                
         display:
                mov rsi,ans+3
                mov rbx,16
                mov rcx,4
                
         back:
                xor rdx,rdx
                div rbx
                cmp dl,09h
                jbe add1
                add dl,07h
                
         add1:
                add dl,30h
                mov [rsi],dl
                inc rsi
                
                dec rcx
                jnz back
                scall 1,1,ans,4
                scall 1,1,newline,newline_len
                ret
                exit
                
