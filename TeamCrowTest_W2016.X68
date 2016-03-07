*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program

* Put program code here
    MOVEA.L      $12345678, A1
    NOP
    RTS
    JSR     (A1)
    JSR     (A2)
    JSR     (A3)
    JSR     (A4)
    JSR     (A5)
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
