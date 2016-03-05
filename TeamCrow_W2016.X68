*------------------------------------------------------------------------------------------
* Title:  68K Disassembler
* Written by :  Hoa, Tenzin Khando, Marco F.
* Date       :
* Description:  Awesome 68k disassembler 
*------------------------------------------------------------------------------------------
    ORG    $400
START:  
        LEA         GREETING, A1            * Load the greeting message
        MOVE.B      #14,D0
        TRAP        #15 
            
*-------------------------------------------------------------------------------------------
*------------------ STARTING ADDRESS -------------------------------------------------------
READ_SADDR
        CLR.L       D7
        LEA         PROMPTSADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA         INPUT_HEX,A1            * Temp hold starting address
        MOVE.B      #2,D0                   * Read string from keyboard and store at A1
        TRAP        #15
        BRA         VALIDATE_STORE 
*------------------ STARTING ADDRESS -------------------------------------------------------
READ_EADDR
        LEA         PROMPTEADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA         INPUT_HEX,A1            * Temp hold ending address
        MOVE.B      #2,D0                   * Read string from keyboard and store at A1
        TRAP        #15  
        BRA         VALIDATE_STORE 

*-------------------------------------------------------------------------------------------
*------------------ VALIDATE & STORE  ADDRESS ----------------------------------------------
VALIDATE_STORE 

        * Check address size
        CMPI.B      #4, D1                  
        BLT         BADSIZES 
        CMPI.B      #8, D1 
        BGT         BADSIZES
        BRA         READHEX
BADSIZES
        LEA         ERRORINPUTSIZE, A1      * Print Bad Size Error
        MOVE.B      #14,D0
        TRAP        #15
        CMP.B       #0,D3                   * D3 - HOLDS 0 if starting address has not being stored yet
        BEQ         READ_SADDR
        BRA         READ_EADDR 
INVALID_CHARACTER                           * Print Invalid Character for Address
        LEA         INVALIDCHAR, A1
        MOVE.B      #14,D0 
        TRAP        #15 
        CMP.B       #0,D3
        BEQ         READ_SADDR 
        BRA         READ_EADDR
*------------------ Read ASCII & Convert + Store as Hex ----------------------------------
READHEX       
        CMPI.B      #$30,(A1)
        BLT         INVALID_CHARACTER       * Wrong data
        CMPI.B      #$40,(A1)
        BLT         NUMBER                  * Is number
        CMPI.B      #$47,(A1)
        BLT         LETTERS                 * Is Letter
        BRA         INVALID_CHARACTER
NUMBER      
        SUBI.B      #$30,(A1)               * Convert Numbers to Hex
        BRA         STORE   
LETTERS     
        SUBI.B      #$37,(A1)               * Convert Numbers to Hex
        BRA         STORE
STORE       
        ADD.B       (A1)+,D7                * Save data from A1 to D7
        CMPI.B      #0,(A1)                 * NO MORE TO READ SO CHECK IF ADDRESS IS ODD
        BEQ         ODD_TEST     
        LSL.L       #4,D7                   * Keep reading next character
        BRA         READHEX

* Before storing address - check if odd --------------------------------------------------------
ODD_TEST                                    * Check if address is odd
        MOVE.L      #$00000002,D1  	        * Put 2 in D1 so we can use it to divide input by 2
        MOVE.L      D7,D6
        DIVU        D1,D6          	        * Divide the input address by 2
        SWAP        D6             	        * Store the remainder in D2
        CMP.B       #1,D6          	        * Is the remainder ==1
        BEQ         ODD_TEST_FAIL  	        * Remainder is 1 so input fails odd test 
        CMP.B       #0,D3
            
        BRA         STORE_ADDRESS                           
ODD_TEST_FAIL   
        LEA         ODD_ADD_MSG,A1  	    * Load ODD_ADD_MSG to A1
        MOVE.B      #14,D0          	    * Print odd address error message
        TRAP        #15                     
        CLR.L       D6
        CLR.L       D7      
        CMP.B       #0,D3
        BEQ         READ_SADDR
        BRA         READ_EADDR 

