
  NEWBANK BIGASS_BITMAP


ICC_Y           = 70
BITMAP_Y        = 3 * ICC_Y

Bitmap

    ; 210 lines
    ; 4 bytes/line


    ; The screen is stored in colour planes, so bytes in the strips are not consecutive on the screen.
    ; use +ICC_Y to skip to each plane

    ;OPTIONAL_PAGEBREAK "Strip_0", BITMAP_Y
Strip_0
    ds BITMAP_Y, %10101010
    ;OPTIONAL_PAGEBREAK "Strip_1", BITMAP_Y
Strip_1
    ds BITMAP_Y, %11111111
    ;OPTIONAL_PAGEBREAK "Strip_2", BITMAP_Y
Strip_2
    ds BITMAP_Y, %11111111
    ;OPTIONAL_PAGEBREAK "Strip_3", BITMAP_Y
Strip_3
    ds BITMAP_Y, %11000011


SPRITE_Y = 24           ; vertical size (ICC lines) of a sprite

SpriteBuffer
    ds 2 * SPRITE_Y * 3


    DEFINE_SUBROUTINE BitmapSetup

        ; mirrored playfield

                lda #1
                sta CTRLPF


                rts



    DEFINE_SUBROUTINE BitmapDraw

                lda #0
                sta COLUBK
                sta PF0

    ; point to the 3-byte colour table, based on PAL/NTSC
    ; TODO - alternative - put the colours in 3 RAM bytes and index directly

                ldx Platform
                lda BitmapColours,x
                sta bitmap_colour_table
                lda BitmapColours+1,x
                sta bitmap_colour_table+1

StartBitmapDraw

                lda #%1110                       ; VSYNC ON
.verticalSync   sta WSYNC
                sta VSYNC
                lsr
                bne .verticalSync               ; branch until VYSNC has been reset

                lda VBlankTime,x
                sta TIM64T

                jsr BitmapTimeSlice

BitmapVB        lda INTIM
                bne BitmapVB
                sta VBLANK

                ldx #ICC_Y-1             ; # ICC lines to draw

BitmapDrawLines

.ICC_LINE SET 0
    REPEAT 3            ;# ICC triplet

                lda NTSC_Colours + .ICC_LINE        ; TODO - PAL/NTSC in var
                sta WSYNC
                sta COLUPF                      ; 3

    ; Note that there may be page crossings here. Hopefully we don't care...
    ; TODO figure timing for mirrored PF writes

                lda Strip_0 + .ICC_LINE,x       ; 5
                sta PF1                         ; 3     @11
                lda Strip_1 + .ICC_LINE,x       ; 5
                sta PF2                         ; 3     @19
                lda Strip_3 + .ICC_LINE,x       ; 5
                sta PF1                         ; 3     @27
                lda Strip_2 + .ICC_LINE,x       ; 5
                sta PF2                         ; 3     @35

    ; Other stuff
    ; couple of sprite writes... well....?
    ; sprite colours

.ICC_LINE SET .ICC_LINE + ICC_Y
    REPEND

                dex                             ; 2
                bpl BitmapDrawLines             ; 2(3)      @ 40 when taken  + stuff @ start of loop = 47

                lda #0
                sta PF1
                sta PF2

                ldx Platform
                lda BitmapOverscanTime,x
                sta TIM64T

                jsr BitmapTimeSlice

BitmapOverscan  lda INTIM
                bne BitmapOverscan

                lda #%01000010                  ; bit6 is not required
                sta VBLANK                      ; end of screen - enter blanking

                jmp StartBitmapDraw

                rts

BitmapTimeSlice       ; TODO
                rts



BitmapOverscanTime
                .byte 23, 23                    ; NTSC
                .byte 33, 33                    ; PAL


BitmapColours   .word NTSC_Colours, NTSC_Colours
                .word PAL_Colours, PAL_Colours

NTSC_Colours    .byte $A4, $98, $C6         ; TODO
PAL_Colours     .byte $96, $56, $A6         ; TODO
