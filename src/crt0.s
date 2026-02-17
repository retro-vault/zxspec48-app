        ;; crt0.s
        ;; 
        ;; zx spectrum 48K ram startup code
        ;;
        ;; MIT License (see: LICENSE)
        ;; Copyright (C) 2021 Tomaz Stih
        ;;
        ;; 2021-06-16   tstih
        .module crt0
        .globl  ___sdcc_heap_init
        .globl  ___sdcc_heap
        .globl  ___sdcc_heap_end
        .globl  _putchar
        .globl  _getchar
        
        .area   _CODE

        ld      (#__store_sp),sp        ; store current stack pointer
        ld      sp,#__stack             ; load new stack pointer

        ;; store all regs
        push    af
        push    bc
        push    de
        push    hl
        push    ix
        push    iy
        ex      af, af'
        push    af
        exx
        push    bc
        push    de
        push    hl

        ;; open stream channel so stdio output goes to screen
        ld      iy,#0x5c3a
        ld      a,#2
        call    0x1601

        call    gsinit                  ; call SDCC init code

        ;; call C main function
        call    _main			

        ;; restore all regs
        pop     hl
        pop     de
        pop     bc
        pop     af
        exx
        ex      af,af'
        pop     iy
        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af

        ld      sp,(#__store_sp)        ; restore original stack pointer

        ;; return to wherever you were called from
        ret	

        ;; SDCC library support:
        ;; provide putchar/getchar hooks used by z80 stdio.
_putchar::
        ld      a,l
        cp      #0x0a
        jr      nz, putchar_emit
        ld      a,#0x0d
putchar_emit:
        push    iy
        ld      iy,#0x5c3a
        rst     0x10
        pop     iy
        ld      l,a
        ld      h,#0x00
        ret

_getchar::
        push    iy
        ld      iy,#0x5c3a
        call    0x15e6
        pop     iy
        cp      #0x0d
        jr      nz, getchar_done
        ld      a,#0x0a
getchar_done:
        ld      l,a
        ld      h,#0x00
        ret

        ;;	(linker documentation:) where specific ordering is desired - 
        ;;	the first linker input file should have the area definitions 
        ;;	in the desired order
        .area   _GSINIT
        .area   _GSFINAL	
        .area   _HOME
        .area   _INITIALIZER
        .area   _INITFINAL
        .area   _INITIALIZED
        .area   _DATA
        .area   _BSS
        .area   _HEAP
        .area   _HEAP_END

        ;;	this area contains data initialization code.
        .area _GSINIT
gsinit:	
        call    ___sdcc_heap_init

        ;; initialize vars from initializer
        ld      de, #s__INITIALIZED
        ld      hl, #s__INITIALIZER
        ld      bc, #l__INITIALIZER
        ld      a, b
        or      a, c
        jr      z, gsinit_none
        ldir
gsinit_none:
        .area _GSFINAL
        ret

        .area _DATA
        .area _BSS
        ;; this is where we store the stack pointer
__store_sp:	
        .word 1
        ;; 512 bytes of stack.
        .ds	512
__stack::
        .area _HEAP
___sdcc_heap::
        .area _HEAP_END
___sdcc_heap_end = 0xffff
