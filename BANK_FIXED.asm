
    ;------------------------------------------------------------------------------
    ;###############################  FIXED BANK  #################################
    ;------------------------------------------------------------------------------


ORIGIN          SET FIXED_BANK

                NEWBANK THE_FIXED_BANK
                RORG $f800

    ;------------------------------------------------------------------------------



    DEFINE_SUBROUTINE Reset

                CLEAN_START

Restart     ; go here on RESET + SELECT

                ldx #$ff                    ; adjust stack pointer after RESET + SELECT
                txs

                lda #BANK_Cart_Init             ; 2
                sta SET_BANK                    ; 3
                jsr Cart_Init                   ; 6+x

    ;---------------------------------------------------------------------------

                lda #BANK_BitmapSetup
                sta SET_BANK
                jsr BitmapSetup

                lda #BANK_BitmapDraw
                sta SET_BANK
                jsr BitmapDraw



    ;---------------------------------------------------------------------------

VBlankTime
                .byte VBLANK_TIM_NTSC, VBLANK_TIM_NTSC
                .byte VBLANK_TIM_PAL, VBLANK_TIM_PAL

    ;---------------------------------------------------------------------------


    DEFINE_SUBROUTINE Random
                NEXT_RANDOM
                rts


    ECHO "FREE BYTES IN FIXED BANK = ", $FFFB - *

    ;---------------------------------------------------------------------------
    ; The reset vectors
    ; these must live in the fixed bank (last 2K of any ROM image in TigerVision)

                SEG InterruptVectors
                ORG FIXED_BANK + $7FC
                RORG $7ffC

;               .word Reset           ; NMI        (not used)
                .word Reset           ; RESET
                .word Reset           ; IRQ        (not used)

    ;---------------------------------------------------------------------------