* STORE ADDRESSESSS INTO MEMORY ----------------------------------------------------------------              
STORE_ADDRESS
        CLR.L       D6
        CMP.B       #0,D3
        BNE         STORE_ENDING
        
        CMP.L       #$00007000, D7
        BGT         CONTINUE_STORE
        BEQ         CONTINUE_STORE
    
        CLR.L       D6
        CLR.L       D7
        LEA         STARTING_ADDR_7, A1  	    * Load ODD_ADD_MSG to A1
        MOVE.B      #14,D0          	    * Print odd address error message
        TRAP        #15  
        BRA         READ_SADDR
        
CONTINUE_STORE        
        MOVE.L      D7, STARTING_ADD        * Save in the memory address 
        MOVEA.L     D7, A6                  * Save starting at A6
        MOVE.B      #1, D3                  * Counter - for VALID_STORE
        CLR.L       D7
        BRA         READ_EADDR    
STORE_ENDING 
        CMP.L       (STARTING_ADD), D7
        BLT         SGTE
        *BEQ         SGTE
        *JSR         ODD_TEST
STORE_E             
        MOVE.L      D7, ENDING_ADD  
        *MOVE.L      D7, A7                  * Save starting at A7
        CLR.L       D7
        BRA         ADDR_LOOP
SGTE                                        * Starting greater then ending
        LEA         INVALIDSADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        CLR.L       D7
        CLR.L       D3
        BRA         READ_SADDR
        
*-------------------------------------------------------------------------------------------
*------------------ Compare Current Address to Ending Adddres ------------------------------ 
ADDR_LOOP
        MOVE.L      ENDING_ADD,A5           
        CMP.L       A5,A6
        BGT         END_PROGRAM
        JSR         CLEAR_REGISTERS
        JSR         PRINT_CURRENT_ADD           * PRINT CURRENT ADDRESS
        
*-------------------------------------------------------------------------------------------  
*------------------ NOP & RTS ADDRESS ------------------------------------------------------
Decode_Constant                             * Check for NOP & RTS
        JSR     CLEAR_REGISTERS
        LEA     OPCODE, A4                  * Load opcode to A4
        JSR     UNCHANGED_CONSTANT          * NOP & RTS

****************************PRINTING HEX ADDRESS TO ASCII *******************

PRINT_CURRENT_ADD
    MOVE.L  A6,D2
    ;LEA     CURRENT_ADDRESS,A7
    MOVE.B  #0,D5
    MOVE.B  #8,D6

CONVERT_HEX_ASCII
    CMP.B   D5,D6
    BNE     SET_COUNTER_4
    RTS

SET_COUNTER_4
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

CLEAR_REGISTERS
    CLR.L   D0
    CLR.L   D5
    CLR.L   D2
    CLR.L   D1
    CLR.L   D3
    CLR.L   D4
    CLR.L   D6
    MOVE.L  #$00000000,A1
    MOVE.L  #$00000000,A2
    MOVE.L  #$00000000,A3
    MOVE.L  #$00000000,A4
    MOVE.L  #$00000000,A5
    RTS

***********************END OF PRINTING HEX ADDRESS TO ASCII *******************


*-------------------------------------------------------------------------------------------
* PRINT NOP OR RTS -------------------------------------------------------------------------

UNCHANGED_CONSTANT
    MOVE.B  #' ',(A4)+
    MOVE.B  #' ',(A4)+
    MOVE.B  #' ',(A4)+
    MOVE.B  #' ',(A4)+
    
    CMP.W   #$4E71,(A6)
    BEQ     PRINT_NOP
    CMP.W   #$4E75,(A6)
    BEQ     PRINT_RTS
    CMP.W   #$FFFF,(A6)
    BEQ     PRINT_NO_CODE    
    RTS  
    
PRINT_NOP
    MOVE.B  #'N',(A4)+
    MOVE.B  #'O',(A4)+
    MOVE.B  #'P',(A4)+
    MOVE.B  #$00,(A4)+
    *MOVEA.L  #$00000000,A1
    LEA     OPCODE,A1
    MOVE.B  #13,D0
    TRAP    #15
    ADD.L   #$2,A6          ;increase by 2 bytes if it prints NOP
    BRA     ADDR_LOOP
PRINT_RTS
    MOVE.B  #'R',(A4)+
    MOVE.B  #'T',(A4)+
    MOVE.B  #'S',(A4)+
    MOVE.B  #$00,(A4)+
    LEA     OPCODE,A1
    MOVE.B  #13,D0
    TRAP    #15
    ADD.L   #$2,A6
    BRA     ADDR_LOOP
