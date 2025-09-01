;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Linux)
;--------------------------------------------------------
	.module main
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _cclear
	.globl _cputs
	.globl _cinit
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
	G$main$0$0	= .
	.globl	G$main$0$0
	C$main.c$6$0_0$3	= .
	.globl	C$main.c$6$0_0$3
;main.c:6: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	C$main.c$7$1_0$3	= .
	.globl	C$main.c$7$1_0$3
;main.c:7: cinit();
	call	_cinit
	C$main.c$9$1_0$3	= .
	.globl	C$main.c$9$1_0$3
;main.c:9: cclear();
	call	_cclear
	C$main.c$11$1_0$3	= .
	.globl	C$main.c$11$1_0$3
;main.c:11: cputs("hello world\nagain!");
	ld	hl, #___str_0
	C$main.c$17$1_0$3	= .
	.globl	C$main.c$17$1_0$3
;main.c:17: }
	C$main.c$17$1_0$3	= .
	.globl	C$main.c$17$1_0$3
	XG$main$0$0	= .
	.globl	XG$main$0$0
	jp	_cputs
Fmain$__str_0$0_0$0 == .
___str_0:
	.ascii "hello world"
	.db 0x0a
	.ascii "again!"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
