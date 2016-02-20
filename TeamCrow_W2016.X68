*-----------------------------------------------------------
* Title      :  68K Disassembler
* Written by :  Hoa, Tenzin Khando, Marco F.
* Date       :
* Description:  Awesome 68k disassembler 
*-----------------------------------------------------------

* Global Variables -----------------------------------------
startLoc    EQU     $7000
stack       EQU     $0FFE       * stack pointer (SP)

* Hex values -----------------------------------------------  
numzero     EQU     0  
numone      EQU     1
numtwo      EQU     2
numthree    EQU     3
numfour     EQU     4
numfive     EQU     5
numsix      EQU     6
numseven    EQU     7
numeight    EQU     8
numnine     EQU     9
numA        EQU     10
numB        EQU     11
numC        EQU     12
numD        EQU     13
numE        EQU     $E
numF        EQU     15

* Binary Hex Values ----------------------------------------
hex0        EQU     %0000   
hex1        EQU     %0001   
hex2        EQU     %0010   
hex3        EQU     %0011   
hex4        EQU     %0100   
hex5        EQU     %0101   
hex6        EQU     %0110   
hex7        EQU     %0111   
hex8        EQU     %1000   
hex9        EQU     %1001   
hexA        EQU     %1010   
hexB        EQU     %1011   
hexC        EQU     %1100   
hexD        EQU     %1101   
hexE        EQU     %1110   
hexF        EQU     %1111   

* OP Codes -------------------------------------------------
bin0000     EQU     %0000   ;ADDI, ANDI, EORI, BCHG, CMPI
bin0001     EQU     %0001   ;MOVE.B
bin0010     EQU     %0010   ;MOVE.L
bin0011     EQU     %0011   ;MOVE.W
bin0100     EQU     %0100   ;MOVEM, MULS.L, DIVU.L, LEA, CLR, JSR, RTS
bin0101     EQU     %0101   ;SUBQ
bin0110     EQU     %0110   ;Bcc
bin0111     EQU     %0111   ;MOVEQ
bin1000     EQU     %1000   ;DIVU.W
bin1001     EQU     %1001   ;SUB, SUBA
bin1011     EQU     %1011   ;CMP, CMPA, EOR
bin1100     EQU     %1100   ;AND, MULS.W
bin1101     EQU     %1101   ;ADD, ADDA
bin1110     EQU     %1110   ;ASR, ASL, ROL, ROR


CR        EQU       $0D
LF        EQU       $0A

    ORG    $400
START:                 

* Put program code here
MESSAGE     LEA         GREETING, A1    *load the greeting message
            MOVE.B      #14,D0
            TRAP        #15 
     
            LEA         PROMPT,A1      *load the message asked for starting address
            MOVE.B      #14,D0       
            TRAP        #15
            
LOOP        MOVE.B      #4, D0          *Task 4: read a number from keyborad into D1
            TRAP        #15
            CMP.W       #4000,D1        *comapare number in D1 to 4000, if the value entered is 4000
            BLT         ERROR1          //NL: nelse display WRONG1 
            BGT         PROMPT2         // NL: display PROMPT3
            MOVE.B      #4,D0           //NL store starting address at D1
            TRAP        #15
            
ERROR1      LEA        WRONG1,A1
            MOVE.B      #14,D0
            TRAP        #15       
            BRA         LOOP            // NEW LINE 

PROMPT2     LEA        PROMPT3, A1
            MOVE.B     #14,D0          
            TRAP       #15
            MOVE.B     #4,D0            //Store ending address at A1
            TRAP       #15
               
    
    SIMHALT             ; halt simulator

* Put variables and constants here
GREETING        DC.B    'HELLO THERE, WELCOME TO AWESOME DISASSEMBLER',CR,LF,CR,LF,0 
PROMPT          DC.B    'PLEASE ENTER THE STARTING ADDRESS, MUST BE GREATER THAN 4000: ',0,CR,LF
PROMPT3         DC.B    'PLEASE ENTER THE ENDING ADDRESS: ',CR,LF,0
WRONG1          DC.B   'YOUR STARTING ADDRESS MUST BE GREATER THAN 4000:',0 //NEW CHANGE   
 END    START        ; last line of source
  













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
