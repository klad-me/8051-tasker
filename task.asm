		.module task
		
		
		.area   OSEG(OVR,DATA)
		
_taskCreate_PARM_2::
		.ds		2
		
		
		.area	DSEG(DATA)
		
currentTCB:
		.ds		2
		
schedulerSP:
		.ds		1
		
		
		
		.area	CSEG(CODE)
		
		
		
; Create TCB for task
;  DPTR   - TCB
;  PARM_2 - task code
_taskCreate::
		mov		A, #2					; saving stack usage
		movx	@DPTR, A
		inc		DPTR
		
		mov		A, _taskCreate_PARM_2+0	; saving task code
		movx	@DPTR, A
		inc		DPTR
		mov		A, _taskCreate_PARM_2+1
		movx	@DPTR, A
		
		ret
		
		
; Run task from TCB
;  DPTR - TCB
_taskRun::
		clr		EA						; disabling interrupts
		
		mov		currentTCB+0, DPL		; saving TCB
		mov		currentTCB+1, DPH
		
		mov		schedulerSP, SP			; saving scheduler's SP
		
		movx	A, @DPTR				; reading stack usage to R2
		mov		R2, A
		inc		DPTR
		
		mov		R0, SP					; R0 - stack pointer
		mov		R1, A					; R1 - stack usage counter
		
1$:		inc		R0						; copying stack
		movx	A, @DPTR
		inc		DPTR
		mov		@R0, A
		djnz	R1, 1$
		
		mov		A, R2					; shifting SP to stack top
		add		A, SP
		mov		SP, A
		
		setb	EA						; enabling interrupts
		
		ret								; starting task
		
		
; Return to taskRun() caller
_taskYield::
		clr		EA						; disabling interrupts
		
		mov		DPL, currentTCB+0		; DPTR=currentTCB
		mov		DPH, currentTCB+1
		
		mov		A, SP					; calculating stack usage
		clr		C
		subb	A, schedulerSP
		
		movx	@DPTR, A				; saving stack usage
		inc		DPTR
		
		mov		R0, schedulerSP			; R0 - stack pointer
		mov		R1, A					; R1 - stack usage counter
		
1$:		inc		R0						; copying stack
		mov		A, @R0
		movx	@DPTR, A
		inc		DPTR
		djnz	R1, 1$
		
		mov		SP, schedulerSP			; restoring scheduler's SP
		
		ret								; returning to scheduler
