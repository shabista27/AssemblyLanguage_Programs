section .data
	welmsg db 10, "Coprocessor program"
	welmsg_len equ $-welmsg

	array dd 20.0, 70.3, 30.0
	arrcnt dq 03
	hedec dw 100

	meanmsg db 10, 10, "Mean="
	meanmsg_len equ $-meanmsg
	
	sdmsg db 10, "SD="
	sdmsg_len equ $-sdmsg

	vmsg db 10, "variance="
	vmsg_len equ $-vmsg

section .bss
	mean1 rest 1
	sd1 rest 1
	v1 rest 1
	dispbuff resb 2
	p resq 1
	q resq 1
	w resq 1
	array2 resd 20
	
%macro display 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

section .test
global _start
_start:
	display welmsg, welmsg_len
	finit
	fldz
	mov rcx, [arrcnt]
	mov rbx, array
	mov rsi, 0
	
up1:
	fadd dword[rbx+rsi*4]
	inc rsi
	dec rcx
	jnz up1
	
	fild qword[arrcnt]
	fdiv
	fst qword[p]

	fimul word[hedec]

	display meanmsg, meanmsg_len
	
	mov rsi, mean1+9
	call disp_proc

	mov rcx, [arrcnt]
	mov rbx, array
	mov rsi, 0
	mov rdi, array2

up2:
	fadd dword[rbx+rsi*4]
	fld qword[p]
	fsub
	fst qword[q]
	fld qword[q]
	fmul

	fst dword[rdi]
	add rdi, 4
	inc rsi
	dec rcx
	jnz up2
	fldz

	mov rcx, [arrcnt]
	mov rbx, array2
	mov rsi,0
	
up3:
	fadd dword[rbx+rsi*4]
	inc rsi
	dec rcx
	jnz up3
	
	fild qword[arrcnt]
	fdiv
	fst qword[w]
	fimul word[hedec]
	fbstp[v1]
	display vmsg, vmsg_len
	mov rsi, v1+9
	call disp_proc
	
	fld qword[w]
	fsqrt
	fimul word[hedec]
	fbstp [sd1]
	display sdmsg, sdmsg_len
	mov rsi, sd1+9
	call disp_proc

exit:
	mov rax, 60
	mov rdi, 00
	syscall

disp_proc:
	mov rcx, 09

dresup:
	mov bl, [rsi]
	push rcx
	push rsi
	call disp_proc
	pop rsi
	pop rcx
	dec rsi
	loop dresup
	push rsi
	
	pop rsi
	mov bl, [rsi]
	call disp8_proc
ret

disp8_proc:
	mov rcx, 2
	mov rdi, dispbuff
dup1:
	rol bl, 4
	mov dl, bl
	and dl, 0fH
	cmp dl, 09H
	jbe dskip
	add dl, 07H
dskip:
	add al, 30h
	mov [rdi], al
	inc rdi
	loop dup1

	display dispbuff, 2
ret

	