PRINT_NO_CODE
    MOVE.B  #'N',(A4)+
    MOVE.B  #'O',(A4)+
    MOVE.B  #' ',(A4)+
    MOVE.B  #'D',(A4)+
    MOVE.B  #'A',(A4)+
    MOVE.B  #'T',(A4)+
    MOVE.B  #'A',(A4)+
    MOVE.B  #' ',(A4)+
    MOVE.B  #'$',(A4)+
    MOVE.B  #0,D2                   ;Setting counter for print Must be word size
    MOVE.B  #4,D3
    JSR     PRINT_IMMIDIATE_DATA
    MOVE.B  #$00,(A4)+
    LEA     OPCODE,A1
    MOVE.B  #13,D0
    TRAP    #15
    ADD.L   #$2,A6
    BRA     ADDR_LOOP
   
END_PROGRAM
        SIMHALT             ; halt simulator

*-------------------------------------------------------------------------------------------
* PRINT_IMMIDIATE_DATA---------------------------------------------------------------------

PRINT_IMMIDIATE_DATA
    CMP.B   #2,D3
    BEQ     BYTE_SIZE
    CMP.B   #4,D3
    BEQ     WORD_SIZE
    CMP.B   #8,D3
    BEQ     LONG_SIZE

BYTE_SIZE
    MOVE.B  (A6),D0
    MOVE.B  #1,SIZE
    BRA     LOOP_IMMIDIATE_DATA
WORD_SIZE
    MOVE.W  (A6),D0
    MOVE.B  #3,SIZE
    BRA     LOOP_IMMIDIATE_DATA
LONG_SIZE
    MOVE.L  (A6),D0
    MOVE.B  #3,SIZE
    BRA     LOOP_IMMIDIATE_DATA
    
LOOP_IMMIDIATE_DATA    
    CMP.B   D2,D3               ;D3 WIIL BE 8 FOR BYTE, 16 FOR WORD, 32 FOR LONG
    BNE     CONTINUE_SHIFT
    CLR.L   D2
    CLR.L   D3       
    RTS
    
CONTINUE_SHIFT
    JSR     SHIFT_4_BIT         ;SHIFT 4 BIT TO SEE WHAT TYPE OF 

;HEX_D    
    ;CMP.B   #hexD,D1
    ;BEQ     PRINT_F
   

;HEX_E    
    ;CMP.B   #hexE,D1
    ;BEQ     PRINT_E

HEX_F    
    CMP.B   #hexF,D1
    BEQ     PRINT_F
    
ADD_COUNTER
    ADDI.B  #1,D2
    CLR.L   D1
    BRA     LOOP_IMMIDIATE_DATA

*-------------------------------------------------------------------------------------------
* SHIFT_4_BIT--------------------------------------------------------------------

SHIFT_4_BIT
    MOVE.B   #0,D4
    MOVE.B   #4,D5              ;SHIFTS FROM 
    
START_SHIFT_4_BIT   
    CMP.B    D4,D5
    BNE      SHIFT_SIZE 
    LSR.L    #1,D1
    RTS

SHIFT_SIZE 
    CMP.B   #2,D3
    BEQ     SHIFT_SIZE_BYTE
    CMP.B   #4,D3
    BEQ     SHIFT_SIZE_WORD
    CMP.B   #8,D3
    BEQ     SHIFT_SIZE_LONG

SHIFT_SIZE_BYTE
    LSL.B   #1, D0              ;COPY OF THE DATA WE NEED TO SHIFT
    BCS     ADDONE
    BRA     ADD_ZERO
SHIFT_SIZE_WORD
    LSL.W   #1, D0              ;COPY OF THE DATA WE NEED TO SHIFT
    BCS     ADDONE
    BRA     ADD_ZERO
SHIFT_SIZE_LONG
    LSL.L   #1, D0              ;COPY OF THE DATA WE NEED TO SHIFT
    BCS     ADDONE

ADD_ZERO        
    ADDI.B  #%0, D1                    * add 0 bit to d2
    ASL.L   #1, D1     
    BRA     COUNTER_SHIFT_4_BIT
         
ADDONE        
    ADDI.B  #%1, D1                    * add 1 bit to d2
    ASL.L   #1, D1
    BRA     COUNTER_SHIFT_4_BIT 

