CODE SEGMENT

ASSUME CS:CODE, DS:DATA, ES:NOTHING, SS:AStack

outputAL 	PROC 
		push AX
		push BX
		push CX
	
		mov AH, 09h
		mov BH, 0
		mov CX, 1
		int 10h

		pop CX
		pop BX
		pop AX
		ret
outputAL 	ENDP

SaveCurs  PROC
		push AX
		push BX

		mov AH, 03h
		mov BH, 0
		int 10h

		pop BX
		pop AX
		ret
SaveCurs  ENDP

SetCurs  PROC
		push AX
		push BX

		mov AH, 02h
		mov BH, 0
		int 10h
		
		pop BX
		pop AX
		ret
SetCurs  ENDP


MY_INTERRUPT PROC FAR
		jmp start
		KEY DW 1274h
		KEEP_IP DW 0 
		KEEP_CS DW 0 
		KEEP_PSP  dw 0
		KEEP_SS dw 0
		KEEP_SP dw 0
		KEEP_AX dw	0
		count db 48
		
		my_stack dw 200 dup(?)

		MY_INTERRUPT_STACK_TOP:


		start:
		
		mov 	KEEP_SS, ss 
		mov 	KEEP_SP, sp 
		mov 	KEEP_AX, ax 
		
		mov 	ax, seg my_stack 
		mov 	ss, ax 
		mov 	sp, offset MY_INTERRUPT_STACK_TOP
		
		push AX
		push BX
		push CX
		push DX
		push ES

		inc count
		cmp count, 57 
		jne show
		mov count, 48
	show:
		
		call SaveCurs
		mov CX, DX

		mov DH, 23
		mov Dl, 33
		call SetCurs
		push AX
		mov AL, count
		call OutputAL
		pop AX
		
		mov DX, CX
		call SetCurs

		mov AL, 20h
		out 20h, AL

		pop	ES
		pop DX
		pop CX
		pop BX
		pop AX

			
		mov		sp, KEEP_SP
		mov		ax, KEEP_SS
		mov		ss, ax
		mov		ax, KEEP_AX
		
		mov		al, 20h
		out		20h, al
				
		iret 	
MY_INTERRUPT 	ENDP
LAST_BYTE:


CHECK PROC
		push BX
		push DX
		push SI
		push ES

		mov AH, 35h
		mov AL, 1Ch
		int 21h

		lea SI, KEY
		sub SI, offset MY_INTERRUPT 

		mov AX, 1
		mov BX, ES:[BX+SI]
		cmp BX, KEY
		je CHECK_INT_END
		mov AX, 0

		CHECK_INT_END:
		pop ES
		pop SI
		pop DX
		pop BX
		ret


CHECK ENDP

CHECK_UN PROC
		cmp byte ptr ES:[82h], '/'
		jne CHECK_TAIL_END
		cmp byte ptr ES:[83h], 'u'
		jne CHECK_TAIL_END
		cmp byte ptr ES:[84h], 'n'
		jne CHECK_TAIL_END
		mov BX, 1
		CHECK_TAIL_END:
		ret
CHECK_UN ENDP

UNLOAD PROC 
		push	ax
		push	bx
		push	dx
		push	es
		push	si
		
		cli

		mov		ah, 35h
		mov		al, 1Ch
		int		21h

		mov		si, offset KEEP_IP
		sub		si, offset MY_INTERRUPT 
	
		
	
		
		push	ds
		mov		dx, es:[bx+si]
		mov		ax, es:[bx+si+2]
		mov		ds, ax
		mov		ah, 25h
		mov		al, 1Ch
		int		21h
		pop		ds
		
		
		mov		ax, es:[bx+si+4]
		mov		es, ax
		push	es
		mov		ax, es:[2Ch]
		mov		es, ax
		mov		ah, 49h
		int		21h
		
		pop		es
		mov		ah, 49h
		int		21h
		sti

		pop		si
		pop		es
		pop		dx
		pop		bx
		pop		ax
		ret

UNLOAD ENDP



LOAD PROC	
		push ax
		push bx
		push es
		push dx

		mov AH, 35h
		mov AL, 1Ch 
		int 21h
		mov KEEP_IP , BX
		mov KEEP_CS , ES


		push DS
		mov DX, offset MY_INTERRUPT 
		mov AX, seg MY_INTERRUPT 	    
		mov DS, AX
		mov AH, 25h		 
		mov AL, 1Ch         	
    		int 21h
		pop ds

		mov DX,offset LAST_BYTE
		mov CL,4
		shr DX,CL
		inc DX
		add dx,10h
		mov AH,31h
		int 21h

		pop dx
		pop es
		pop bx
		pop ax

		ret
LOAD ENDP

Write_message	PROC
		push AX
		mov AH, 09h
		int 21h
		pop AX
		ret
Write_message		ENDP

MAIN PROC
		PUSH DS
		SUB AX, AX
		SUB BX, BX
		PUSH AX
		MOV AX, DATA
		MOV DS, AX
		
		mov KEEP_PSP, ES
		
		call CHECK
		call CHECK_UN

		cmp BX, 1
		je unload_point

		cmp AX, 1
		je end_point3
	
		
		load_point:
		lea dx, LOAD_String
		call Write_message
		call LOAD
		jmp end_point
		
		unload_point:
		cmp AX, 0
		je end_point2
	
		lea dx, UNLOAD_String
		call Write_message
		call UNLOAD
		jmp end_point

		end_point3:
		lea dx, LOAD_String2
		call Write_message

		jmp end_point
		
		end_point2:
		lea dx, UNLOAD_String2
		call Write_message


		end_point:
		
		
				

		xor AL, AL
		mov AH, 4Ch
		int 21h


MAIN ENDP

CODE ENDS

DATA SEGMENT
	LOAD_String db "Interruption is loaded now",0dh,0ah,'$'
	UNLOAD_String db "Interruption is unloaded  now",0dh,0ah,'$'
	LOAD_String2 db "The interrupt was already loaded",0dh,0ah,'$'
	UNLOAD_String2 db "The interrupt was already unloaded",0dh,0ah,'$'


DATA ENDS

AStack SEGMENT STACK
	DW 200 DUP(?)
AStack ENDS

END MAIN
