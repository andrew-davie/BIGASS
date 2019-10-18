
                SEG.U variables
                ORG $80

Platform                        ds 1        ; TV system (%0x=NTSC, %10=PAL-50, %11=PAL-60)

BufferedJoystick                ds 1        ; player joystick input
PreviousJoystick                ds 1

colour_table                    ds 2
rndHi                           ds 1
rnd                             ds 1


OVERLAY_SIZE    SET 24



        ; This overlay variable is used for the overlay variables.  That's OK.
        ; However, it is positioned at the END of the variables so, if on the off chance we're overlapping
        ; stack space and variable, it is LIKELY that that won't be a problem, as the temp variables
        ; (especially the latter ones) are only used in rare occasions.

        ; FOR SAFETY, DO NOT USE THIS AREA DIRECTLY (ie: NEVER reference 'Overlay' in the code)
        ; ADD AN OVERLAY FOR EACH ROUTINE'S USE, SO CLASHES CAN BE EASILY CHECKED

Overlay         ds OVERLAY_SIZE       ;--> overlay (share) variables
                VALIDATE_OVERLAY "DEFINITION"


                ds RESERVED_FOR_STACK

    ECHO "FREE BYTES IN ZERO PAGE = ", $FF - *
    IF * > $FF
        ERR
    ENDIF
