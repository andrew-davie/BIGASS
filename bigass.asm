
TIA_BASE_ADDRESS = $40

                processor 6502
                include "vcs.h"
                include "macro.h"

ORIGIN          SET 0
ORIGIN_RAM      SET 0

;FIXED_BANK             = 3 * 2048           ;-->  8K ROM tested OK
;FIXED_BANK              = 7 * 2048          ;-->  16K ROM tested OK
FIXED_BANK             = 15 * 2048           ; ->> 32K
;FIXED_BANK             = 31 * 2048           ; ->> 64K
;FIXED_BANK             = 239 * 2048         ;--> 480K ROM tested OK (KK/CC2 compatibility)
;FIXED_BANK             = 127 * 2048         ;--> 256K ROM tested OK
;FIXED_BANK             = 255 * 2048         ;--> 512K ROM tested OK (CC2 can't handle this)

YES                     = 1
NO                      = 0

;-------------------------------------------------------------------------------

COMPILE_ILLEGALOPCODES          = 1
RESERVED_FOR_STACK              = 12            ; bytes guaranteed not overwritten by variable use


SET_BANK                    = $3F               ; write address to switch ROM banks
SET_BANK_RAM                = $3E               ; write address to switch RAM banks

RAM_3E                      = $1000
RAM_SIZE                    = $400
RAM_WRITE                   = $400              ; add this to RAM address when doing writes

RND_EOR_VAL                 = $b4


; Platform constants:
PAL                 = %10
PAL_50              = PAL|0
PAL_60              = PAL|1


VBLANK_TIM_NTSC     = 48                        ; NTSC 276 (Desert Falcon does 280, so this should be pretty safe)
VBLANK_TIM_PAL      = 85 ;85                        ; PAL 312 (we could increase this too, if we want to, but I suppose the used vertical screen size would become very small then)

OVERSCAN_TIM_NTSC   = 35 ;24 ;51                        ; NTSC 276 (Desert Falcon does 280, so this should be pretty safe)
OVERSCAN_TIM_PAL    = 41                        ; PAL 312 (we could increase this too, if we want to, but I suppose the used vertical screen size would become very small then)

SCANLINES_NTSC      = 276                       ; NTSC 276 (Desert Falcon does 280, so this should be pretty safe)
SCANLINES_PAL       = 312

;------------------------------------------------------------------------------
; MACRO definitions


ROM_BANK_SIZE               = $800

            MAC NEWBANK ; bank name
                SEG {1}
                ORG ORIGIN
                RORG $F000
BANK_START      SET *
{1}             SET ORIGIN / 2048
ORIGIN          SET ORIGIN + 2048
_CURRENT_BANK   SET {1}
            ENDM

            MAC DEFINE_1K_SEGMENT ; {seg name}
                ALIGN $400
SEGMENT_{1}     SET *
BANK_{1}        SET _CURRENT_BANK
            ENDM

            MAC CHECK_BANK_SIZE ; name
.TEMP = * - BANK_START
    ECHO {1}, "(2K) SIZE = ", .TEMP, ", FREE=", ROM_BANK_SIZE - .TEMP
#if ( .TEMP ) > ROM_BANK_SIZE
    ECHO "BANK OVERFLOW @ ", * - ORIGIN
    ERR
#endif
            ENDM


            MAC CHECK_HALF_BANK_SIZE ; name
    ; This macro is for checking the first 1K of ROM bank data that is to be copied to RAM.
    ; Note that these ROM banks can contain 2K, so this macro will generally go 'halfway'
.TEMP = * - BANK_START
    ECHO {1}, "(1K) SIZE = ", .TEMP, ", FREE=", ROM_BANK_SIZE/2 - .TEMP
#if ( .TEMP ) > ROM_BANK_SIZE/2
    ECHO "HALF-BANK OVERFLOW @ ", * - ORIGIN
    ERR
#endif
            ENDM


            MAC OVERLAY ; {name}
    SEG.U OVERLAY_{1}
    org Overlay
            ENDM

    ;--------------------------------------------------------------------------

    MAC VALIDATE_OVERLAY
        LIST OFF
        #if * - Overlay > OVERLAY_SIZE
            ECHO "Overlay ", {1}, "too big"
            ERR
        #endif
        LIST ON
    ENDM

    ;--------------------------------------------------------------------------
    ; Macro inserts a page break if the object would overlap a page

    MAC OPTIONAL_PAGEBREAK ; { string, size }
        LIST OFF
        IF (>( * + {2} -1 )) > ( >* )
EARLY_LOCATION  SET *
            ALIGN 256
            ECHO "PAGE BREAK INSERTED FOR ", {1}
            ECHO "REQUESTED SIZE = ", {2}
            ECHO "WASTED SPACE = ", *-EARLY_LOCATION
            ECHO "PAGEBREAK LOCATION = ", *
        ENDIF
        LIST ON
    ENDM


    MAC CHECK_PAGE_CROSSING
        LIST OFF
#if ( >BLOCK_END != >BLOCK_START )
    ECHO "PAGE CROSSING @ ", BLOCK_START
#endif
        LIST ON
    ENDM

    MAC CHECKPAGE
        LIST OFF
        IF >. != >{1}
            ECHO ""
            ECHO "ERROR: different pages! (", {1}, ",", ., ")"
            ECHO ""
        ERR
        ENDIF
        LIST ON
    ENDM

    MAC CHECKPAGEX
        LIST OFF
        IF >. != >{1}
            ECHO ""
            ECHO "ERROR: different pages! (", {1}, ",", ., ") @ {0}"
            ECHO {2}
            ECHO ""
        ERR
        ENDIF
        LIST ON
    ENDM


    MAC CHECKPAGE_BNE
        LIST OFF
        IF 0;>(. + 2) != >{1}
            ECHO ""
            ECHO "ERROR: different pages! (", {1}, ",", ., ")"
            ECHO ""
            ERR
        ENDIF
        LIST ON
            bne     {1}
    ENDM

    MAC CHECKPAGE_BPL
        LIST OFF
        IF (>(.+2 )) != >{1}
            ECHO ""
            ECHO "ERROR: different pages! (", {1}, ",", ., ")"
            ECHO ""
            ERR
        ENDIF
        LIST ON
            bpl     {1}
    ENDM

  MAC ALIGN_FREE
FREE SET FREE - .
    align {1}
FREE SET FREE + .
    echo "@", ., ":", FREE
  ENDM

    ;--------------------------------------------------------------------------

    MAC VECTOR              ; just a word pointer to code
        .word {1}
    ENDM


    MAC DEFINE_SUBROUTINE               ; name of subroutine
BANK_{1}        = _CURRENT_BANK         ; bank in which this subroutine resides
                SUBROUTINE              ; keep everything local
{1}                                     ; entry point
    ENDM



    ;--------------------------------------------------------------------------

    MAC NEWRAMBANK ; bank name
                SEG.U {1}
                ORG ORIGIN_RAM
                RORG RAM_3E
BANK_START      SET *
{1}             SET ORIGIN_RAM / RAM_SIZE
ORIGIN_RAM      SET ORIGIN_RAM + RAM_SIZE
    ENDM

    MAC VALIDATE_RAM_SIZE
        #if * - RAM_3E > RAM_SIZE
            ERR
        #endif
    ENDM

    MAC NEXT_RANDOM
; update random value:
                lda rnd                                         ; 3
                lsr                                             ; 2
        IFCONST rndHi
                ror rndHi                                       ; 5     16 bit LFSR
        ENDIF
                bcc .skipEOR                                    ; 2/3
                eor #RND_EOR_VAL                                ; 2
.skipEOR
                sta rnd                                         ; 3 = 14/19
    ENDM

    MAC RESYNC
; resync screen, X and Y == 0 afterwards
                lda #%10                        ; make sure VBLANK is ON
                sta VBLANK

                ldx #8                          ; 5 or more RESYNC_FRAMES
.loopResync
                VERTICAL_SYNC

                ldy #SCANLINES_NTSC/2 - 2
                lda Platform
                eor #PAL_50                     ; PAL-50?
                bne .ntsc
                ldy #SCANLINES_PAL/2 - 2
.ntsc
.loopWait
                sta WSYNC
                sta WSYNC
                dey
                bne .loopWait
                dex
                bne .loopResync
    ENDM

    MAC SET_PLATFORM
; 00 = NTSC
; 01 = NTSC
; 10 = PAL-50
; 11 = PAL-60
                lda SWCHB
                rol
                rol
                rol
                and #%11
                eor #PAL
                sta Platform                    ; P1 difficulty --> TV system (0=NTSC, 1=PAL)
    ENDM


;------------------------------------------------------------------------------


    #include "zeropage.asm"


;------------------------------------------------------------------------------
; OVERLAYS!
; These variables are overlays, and should be managed with care
; That is, variables are ALREADY DEFINED, and we're reusing RAM for other purposes

; EACH OF THESE ARE VARIABLES (TEMPORARY) USED BY ONE ROUTINE (AND IT'S SUBROUTINES)
; THAT IS, LOCAL VARIABLES.  USE 'EM FREELY, THEY COST NOTHING

; TOTAL SPACE USED BY ANY OVERLAY GROUP SHOULD BE <= SIZE OF 'Overlay'



    OVERLAY TitleScreen
title_colour_table           ds 2
    VALIDATE_OVERLAY "TitleScreen"

    OVERLAY BitmapHandler
bitmap_colour_table             ds 2
    VALIDATE_OVERLAY "BitmapHandler"


    ;------------------------------------------------------------------------------
    ;##############################################################################
    ;------------------------------------------------------------------------------

                NEWRAMBANK BANK_DRAW_BUFFERS
; VARS DEFINED IN ROM_SHADOW_OF_BANK_DRAW_BUFFERS
; SELF-MODIFYING SUBROUTINES MAY BE PRESENT IN THIS BANK TOO!
                VALIDATE_RAM_SIZE

    ;------------------------------------------------------------------------------
    ;##############################################################################
    ;------------------------------------------------------------------------------

;ORIGIN      SET 0

            include "BANK_GENERIC.asm"
            include "titleScreen.asm"
            include "BANK_INITBANK.asm"         ; MUST be after banks that include levels -- otherwise MAX_LEVELBANK is not calculated properly
            include "bitmap.asm"

    ; MUST BE LAST...
            include "BANK_FIXED.asm"

            ;END
