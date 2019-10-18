;    Sokoboo - a Sokoban implementation
;    using a generic tile-based display engine for the Atari 2600
;    Sokoban (倉庫番)™ is © Falcon Co., Ltd.
;
;    Code related to this Sokoban™ implementation was developed by Andrew Davie.
;
;    Code related to the generic tile-based display engine was developed by
;    Andrew Davie and Thomas Jentzsch during 2003-2011 and is
;    Copyright(C)2003-2019 Thomas Jentzsch and Andrew Davie - contacts details:
;    Andrew Davie (andrew@taswegian.com), Thomas Jentzsch (tjentzsch@yahoo.de).
;
;    Code related to music and sound effects uses the TIATracker music player
;    Copyright 2016 Andre "Kylearan" Wichmann - see source code in the "sound"
;    directory for Apache licensing details.
;
;    Some level data incorporated in this program were created by Lee J Haywood.
;    See the copyright notices in the License directory for a list of level
;    contributors.
;
;    Except where otherwise indicated, this software is released under the
;    following licensing arrangement...
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;    see https://www.gnu.org/licenses/gpl-3.0.en.html

;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.

; level definitions
; Sample level definitions.
; Any level can be in any bank.  System auto-calculates required bank buffer size in RAM.
; have as many banks as you like.

  NEWBANK LEVELS_TABLES


; The ordering here corresponds to the ordering when playing...

    align 256
    DEFINE_SUBROUTINE LevelInfoLO
     .byte <(LEVEL__001_L-1)
     .byte <(LEVEL__001_R-1)
     .byte <(LEVEL__002_L-1)
     .byte <(LEVEL__002_R-1)
     .byte <(LEVEL__003_L-1)
     .byte <(LEVEL__003_R-1)
     .byte <(LEVEL__004_L-1)
     .byte <(LEVEL__004_R-1)
     .byte <(LEVEL__005_L-1)
     .byte <(LEVEL__005_R-1)
     .byte <(LEVEL__006_L-1)
     .byte <(LEVEL__006_R-1)
     .byte <(LEVEL__007_L-1)
     .byte <(LEVEL__007_R-1)
     .byte <(LEVEL__008_L-1)
     .byte <(LEVEL__008_R-1)
     .byte <(LEVEL__009_L-1)
     .byte <(LEVEL__009_R-1)
     .byte <(LEVEL__010_L-1)
     .byte <(LEVEL__010_R-1)
     .byte <(LEVEL__011_L-1)
     .byte <(LEVEL__011_R-1)
     .byte <(LEVEL__012_L-1)
     .byte <(LEVEL__012_R-1)
     .byte <(LEVEL__013_L-1)
     .byte <(LEVEL__013_R-1)
     .byte <(LEVEL__014_L-1)
     .byte <(LEVEL__014_R-1)
     .byte <(LEVEL__015_L-1)
     .byte <(LEVEL__015_R-1)
     .byte <(LEVEL__016_L-1)
     .byte <(LEVEL__016_R-1)
     .byte <(LEVEL__017_L-1)
     .byte <(LEVEL__017_R-1)
     .byte <(LEVEL__018_L-1)
     .byte <(LEVEL__018_R-1)
     .byte <(LEVEL__019_L-1)
     .byte <(LEVEL__019_R-1)


