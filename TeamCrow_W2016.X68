********************************************************************************************
* Title:  68K Disassembler
* Written by :  Hoa, Tenzin Khando, Marco F.
* Date       :
* Description:  Awesome 68k disassembler 
********************************************************************************************
    ORG    $400
START:  
        LEA         GREETING, A1            * Load the greeting message
        MOVE.B      #14,D0
        TRAP        #15 
   		MOVE.B      #0, LINE_COUNT          * Initilize the LINE_COUNTER variable 
        MOVE.B      #0, BAD_DATA_SWITCH            * Reset Line Count 

********************************************************************************************
* DESCRIPTION: Reading Addresses
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
*------------------ ENDING ADDRESS -------------------------------------------------------
READ_EADDR
        LEA         PROMPTEADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA         INPUT_HEX,A1            * Temp hold ending address
        MOVE.B      #2,D0                   * Read string from keyboard and store at A1
        TRAP        #15  
        BRA         VALIDATE_STORE 

********************************************************************************************
* Validating and storing addresses
*------------------ VALIDATE & STORE  ADDRESS ----------------------------------------------
VALIDATE_STORE 
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
        MOVE.B      #14,D0                	    * Print odd address error message
        TRAP        #15  
        BRA         READ_SADDR
        
CONTINUE_STORE        
        MOVE.L      D7, STARTING_ADD            * Save in the memory address 
        MOVEA.L     D7, A6                      * Save starting at A6
        MOVE.B      #1, D3                      * Counter - for VALID_STORE
        CLR.L       D7
        BRA         READ_EADDR    
STORE_ENDING 
        CMP.L       (STARTING_ADD), D7
        BLT         SGTE

STORE_E             
        MOVE.L      D7, ENDING_ADD  
        CLR.L       D7
        JSR         CLEAR_SCREEN
        BRA         ADDR_LOOP
SGTE                                            * Starting greater then ending
        LEA         INVALIDSADDR, A1
        MOVE.B      #14, D0
        TRAP        #15
        CLR.L       D7
        CLR.L       D3
        BRA         READ_SADDR
  
        
********************************************************************************************
*------------------ OPCODE READ ------------------------------------------------------------
* Description:
*
*------------------ Compare Current Address to Ending Adddres ------------------------------ 
ADDR_LOOP
        JSR         CLEAR_REGISTERS             * Clear registers
        MOVE.L      ENDING_ADD,A5               * Check current address against ending adress           
        CMP.L       A5,A6
        BGT         END_PROGRAM    

        MOVE.L      #$00000000, A5
        CMP.B       #25, LINE_COUNT             * Check line counter
        BNE         CONTINUE_ADDR_LOOP
        JSR         USER_RESPONSE         
CONTINUE_ADDR_LOOP        
        ADD.B       #1, LINE_COUNT              * Update Line counter
        JSR         CLEAR_REGISTERS             * Clear registers
        JSR         PRINT_CURRENT_ADD           * PRINT CURRENT ADDRESS
        
        LEA         PRINTER, A5                  
        MOVE.W      (A6)+, D7
        JSR         GET_INSTRUCTION
        
        CMP.B       #10, BAD_DATA_SWITCH        * Check if Bad Data Switch is True
        BEQ         PRINT_BAD_DATA  
        MOVE.B      #$00,(A5)+                  * Add 00 to opcode printer
        LEA         PRINTER, A1		            * Print
        MOVEQ       #13,D0				
        TRAP        #15					

        BRA         ADDR_LOOP
PRINT_BAD_DATA                                  * Asume is Empty 
        JSR         CLEAR_REGISTERS             * Clear registers
        LEA         PRINTER, A5
        *MOVE.W      (A6), D7
        JSR		    BAD_DATA		        
        MOVE.B      #$00,(A5)+                  * Add 00 BAD_BUFFER so we can end the line.
        LEA         PRINTER,A1		            * Load the bad data into A1
        MOVEQ       #13,D0				        * Set print trap
        TRAP        #15		
        MOVE.B      #$00, BAD_DATA_SWITCH            * Reset Line Count 
        BRA         ADDR_LOOP		Go back to main loop
        

*---------------------------------------------------------------------------------------
BAD_DATA
        MOVE.B      #'B',(A5)+			            * Print BAD DATA using A4
        MOVE.B	    #'A',(A5)+			
        MOVE.B	    #'D',(A5)+			
        MOVE.B	    #' ',(A5)+			
        MOVE.B	    #'D',(A5)+			
        MOVE.B	    #'A',(A5)+			
        MOVE.B	    #'T',(A5)+			
        MOVE.B	    #'A',(A5)+			
        MOVE.B	    #' ',(A5)+			
        MOVE.B      #' ',(A5)+
        MOVE.B	    #'$',(A5)+			
        
        MOVE.B	    #0,D6                           * Set 0
        MOVE.W      D7,D5                           * Bad Code to D5
        MOVE.B      #4,D3

WORD_ASCII                      	
    	ROL.W       #4,D5               	        * Move the MSB to LSB
    	MOVE.L      D5,D4               	        * Move longword address to D5
    	ANDI.L      #$0000000F,D4       	        * Clear everything except for MSB
DATA_ASC
    	CMPI.B      #$09,D4             	            * Is the character a number?
    	BLE         DATA_NUM                        * Branch if yes.
DATA_LET
    	ADDI.B      #$37,D4                         * Convert into a prinatble ascii letter
    	BRA         DATA_CHAR
DATA_NUM 
    	ADDI.B      #$30,D4             	        * Convert into a prinatble ascii number
    	BRA         DATA_CHAR
    	
DATA_CHAR
    	ADDI.B      #1,D6               	        * Update counter
    	MOVE.B      D4,(A5)+            	        * Add ASCII to printer
    	CMP.B       D3,D6               	
    	BLT         WORD_ASCII                      * if not, repeat loop
    	RTS
    	
LONG_ASCII                      	
    	ROL.L       #4,D5               	        * Move the MSB to LSB
    	MOVE.L      D5,D4               	        * Move longword address to D5
    	ANDI.L      #$0000000F,D4       	        * Clear everything except for MSB
DATA_ASC2
    	CMPI.B      #$09,D4             	            * Is the character a number?
    	BLE         DATA_NUM2                        * Branch if yes.
DATA_LET2
    	ADDI.B      #$37,D4                         * Convert into a prinatble ascii letter
    	BRA         DATA_CHAR2
DATA_NUM2 
    	ADDI.B      #$30,D4             	        * Convert into a prinatble ascii number
    	BRA         DATA_CHAR2
    	
DATA_CHAR2
    	ADDI.B      #1,D6               	        * Update counter
    	MOVE.B      D4,(A5)+            	        * Add ASCII to printer
    	CMP.B       D3,D6               	
    	BLT         LONG_ASCII                      * if not, repeat loop
    	RTS    	
    	
    	
*---------------------------------------------------------------------------------

GET_INSTRUCTION
        MOVE.W      D7, D6                          * Move the instruction so we can shift it
        ROL.W       #4, D6				            * Shift 8 bits to the right
        MOVE.W      D6, D5
        LEA         OPCODE_JMP_TABLE, A0      	    * Set the table to A0 so we know where to jump to
        ANDI.W      #$000F, D6
        MULU        #8, D6             	            * Offset D5 to show the word binary for the instruction
        *MOVE.B      D6, D4
        *ADD.W       A0, D4
        JSR         0(A0,D6)          	            
        RTS        

********************************************************************************************
* OP CODE                                              
OPCODE_JMP_TABLE
    JSR     OPCODE0000                           * - ADDI - ------------------------------------------
    RTS
    JSR     OPCODE0001                           * - MOVE.B - Marco 
    RTS
    JSR     OPCODE0010                           * - MOVE.L - Marco
    RTS
    JSR     OPCODE0011                           * - MOVE.W - Marco
    RTS
    JSR     OPCODE0100                           * - MOVEM, LEA, JSR, CLR, RTS, NOP -------------> MOVEM??
    RTS
    JSR     OPCODE0101                           * - BAD DATA -----------------------------------
    RTS   
    JSR     OPCODE0110                           * - BCC, BLE, BGT - Tenzin
    RTS
    JSR     OPCODE0111                           * - MOVEQ - Hoa
    RTS
    JSR     OPCODE1000                           * - DIVU - Hoa
    RTS 
    JSR     OPCODE1001                           * - SUB - Hoa
    RTS
    JSR     OPCODE1010                           * - BAD DATA ----------------------------------
    RTS  
    JSR     OPCODE1011                           * - CMP - Hoa
    RTS
    JSR     OPCODE1100                           * - AND, MULS - Tenzin
    RTS
    JSR     OPCODE1101                           * - ADDA,ADD - Tenzin
    RTS
    JSR     OPCODE1110                           * - ASR, LSL, ROL -------------------------------
    RTS  
    JSR     OPCODE1111                           * - BAD DATA -------------------------------------
    RTS   

