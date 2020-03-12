%macro scall 4
mov eax,%1
mov ebx,%2
mov ecx,%3
mov edx,%4
int 80h
%endmacro

section .data
	rmsg db 10d,13d,"processor is in real mode"
	rlen equ $-rmsg
	pmsg db 10d,13d,"processor is in protected mode"
	plen equ $-pmsg
	gmsg db 10d,13d,"gdt contents are"
	glen equ $-gmsg
	imsg db 10d,13d,"idt contents are"
	ilen equ $-imsg
	lmsg db 10d,13d,"ldt contents are"
	llen equ $-lmsg
	trmsg db 10d,13d,"task resister contents are"
	trlen equ $-trmsg
	mswmsg db 10d,13d,"machine status word contents are"
	mswlen equ $-mswmsg
	col db ':'
	nwline db 10
 
section .bss
	cr0_data resd 1
	gdt resd 1
 	 resw 1
	ldt resw 1
	idt resd 1
	 resw 1
	tr resw 1
	answer resb 04
	
section .text
	GLOBAL _start
	_start:
	smsw eax ;stored machine status word
	mov [cr0_data],eax
	bt eax,1
	jc prmode
	 
	scall 4,1,rmsg,rlen
	jmp next1

prmode: scall 4,1,pmsg,plen
next1:
	sgdt [gdt]
	sldt [ldt]
	sidt [idt]
	str [tr]

	scall 4,1,gmsg,glen
	mov ax,[gdt+4]
	call display
	mov ax,[gdt+2]
	call display	
	scall 4,1,col,1
	mov ax,[gdt]
	call display

	scall 4,1,imsg,ilen
	mov ax,[idt+4]
	call display
	mov ax,[idt+2]
	call display
	scall 4,1,col,1
	mov ax,[idt]
	call display	

	scall 4,1,lmsg,llen
	mov ax,[ldt]
	call display

	scall 4,1,trmsg,trlen
	mov ax,[tr]
	call display

	scall 4,1,mswmsg,mswlen
	mov ax,[cr0_data+2]
	call display

	mov ax,[cr0_data]
	call display

	scall 4,1,nwline,1
	mov eax,1
	mov ebx,0
	int 80h
	
display:
	mov esi,answer+3
	mov ecx,4
	
	cnt:
	mov edx,0
	mov ebx,16h
	div ebx 
	cmp dl,09h
	jbe x
	add dl,07h
	
	x:
	add dl,30h
	mov [esi],dl
	dec esi
	dec ecx
	jnz cnt
	scall 4,1,answer,4
ret