COUNTER_SHIFT_4_BIT
    ADDI.L  #1,D4
    BRA     START_SHIFT_4_BIT

    


*-------------------------------------------------------------------------------------------
* SHIFT_4_BIT--------------------------------------------------------------------


*-------------------------------------------------------------------------------------------
* PRINT_ASCCI_HEX---------------------------------------------------------------------
PRINT_0
    MOVE.B  #'0',(A4)+
    BRA     ADD_COUNTER

PRINT_1
    MOVE.B  #'1',(A4)+
    BRA     ADD_COUNTER

PRINT_2
    MOVE.B  #'2',(A4)+
    BRA     ADD_COUNTER

PRINT_3
    MOVE.B  #'3',(A4)+
    BRA     ADD_COUNTER

PRINT_4
    MOVE.B  #'4',(A4)+
    BRA     ADD_COUNTER

PRINT_5
    MOVE.B  #'5',(A4)+
    BRA     ADD_COUNTER

PRINT_6
    MOVE.B  #'6',(A4)+
    BRA     ADD_COUNTER

PRINT_7
    MOVE.B  #'7',(A4)+
    BRA     ADD_COUNTER

PRINT_8
    MOVE.B  #'8',(A4)+
    BRA     ADD_COUNTER

PRINT_9
    MOVE.B  #'9',(A4)+
    BRA     ADD_COUNTER

PRINT_A
    MOVE.B  #'A',(A4)+
    BRA     ADD_COUNTER

PRINT_B
    MOVE.B  #'B',(A4)+
    BRA     ADD_COUNTER

PRINT_C
    MOVE.B  #'C',(A4)+
    BRA     ADD_COUNTER

PRINT_D
    MOVE.B  #'D',(A4)+
    BRA     ADD_COUNTER

PRINT_E
    MOVE.B  #'E',(A4)+
    BRA     ADD_COUNTER

PRINT_F
    MOVE.B  #'F',(A4)+
    BRA     ADD_COUNTER

*-------------------------------------------------------------------------------------------
* VARIABLES & MESSAGES ---------------------------------------------------------------------
CR        EQU       $0D
LF        EQU       $0A

*-------------------------------------------------------------------------------------------
* Hex values -------------------------------------------------------------------------------  
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
*-------------------------------------------------------------------------------------------
* Binary Hex Values ------------------------------------------------------------------------
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
*-------------------------------------------------------------------------------------------
* OP Codes ---------------------------------------------------------------------------------
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

GREETING        DC.B    '       HELLO THERE, WELCOME TO AWESOME DISASSEMBLER'
                DC.B    CR,LF,'Note: Addressess must be in HEX'
                DC.B    CR,LF,'Note: Addressess must be in caps'
                DC.B    CR,LF,'    : Starting Address must be greater than 70000',CR,LF,CR,LF,CR,LF,0 
PROMPTSADDR     DC.W    'ENTER A STARTING ADDRESS (ON CAPS): ',0
PROMPTEADDR     DC.W    'ENTER A ENDING ADDRESS   (ON CAPS): ',0

*ERROR MSG-------------------------------------------------------------------------------------------
INVALIDSADDR        DC.B    'ERROR: INVALID STARTING ADDRESS VERSUS ENDING.',CR,LF,CR,LF,0
ERRORINPUTSIZE      DC.B    'ERROR: INVALID ADDRESS SIZE',CR,LF,CR,LF,0
INVALIDCHAR         DC.B    'ERROR: INVALID ADDRESS CHARACTER',CR,LF,CR,LF,0
SGTEM               DC.B    'ERROR: STARTING ADDRESS > ENDING ADDRESS',CR,LF,CR,LF,0
ODD_ADD_MSG         DC.B    'ERROR: ODD ADDRESS',CR,LF,CR,LF,0
STARTING_ADDR_7     DC.B    'ERROR: Invalid starting adress - must be greater than 7000',CR,LF,CR,LF,0

*-------------------------------------------------------------------------------------------
* VARIABLES --------------------------------------------------------------------------------
SIZE            DS.B    1
INPUT_HEX       DS.L    1   * Use to temp hold starting and ending address
STARTING_ADD    DS.L    1   ;1 is the size, if I change to 4 then array size changes
ENDING_ADD      DS.L    1
OPCODE          DC.L    1

 END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