*********************************************************
* 0100 Jump Table CLR, JSR, LEA, MOVEM, RTS INSTRUCTIONS
THREE_TABLE     
    JSR     THREE000            - LEA                  
    RTS                                 
    JSR     THREE001            - LEA, CLR        
    RTS                                 
    JSR     THREE010            - LEA
    RTS                                 
    JSR     THREE011            - LEA        
    RTS                                 
    JSR     THREE100            - LEA, MOVEM        
    RTS                                 
    JSR     THREE101            - LEA
    RTS                                 
    JSR     THREE110            - LEA, MOVEM        
    RTS                                 
    JSR     THREE111            - LEA, JSR, NOP, RTS       
    RTS    
*********************************************************
* 0100 
THREE_TABLE_2     
    JSR     THREE2000            - CLR.B               
    RTS                                 
    JSR     THREE2001            - CLR.W       
    RTS                                 
    JSR     THREE2010            - CLR.L, MOVEM.W
    RTS                                 
    JSR     THREE2011            - MOVEM.L, JSR        
    RTS                                 
    JSR     THREE2100            - Bad Data       
    RTS                                 
    JSR     THREE2101            - Bad Data
    RTS                                 
    JSR     THREE2110            - Bad Data
    RTS                                 
    JSR     THREE2111            - LEA     
    RTS    
********************************************************
OPCODE0101       
    ADD.B       #10, BAD_DATA_SWITCH           
    RTS
OPCODE1010  
    ADD.B       #10, BAD_DATA_SWITCH              
    RTS                         
OPCODE1111 
    ADD.B       #10, BAD_DATA_SWITCH               
    RTS                          
**********************ADDI*********************************
OPCODE0000
    MOVE.W          D7, D4
    ANDI.W          #$0600, D4
    CMP.W           #$0600, D4
    BEQ             C_OPCODE0000
    ADD.B           #10, BAD_DATA_SWITCH             
    RTS
C_OPCODE0000  
    MOVE.B          #'A',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.B          #'I',(A5)+
    MOVE.B          #'.',(A5)+      
    MOVE.W          D7, D4
    ANDI.W          #$00C0, D4
    CMP.W           #$0000, D4
    BEQ             ADDI_B_0000
    CMP.W           #$0040, D4
    BEQ             ADDI_W_0000
    CMP.W           #$0080, D4
    BEQ             ADDI_L_0000
    ADD.B           #10, BAD_DATA_SWITCH             
    RTS
ADDI_B_0000
    MOVE.B          #'B',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #'#',(A5)+
    MOVE.B          #'$',(A5)+
    MOVE.W          (A6)+, D5
    MOVE.B          #0 , D6
    MOVE.B          #4, D3
    JSR             WORD_ASCII
    *MOVE.W          D4, (A5)+
    BRA             C2_OPCODE0000
ADDI_W_0000
    MOVE.B          #'W',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #'#',(A5)+
    MOVE.B          #'$',(A5)+
    MOVE.W          (A6)+, D5
    MOVE.B          #0 , D6
    MOVE.B          #4, D3
    JSR             WORD_ASCII
    *MOVE.W          D4, (A5)+ 
    BRA             C2_OPCODE0000
ADDI_L_0000
    MOVE.B          #'L',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #'#',(A5)+
    MOVE.B          #'$',(A5)+
    *MOVE.L          (A6)+, D5
    MOVE.L          (A6)+, D5
    MOVE.B          #0 , D6
    MOVE.B          #4, D3
    JSR             WORD_ASCII
    *MOVE.W          D4, (A5)+ 
    BRA             C2_OPCODE0000
C2_OPCODE0000
    MOVE.B          #',',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0038, D4
    CMP.W           #$0000, D4
    BEQ             DN_CASE_0000
    CMP.W           #$0010, D4
    BEQ             ABSOLUTE_AN_CASE_0000
    CMP.W           #$0018, D4
    BEQ             INCREMENT_AN_CASE_0000
    CMP.W           #$0020, D4
    BEQ             DECREMENT_AN_CASE_0000
    CMP.W           #$0038, D4
    BEQ             EA_CASE_0000
    ADD.B           #10, BAD_DATA_SWITCH   
    RTS
DN_CASE_0000    
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)      
    RTS
ABSOLUTE_AN_CASE_0000
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    RTS
INCREMENT_AN_CASE_0000
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    MOVE.B          #'+',(A5)+
    RTS
DECREMENT_AN_CASE_0000  
    MOVE.B          #'-',(A5)+ 
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    RTS
EA_CASE_0000  
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    CMP.W           #$0000, D4
    BEQ             EA_000_CASE
    CMP.W           #$0001, D4
    BEQ             EA_001_CASE
    ADD.B           #10, BAD_DATA_SWITCH   
    RTS 
EA_000_CASE
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                           
    MOVE.W      (A6)+,D5                          
    MOVE.B      #4,D3  
    JSR         WORD_ASCII
    RTS 
EA_001_CASE
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                          
    MOVE.L      (A6)+,D5                          
    MOVE.B      #8,D3
    JSR         LONG_ASCII  
    RTS  
    
*********************************************************
OPCODE0001
    MOVE.B          #'M',(A5)+
    MOVE.B          #'O',(A5)+
    MOVE.B          #'V',(A5)+
    MOVE.B          #'E',(A5)+
    MOVE.B          #'.',(A5)+
    MOVE.B          #'B',(A5)+ 
    MOVE.B          #' ',(A5)+     
    MOVE.B          #' ',(A5)+     
    MOVE.B          #' ',(A5)+     
 
OPCODE_MOVE_DECODER    *** Do Source ***
    MOVE.W          D7, D4
    ANDI.W          #$0038, D4
    CMP.W           #$0000, D4
    BEQ             DN_CASE_0001
    CMP.W           #$0001, D4
    BEQ             AN_CASE_0001
    CMP.W           #$0010, D4
    BEQ             ABSOLUTE_AN_CASE_0001
    CMP.W           #$0018, D4
    BEQ             INCREMENT_AN_CASE_0001
    CMP.W           #$0020, D4
    BEQ             DECREMENT_AN_CASE_0001
    CMP.W           #$0038, D4
    BEQ             EA_CASE_0001
    ADD.B           #10, BAD_DATA_SWITCH  
    RTS
   
C_OPCODE0001
    MOVE.B          #',',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$01C0, D4
    CMP.W           #$0000, D4
    BEQ             DESTINATION_DN_CASE_0001
    CMP.W           #$0080, D4
    BEQ             DESTINATION_ABSOLUTE_AN_0001
    CMP.W           #$00C0, D4
    BEQ             DESTINATION_INCREMENT_AN_0001
    CMP.W           #$0100, D4
    BEQ             DESTINATION_DECREMENT_AN_0001
    CMP.W           #$01C0, D4
    BEQ             DESTINATION_EA_CASE_0001
    ADD.B           #10, BAD_DATA_SWITCH  
    RTS
   
DN_CASE_0001   
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ROR.W           #4, D4
    ROR.W           #3, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)     
    BRA             C_OPCODE0001
AN_CASE_0001   
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ROR.W           #4, D4
    ROR.W           #3, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)     
    BRA             C_OPCODE0001
ABSOLUTE_AN_CASE_0001
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ROR.W           #4, D4
    ROR.W           #3, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    MOVE.B          #')',(A5)+
    BRA             C_OPCODE0001
INCREMENT_AN_CASE_0001
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ROR.W           #4, D4
    ROR.W           #3, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    MOVE.B          #')',(A5)+
    MOVE.B          #'+',(A5)+
    BRA             C_OPCODE0001
DECREMENT_AN_CASE_0001
    MOVE.B          #'-',(A5)+
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ROR.W           #4, D4
    ROR.W           #3, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    MOVE.B          #')',(A5)+
    BRA             C_OPCODE0001
