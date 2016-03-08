*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program

* Put program code here
    NOP
    RTS
    JSR     TEST
    MOVE.W  #$1234,A0
    JSR     0(A0,D0)
    JSR     (A1)
    JSR     $40000
    JSR     (A2)
    JSR     (A3)
    JSR     (A4)
    JSR     (A5)
    MOVEM.L  $12345678, A1
 
    
TEST    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