MAX_LEVEL = * - LevelInfoLO
    ECHO MAX_LEVEL, "LEVELS INSTALLED"

    align 256
    DEFINE_SUBROUTINE LevelInfoHI

     .byte >(LEVEL__001_L-1)
     .byte >(LEVEL__001_R-1)
     .byte >(LEVEL__002_L-1)
        .byte >(LEVEL__002_R-1)
        .byte >(LEVEL__003_L-1)
        .byte >(LEVEL__003_R-1)
     .byte >(LEVEL__004_L-1)
     .byte >(LEVEL__004_R-1)
     .byte >(LEVEL__005_L-1)
     .byte >(LEVEL__005_R-1)
     .byte >(LEVEL__006_L-1)
     .byte >(LEVEL__006_R-1)
     .byte >(LEVEL__007_L-1)
     .byte >(LEVEL__007_R-1)
     .byte >(LEVEL__008_L-1)
     .byte >(LEVEL__008_R-1)
     .byte >(LEVEL__009_L-1)
     .byte >(LEVEL__009_R-1)
     .byte >(LEVEL__010_L-1)
     .byte >(LEVEL__010_R-1)
     .byte >(LEVEL__011_L-1)
     .byte >(LEVEL__011_R-1)
     .byte >(LEVEL__012_L-1)
     .byte >(LEVEL__012_R-1)
     .byte >(LEVEL__013_L-1)
     .byte >(LEVEL__013_R-1)
     .byte >(LEVEL__014_L-1)
     .byte >(LEVEL__014_R-1)
     .byte >(LEVEL__015_L-1)
     .byte >(LEVEL__015_R-1)
     .byte >(LEVEL__016_L-1)
     .byte >(LEVEL__016_R-1)
     .byte >(LEVEL__017_L-1)
    .byte >(LEVEL__017_R-1)
    .byte >(LEVEL__018_L-1)
    .byte >(LEVEL__018_R-1)
    .byte >(LEVEL__019_L-1)
    .byte >(LEVEL__019_R-1)

    IF (* - LevelInfoHI != MAX_LEVEL)
        ECHO "ERROR: Incorrect LevelInfoHI table!"
        ERR
    ENDIF

    align 256
    DEFINE_SUBROUTINE LevelInfoBANK

    .byte BANK_LEVEL__001_L
    .byte BANK_LEVEL__001_R
    .byte BANK_LEVEL__002_L
    .byte BANK_LEVEL__002_R
    .byte BANK_LEVEL__003_L
    .byte BANK_LEVEL__003_R
    .byte BANK_LEVEL__004_L
    .byte BANK_LEVEL__004_R
    .byte BANK_LEVEL__005_L
    .byte BANK_LEVEL__005_R
    .byte BANK_LEVEL__006_L
    .byte BANK_LEVEL__006_R
    .byte BANK_LEVEL__007_L
    .byte BANK_LEVEL__007_R
    .byte BANK_LEVEL__008_L
    .byte BANK_LEVEL__008_R
    .byte BANK_LEVEL__009_L
    .byte BANK_LEVEL__009_R
    .byte BANK_LEVEL__010_L
    .byte BANK_LEVEL__010_R
    .byte BANK_LEVEL__011_L
    .byte BANK_LEVEL__011_R
    .byte BANK_LEVEL__012_L
    .byte BANK_LEVEL__012_R
    .byte BANK_LEVEL__013_L
    .byte BANK_LEVEL__013_R
    .byte BANK_LEVEL__014_L
    .byte BANK_LEVEL__014_R
    .byte BANK_LEVEL__015_L
    .byte BANK_LEVEL__015_R
    .byte BANK_LEVEL__016_L
    .byte BANK_LEVEL__016_R
    .byte BANK_LEVEL__017_L
    .byte BANK_LEVEL__017_R
    .byte BANK_LEVEL__018_L
    .byte BANK_LEVEL__018_R
    .byte BANK_LEVEL__019_L
    .byte BANK_LEVEL__019_R


    IF (* - LevelInfoBANK != MAX_LEVEL)
        ECHO "ERROR: Incorrect LevelInfoBANK table!"
        ERR
    ENDIF


    DEFINE_SUBROUTINE GetLevelAddress
    ; returns address,bank of level #
    ; Uses overlay LevelLookup
    ; relies on tables being page-aligned

                clc
                lda levelX
                sta levelTable
;                lda levelX+1
                lda #>LevelInfoLO
                sta levelTable+1

                ldy #0
                lda (levelTable),y
                sta Board_AddressR

;                lda levelX+1
                lda #>LevelInfoHI
                sta levelTable+1

                lda (levelTable),y
                sta Board_AddressR+1

                ;lda levelX+1
                lda #>LevelInfoBANK
                sta levelTable+1

                lda (levelTable),y
                sta LEVEL_bank

                rts


   CHECK_BANK_SIZE "LEVELS_TABLES -- full 2K"