EA_CASE_0001 
    MOVE.W          D7, D4
    ROR.W           #4, D4
    ROR.W           #3, D4
    ANDI.W          #$0007, D4
    CMP.W           #$0000, D4
    BEQ             EA_000_CASE_0001
    CMP.W           #$0001, D4
    BEQ             EA_001_CASE_0001
    CMP.W           #$0004, D4
    BEQ             EA_100_CASE_0001
    ADD.B           #10, BAD_DATA_SWITCH  
    BRA             C_OPCODE0001
 
        *** Destination ***
DESTINATION_DN_CASE_0001   
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)     
    RTS
DESTINATION_ABSOLUTE_AN_0001
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    MOVE.B          #')',(A5)+
    RTS
DESTINATION_INCREMENT_AN_0001
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    MOVE.B          #')',(A5)+
    MOVE.B          #'+',(A5)+
    RTS
DESTINATION_DECREMENT_AN_0001 
    MOVE.B          #'-',(A5)+
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    MOVE.B          #')',(A5)+
    RTS
DESTINATION_EA_CASE_0001 
    MOVE.W          D7, D4
    LSR.W           #8, D4
    LSR.W           #1, D4
   
    ANDI.W          #$0007, D4
    CMP.W           #$0000, D4
    BEQ             DEA_000_CASE_0001
    CMP.W           #$0001, D4
    BEQ             DEA_001_CASE_0001
   
    ADD.B           #10, BAD_DATA_SWITCH  
    RTS
   
EA_000_CASE_0001
    MOVE.B      #'$',(A5)+
    MOVE.B          #0,D6                          
    MOVE.W      (A6)+,D5                         
    MOVE.B      #4,D3 
    JSR         WORD_ASCII
    BRA         C_OPCODE0001
EA_001_CASE_0001
    MOVE.B      #'$',(A5)+
    MOVE.B          #0,D6                         
    MOVE.L      (A6)+,D5                         
    MOVE.B      #8,D3
    JSR         LONG_ASCII    
    BRA         C_OPCODE0001
EA_100_CASE_0001
    MOVE.B      #'$',(A5)+
    MOVE.B          #0,D6                          
    MOVE.W      (A6)+,D5                         
    MOVE.B      #4,D3 
    JSR         WORD_ASCII
    BRA         C_OPCODE0001  
    
    
DEA_000_CASE_0001
    MOVE.B      #'$',(A5)+
    MOVE.B          #0,D6                          
    MOVE.W      (A6)+,D5                         
    MOVE.B      #4,D3 
    JSR         WORD_ASCII
    RTS
DEA_001_CASE_0001
    MOVE.B      #'$',(A5)+
    MOVE.B          #0,D6                         
    MOVE.L      (A6)+,D5                         
    MOVE.B      #8,D3
    JSR         LONG_ASCII    
    RTS
*----------------------------------------------------END MOVE.L------------------------------
************************************************************************************************
*----------------------------------------------------MOVE.L------------------------------
OPCODE0010
    MOVE.B          #'M',(A5)+
    MOVE.B          #'O',(A5)+
    MOVE.B          #'V',(A5)+
    MOVE.B          #'E',(A5)+
    MOVE.B          #'.',(A5)+
    MOVE.B          #'L',(A5)+ 
    MOVE.B          #' ',(A5)+     
    MOVE.B          #' ',(A5)+     
    MOVE.B          #' ',(A5)+
    BRA             OPCODE_MOVE_DECODER     
*----------------------------------------------------END MOVE.L------------------------------
************************************************************************************************
*----------------------------------------------------MOVE.W------------------------------

OPCODE0011
    MOVE.B          #'M',(A5)+
    MOVE.B          #'O',(A5)+
    MOVE.B          #'V',(A5)+
    MOVE.B          #'E',(A5)+
    MOVE.B          #'.',(A5)+
    MOVE.B          #'W',(A5)+ 
    MOVE.B          #' ',(A5)+     
    MOVE.B          #' ',(A5)+     
    MOVE.B          #' ',(A5)+
    BRA             OPCODE_MOVE_DECODER 
*----------------------------------------------------END MOVE.W------------------------------
************************************************************************************************    
*----------------------------------------------------JSR RTS NOP LEA------------------------------
OPCODE0100
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE, A0
    JSR             00(A0,D6)   
    RTS
*----------------------------------------------------END JSR RTS NOP LEA------------------------------
************************************************************************************************
*--------------------BCC, BLE, BGT**************************************
OPCODE0110          *BCC, BLE, BGT                                       
    MOVE.W          D5, D6                      *D5:XXX6 -> D6:XXX6      
    ROL.W           #4, D6                      *D6:XX6X 
    MOVE.W          D6, D5                      *D6:XX6X -> D5:XX6X
    ANDI.W          #$000F, D6                  *D6:000X
    CMP.W           #$F,D6                      *D6:000F
    BEQ             OPCODE0110_BLE              *Go to BLE OPcode
    CMP.W           #$E,D6                      *D6:000E
    BEQ             OPCODE0110_BGT              *Go to BGT OPcode
    CMP.W           #$4,D6                      *D6:0004
    BEQ             OPCODE0110_BCC              *Go to BCC Opcode
    ADD.B           #10, BAD_DATA_SWITCH        *If none of those, then it is something we haven't decoded      
    RTS  
OPCODE0110_BLE
    MOVE.B	        #'B',(A5)+			        
    MOVE.B	        #'L',(A5)+			
    MOVE.B	        #'E',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+   
    BRA             OPCODE0110_DISPLACEMENT         *To check how far away the to branch to
OPCODE0110_BGT    
    MOVE.B	        #'B',(A5)+			
    MOVE.B	        #'G',(A5)+			
    MOVE.B	        #'T',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+
    BRA             OPCODE0110_DISPLACEMENT
OPCODE0110_BCC
    MOVE.B	        #'B',(A5)+			
    MOVE.B	        #'C',(A5)+			
    MOVE.B	        #'C',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+			
    MOVE.B	        #' ',(A5)+
OPCODE0110_DISPLACEMENT
    MOVE.W          D7,D6                           *D7:6XXX  -> D6:6XXX
    MOVE.L          A6,D5                           *Save current address to D5
    ANDI.W          #$00FF, D6                      *D6:00XX
    CMP.W           #$00,D6                         *XX:00, then check the next 2 bytes from current address
    BEQ             OPCODE0110_DISPLACEMENT_WORD    
    CMP.W           #$FF,D6                         *XX:FF, then check the next 4 bytes from current address
    BEQ             OPCODE0110_DISPLACEMENT_LONG
    MOVE.B          #0,D0                           *Set counter
    MOVE.B          #8,D1                           *Max Counter 
    BRA             OPCODE011_TWOSCOMPLEMENT_BYTE   *XX:00<XX<FF, then must do twos complement because we have to subtract
OPCODE0110_DISPLACEMENT_WORD
    MOVE.W          (A6)+,D6                        *Save the next word size from current address
    MOVE.B          #16,D1                          *Set counter for word-bit size
    MOVE.W          D6,D4                           *Copy D6 to D4
    ANDI.W          #$F000,D4   
    CMP.W           #$F000,D4                       *Checking to see if I need to go backwards
    BEQ             OPCODE011_TWOSCOMPLEMENT_WORD   
    ADD.W           D6,D5                           *Else, add the value with current address
    BRA             OPCODE0110_PRINT                *print word

OPCODE0110_DISPLACEMENT_LONG                        *same as OPCODE0110_DISPLACEMENT_WORD but for Long
    MOVE.L          (A6)+,D6                        
    MOVE.B          #32,D1
    MOVE.L          D6,D4
    ANDI.L          #$F0000000,D4
    CMP.L           #$F0000000,D4
    BEQ             OPCODE011_TWOSCOMPLEMENT_WORD
    ADD.L           D6,D5
    BRA             OPCODE0110_PRINT
*********OPCODE011_TWOSCOMPLEMENT-----------------------------------------
OPCODE011_TWOSCOMPLEMENT_BYTE
    ROL.B       #1,D6                               *Check bit by bit for byte size        
    BCS         OPCODE011_TWOSCOMPLEMENT_ONE
    BRA         OPCODE011_TWOSCOMPLEMENT_ZERO
OPCODE011_TWOSCOMPLEMENT_WORD
    ROL.W       #1,D6                               *Check bit by bit for word size
    BCS         OPCODE011_TWOSCOMPLEMENT_ONE
    BRA         OPCODE011_TWOSCOMPLEMENT_ZERO    
