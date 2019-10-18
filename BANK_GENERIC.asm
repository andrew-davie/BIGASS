
    ;------------------------------------------------------------------------------
    ;##############################################################################
    ;------------------------------------------------------------------------------

            NEWBANK GENERIC_BANK_1

    DEFINE_1K_SEGMENT DECODE_LEVEL_SHADOW

            CHECK_HALF_BANK_SIZE "GENERIC_BANK_1 (DECODE_LEVEL)"

    ;------------------------------------------------------------------------------
    ; ... the above is a RAM-copied section -- the following is ROM-only.  Note that
    ; we do not configure a 1K boundary, as we con't really care when the above 'RAM'
    ; bank finishes.  Just continue on from where it left off...
    ;------------------------------------------------------------------------------

    DEFINE_SUBROUTINE Cart_Init ; in GENERIC_BANK_1

    ; Note the variables from the title selection are incredibly transient an can be stomped
    ; at any time.  So they need to be used immediately.


    ; odd usage below is to prevent any possibility of variable stomping/assumptions

                lda #0
                sta SWBCNT                      ; console I/O always set to INPUT
                sta SWACNT                      ; set controller I/O to INPUT
                sta HMCLR

    ; cleanup remains of title screen
                sta GRP0
                sta GRP1

                lda #%00010000              ; 2     double width missile, double width player
                sta NUSIZ0                  ; 3
                sta NUSIZ1

                lda #%100                       ; players/missiles BEHIND BG
                sta CTRLPF

                lda #$FF
                sta BufferedJoystick


    ;-------------------------------------------------------------------------------------

    DEFINE_SUBROUTINE Resync
                RESYNC
Ret             rts

;------------------------------------------------------------------------------

OverscanTime
    .byte OVERSCAN_TIM_NTSC, OVERSCAN_TIM_NTSC
    .byte OVERSCAN_TIM_PAL, OVERSCAN_TIM_NTSC


;------------------------------------------------------------------------------


            CHECK_BANK_SIZE "GENERIC_BANK_1 -- full 2K"
