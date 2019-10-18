
            NEWBANK INITBANK

;                      RLDU RLD  RL U RL   R DU R D  R  U R     LDU  LD   L U  L     DU   D     U
;                      0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111
JoyMoveX        .byte     0,   0,   0,   0,   0,   1,   1,   1,   0,  -1,  -1,  -1,   0,   0,   0,   0
JoyMoveY        .byte     0,   0,   0,   0,   0,   1,  -1,   0,   0,   1,  -1,   0,   0,   1,  -1,   0

JoyDirY
    .byte   0,0;,1,-1,0
JoyDirX
    .byte   1,-1,0,0,0

    CHECK_BANK_SIZE "INITBANK"
