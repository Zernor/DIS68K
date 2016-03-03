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
   
        LEA         GREETING, A1    *load the greeting message
        MOVE.B      #14,D0
        TRAP        #15 
            
* Put program code here
READ_SADDR
        LEA         PROMPTSADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVE.L      #$0,A1             ; clear after printing message
        MOVE.B      #2,D0              * Read string from keyboard and store at A1
        TRAP        #15
        BRA         VALIDATE_STORE 
BADSIZES
        LEA         ERRORINPUTSIZE, A1
        MOVE.B      #14,D0
        TRAP        #15
        CMP.B       #0,D3
        BEQ         READ_SADDR
        BRA         READ_EADDR 

INVALID_CHARACTER
        LEA         ERRORINPUTSIZE, A1
        MOVE.B      #14,D0 
        TRAP        #15 
        CMP.B       #0,D3
        BEQ         READ_SADDR 
        
READ_EADDR
        LEA         PROMPTEADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.L      #$0,A1             ; clear after printing message
        MOVE.B      #2,D0              * Read string from keyboard and store at A1
        TRAP        #15  
        
VALIDATE_STORE 
        CMPI.B      #4, D1             * Check address size
        BLT         BADSIZES 
        CMPI.B      #8, D1 
        BGT         BADSIZES
        
READHEX       
        CMPI.B      #$30,(A1)
        BLT         INVALID_CHARACTER   * Wrong data
        CMPI.B      #$40,(A1)
        BLT         NUMBER              * Is number
        CMPI.B      #$46,(A1)
        BLT         LETTERS             * Is Letter
        BRA         INVALID_CHARACTER
NUMBER      SUBI.B      #$30,(A1)           * Convert Numbers to Hex
        BRA         STORE   
LETTERS     SUBI.B      #$37,(A1)           * Convert Numbers to Hex
         BRA         STORE
STORE       ADD.B       (A1)+,D7            * Save data from A1 to D7
        CMPI.B      #0,(A1) 
        BEQ         STOREME     
        LSL.L       #4,D7               * Keep reading next character
        BRA         READHEX
STOREME     
        CMP.B       #0,D3
        BNE         STORE_ENDING
        MOVE.L      D7, STARTING_ADD      * Save in the memory address 
        MOVEA.L     D7, A6                *save starting at A6
        MOVE.B      #1, D3               * Counter - for VALID_STORE
        CLR.L       D7
        BRA         READ_EADDR    
        
STORE_ENDING 
        CMP.L       (STARTING_ADD), D7
        BLT         SGTE
        MOVE.L      D7, ENDING_ADD  
        MOVE.L      D7, A7                 *save starting at A7
        CLR.L       D7
        CLR.L       D3
        BRA         OPCODEDIS  
        
SGTE    ;starting greater then ending
        LEA         INVALIDSADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        CLR.L       D7
        CLR.L       D3
        BRA         READ_SADDR

*-----------------------------Addressess------------------------------*  

         

OPCODEDIS   ;fix the print of address
        CMP.L   #$4E71,(A6)
        BEQ     
        
        MOVE.L  #1, D0          ;shift 4 bit
        MOVE.L  #4, D2
        

OPCODELOOP 
        CMP.B   D0, D2
        BEQ     OPCODEDONE
        LSL.L   #1, D3
        BCS     ADDONE
        ADDI.B  #%0, D4                 * Add 0 bit to d2
         ASL.L   #1, D4
         ADDQ.L  #1,D0
         BRA     OPCODELOOP 
ADDONE      
        ADDI.B  #%1, D4                 * Add 1 bit to d2
        ADDQ.L  #1,D0
        BRA     OPCODELOOP
OPCODEDONE            


PRINTADD
        LEA     
        SIMHALT             ; halt simulator

* Put variables and constants here

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

GREETING        DC.B    'HELLO THERE, WELCOME TO AWESOME DISASSEMBLER',CR,LF,CR,LF,0 
PROMPTSADDR     DC.W    'PLEASE ENTER THE STARTING ADDRESS MUST BE GREATER THAN 7000: ',0,CR,LF
INVALIDSADDR    DC.B    'INVALID STARTING ADDRESS VERSUS ENDING.',CR,LF,0
PROMPT3         DC.B    'PLEASE ENTER THE ENDING ADDRESS: ',CR,LF,0
PROMPTEADDR     DC.W    'PLEASE ENTER THE ENDING ADDRESS AND ALL CAPITALS: ',0
ERRORINPUTSIZE  DC.B    'ERROR: INVALID ADDRESS SIZE',CR,LF,CR,LF,0
SGTEM           DC.B    'ERROR: STARTING ADDRESS > ENDING ADDRESS',CR,LF,0

STARTING_ADD    DS.L    1
ENDING_ADD      DS.L    1


 END    START        ; last line of source
  















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
