*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
CR        EQU       $0D
LF        EQU       $0A
    ORG    $1000
START:                  ; first instruction of program

addressdata EQU $7000

* Put program code here
            MOVEA.W         #addressdata, A0
            MOVE.B          (A0)+, D1
            CMP.B           #$12, D1
            BEQ             correctA
            BNE             wrongData



wrongData   LEA             WRONG, A1
            MOVE.B          #14,D0
            TRAP            #15
            
correctA    MOVE.B          D1, D2
            LSR             #4, D2
            CMP.B           #%0001, D2
            BEQ             OP
            LEA             Instruction, A1
            MOVE.B          #14,D0
            TRAP            #15

OP          LEA             OPCODE, A1
            MOVE.B          #14,D0
            TRAP            #15

    SIMHALT             ; halt simulator

* Put variables and constants here

WRONG        DC.B    'IT IS NOT EQUAL',CR,LF,0
Instruction  DC.B    'IT IS CORRECT ADDRESS',CR,LF,0
OPCODE       DC.B    'IT IS MOVE.B',CR,LF,0
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