OPCODE011_TWOSCOMPLEMENT_LONG
    ROL.L       #1,D6                               *Check bit by bit for long size
    BCS         OPCODE011_TWOSCOMPLEMENT_ONE
OPCODE011_TWOSCOMPLEMENT_ZERO
    ADDI.B      #1,D6                               *Add one if its zero
    BRA         OPCODE011_TWOSCOMPLEMENT_LOOP
OPCODE011_TWOSCOMPLEMENT_ONE    
    SUBI.B      #1,D6                               *Sub one if its one
OPCODE011_TWOSCOMPLEMENT_LOOP
    ADDI.B      #1,D0                               *increase the counter
    CMP.B       D0,D1                               *check if it is done
    BEQ         OPCODE011_TWOSCOMPLEMENT_ADD_ONE    
    CMP.B       #8,D1                               *check the counter size to jump to byte,word, or long
    BEQ         OPCODE011_TWOSCOMPLEMENT_BYTE
    CMP.B       #16,D1
    BEQ         OPCODE011_TWOSCOMPLEMENT_WORD
    CMP.B       #32,D1
    BEQ         OPCODE011_TWOSCOMPLEMENT_LONG
OPCODE011_TWOSCOMPLEMENT_ADD_ONE
    ADDI.W      #$1,D6                              *complete twos complement by adding $1 to the value             
    SUB.L       D6,D5                               *Sub the current address with the new value to get the address to branch

*********OPCODE011_TWOSCOMPLEMENT-----------------------------------------
OPCODE0110_PRINT
    CMP.L           #$FFFF,D5                       *check to see if the address exceeds word size
    BGT             OPCODE0110_PRINT_LONG           *if it does, print long
    MOVE.B          #4,D3                           *setting the max time for loop
    CLR.L           D6                              *clear it because WORD_ASCII uses D6 
    JSR             WORD_ASCII
    RTS
OPCODE0110_PRINT_LONG 
    MOVE.B          #8,D3                           *setting the max 
    CLR.L           D6
    JSR             LONG_ASCII
    RTS 
*-----------------------------------------*BCC, BLE, BGT--------------------------------------------------    
*************************************************************************************************************************
*-----------------------------------------MOVEQ--------------------------------------------------    
OPCODE0111
    MOVE.W      D7, D4
    ANDI.W      #$0100, D4
    CMP.W       #$0000, D4
    BEQ         P_IS_MOVEQ
    ADD.B       #10, BAD_DATA_SWITCH  
    RTS   
 
P_IS_MOVEQ
    MOVE.B          #'M',(A5)+
    MOVE.B          #'O',(A5)+
    MOVE.B          #'V',(A5)+
    MOVE.B          #'E',(A5)+
    MOVE.B          #'Q',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D7, D4
    ANDI.W          #$00FF, D4
    MOVE.B          #'#',(A5)+
    MOVE.B              #0,D6                         
    MOVE.L          D4,D5                         
    MOVE.B          #8,D3
    JSR             LONG_ASCII 
 
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
   
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    RTS 
*-------------------------------------END MOVEQ--------------------------------------------------    
************************************************************************************************
*-------------------------------------SUB--------------------------------------------------------    
OPCODE1001
    MOVE.W      D7, D4
    ANDI.W      #$01C0, D4 
  
    *OPMODE FOR ADD
    CMP.W       #$0000, D4
    BEQ         B_EA_DN_1001
    CMP.W       #$0100, D4
    BEQ         B_DN_EA_1001
   
    CMP.W       #$0040, D4
    BEQ         W_EA_DN_1001
    CMP.W       #$0140, D4
    BEQ         W_DN_EA_1001
   
    CMP.W       #$0080, D4
    BEQ         L_EA_DN_1001
    CMP.W       #$0180, D4
    BEQ         L_DN_EA_1001
 
    ADD.B       #10, BAD_DATA_SWITCH  
    RTS   
 
*BYTE CASE   
B_EA_DN_1001
    JSR             LOAD_SUB_
    MOVE.B          #'B',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
 
B_DN_EA_1001
    JSR             LOAD_SUB_
    MOVE.B          #'B',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    MOVE.B          #',',(A5)+
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR             00(A0,D6) 
    RTS
 
 
W_EA_DN_1001
    JSR             LOAD_SUB_
    MOVE.B          #'W',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
W_DN_EA_1001
    JSR             LOAD_SUB_
    MOVE.B          #'W',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    MOVE.B          #',',(A5)+
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    RTS
L_EA_DN_1001
    JSR             LOAD_SUB_
    MOVE.B          #'L',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
L_DN_EA_1001
    JSR             LOAD_SUB_
    MOVE.B          #'L',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    MOVE.B          #',',(A5)+
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    RTS
  
 
 
LOAD_SUB_
    MOVE.B          #'S',(A5)+
    MOVE.B          #'U',(A5)+
    MOVE.B          #'B',(A5)+
    MOVE.B          #'.',(A5)+
    RTS
*---------------------------------------------END SUB---------------------------------------------------------------
*************************************************************************************************************************
*-----------------------------------------------CMP-----------------------------------------------------------------

OPCODE1011
    MOVE.B         #'C',(A5)+            
    MOVE.B         #'M',(A5)+
    MOVE.B         #'P',(A5)+ 
    MOVE.B         #'.',(A5)+  
         
    MOVE.W          D7, D6           *copy instruction in D7 to D6
    MOVE.W          D6, D5           *copy instruction in D6 to D5 
    ANDI.W          #$01C0,D6        * GET OPMODE Add $10C0 to instruction to get bit 678 in the instruction
    ROL.W           #7, D6          *Move the 1st 7 bits of intsruction to the end
    ROL.W           #3, D6          *Move 6,7,8th bits to the end
    CMP.B           #0, D6
    BEQ             PRINTCMPB1011
    CMP.B           #1, D6
    BEQ             PRINTCMPW1011
    CMP.B           #2, D6
    BEQ             PRINTCMPL1011
    ADD.B       #10, BAD_DATA_SWITCH             
    RTS
PRINTCMPB1011 
    MOVE.B         #'B',(A5)+
    BRA            GETSOURCE1011
    
PRINTCMPW1011  
    MOVE.B         #'W',(A5)+
    BRA             GETSOURCE1011
PRINTCMPL1011 
    MOVE.B         #'L',(A5)+
    BRA             GETSOURCE1011
GETSOURCE1011   *GET EA MODE

    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+ 
    MOVE.W          D5, D6
    ANDI.W          #$0038, D6
    CMP.W           #$0000, D6
    
   BEQ             DN_CASE_1011    * Dn
   
   CMP.W           #$0008, D6   
   BEQ             AN_CASE_1011    * An
  
   CMP.W           #$0010, D6 
   BEQ             AN_CASE_RE_1011   *(An)

   CMP.W           #$0018, D6
   BEQ             INCREMENT_AN_CASE_1011    *(An)+
  
   CMP.W           #$0020,D6
   BEQ             DECREMENT_AN_CASE_1011  *-(An)

   CMP.W           #$0038,D6
   BEQ             GET111_1011    *Absoblute or immidately
  
   ADD.B          #10, BAD_DATA_SWITCH  
   RTS
DN_CASE_1011
    MOVE.B          #'D',(A5)+
*    BRA             GET_REGISTER 

    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    BRA             PRINTDN1011      
    RTS


PRINTDN1011 
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D6
    ANDI.W          #$0E00, D6
    ROL.W           #4, D6
    ROL.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    RTS
AN_CASE_1011  
    MOVE.B          #'A',(A5)+
*    BRA             GET_REGISTER 
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    BRA             PRINTDN1011      
    RTS
      
AN_CASE_RE_1011 
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
*    BRA             GET_REGISTER 
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    BRA             PRINTDN1011  
    RTS 

INCREMENT_AN_CASE_1011 
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
*    BRA             GET_REGISTER 
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    MOVE.B          #'+',(A5)+
    BRA             PRINTDN1011 
    RTS
DECREMENT_AN_CASE_1011 
    MOVE.B          #'-',(A5)+ 
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
*    BRA             GET_REGISTER 
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    BRA             PRINTDN1011 
    RTS
*
*GET_REGISTER        * GET 1 TO 7
*    ANDI.W          #$0007, D4
*    LSL.W           #3, D4
*    MOVE.W          D4, D5
*    MOVE.W          D4, D6
*    LSR.W           #3, D6
*    ANDI.W          #$0007, D6
*    MULU            #6, D6
*    LEA             REGISTER, A0
*    JSR             00(A0,D6)      
*    RTS

