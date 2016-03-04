*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    MOVE.L  #$BCDEFABC,A6
    MOVE.L  A6,D2
    ;LEA     CURRENT_ADDRESS,A7
    MOVE.B  #0,D5
    MOVE.B  #8,D6

CONVERT_HEX_ASCII
    CMP.B   D5,D6
    BEQ     DONE

    
    MOVE.B  #0,D3
    MOVE.B  #4,D4    
Loop
    CMP.B   D3,D4
    BEQ     STORE_ONE_CHAR
    LSL.L   #1,D2
    BCC     ADDZERO

    ADDI.B  #1,D1
    BRA     INCREMENT_BIT_LOOP
    
ADDZERO
    ADDI.B  #0,D1

INCREMENT_BIT_LOOP
    ADDI.B  #1,D3
    LSL.L   #1,D1
    BRA     Loop
    
STORE_ONE_CHAR
    LSR.L   #1,D1
    CMP.B   #$9,D1
    BLT     HEX_TO_ASCII_NUMBER
    
    ADDI.B  #$37,D1     ;HEX_TO_ASCII_LETTER
    BRA     INCREMENT_NEXT_HEX_LOOP
    
HEX_TO_ASCII_NUMBER
    ADDI.B  #$30,D1

    ;MOVE.B  D7,(A7)+
INCREMENT_NEXT_HEX_LOOP
    ADDI.B  #1,D5
    MOVE.B  #6,D0
    TRAP    #15
    CLR.L   D1
    BRA     CONVERT_HEX_ASCII

DONE
    ;MOVE.B  #0,(A7)+
    ;LEA     CURRENT_ADDRESS,A1
    ;MOVE.B  #13,D0
    ;TRAP    #15
    SIMHALT             ; halt simulator

* Put variables and constants here

CURRENT_ADDRESS DS.B    9
    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
