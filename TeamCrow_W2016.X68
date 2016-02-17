*-----------------------------------------------------------
* Title      :  68K Disassembler
* Written by :  Hoa, Tenzin Khando, Marco F.
* Date       :
* Description:  Awesome 68k disassembler 
*-----------------------------------------------------------
CR        EQU       $0D
LF        EQU       $0A

    ORG    $1000
START:                 

* Put program code here
MESSAGE     LEA         GREETING, A1
            MOVE.B      #14,D0
            TRAP        #15
    
GETDATA     LEA       PROMPT,A1    
            MOVE.B    #14,D0       
            TRAP      #15
            
            MOVE.B    #4, D0
            TRAP      #15    
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here
GREETING        DC.B    'HELLO THERE, WELCOME TO AWESOME DISASSEMBLER',CR,LF,CR,LF,0 
PROMPT          DC.B    'PLEASE ENTER THE STARTING ADDRESS ',CR,LF,0
PROMPT2         DC.B    'PLEASE ENTER THE ENDING ADDRESS ',CR,LF,0

    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
