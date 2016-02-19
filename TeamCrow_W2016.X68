*-----------------------------------------------------------
* Title      :  68K Disassembler
* Written by :  Hoa, Tenzin Khando, Marco F.
* Date       :
* Description:  Awesome 68k disassembler 
*-----------------------------------------------------------
CR        EQU       $0D
LF        EQU       $0A

    ORG    $400
START:                 

* Put program code here
MESSAGE     LEA         GREETING, A1 load the greeting message
            MOVE.B      #14,D0
            TRAP        #15
    
LOOP        LEA         PROMPT,A1    load the message asked for starting address
            MOVE.B      #14,D0       
            TRAP        #15
            
            MOVE.B      #4, D0      Task 4: read a number from keyborad into D1
            TRAP        #15
            CMP.W       #4000,D1    ;comapare number in D1 to 4000, if the value entered is 4000 
            BNE         ERROR       ;else display error
            LEA         DATA, A1
            MOVE        #14, D0
            TRAP        #15
            BRA         LOOP    
            
ERROR       LEA         WRONG,A1
            MOVE.B      #14,D0
            TRAP        #15       
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here
GREETING        DC.B    'HELLO THERE, WELCOME TO AWESOME DISASSEMBLER',CR,LF,CR,LF,0 
PROMPT          DC.B    'PLEASE ENTER THE STARTING ADDRESS: ',0,CR,LF
PROMPT2         DC.B    'PLEASE ENTER THE ENDING ADDRESS: ',CR,LF,0
DATA            DC.B    'WE ARE AT ADDRESS 4000',CR,LF,0
WRONG           DC.B    'WE ARE NOT AT ADDRESS 4000',0
    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