GET111_1011   
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    CMP.W           #$0000, D4
    BEQ             EA_000_CASE1011    * (xxx).w
    CMP.W           #$0001, D4
    BEQ             EA_001_CASE1011    *(xxx).L
    CMP.W           #$0004, D4
    BEQ             EA_100_CASE1011    *#data
    ADD.B           #10, BAD_DATA_SWITCH   
    RTS 
EA_000_CASE1011      * (xxx).w
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                           
    MOVE.W      (A6)+,D5                          
    MOVE.B      #4,D3  
    JSR         WORD_ASCII
    BRA         PRINTDN1011 
    RTS 
EA_001_CASE1011      *(xxx).L
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                          
    MOVE.L      (A6)+,D5                          
    MOVE.B      #8,D3
    JSR         LONG_ASCII  
    BRA         PRINTDN1011 
    RTS   
EA_100_CASE1011      *#data
    MOVE.W          D7, D6           *copy instruction in D7 to D6
    ANDI.W          #$01C0,D6        * GET OPMODE Add $10C0 to instruction to get bit 678 in the instruction
    ROL.W           #7, D6          *Move the 1st 7 bits of intsruction to the end
    ROL.W           #3, D6          *Move 6,7,8th bits to the end
    CMP.B           #0, D6
    BEQ             IMMIB1011
    CMP.B           #1, D6
    BEQ             IMMIW1011
    CMP.B           #2, D6
    BEQ             IMMIL1011
    ADD.B       #10, BAD_DATA_SWITCH       
    RTS 
IMMIB1011
    MOVE.B      #'#',(A5)+
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                           
    MOVE.W      (A6)+,D5                          
    MOVE.B      #4,D3  
    JSR         WORD_ASCII
    BRA         PRINTDN1011 
    RTS  
IMMIW1011
    MOVE.B      #'#',(A5)+
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                           
    MOVE.W      (A6)+,D5                          
    MOVE.B      #4,D3  
    JSR         WORD_ASCII
    BRA         PRINTDN1011 
    RTS 
IMMIL1011
    MOVE.B      #'#',(A5)+
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                          
    MOVE.L      (A6)+,D5                          
    MOVE.B      #8,D3
    JSR         LONG_ASCII  
    BRA         PRINTDN1011 
    RTS  
  
*-----------------------------------------------END CMP-----------------------------------------------------------------
*************************************************************************************************************************
*-----------------------------------------------MULS & AND-----------------------------------------------------------------   
OPCODE1100      *MULS & AND
    MOVE.W          D5,D4                   *D5:XXXC
    ANDI.W          #$1C00,D5
    CMP.W           #$1C00,D5
    BEQ             OPCODE1100_MULS
  
    MOVE.W      D4,D5
    ROL.W       #3,D4
    ANDI.W      #$7,D4                      *Saving register into D4
    LSL.W       #4,D5                       *D5[opmode][EAmode][EAregister][register]
    BCC         OPCODE1100_EA_SOURCE
    
    JSR     OPCODE1100_SIZE                 *EA_DESTINATION
    JSR     OPCODE1100_EA_MODE
    JSR     OPCODE1100_EA_REGISTER
    
    CMP.B   #$0,D6
    BEQ     OPCODE1100_INVALID_EA_SOURCE
    CMP.B   #$1,D6
    BEQ     OPCODE1100_INVALID_EA_SOURCE
    CMP.B   #$7,D6
    BNE     OPCODE1100_EA_DEST_VALID
    CMP.B   #%100,D5
    BEQ     OPCODE1100_INVALID_EA_SOURCE
        
OPCODE1100_EA_DEST_VALID
    JSR     OPCODE1100_PRINT
    ROR.W   #3,D4
    MOVE.W  D4,D5
    JSR     EAMODE000
    
    MOVE.B      #',',(A5)+
    MOVE.W      D7,D6
    ROR.W       #3,D6
    LEA         EA_MODE,A0
    MOVE.W      D6,D5
    ANDI.W      #$7,D6
    MULU        #6,D6
    JSR         00(A0,D6)
    RTS
    
OPCODE1100_EA_SOURCE
    JSR     OPCODE1100_SIZE
    JSR     OPCODE1100_EA_MODE
    JSR     OPCODE1100_EA_REGISTER
    CMP.B   #$1,D6
    BEQ     OPCODE1100_INVALID_EA_SOURCE
    JSR     OPCODE1100_PRINT
    MOVE.W      D7,D6
    ROR.W       #3,D6
    LEA         EA_MODE,A0
    MOVE.W      D6,D5
    ANDI.W      #$7,D6
    MULU        #6,D6
    JSR         00(A0,D6)
    
    MOVE.B      #',',(A5)+
    ROR.W       #3,D4
    MOVE.W      D4,D5
    JSR         EAMODE000
    RTS
*-------------------------------------------PRINT_SIZE----------------------     
OPCODE1100_PRINT
    MOVE.B      #'A',(A5)+
    MOVE.B      #'N',(A5)+
    MOVE.B      #'D',(A5)+
    MOVE.B      #'.',(A5)+
    JSR         OPCODE1100_PRINT_SIZE
    RTS
OPCODE1100_PRINT_SIZE
    CMP.B       #0,D3
    BEQ         OPCODE1100_PRINT_SIZE_BYTE
    CMP.B       #1,D3
    BEQ         OPCODE1100_PRINT_SIZE_WORD
    CMP.B       #2,D3
    BEQ         OPCODE1100_PRINT_SIZE_LONG

OPCODE1100_PRINT_SIZE_BYTE    
    MOVE.B      #'B',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    RTS         
OPCODE1100_PRINT_SIZE_WORD
    MOVE.B      #'W',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    RTS
OPCODE1100_PRINT_SIZE_LONG
    MOVE.B      #'L',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    RTS
*-------------------------------------------MODE_REGISTER----------------------    
OPCODE1100_EA_REGISTER
    MOVE.W  D7,D5
    ANDI.W  #$7,D5
    RTS
OPCODE1100_EA_MODE
    MOVE.W  D6,D5
    ROL.W   #5,D6
    ANDI.W  #$7,D6
    RTS
OPCODE1100_INVALID_EA_SOURCE
    ADD.B       #10, BAD_DATA_SWITCH         
    RTS 
*----------------------------------------------MODE_REGISTER----------------------
OPCODE1100_SIZE
    MOVE.W      D5,D6
    ROL.W       #2,D5
    ANDI.W      #$3,D5
    CMP.W       #$0,D5
    BEQ         OPCODE1100_AND_BYTE
    CMP.W       #$1,D5
    BEQ         OPCODE1100_AND_WORD
    CMP.W       #$2,D5
    BEQ         OPCODE1100_AND_LONG
    ADD.B       #10, BAD_DATA_SWITCH               
    RTS

OPCODE1100_AND_BYTE
    MOVE.B      #0,D3
    RTS
OPCODE1100_AND_WORD
    MOVE.B      #1,D3
    RTS
OPCODE1100_AND_LONG
    MOVE.B      #2,D3
    RTS    
    MOVE.B      #'A',(A5)+
    MOVE.B      #'N',(A5)+
    MOVE.B      #'D',(A5)+
    MOVE.B      #'.',(A5)+
    CMP.W       #0,D5
    BEQ         OPCODE1100_AND_BYTE

OPCODE1100_MULS
    MOVE.B      #'M',(A5)+
    MOVE.B      #'U',(A5)+
    MOVE.B      #'L',(A5)+
    MOVE.B      #'S',(A5)+
    MOVE.B      #'.',(A5)+
    MOVE.B      #'W',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+ 


    MOVE.W      D7,D6               
    ANDI.W      #$003F,D6           *To only see the EA mode and register
    LEA         EA_MODE,A0          
    ROR.W       #3,D6
    MOVE.W      D6,D5
    ANDI.W      #$F,D6
    MULU        #6,D6
    JSR         0(A0,D6)
    
    MOVE.B      #',',(A5)+
    ROL.W       #4,D7
    ANDI.W      #$E000,D7
    MOVE.L      D7,D5
    JSR         EAMODE000
    
    RTS
