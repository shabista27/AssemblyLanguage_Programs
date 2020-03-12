section .data 
        nline db 10
        nline_len equ $-nline
        
        ano db 10,"Bubble sort using file operator:-"
        ano_len equ $-ano
        
        filemsg db 10,"Enter filename of input data:-"
        filemsg_len equ $-filemsg
        
        omsg db 10,"sorting using bubble sort operation successful"
        db 10,"output stored in same file:-",10,10
        omsg_len equ $-omsg
        
        errmsg db 10,"error in opening the file"
        errmsg_len equ $-errmsg
        
        err1msg db 10,"Error in writing the file"
        err1msg_len equ $-err1msg 
        
        exitmsg db 10,"Exit from the program"
        exitmsg_len equ $-exitmsg
        
section .bss
        buf resq 1024
        buf_len equ $-buf
        
        filename resq 50
        
        filehandle resq 1
        abuf_len resq 1
        
        array resq 10
        n resq 1
        
        %macro accept 2
        mov rax,0
        mov rdi,0
        mov rsi,%1
        mov rdx,%2
        syscall
        %endmacro
        
        %macro display 2
        mov rax,1
        mov rdi,1
        mov rsi,%1
        mov rdx,%2
        syscall
        %endmacro
        
        %macro fopen 1
        mov rax,2
        mov rdi,%1
        mov rsi,2
        mov rdx,0777
        syscall
        %endmacro
        
        %macro fread 3
        mov rax,0
        mov rdi,%1
        mov rsi,%2
        mov rdx,%3
        syscall
        %endmacro
        
        %macro fclose 1
        mov rax,3
        mov rdi,%1
        syscall
        %endmacro
        
        %macro fwrite 3
        mov rax,1
        mov rdi,%1
        mov rsi,%2
        mov rdx,%3
        syscall
        %endmacro
        
section .text
global _start
       _start:
                display ano,ano_len
                
                display filemsg,filemsg_len
                accept filename,50
                
                dec rax
                mov byte [filename+rax],0
                fopen filename
                
                cmp rax,-1H
                je error
                mov [filehandle],rax
                
                fread [filehandle],buf,buf_len
                dec rax
                mov [abuf_len],rax
                
                call bsort_proc
                jmp exit
                
error:
        display errmsg,errmsg_len
exit:
        display exitmsg,exitmsg_len
        
        mov rax,60
        mov rdi,0
        syscall
        
bsort_proc:
        call buf_array_proc
        
        mov rax,0
        mov rbp,[n]
        dec rbp
        
        mov rcx,0
        mov rdx,0
        mov rsi,0
        mov rdi,0
        mov rcx,0
                
oloop:
        mov rbx,0
        mov rsi,array
        
iloop:
        mov rdi,rsi
        inc rdi
        
        mov al,[rsi]
        cmp al,[rdi]
        jbe next
        
        mov dl,0
        mov dl,[rdi]
        mov [rdi],al
        mov [rsi],dl
        
next:
        inc rsi
        inc rbx
        cmp rbx,rbp
        jb iloop
        
        inc rcx
        cmp rcx,rbp
        jb oloop
        
   fwrite [filehandle],omsg,omsg_len
   fwrite [filehandle],array,[n]
   
   fclose [filehandle]
   
   display omsg,omsg_len
   display array,[n]
   
   ret
   
error1:
        display errmsg,errmsg_len
        ret
        
buf_array_proc:
            mov rcx,0
            mov rsi,0
            mov rdi,0

            mov rcx,[abuf_len]
            mov rsi,buf
            mov rdi,array
            
next_num:
        mov al,[rsi]
        mov [rdi],al
        
        inc rsi
        inc rsi
        inc rdi
        
        inc byte [n]
        dec rcx
        dec rcx
        jnz next_num
        ret
        
      
