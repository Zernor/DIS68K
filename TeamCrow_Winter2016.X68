*-----------------------------------------------------------
* Title      :  68K Disassembler
* Written by :  Hoa Vo, Tenzin Khando, Marco F.
* Date       :
* Description:  68k disassembler 
*-----------------------------------------------------------
    
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    LEA         MESSAGE, A1
    MOVE.B      #14,D0
    TRAP        #15
    SIMHALT             ; halt simulator

* Put variables and constants here
MESSAGE DC.B    'HELLO, THIS IS MY FIRST COMMIT - Tenzin',0 
    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