*-----------------------------------------------------END MULS & AND -------------------------------    
*******************************************************************************************
*-----------------------------------------------------ADD & ADDA -------------------------------    
OPCODE1101
    MOVE.W      D7, D4
    ANDI.W      #$01C0, D4 
  
    *OPMODE FOR ADD
    CMP.W       #$0000, D4
    BEQ         B_EA_DN
    CMP.W       #$0100, D4
    BEQ         B_DN_EA
   
    CMP.W       #$0040, D4
    BEQ         W_EA_DN
    CMP.W       #$0140, D4
    BEQ         W_DN_EA
   
    CMP.W       #$0080, D4
    BEQ         L_EA_DN
    CMP.W       #$0180, D4
    BEQ         L_DN_EA
   
    **OPMODE FOR ADDA
    CMP.W       #$00C0, D4
    BEQ         W_EA_AN
    CMP.W       #$01C0, D4
    BEQ         L_EA_AN
 
    ADD.B       #10, BAD_DATA_SWITCH  
    RTS   
 
*BYTE CASE   
B_EA_DN
    JSR             LOAD_ADD_
    MOVE.B          #'B',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
 
B_DN_EA
    JSR             LOAD_ADD_
    MOVE.B          #'B',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    MOVE.B          #',',(A5)+
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    RTS
 
 
W_EA_DN
    JSR             LOAD_ADD_
    MOVE.B          #'W',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
W_DN_EA
    JSR             LOAD_ADD_
    MOVE.B          #'W',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    MOVE.B          #',',(A5)+
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    RTS
L_EA_DN
    JSR             LOAD_ADD_
    MOVE.B          #'L',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
L_DN_EA
    JSR             LOAD_ADD_
    MOVE.B          #'L',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    MOVE.B          #',',(A5)+
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR         00(A0,D6) 
    RTS
    
    
W_EA_AN
    JSR             LOAD_ADDA_
    MOVE.B          #$1, D3
    MOVE.B          #'W',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR             00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
    
L_EA_AN
    JSR             LOAD_ADDA_
    MOVE.B          #'L',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
    MOVE.B          #' ',(A5)+
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
 
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
   
    MOVE.W          D5, D6                    
    ROL.W           #3, D6
    MOVE.W          D6, D5
    CLR.L           D3
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             EA_MODE, A0
    JSR             00(A0,D6) 
    
    MOVE.B          #',',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.W          D7, D4
    ANDI.W          #$0E00, D4
    LSR.W           #4, D4
    LSR.W           #4, D4
    LSR.W           #1, D4
    MOVE.W          D4, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    RTS
 
LOAD_ADD_
    MOVE.B          #'A',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.B          #'.',(A5)+
    RTS
   
LOAD_ADDA_
    MOVE.B          #'A',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.B          #'A',(A5)+
    MOVE.B          #'.',(A5)+
    RTS   
*-----------------------------------------------------END ADD & ADDA -------------------------------    
*****************************************************************
*-----------------------------------------------------* - ASR, LSL, ROL-------------------------------    
OPCODE1110              
    MOVE.W      D7, D4
    ANDI.W      #$0118, D4
    CMP.W       #$0118, D4
    BEQ         IS_ROL
    CMP.W       #$0000, D4
    BEQ         IS_ASR
    CMP.W       #$0108, D4
    BEQ         IS_LSL
    
    ADD.B       #10, BAD_DATA_SWITCH               
    RTS
    
IS_ROL
    MOVE.B  #'R',(A5)+
    MOVE.B  #'O',(A5)+
    MOVE.B  #'L',(A5)+
    MOVE.B  #'.',(A5)+
    JSR     SHIFTER_SIZE
    RTS
IS_ASR
    MOVE.B  #'A',(A5)+
    MOVE.B  #'S',(A5)+
    MOVE.B  #'R',(A5)+
    MOVE.B  #'.',(A5)+
    JSR     SHIFTER_SIZE
    RTS
IS_LSL
    MOVE.B      #'L',(A5)+
    MOVE.B      #'S',(A5)+
    MOVE.B      #'L',(A5)+
    MOVE.B      #'.',(A5)+            
    JSR         SHIFTER_SIZE
    RTS
SHIFTER_SIZE
    MOVE.W      D7, D4
    ANDI.W      #$00C0, D4
    CMP.W       #$0000, D4
    BEQ         SHIFTER_B
    CMP.W       #$0040, D4
    BEQ         SHIFTER_W
    CMP.W       #$0080, D4
    BEQ         SHIFTER_L
    
    ADD.B       #10, BAD_DATA_SWITCH               
    RTS
    
SHIFTER_B
    MOVE.B      #'B',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    BRA         SHIFTER_IR
SHIFTER_W
    MOVE.B      #'W',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    BRA         SHIFTER_IR    
SHIFTER_L
    MOVE.B      #'L',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    BRA         SHIFTER_IR

SHIFTER_IR
    MOVE.W      D7, D4
    ANDI.W      #$0020, D4
    CMP.W       #$0020, D4
    BEQ         SHIFTER_D_REGISTER              ******
    CMP.W       #$0000, D4
    BEQ         SHIFTER_NUM
    
SHIFTER_D_REGISTER
    MOVE.B      #'D',(A5)+
    MOVE.W      D7, D4
    ANDI.W      #$0E00, D4
    LSR.W       #6, D4
    MOVE.W      D4, D5
    MOVE.W      D4, D6
    LSR.W       #3, D6
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)   

    MOVE.B      #',',(A5)+   
    MOVE.B      #'D',(A5)+
    MOVE.W      D7, D4
    ANDI.W      #$0007, D4
    LSL.W       #3, D4
    MOVE.W      D4, D5
    MOVE.W      D4, D6
    LSR.W       #3, D6
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)  
   
    RTS
    
SHIFTER_NUM
    MOVE.B      #'#',(A5)+
    MOVE.W      D7, D4
    ANDI.W      #$0E00, D4
    ROR.W       #8, D4
    LSR.B       #1, D4
    ADDI.B      #$30,D4
    MOVE.B      D4,(A5)+
    
    MOVE.B      #',',(A5)+   
    MOVE.B      #'D',(A5)+
    MOVE.W      D7, D4
    ANDI.W      #$0007, D4
    LSL.W       #3, D4
    MOVE.W      D4, D5
    MOVE.W      D4, D6
    LSR.W       #3, D6
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)
    RTS
*-----------------------------------------------------END ASR, LSL, ROL-------------------------------        
*****************************************************************************************************    
*-----------------------------------------------------------DIVU---------------------------------    
OPCODE1000
    MOVE.B         #'D',(A5)+            
    MOVE.B         #'I',(A5)+
    MOVE.B         #'V',(A5)+ 
    MOVE.B         #'U',(A5)+  
    MOVE.B         #' ',(A5)+ 
    MOVE.B         #' ',(A5)+ 
    
    MOVE.W          D7, D6        
    MOVE.W          D7, D6
    ANDI.W          #$01C0,D6          * GET OPCODE 011 FOR OPERATION W - AT 678 BIT       
    CMP.W           #$00C0, D6         *CMP TO 00C0 TO KNOW IT IS A W OPERATION
    BRA             EA_1000            * BRA TO GET OPCODE
    ADD.B           #10, BAD_DATA_SWITCH       
  
EA_1000
  
    MOVE.W          D7, D6
    ANDI.W          #$0038, D6
    CMP.W           #$0000, D6
    
   BEQ             DN_C_1000    * Dn
  
   CMP.W           #$0010, D6 
   BEQ             AN_C_RE_1000   *(An)

   CMP.W           #$0018, D6
   BEQ             INCREMENT_AN_C_1000    *(An)+
  
   CMP.W           #$0020,D6
   BEQ             DECREMENT_AN_C_1000    *-(An)

   CMP.W           #$0038,D6
   BEQ             GET111_1000    *Absoblute or immidately
   
   ADD.B          #10, BAD_DATA_SWITCH  
   RTS
DN_C_1000
    MOVE.B          #'D',(A5)+
*    BRA             GET_REGISTER 

    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)
    BRA             PRINTDN_1000     
    RTS
PRINTDN_1000 
    MOVE.B          #',',(A5)+
    MOVE.B          #'D',(A5)+
    MOVE.W          D7, D6
    ANDI.W          #$0E00, D6
    ROL.W           #4, D6
    ROL.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6)   
    RTS
      
AN_C_RE_1000 
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
*    BRA             GET_REGISTER 
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    BRA             PRINTDN_1000   
    RTS 
   
INCREMENT_AN_C_1000  
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
*    BRA             GET_REGISTER 
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    MOVE.B          #'+',(A5)+
    BRA             PRINTDN_1000 
    RTS
DECREMENT_AN_C_1000  
    MOVE.B          #'-',(A5)+ 
    MOVE.B          #'(',(A5)+
    MOVE.B          #'A',(A5)+
*    BRA             GET_REGISTER 
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    LSL.W           #3, D4
    MOVE.W          D4, D5
    MOVE.W          D4, D6
    LSR.W           #3, D6
    ANDI.W          #$0007, D6
    MULU            #6, D6
    LEA             REGISTER, A0
    JSR             00(A0,D6) 
    MOVE.B          #')',(A5)+
    BRA             PRINTDN_1000 
    RTS

GET111_1000         *CLASSIFY CASE 111
    MOVE.W          D7, D4
    ANDI.W          #$0007, D4
    CMP.W           #$0000, D4
    BEQ             EA_000_1000    * (xxx).w
    CMP.W           #$0001, D4
    BEQ             EA_001_1000    *(xxx).L
    CMP.W           #$0004, D4
    BEQ             EA_100_1000    *#data SAME AS (XXX).W
    ADD.B           #10, BAD_DATA_SWITCH   
    RTS 
EA_000_1000      * (xxx).w  
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                           
    MOVE.W      (A6)+,D5                          
    MOVE.B      #4,D3  
    JSR         WORD_ASCII
    BRA        PRINTDN_1000 
    RTS 
EA_001_1000      *(xxx).L
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                          
    MOVE.L      (A6)+,D5                          
    MOVE.B      #8,D3
    JSR         LONG_ASCII  
    BRA         PRINTDN_1000 
    RTS   
EA_100_1000      * #DATA  
    MOVE.B      #'#',(A5)+
    MOVE.B      #'$',(A5)+
    MOVE.B	    #0,D6                           
    MOVE.W      (A6)+,D5                          
    MOVE.B      #4,D3  
    JSR         WORD_ASCII
    BRA         PRINTDN_1000 
    RTS 
*-----------------------------------------------------------END DIVU---------------------------------
    

                             

*********************************************************
EA_MODE
    JMP    EAMODE000      		Call function with EA mode of 000
    JMP    EAMODE001      		Call function with EA mode of 001
    JMP    EAMODE010      		Call function with EA mode of 010
    JMP    EAMODE011      		Call function with EA mode of 011
    JMP    EAMODE100      		Call function with EA mode of 100
    JMP    EAMODE101      		Call function with EA mode of 101
    JMP    EAMODE110     		Call function with EA mode of 110
    JMP    EAMODE111     		Call function with EA mode of 111
*********************************************************   
REGISTER
    JMP    REGISTER000      	Call function with EA register of 000
    JMP    REGISTER001      	Call function with EA register of 001
    JMP    REGISTER010      	Call function with EA register of 010
    JMP    REGISTER011      	Call function with EA register of 011
    JMP    REGISTER100      	Call function with EA register of 100
    JMP    REGISTER101      	Call function with EA register of 101
    JMP    REGISTER110      	Call function with EA register of 110
    JMP    REGISTER111      	Call function with EA register of 111
*********************************************************   
*ABSOLUTE
*    JMP    ABSOLUTE000      	Call function with absolute register of 000
*    JMP    ABSOLUTE001      	Call function with absolute register of 001
*    JMP    ABSOLUTE010      	Call function with absolute register of 100
*    JMP    ABSOLUTE011      	Call function with absolute register of 100
*    JMP    ABSOLUTE100      	Call function with absolute register of 100
*



* ------------------------------------------  
THREE000
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6) 
    RTS
    
THREE001
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6) 
    RTS  
  
THREE010
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6) 
    RTS
    
THREE011
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6) 
    RTS
    
THREE100
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6) 
    RTS
    
THREE101
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6) 
    RTS
    
THREE110
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6) 
    RTS
    
THREE111
    CMP.W           #$4E75, D7                      Is this an RTS function
    BEQ             IS_RTS                         If so go to the ITSARTS function
    CMP.W           #$4E71, D7
    BEQ             IS_NOP
IS_JSR
    MOVE.W          D5, D6                     
    ROL.W           #3, D6
    MOVE.W          D6, D5
    ANDI.W          #$0007, D6
    MULU            #8, D6
    LEA             THREE_TABLE_2, A0
    JSR             00(A0,D6)   
    RTS
IS_NOP
    MOVE.B  #'N',(A5)+						Insert R into output
    MOVE.B  #'O',(A5)+						Insert T into output
    MOVE.B  #'P',(A5)+						Insert S into output
    RTS  
IS_RTS
    MOVE.B  #'R',(A5)+						Insert R into output
    MOVE.B  #'T',(A5)+						Insert T into output
    MOVE.B  #'S',(A5)+						Insert S into output
    RTS       
*-------------------------------------------------------------------------------    
    
    
    
    
    
THREE2000
    MOVE.B      #'C',(A5)+
    MOVE.B      #'L',(A5)+
    MOVE.B      #'R',(A5)+
    MOVE.B      #'.',(A5)+
    MOVE.B      #'B',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         EA_MODE, A0
    JSR         00(A0,D6)   
       
    RTS
THREE2001
    MOVE.B      #'C',(A5)+
    MOVE.B      #'L',(A5)+
    MOVE.B      #'R',(A5)+
    MOVE.B      #'.',(A5)+
    MOVE.B      #'W',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         EA_MODE, A0
    JSR         00(A0,D6)   
       
    RTS

THREE2010
    MOVE.W      D7, D6
    ANDI.W      #$FF00, D6
    CMP.W       #$4200, D6
    BEQ         IS_CLR
    
    MOVE.B      #'J',(A5)+
    MOVE.B      #'S',(A5)+
    MOVE.B      #'R',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+    
    MOVE.B      #' ',(A5)+ 
    BRA         THREE2010_EA   
    
IS_CLR
    MOVE.B      #'C',(A5)+
    MOVE.B      #'L',(A5)+
    MOVE.B      #'R',(A5)+
    MOVE.B      #'.',(A5)+
    MOVE.B      #'L',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
THREE2010_EA    
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         EA_MODE, A0
    JSR         00(A0,D6)  
    RTS
THREE2011
    RTS
THREE2100
    RTS
THREE2101
    RTS
THREE2110
    RTS
THREE2111 
    MOVE.B      #'L',(A5)+
    MOVE.B      #'E',(A5)+
    MOVE.B      #'A',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.B      #' ',(A5)+
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         EA_MODE, A0
    JSR         00(A0,D6)  
    MOVE.B      #',',(A5)+
    
    CLR.L       D5
    MOVE.W      D7, D5
    ROL.L       #4, D5
    JSR         EAMODE010 
    RTS
    



EAMODE000
    MOVE.B      #'D',(A5)+  
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)
    RTS   
EAMODE001
    MOVE.B      #'A',(A5)+  
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)
    RTS 
    RTS       		
EAMODE010 
    MOVE.B      #'(',(A5)+  
    MOVE.B      #'A',(A5)+  
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)
    MOVE.B      #')',(A5)+
    RTS		
EAMODE011 
    MOVE.B      #'(',(A5)+  
    MOVE.B      #'A',(A5)+  
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)
    MOVE.B      #')',(A5)+
    MOVE.B      #'+',(A5)+
    RTS
EAMODE100
    MOVE.B      #'-',(A5)+
    MOVE.B      #'(',(A5)+  
    MOVE.B      #'A',(A5)+  
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)
    MOVE.B      #')',(A5)+
    RTS      		
EAMODE101
    ADD.B       #10, BAD_DATA_SWITCH             
    RTS      		
EAMODE110
    ADD.B       #10, BAD_DATA_SWITCH             
    RTS     		
EAMODE111
    MOVE.W      D5, D6                     
    ROL.W       #3, D6
    MOVE.W      D6, D5
    ANDI.W      #$0007, D6
    MULU        #6, D6
    LEA         REGISTER, A0
    JSR         00(A0,D6)
    RTS 		


* Registers ------------------------------------------------
REGISTER000
    MOVE.W      D5, D6                     
    ROL.W       #8, D6
    ROL.W       #5, D6

    ANDI.W      #$0007, D6
    CMP.B       #$7,D6
    BEQ         ReadNextW
    BRA         CREGISTER000
ReadNextW
    MOVE.B	    #0,D6                           * Set 0
    MOVE.B      #'$',(A5)+
    MOVE.W      (A6)+,D5                           * Bad Code to D5
    MOVE.B      #4,D3
    JSR         WORD_ASCII
    RTS
CREGISTER000
    MOVE.B      #'0',(A5)+
    RTS
    
REGISTER001
    MOVE.W      D5, D6                     
    ROL.W       #8, D6
    ROL.W       #5, D6

    ANDI.W      #$0007, D6
    CMP.B       #$7,D6
    BEQ         ReadNextL
    BRA         CREGISTER001  
ReadNextL
    MOVE.B	    #0,D6                           * Set 0
    MOVE.B      #'$',(A5)+
    MOVE.L      (A6)+,D5                           * Bad Code to D5
    MOVE.B      #8,D3
    JSR         LONG_ASCII
    RTS
CREGISTER001  
    MOVE.B      #'1',(A5)+
    RTS
    
REGISTER010
    MOVE.B      #'2',(A5)+
    RTS
REGISTER011
    MOVE.B      #'3',(A5)+
    RTS
REGISTER100
    MOVE.W      D5, D6                     
    ROL.W       #8, D6
    ROL.W       #5, D6

    ANDI.W      #$0007, D6
    CMP.B       #$7,D6
    BEQ         SIZE100
    BRA         CREGISTER100
SIZE100
    CMP.B       #$1,D3
    BEQ         ReadNextW_100
    CMP.B       #0,D3
    BEQ         ReadNextL_100
ReadNextW_100
    MOVE.B      #'#',(A5)+
    MOVE.B      #0,D6
    MOVE.W      (A6)+,D5
    MOVE.B      #4,D3
    JSR         WORD_ASCII
    RTS
ReadNextL_100
    MOVE.B      #'#',(A5)+
    MOVE.B      #0,D6
    MOVE.W      (A6)+,D5
    MOVE.B      #8,D3
    JSR         LONG_ASCII
    RTS
CREGISTER100    
    MOVE.B      #'4',(A5)+
    RTS
REGISTER101
    MOVE.B      #'5',(A5)+
    RTS
REGISTER110
    MOVE.B      #'6',(A5)+
    RTS
REGISTER111
    MOVE.B      #'7',(A5)+
    RTS
*---------------------------------------------------------------


********************************************************************************************
*------------------ PRINT CURRENT ADDRESS IN ASCII -----------------------------------------
PRINT_CURRENT_ADD
        MOVE.L      A6,D2                       * Move current address into D2
        MOVE.B      #0,D5                       * Set counter to read all hex
        MOVE.B      #8,D6                       
CONVERT_HEX_ASCII
        CMP.B       D5,D6                       * Check if last hex character is read
        BNE         SET_COUNTER_4               * Set counter to read 4 bits
        MOVE.B      #6, D0
        MOVE.B      #32, D1
        TRAP        #15
        TRAP        #15
        TRAP        #15
        RTS
SET_COUNTER_4
        MOVE.B      #0,D3                       
        MOVE.B      #4,D4    
Loop
        CMP.B       D3,D4                       * Read one character at a time
        BEQ         STORE_ONE_CHAR
        LSL.L       #1,D2
        BCC         ADDZERO
        ADDI.B      #1,D1
        BRA         INCREMENT_BIT_LOOP
ADDZERO
        ADDI.B      #0,D1
INCREMENT_BIT_LOOP
        ADDI.B      #1,D3
        LSL.L       #1,D1
        BRA         Loop
STORE_ONE_CHAR                                   * Store hex character
        LSR.L       #1,D1
        CMP.B       #$A,D1
        BLT         HEX_TO_ASCII_NUMBER
        ADDI.B      #$37,D1                     * HEX_TO_ASCII_LETTER
        BRA         INCREMENT_NEXT_HEX_LOOP
HEX_TO_ASCII_NUMBER
        ADDI.B      #$30,D1
INCREMENT_NEXT_HEX_LOOP
        ADDI.B      #1,D5
        MOVE.B      #6,D0
        TRAP        #15
        CLR.L       D1
        BRA         CONVERT_HEX_ASCII
***********************END OF PRINTING HEX ADDRESS TO ASCII *******************

********************************************************************************************
*------------------ KEY -  -----------------------------------------------------------------
* Desctiption:
* Expect:       DO, D1, A1 to be empty
* 
*------------------ Prompt User for Enter, R, or Q -----------------------------------------
USER_RESPONSE
        LEA         PROMPTOPTIONS, A1            * Load the prompt message
        MOVE.B      #14,D0
        TRAP        #15 
        MOVE.B      #$00, LINE_COUNT            * Reset Line Count 
        MOVE.B      #5, D0                      * Log keyboard input
        TRAP        #15                 
        CMP.B       #$D, D1                     * Compare the key press with ENTER
        BEQ         CLEAR_SCREEN                  
        CMP.B       #$72, D1                    * Compare the key press with R
        BEQ         RESTART             
        CMP.B       #$52, D1                    * Compare the key press with r
        BEQ         RESTART             
        CMP.B       #$71, D1                    * Compare the key press with q
        BEQ         END_PROGRAM             
        CMP.B       #$51, D1                    * Compare the key press with Q
        BEQ         END_PROGRAM            
        CMP.B       #$5D, D1                    * Check the key press with ENTER
        BNE         USER_RESPONSE              
CLEAR_SCREEN
        MOVE.B  #11, D0                         * Task 11 - Clear screen
        MOVE.W  #$FF00, D1          
        TRAP    #15                 
        CLR.L   D1
        CLR.L   D0
        RTS                 
*------------------ RESTART ----------------------------------------------------------------
RESTART
        JSR         CLEAR_SCREEN
        JSR         CLEAR_REGISTERS
        MOVEA.L     #$01000000,A7       Reset stack pointer
        MOVEA.L     #$01000000,A6       Reset stack pointer
        BRA         START
        
********************************************************************************************
*------------------ CLEAR REGISTERS --------------------------------------------------------
* Desctiption:
* 
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

********************************************************************************************
********************************************************************************************
********************************************************************************************
END_PROGRAM
        SIMHALT             ; halt simulator
********************************************************************************************
********************************************************************************************
********************************************************************************************


********************************************************************************************
* VARIABLES & MESSAGES ---------------------------------------------------------------------
CR        EQU       $0D
LF        EQU       $0A

* MESSAGES ---------------------------------------------------------------------------------------------
GREETING        DC.B    '       HELLO THERE, WELCOME TO AWESOME DISASSEMBLER'
                DC.B    CR,LF,'Note: Addressess must be in HEX'
                DC.B    CR,LF,'Note: Addressess must be in caps'
                DC.B    CR,LF,'    : Starting Address must be greater than 70000',CR,LF,CR,LF,CR,LF,0 
PROMPTSADDR     DC.W    'ENTER A STARTING ADDRESS (ON CAPS): ',0
PROMPTEADDR     DC.W    'ENTER A ENDING ADDRESS   (ON CAPS): ',0
PROMPTOPTIONS    DC.B    'Press: ENTER to Continue || Q or q to Quit || R OR r to Restart',CR,LF,CR,LF,0
* ERROR MSG --------------------------------------------------------------------------------------------
INVALIDSADDR        DC.B    'ERROR: INVALID STARTING ADDRESS VERSUS ENDING.',CR,LF,CR,LF,0
ERRORINPUTSIZE      DC.B    'ERROR: INVALID ADDRESS SIZE',CR,LF,CR,LF,0
INVALIDCHAR         DC.B    'ERROR: INVALID ADDRESS CHARACTER',CR,LF,CR,LF,0
SGTEM               DC.B    'ERROR: STARTING ADDRESS > ENDING ADDRESS',CR,LF,CR,LF,0
ODD_ADD_MSG         DC.B    'ERROR: ODD ADDRESS',CR,LF,CR,LF,0
STARTING_ADDR_7     DC.B    'ERROR: Invalid starting adress - must be greater than 7000',CR,LF,CR,LF,0
* VARIABLES --------------------------------------------------------------------------------------------

LINE_COUNT      DS.L    1
BAD_DATA_SWITCH DS.L    1    
SIZE            DS.B    1
INPUT_HEX       DS.L    1   * Use to temp hold starting and ending address
STARTING_ADD    DS.L    1   ;1 is the size, if I change to 4 then array size changes
ENDING_ADD      DS.L    1
PRINTER         DC.L    1
        
        END    START        ; last line of source
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
