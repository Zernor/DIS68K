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
   		MOVE.B      #0, LINE_COUNT          * Initilize the LINE_COUNTER variable 
    
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

STORE_E             
        MOVE.L      D7, ENDING_ADD  
        CLR.L       D7
        JSR         OPCODESETUP
        BRA         ADDR_LOOP
SGTE                                        * Starting greater then ending
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
        CMP.B       #25, LINE_COUNT             * Check line counter
        BNE         CONTINUE_ADDR_LOOP
        JSR         GETKEY        
CONTINUE_ADDR_LOOP        
        ADD.B       #1, LINE_COUNT              * Update Line counter
        JSR         CLEAR_REGISTERS             * Clear registers
        JSR         PRINT_CURRENT_ADD           * PRINT CURRENT ADDRESS
        LEA         OPCODE, A3                  * initialize good buffer
        LEA         BADCODE, A4                 * initialize bad buffer
        
        MOVE.W      (A6)+, D6
        JSR		    SETUPBADDATA		        * Setup the bad data printing
        JSR         SETUPOPCODE
        JSR         GET_INSTRUCTION

        CMP.B       $FF,D7                      * Is the instruction bad data?
        BEQ         PRINTBADDATA		            It is! Print it out
        
        MOVE.B      #$00,(A3)+                  * Add 00 to opcode printer
        LEA         OPCODE, A1		            * Print good data
        MOVEQ       #13,D0				
        TRAP        #15					
        CLR.L       D6
        BRA         ADDR_LOOP
PRINTBADDATA
        MOVE.B  #$00,(A4)+          Add 00 BAD_BUFFER so we can end the line.
        LEA     BADCODE,A1		Load the bad data into A1
        MOVEQ   #13,D0				set print trap
        TRAP    #15					Call trap
        CLR.L	D7					Clear the bad data flag
        BRA     ADDR_LOOP		Go back to main loop
        
        
SETUPOPCODE
        MOVE.B  #' ',(A3)+
        MOVE.B  #' ',(A3)+
        MOVE.B  #' ',(A3)+
        MOVE.B  #' ',(A3)+
        MOVE.B  #' ',(A3)+
        RTS
        
*---------------------------------------------------------------------------------------
SETUPBADDATA
        *MOVE.L  #$00000000, A4

        MOVE.B  #' ',(A4)+
        MOVE.B	#'B',(A4)+			Insert B into the output
        MOVE.B	#'A',(A4)+			Insert A into the output
        MOVE.B	#'D',(A4)+			Insert D into the output
        MOVE.B	#' ',(A4)+			Insert a space into the output
        MOVE.B	#'D',(A4)+			Insert D into output
        MOVE.B	#'A',(A4)+			Insert A into output
        MOVE.B	#'T',(A4)+			Insert T into output
        MOVE.B	#'A',(A4)+			Insert A into output
        MOVE.B	#' ',(A4)+			Insert a space into output
        MOVE.B	#'$',(A4)+			Insert a $ into output
GETBADDATA            
        MOVEQ	#4,D0               Move counter to D0
        MOVE.W  D6,D4               Move longword address into D4
DATA_PREP9                      	
    	ROL.W  #4,D4               	Move the MSB to LSB
    	MOVE.L D4,D5               	Move longword address to D5
    	ANDI.L #$0000000F,D5       	Clear everything except for MSB
DATA_ASC9
    	CMPI.B #$09,D5             	Is the character a number?
    	BLE    DATA_NUM9            Branch if yes.
DATA_LET9
    	ADDI.B #$37,D5             	Convert into a prinatble ascii letter
    	BRA    DATA_CHAR9
DATA_NUM9 
    	ADDI.B #$30,D5             	Convert into a prinatble ascii number
    	BRA    DATA_CHAR9
DATA_CHAR9
    	SUBI.B #1,D0               	Decrement counter
    	MOVE.B D5,(A4)+            	Move ascii into bad buffer also
    	CMPI.B #0,D0               	Have we moved all characters?
    	BGT    DATA_PREP9          	if not, repeat loop
    	RTS
*---------------------------------------------------------------------------------

GET_INSTRUCTION
        CLR.B   D1					            * Clear D1 so other tests don't get bugged
        MOVE.W  D6, D5                          * Move the instruction so we can shift it
        LSR.W   #8, D5				            * Shift 8 bits to the right
        LSR.W   #4, D5				            * Shift 4 biths to the right
        MULU    #8, D5             	            * Offset D5 to show the word binary for the instruction
        LEA     OPCODE_JMP_TABLE, A0      	    * Set the table to A0 so we know where to jump to
        JSR     0(A0,D5)          	            
        RTS        

********************************************************************************************
* OP CODE                                              
OPCODE_JMP_TABLE
    JSR     INSTR0000                           * - ADDI
    RTS
    JSR     INSTR0001                           * - MOVE.B
    RTS
    JSR     INSTR0010                           * - MOVE.L
    RTS
    JSR     INSTR0011                           * - MOVE.W
    RTS
    JSR     INSTR0100                           * - MOVEM, LEA, JSR, CLR, RTS, NOP
    RTS
    JSR     INSTR0110                           * - BCC, BLE, BGT
    RTS
    JSR     INSTR0111                           * - MOVEQ
    RTS
    JSR     INSTR1001                           * - SUB
    RTS
    JSR     INSTR1011                           * - CMP
    RTS
    JSR     INSTR1100                           * - ADD, MULS
    RTS
    JSR     INSTR1101                           * - ADDA, AND, 
    RTS
    JSR     INSTR1110                           * - ASR, LSL, ROL
    RTS
    JSR     INSTR1000                           * - DIVU
    RTS   
    
    JSR     INSTR0101                           * - BAD DATA
    RTS   
    JSR     INSTR1010                           * - BAD DATA
    RTS   
    JSR     INSTR1111                           * - BAD DATA
    RTS   


    
********************************************************


INSTR0101                           
    MOVE.B	$11, D7   
    RTS
INSTR1010  
    MOVE.B	$11, D7   
    RTS                         
INSTR1111 
    MOVE.B	$11, D7   
    RTS                          


INSTR0000
    RTS
INSTR0001
    RTS
INSTR0010
    RTS
INSTR0011
    RTS
INSTR0100
    MOVE.W  D6, D5                      Move instruction for shifting
    LSR.W   #$8, D5
    ANDI.W  #$000F, D5
    MULU    #8, D5
    LEA     FOURTABLE, A0
    JSR     00(A0,D5)   
    RTS
INSTR0110
    RTS
INSTR0111
    RTS
INSTR1001
    RTS
INSTR1011
    RTS  
INSTR1100
    RTS
INSTR1101
    RTS  
INSTR1110
    RTS
INSTR1000
    RTS
    








* 1011 - CMP INSTRUCTION TABLES             *                   
*BINSTTABLE
*    JSR     BTABLE000                       CMP.B Instruction
*    RTS
*    JSR     BTABLE001                       CMP.W Instruction
*    RTS
*    JSR     BTABLE010                       CMP.L Instruction
*    RTS

*********************************************************
* 0100 Jump Table CLR, JSR, LEA, MOVEM, RTS INSTRUCTIONS
FOURTABLE     
    JSR     FOUR0000                    Illegal Instruction
    RTS                                 Return Bad Instruction
    JSR     FOUR0001                    LEA instruction with An = 0
    RTS                                 Return full instruction
    JSR     FOUR0010                    CLR instruction
    RTS                                 Return full instruction
    JSR     FOUR0011                    LEA instruction with An = 1
    RTS                                 Return full instruction
    JSR     FOUR0100                    Illegal Instruction
    RTS                                 Return Bad Instruction
    JSR     FOUR0101                    LEA instruction with An = 2
    RTS                                 Return full instruction
    JSR     FOUR0110                    Illegal Instruction
    RTS                                 Return Bad Instruction
    JSR     FOUR0111                    LEA instruction with An = 3
    RTS                                 Return full instruction
    JSR     FOUR1000                    MOVEM instruction for Register to Memory
    RTS                                 Return full instruction
    JSR     FOUR1001                    LEA instruction with An = 3
    RTS                                 Return full instruction
    JSR     FOUR1010                    Illegal Instruction
    RTS                                 Return Bad Instruction
    JSR     FOUR1011                    LEA instruction with An = 4
    RTS                                 Return full instruction
    JSR     FOUR1100                    MOVEM instruction for Memory to Register
    RTS                                 Return full instruction
    JSR     FOUR1101                    LEA instruction with An = 5
    RTS                                 Return full instruction
    JSR     FOUR1110                    JSR and RTS instructions
    RTS                                 Return full instruction
    JSR     FOUR1111                    LEA instruction with An = 6
    RTS
*********************************************************
FORMAT
    JMP    FORMAT000      		Call function with EA mode of 000
    JMP    FORMAT001      		Call function with EA mode of 001
    JMP    FORMAT010      		Call function with EA mode of 010
    JMP    FORMAT011      		Call function with EA mode of 011
    JMP    FORMAT100      		Call function with EA mode of 100
    JMP    FORMAT101      		Call function with EA mode of 101
    JMP    FORMAT110     		Call function with EA mode of 110
    JMP    FORMAT111     		Call function with EA mode of 111
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
ABSOLUTE
    JMP    ABSOLUTE000      	Call function with absolute register of 000
    JMP    ABSOLUTE001      	Call function with absolute register of 001
    JMP    ABSOLUTE010      	Call function with absolute register of 100
    JMP    ABSOLUTE011      	Call function with absolute register of 100
    JMP    ABSOLUTE100      	Call function with absolute register of 100

********************************************************
* Illegal Instruction                                  *     
********************************************************
FOUR0000
    MOVE.B  $11, D7							Create bad data flag
    RTS                                     Return the instruction
********************************************************
* 0100 0001 - LEA instruction with An = 0              *     
********************************************************
FOUR0001
    JSR     LEAMAIN
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'0',(A3)+                      Move 0 into the output
    RTS                                     Return the instruction
********************************************************
* 0100 0010 - CLR                                      *     
********************************************************
FOUR0010
    MOVE.B  #'C',(A3)+                      Move C into output
    MOVE.B  #'L',(A3)+                      Move L into output
    MOVE.B  #'R',(A3)+                      MOVE R into output
    MOVE.B  #'.',(A3)+                      MOVE . into output
    JSR     GETSIZE                         Get the size of CLR
    CMP.B   #%00, D3                        Is it Byte data?
    BEQ     BYTEDATA                        If so go to BYTEDATA
    CMP.B   #$01, D3                        Is it Word data?
    BEQ     WORDDATA                        If so go to WORDDATA
    CMP.B   #$02, D3                        Is it Long data?
    BEQ     LONGDATA                        If so go to LONGDATA
    MOVE.B  $11, D7                         It's not a byte, word or long, so it's bad data
    RTS                                     Return bad data
BYTEDATA
    MOVE.B  #'B',(A3)+                      Move B into output
    BRA     FINISHCLR                       Finish the CLR instruction
WORDDATA
    MOVE.B  #'W',(A3)+                      Move W into output
    BRA     FINISHCLR                       Finish the CLR instruction
LONGDATA
    MOVE.B  #'L',(A3)+                      Move L into output
    BRA     FINISHCLR                       Finish the CLR instruction
FINISHCLR    
    MOVE.B  #' ',(A3)+                      Move a space into the output
    JSR     EACODE                          Call EA code
    RTS                                     Return the instruction

********************************************************
* 0100 0011 - LEA instruction with An = 1              *     
********************************************************
FOUR0011
    JSR     LEAMAIN							Jump to main output printing routine
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'1',(A3)+                      Move 1 into the output
    RTS                                     Return the instruction
********************************************************
* Illegal Instruction                                  *     
********************************************************
FOUR0100
    MOVE.B  $11, D7							Set bad data flag
    RTS                                     Return the instruction
********************************************************
* 0100 0101 - LEA instruction with An = 2              *     
********************************************************
FOUR0101
    JSR     LEAMAIN
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'2',(A3)+                      Move 2 into the output
    RTS                                     Return the instruction
********************************************************
* Illegal Instruction                                  *     
********************************************************
FOUR0110
	MOVE.B	$11, D7
    RTS                                     Return the instruction
********************************************************
* 0100 1001 - LEA instruction with An = 3              *     
********************************************************
FOUR0111
    JSR     LEAMAIN							Jump to main output printing routine
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'3',(A3)+                      Move 3 into the output
    RTS                                     Return the instruction
********************************************************
* 0100 1000 - MOVEM: Register to Memory                *     
********************************************************
FOUR1000
    MOVE.B  #'M',(A3)+                      Move M to the output
    MOVE.B  #'O',(A3)+                      Move O to the output
    MOVE.B  #'V',(A3)+                      Move V to the output
    MOVE.B  #'E',(A3)+                      Move E to the output
    MOVE.B  #'M',(A3)+                      Move M to the output
    MOVE.B  #'.',(A3)+                      Move . to the output
    JSR     GETSIZEONEBIT                   Check size of the instruction
    CMP.B   #%0, D3                         Is it Word data?
    BEQ     WORDDATAR2M                     If so go to MWORDDATA
    CMP.B   #$1, D3                         Is it Long data?
    BEQ     LONGDATAR2M                     If so go to LONGDATA
    MOVE.B  #$11, D7                        It's not a byte, word or long, so it's bad data
    RTS                                     Return bad data
FINDLIST2M
    MOVE.B  #' ',(A3)+                      Move a space into the output
    MOVE.W  (A5)+,D5                        Load next word in memory
    MOVE.W  D5,D4 
    CLR.B   D1                              Clear D1 register (reset counter)
    CLR.L   D3                              Clear D3 register
    MOVE.B  D6,D3                           Used to find EA
    ANDI.B  #$38,D3                         Isolate EA mode
    CMPI.B  #$20,D3
    BEQ     FINDDATAREG_PREDEC              It is a predecremnt do the algorithm with differently
FINDDATAREG
    LSR.B   #1,D5                           Shift to the right
    BCS     FOUNDFIRSTDATA                  Is there at least 1 data register?
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all the data register list?
    BEQ     FINDADDRESSREG                  If so, time to compare address register
    BRA     FINDDATAREG  
FOUNDFIRSTDATA
    MOVE.B  #'D',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    ADDI.B  #$30,D0                          Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
LISTDATALOOP1
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all the data register list?
    BEQ     PRINTLISTDATA1                  If so, print  
    LSR.B   #1,D5                           Shift to the right
    BCS     FOUNDSECONDDATA                 Are there more data registers?
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all in the data register list?
    BEQ     PRINTLISTDATA1                  If so, print
    BRA     LISTDATALOOP1                   If not, repeat loop
PRINTLISTDATA1
    MOVE.B  #'/',(A3)+                      Add / to goodbuffer
    BRA     FINDADDRESSREG                  Time to compare address register
FOUNDSECONDDATA  
    MOVE.B  #'-',(A3)+
LISTDATALOOP2
    LSR.B   #1,D5                           Shift to the right
    BCC     PRINTLISTDATA2
    CMPI.B  #7,D1                           Have we compared all in the data register list?
    BEQ     PRINTLISTDATA2                  If so, time to compare address register
    ADDI.B  #1,D1                           Increment counter
    BRA     LISTDATALOOP2    
PRINTLISTDATA2
    MOVE.B  #'D',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
    MOVE.B  #'/',(A3)+                      Add D to goodbuffer
    MOVEQ   #8,D1
    BRA     FINDADDRESSREG        
FINDADDRESSREG
    LSL.W   #1,D5                           Shift to the left
    BCS     FOUNDFIRSTADDRESS               Is there at least 1 address register?
    SUBI.B  #1,D1                           Decrement counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEMR2M                  If so, branch to finish
    BRA     FINDADDRESSREG  
FOUNDFIRSTADDRESS
    MOVE.B  #'A',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    SUBI.B  #1,D0
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
ADDRESSLOOP1
    SUBI.B  #1,D1                           Decrement counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEMR2M                  If so, branch to finish 
    LSL.W   #1,D5                           Shift to the right
    BCS     FOUNDSECONDADDRESS              Are there more address registers?
    SUBI.B  #1,D1                           Increment counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEMR2M                  If so, branch to finish 
    BRA     ADDRESSLOOP1                    If not, repeat loop   
FOUNDSECONDADDRESS 
    MOVE.B  #'-',(A3)+
LISTADDRESSLOOP2
    LSL.W   #1,D5                           Shift to the left
    BCC     PRINTLISTADDRESS2
    SUBI.B  #1,D1                           Increment counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     PRINTLISTADDRESS2
    BRA     LISTADDRESSLOOP2    
PRINTLISTADDRESS2
    MOVE.B  #'A',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    SUBI.B  #1,D0
    ADDI.B  #$30,D0                          Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
    BRA     FINISHMOVEMR2M  
    ************************
FINDDATAREG_PREDEC 
    LSL.W   #1,D5                           Shift to the right
    BCS     FOUNDFIRSTDATA_PREDEC           Is there at least 1 data register?
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all the data register list?
    BEQ     FINDADDRESSREG_PREDEC           If so, time to compare address register
    BRA     FINDDATAREG_PREDEC   
FOUNDFIRSTDATA_PREDEC
    MOVE.B  #'D',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
LISTDATALOOP1_PREDEC
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all the data register list?
    BEQ     PRINTLISTDATA1_PREDEC           If so, print  
    LSL.W   #1,D5                           Shift to the right
    BCS     FOUNDSECONDDATA_PREDEC          Are there more data registers?
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all in the data register list?
    BEQ     PRINTLISTDATA1_PREDEC           If so, print
    BRA     LISTDATALOOP1_PREDEC            If not, repeat loop
PRINTLISTDATA1_PREDEC
    MOVE.B  #'/',(A3)+                      Add / to goodbuffer
    BRA     FINDADDRESSREG_PREDEC           Time to compare address register
FOUNDSECONDDATA_PREDEC  
    MOVE.B  #'-',(A3)+
LISTDATALOOP2_PREDEC
    LSL.W   #1,D5                           Shift to the right
    BCC     PRINTLISTDATA2_PREDEC
    CMPI.B  #7,D1                           Have we compared all in the data register list?
    BEQ     PRINTLISTDATA2_PREDEC           If so, time to compare address register
    ADDI.B  #1,D1                           Increment counter
    BRA     LISTDATALOOP2_PREDEC    
PRINTLISTDATA2_PREDEC
    MOVE.B  #'D',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
    MOVE.B  #'/',(A3)+                      Add D to goodbuffer
    MOVEQ   #8,D1
    BRA     FINDADDRESSREG_PREDEC        
FINDADDRESSREG_PREDEC
    MOVE.B  D4,D5
FINDADDRESSREG_LOOP
    LSR.B   #1,D5                           Shift to the left
    BCS     FOUNDFIRSTADDRESS_PREDEC        Is there at least 1 address register?
    SUBI.B  #1,D1                           Decrement counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEMR2M                 	If so, branch to finish
    BRA     FINDADDRESSREG_LOOP  
FOUNDFIRSTADDRESS_PREDEC
    MOVE.B  #'A',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    SUBI.B  #1,D0
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
ADDRESSLOOP1_PREDEC
    SUBI.B  #1,D1                           Decrement counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEMR2M                  If so, branch to finish 
    LSR.B   #1,D5                           Shift to the right
    BCS     FOUNDSECONDADDRESS_PREDEC       Are there more address registers?
    SUBI.B  #1,D1                           Increment counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEMR2M                  If so, branch to finish 
    BRA     ADDRESSLOOP1_PREDEC             If not, repeat loop   
FOUNDSECONDADDRESS_PREDEC 
    MOVE.B  #'-',(A3)+
LISTADDRESSLOOP2_PREDEC 
    LSR.B   #1,D5                           Shift to the left
    BCC     PRINTLISTADDRESS2_PREDEC 
    SUBI.B  #1,D1                           Increment counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     PRINTLISTADDRESS2_PREDEC
    BRA     LISTADDRESSLOOP2_PREDEC     
PRINTLISTADDRESS2_PREDEC 
    MOVE.B  #'A',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    SUBI.B  #1,D0
    ADDI.B  #$30,D0                          Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
    BRA     FINISHMOVEMR2M  
FINISHMOVEMR2M
    CLR.B   D1
    MOVE.B  #',',(A3)+                      Move a comma into the output
    JSR     EACODE                          Go to EA Code to finish instruction
    RTS                                     Return the instruction
WORDDATAR2M
    MOVE.B  #'W',(A3)+                      Move W to the output
    BRA     FINDLIST2M                  	Finish the instruction
LONGDATAR2M
    MOVE.B  #'L',(A3)+                      Move L to the output
    BRA     FINDLIST2M                  	Finish the instruction

********************************************************
* 0100 1001 - LEA instruction with An = 4              *     
********************************************************
FOUR1001
    JSR     LEAMAIN
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'4',(A3)+                      Move 4 into the output
    RTS                                     Return the instruction
********************************************************
* Illegal Instruction                                  *     
********************************************************
FOUR1010
    MOVE.B  $11, D7							Flag bad data
    RTS                                     Return the instruction
********************************************************
* 0100 1011 - LEA instruction with An = 5              *     
********************************************************
FOUR1011
    JSR     LEAMAIN							Jump to main output printing routine
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'5',(A3)+                      Move 5 into the output
    RTS                                     Return the instruction
********************************************************
* 0100 1100 - MOVEM: Memory to Register                *     
********************************************************
FOUR1100
    MOVE.B  #'M',(A3)+                      Move M to the output
    MOVE.B  #'O',(A3)+                      Move O to the output
    MOVE.B  #'V',(A3)+                      Move V to the output
    MOVE.B  #'E',(A3)+                      Move E to the output
    MOVE.B  #'M',(A3)+                      Move M to the output
    MOVE.B  #'.',(A3)+                      Move . to the output
    JSR     GETSIZEONEBIT                   Check size of the instruction
    CMP.B   #%0, D3                         Is it Word data?
    BEQ     MWORDDATAM2R                    If so go to MWORDDATA
    CMP.B   #$1, D3                         Is it Long data?
    BEQ     MLONGDATAM2R                    If so go to LONGDATA
    MOVE.B  #$11, D7                        It's not a byte, word or long, so it's bad data
    RTS                                     Return bad data
FINDLIST2R
    MOVE.B  #' ',(A3)+                      Move a space into the output
    MOVEQ   #1,D7
    CLR.B   D3
    JSR     EACODE                          Go to EA Code to finish instruction
    MOVE.B  #',',(A3)+                      Move a space into the output
    MOVE.W  (A5)+,D5                        Load next word in memory 
    CLR.B   D1                              Clear D1 register (reset counter)
FINDDATAREG_
    LSR.B   #1,D5                           Shift to the right
    BCS     FOUNDFIRSTDATA_                  Is there at least 1 data register?
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all the data register list?
    BEQ     FINDADDRESSREG_                  If so, time to compare address register
    BRA     FINDDATAREG_  
FOUNDFIRSTDATA_
    MOVE.B  #'D',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    ADDI.B  #$30,D0                          Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
LISTDATALOOP1_
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all the data register list?
    BEQ     PRINTLISTDATA1_                  If so, print  
    LSR.B   #1,D5                           Shift to the right
    BCS     FOUNDSECONDDATA_                 Are there more data registers?
    ADDI.B  #1,D1                           Increment counter
    CMPI.B  #8,D1                           Have we compared all in the data register list?
    BEQ     PRINTLISTDATA1_                  If so, print
    BRA     LISTDATALOOP1_                   If not, repeat loop
PRINTLISTDATA1_
    MOVE.B  #'/',(A3)+                      Add / to goodbuffer
    BRA     FINDADDRESSREG_                  Time to compare address register
FOUNDSECONDDATA_  
    MOVE.B  #'-',(A3)+
LISTDATALOOP2_
    LSR.B   #1,D5                           Shift to the right
    BCC     PRINTLISTDATA2_
    CMPI.B  #7,D1                           Have we compared all in the data register list?
    BEQ     FINDADDRESSREG_                  If so, time to compare address register
    ADDI.B  #1,D1                           Increment counter
    BRA     LISTDATALOOP2_    
PRINTLISTDATA2_
    MOVE.B  #'D',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
    MOVE.B  #'/',(A3)+                      Add D to goodbuffer
    MOVEQ   #8,D1
    BRA     FINDADDRESSREG_        
FINDADDRESSREG_
    LSL.W   #1,D5                           Shift to the left
    BCS     FOUNDFIRSTADDRESS_               Is there at least 1 address register?
    SUBI.B  #1,D1                           Decrement counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEM2R                  If so, branch to finish
    BRA     FINDADDRESSREG_  
FOUNDFIRSTADDRESS_
    MOVE.B  #'A',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    SUBI.B  #1,D0
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
ADDRESSLOOP1_
    SUBI.B  #1,D1                           Decrement counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEM2R                  If so, branch to finish 
    LSL.W   #1,D5                           Shift to the right
    BCS     FOUNDSECONDADDRESS_              Are there more address registers?
    SUBI.B  #1,D1                           Increment counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINISHMOVEM2R                  If so, branch to finish 
    BRA     ADDRESSLOOP1_                    If not, repeat loop   
FOUNDSECONDADDRESS_ 
    MOVE.B  #'-',(A3)+    
LISTADDRESSLOOP2_
    LSL.W   #1,D5                           Shift to the left
    BCC     PRINTLISTADDRESS2_
    SUBI.B  #1,D1                           Increment counter
    CMPI.B  #0,D1                           Have we compared all in the address register list?
    BEQ     FINDADDRESSREG_                  If so, time to compare address register
    BRA     LISTADDRESSLOOP2_    
PRINTLISTADDRESS2_
    MOVE.B  #'A',(A3)+                      Add D to goodbuffer
    MOVE.B  D1,D0                           Move register number to D0.
    SUBI.B  #1,D0
    ADDI.B  #$30,D0                         Convert hex to ascii
    MOVE.B  D0,(A3)+                        Move ascii number to good buffer
    BRA     FINISHMOVEM2R   
    
MWORDDATAM2R
    MOVE.B  #'W',(A3)+                      Move W to the output
    BRA     FINDLIST2R                  Finish the instruction
MLONGDATAM2R
    MOVE.B  #'L',(A3)+                      Move L to the output
    BRA     FINDLIST2R                  Finish the instruction
FINISHMOVEM2R
    CMPI.B  #1,D3
    BEQ     ADDADDRESSWORD
    CMPI.B  #2,D3
    BEQ     ADDADDRESSLONGWORD
    BRA     RTN
ADDADDRESSWORD
    ADDA.L  #2,A5
    BRA     RTN
ADDADDRESSLONGWORD
    ADDA.L  #4,A5
    BRA     RTN
RTN
    RTS                                     Return the instruction
********************************************************
* 0100 1101 - LEA instruction with An = 6              *     
********************************************************
FOUR1101
    JSR     LEAMAIN							Jump to main output printing routine
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'6',(A3)+                      Move 6 into the output
    RTS                                     Return the ins


********************************************************
*0100 1110 - JSR & RTS                                 *     
********************************************************
FOUR1110
    CMP.W   #$4E75, D6                      Is this an RTS function
    BEQ     ITSARTS                         If so go to the ITSARTS function
    CMP.W   #$4E71, D6
    BEQ     ITSNOP
    MOVE.B  #'J',(A3)+                      Move J into the output
    MOVE.B  #'S',(A3)+                      Move S into the output
    MOVE.B  #'R',(A3)+                      Move R into the output
    MOVE.B  #' ',(A3)+                      Move a space into the output
    JSR     EACODE                          call the EA code
    RTS										Return instruction
ITSNOP
    MOVE.B  #'N',(A3)+						Insert R into output
    MOVE.B  #'O',(A3)+						Insert T into output
    MOVE.B  #'P',(A3)+						Insert S into output
    RTS  

ITSARTS
    MOVE.B  #'R',(A3)+						Insert R into output
    MOVE.B  #'T',(A3)+						Insert T into output
    MOVE.B  #'S',(A3)+						Insert S into output
    RTS                                     Return the instruction
********************************************************
* 0100 1111 - LEA instruction with An = 7              *     
********************************************************
FOUR1111
    JSR     LEAMAIN							Jump to main output printing routine
    MOVE.B  #',',(A3)+                      Move a comma into the output
    MOVE.B  #'A',(A3)+                      Move A into the output
    MOVE.B  #'7',(A3)+                      Move 7 into the output
    RTS                                     


********************************************************
* LEA instruction                                      *     
********************************************************
LEAMAIN
    MOVE.B  #'L',(A3)+                      Move L into the ouput
    MOVE.B  #'E',(A3)+                      Move E into the ouput
    MOVE.B  #'A',(A3)+                      Move A into the ouput
    MOVE.B  #' ',(A3)+                      Move a space into the ouput
    JSR     EACODE                          Call EACODE to grab the only EA
    RTS      
********************************************************
* EA FOR ALL OPCODE                                    *
********************************************************
EACODE
    CLR.W  D4           		Clear previous data in D4
    CLR.W  D5					Clear the D5 register
    MOVE.B D6,D5        		Move to isolate register
    MOVE.B D6,D4       			Move to isolate mode
    ANDI.B #$07,D5     			Isolate regster
    LSR.B  #3,D4        		Shift to isolate mode
    ANDI.B #$07,D4      		Isolate mode
    MULU   #$6,D4       		Find offset for mode
    LEA    FORMAT,A0    		Set the table to A0
    JSR    00(A0,D4)    		Set jumptable
    RTS 




*******************************FORMAT*************************
* 000 - Dn INSTRUCTION                                 *               
FORMAT000
    MOVE.B #'D',(A3)+   		Move D into good buffer
    MULU   #$6,D5       		Find offset for register number
    LEA    REGISTER,A1  		Set the table to A0
    JSR    00(A1,D5)    		Set jumptable
    RTS
* 001 - An INSTRUCTION                                 *               
FORMAT001
    MOVE.B #'A',(A3)+   		Move D into good buffer
    MULU   #$6,D5       		Find offset for register number
    LEA    REGISTER,A1  		Set the table to A0
    JSR    00(A1,D5)    		Set jumptable  
    RTS
* 010 - (An) INSTRUCTION                               *               
FORMAT010  
    MOVE.B #'(',(A3)+   		Move (A) into good buffer
    MOVE.B #'A',(A3)+   		Move (A) into good buffer
    MULU   #$6,D5       		Find offset for register number
    LEA    REGISTER,A1  		Set the table to A0
    JSR    00(A1,D5)    		Set jumptable
    MOVE.B #')',(A3)+   		Move (A) into good buffer
    RTS
* 011 - (An)+ INSTRUCTION                              *               
FORMAT011 
    *CMP.B	#7, D5		 		If's a 7 it's the SP which you can't do
    *BEQ		BADDATA				Return bad data
    MOVE.B #'(',(A3)+   		Move (An)+ into good buffer
    MOVE.B #'A',(A3)+   		Move (An)+ into good buffer
    MULU   #$6,D5       		Find offset for register number
    LEA    REGISTER,A1  		Set the table to A0
    JSR    00(A1,D5)    		Set jumptable 
    MOVE.B #')',(A3)+   		Move (An)+ into good buffer 
    MOVE.B #'+',(A3)+   		Move (An)+ into good buffer
    RTS
* 100 - -(An) INSTRUCTION                              *               
FORMAT100  
    *CMP.B	#7, D5		 		If's a 7 it's the SP which you can't do
    *BEQ		BADDATA		 		Return bad data
    MOVE.B	#'-',(A3)+   		Move -(An) into good buffer
    MOVE.B	#'(',(A3)+   		Move -(An) into good buffer
    MOVE.B	#'A',(A3)+   		Move -(An) into good buffer
    MULU	#$6,D5       		Find offset for register number
    LEA		REGISTER,A1  		Set the table to A0
    JSR    	00(A1,D5)    		Set jumptable 
    MOVE.B 	#')',(A3)+   		Move -(An) into good buffer
    RTS
* 101 - (d16,An) INSTRUCTION                           *               
FORMAT101  
    MOVE.B  $11, D7             This is bad data
    BRA		GETWORDFORBADDATA	Branch to bad data that has word
* 110 - (d8,An,Xn) INSTRUCTION                         *               
FORMAT110 
    MOVE.B  $11, D7             This is bad data 
    RTS							return bad data
* 111 - XXX.W,XXX.L, #<data> INSTRUCTION               *               
FORMAT111
    MULU   #$6,D5       		Find offset for register number
    LEA    ABSOLUTE,A1  		Set the table to A0 
    JSR    00(A1,D5)    		Set jumptable 
    RTS

********************************REGISTER************************
* 000- Register number of 0                            *               
REGISTER000
    MOVE.B #'0',(A3)+   		Move 0 into good buffer
    RTS
* 001- Register number of 1                            *               
REGISTER001
    MOVE.B #'1',(A3)+   		Move 1 into good buffer
    RTS
* 010- Register number of 2                            *               
REGISTER010
    MOVE.B #'2',(A3)+   		Move 2 into good buffer
    RTS
* 011- Register number of 3                            *               
REGISTER011
    MOVE.B #'3',(A3)+  		    Move 3 into good buffer
    RTS
* 100- Register number of 4                            *               
REGISTER100
    MOVE.B #'4',(A3)+   		Move 4 into good buffer
    RTS
* 101- Register number of 5                            *               
REGISTER101
    MOVE.B #'5',(A3)+   		Move 5 into good buffer
    RTS
* 110- Register number of 6                            *               
REGISTER110
    MOVE.B #'6',(A3)+   		Move 6 into good buffer
    RTS
* 111- Register number of 7                            *               
REGISTER111
    MOVE.B #'7',(A3)+   		Move 7 into good buffer
    RTS
********************************REGISTER************************

********************************************************
* 000- (XXX).W                                         *               
********************************************************
ABSOLUTE000
    MOVE.B 	#'$',(A3)+      	Move $ into good buffer
    MOVE.B	#' ',(A4)+			Move a space into bad buffer
    MOVE.B	#'$',(A4)+			Move $ into bad buffer
    MOVEQ  	#4,D0            Move counter to D0
    CMPI.B 	#1,D7            For MOVEM
    BEQ    	ADDWORD          We have to skip over a word.
    BRA    	MOVEWORD
ADDWORD
    MOVEA.L A5,A2
    ADDA.L 	#$2,A2
    MOVE.W 	(A2)+,D4
    BRA 	WORD_PREP
MOVEWORD
    MOVE.W (A5)+,D4         Move word address into D4
WORD_PREP
    ROL.W  #4,D4            	Move the MSB
    MOVE.W D4,D5            	Move word address to D5
    ANDI.W #$000F,D5        	Clear everything except for MSB
WORD_ASC
    CMPI.B #$09,D5          	Is the character a number?
    BLE    WORD_NUM         	Branch if yes.
WORD_LET
    ADDI.B #$37,D5			
    BRA    NEXT_WORD_CHAR   	Convert into a prinatble ascii letter

WORD_NUM
    ADDI.B #$30,D5
    BRA    NEXT_WORD_CHAR   	Convert into a prinatble ascii number
NEXT_WORD_CHAR
    SUBI.B #1,D0            	Decrement counter
    MOVE.B D5,(A3)+         	Move ascii into good buffer
    MOVE.B D5,(A4)+				Move ascii into bad buffer
    CMPI.B #0,D0            	Have we moved all characters?
    BGT    WORD_PREP        	If not, repeat loop
    MOVEQ  #1,D3
    RTS                     	If so, return
********************************************************
* 001- (XXX).L                                         *               
********************************************************
ABSOLUTE001
    MOVE.B 	#'$',(A3)+          Move $ into good buffer
    MOVE.B	#' ',(A4)+
    MOVE.B	#'$',(A4)+			Move $ into bad buffer
    MOVEQ  #8,D0               	Move counter to D0
    CMPI.B #1,D7            	For MOVEM
    BEQ    ADDLONGWORD          We have to skip over a word.
    BRA    MOVELONGWORD
ADDLONGWORD
    MOVEA.L A5,A2
    ADDA.L #$2,A2
    MOVE.L (A2)+,D4
    BRA LONGWORD_PREP
MOVELONGWORD
    MOVE.L (A5)+,D4            	Move longword address into D4
LONGWORD_PREP                  
    ROL.L  #4,D4               	Move the MSB
    MOVE.L D4,D5               	Move longword address to D5
    ANDI.L #$0000000F,D5       	Clear everything except for MSB
LONGWORD_ASC
    CMPI.B #$09,D5             	Is the character a number?
    BLE    LONGWORD_NUM        	Branch if yes.
LONGWORD_LET
    ADDI.B #$37,D5             	Convert into a prinatble ascii letter
    BRA    NEXT_LONGWORD_CHAR
LONGWORD_NUM 
    ADDI.B #$30,D5             	Convert into a prinatble ascii number
    BRA    NEXT_LONGWORD_CHAR
NEXT_LONGWORD_CHAR
    SUBI.B #1,D0               	Decrement counter
    MOVE.B 	D5,(A3)+            Move ascii into good buffer
    MOVE.B	D5,(A4)+
    CMPI.B #0,D0               	Have we moved all characters?
    BGT    LONGWORD_PREP       	If not, repeat loop
    MOVEQ  #2,D3
    RTS                        	If so, return
********************************************************
* 010- (d16, PC)                                      *               
********************************************************
ABSOLUTE010
	MOVE.B  $11, D7             This is bad data
	BRA		GETWORDFORBADDATA	Branch to bad data with word
********************************************************
* 011- (d8,PC,Xn)                                      *               
********************************************************
ABSOLUTE011
	MOVE.B  $11, D7             This is bad data
    BRA		GETWORDFORBADDATA	Branch to bad data with word
********************************************************
* 100- #<data>                                         *               
********************************************************
ABSOLUTE100
    MOVE.B #'#',(A3)+          	Move # into good buffer
    MOVE.B #'$',(A3)+          	Move # into good buffer
    MOVE.B #' ',(A4)+			Insert a space into bad buffer
    MOVE.B #'#',(A4)+			Insert a # into bad buffer
    MOVE.B #'$',(A4)+			Insert a $ into bad buffer
    CMPI.B #1,D1               	Do we need to specifically pull a longword of data?
    BEQ    LONGWORD_DATA       	If yes, branch.
WORD_DATA
    MOVEQ  #4,D0               	Move counter to D0
    MOVE.W (A5)+,D4            	Move word address into D4
DATA_WORD_PREP                 
    ROL.W  #4,D4               	Move the MSB
    MOVE.W D4,D5               	Move word address to D5
    ANDI.L #$0000000F,D5       	Clear everything except for MSB
DATA_WORD_ASC
    CMPI.B #$09,D5             	Is the character a number?
    BLE    DATA_WORD_NUM       	Branch if yes.
DATA_WORD_LET
    ADDI.B #$37,D5             	Convert into a prinatble ascii letter
    BRA    DATA_WORD_CHAR
DATA_WORD_NUM
    ADDI.B #$30,D5             	Convert into a prinatble ascii number
    BRA    DATA_WORD_CHAR
DATA_WORD_CHAR
    SUBI.B #1,D0               	Decrement counter
    MOVE.B D5,(A3)+            	Move ascii into good buffer
    MOVE.B D5,(A4)+				Move ascii into bad buffer
    CMPI.B #0,D0               	Have we moved all characters?
    BGT    DATA_WORD_PREP      	If not, repeat loop
    RTS                        	If so, return
LONGWORD_DATA
    MOVEQ  #8,D0               	Move counter to D0
    MOVE.L (A5)+,D4            	Move longword address into D4
DATA_LONGWORD_PREP             	
    ROL.L  #4,D4               	Move the MSB
    MOVE.W D4,D5               	Move longword address to D5
    ANDI.L #$0000000F,D5       	Clear everything except for MSB
DATA_LONGWORD_ASC
    CMPI.B #$09,D5             	Is the character a number?
    BLE    DATA_LONGWORD_NUM   	Branch if yes.
DATA_LONGWORD_LET
    ADDI.B #$37,D5             	Convert into a prinatble ascii letter
    BRA    DATA_LONGWORD_CHAR
DATA_LONGWORD_NUM
    ADDI.B #$30,D5             	Convert into a prinatble ascii number
    BRA    DATA_LONGWORD_CHAR
DATA_LONGWORD_CHAR
    SUBI.B #1,D0               	Decrement counter
    MOVE.B D5,(A3)+            	Move ascii into good buffer
    MOVE.B D5,(A4)+				Move ascii into bad buffer
    CMPI.B #0,D0               	Have we moved all characters?
    BGT    DATA_LONGWORD_PREP  	If not, repeat loop
    RTS                        	If so, return











********************************GET BIT SIZE ************************
* GETSIZE FUNCTION                                     *
********************************************************
GETSIZE
    MOVE.B  D6, D3                          Move instruction over for shifting
    LSR.B   #6, D3                          Shift the bits 6 to the right to put the size in the LSB
    RTS                                     Retrun D3
* GETSIZEONEBIT FUNCTION                               *
GETSIZEONEBIT
    MOVE.B  D6, D3                          Move instruction over for shifting
    LSL.B   #1, D3                          Shift 1 to the left so the MSB is the size
    LSR.B   #7, D3                          Shift 7 to the right so the MSB (which is the size) is in the LSB
    RTS                                     Return D3


********************************************************
* Get word of data from illegal instruction
********************************************************
GETWORDFORBADDATA
   	MOVE.B	 #' ',(A4)+						Move a space into bad buffer
    MOVE.B	#'$',(A4)+						Move $ into bad buffer
    MOVEQ  #4,D0               				Move counter to D0
    MOVE.W (A5)+,D4            				Move longword address into D4
LONGWORD_PREP1                  
    ROL.W  #4,D4               				Move the MSB
    MOVE.W D4,D5               				Move longword address to D5
    ANDI.L #$0000000F,D5       				Clear everything except for MSB
LONGWORD_ASC1
    CMPI.B #$09,D5             				Is the character a number?
    BLE    LONGWORD_NUM1        			Branch if yes.
LONGWORD_LET1
    ADDI.B #$37,D5             				Convert into a prinatble ascii letter
    BRA    NEXT_LONGWORD_CHAR1
LONGWORD_NUM1 
    ADDI.B #$30,D5             				Convert into a prinatble ascii number
    BRA    NEXT_LONGWORD_CHAR1
NEXT_LONGWORD_CHAR1
    SUBI.B #1,D0               				Decrement counter
    MOVE.B	D5,(A4)+						Push ASCII into bad buffer
    CMPI.B #0,D0               				Have we moved all characters?
    BGT    LONGWORD_PREP1       			If not, repeat loop
    RTS                        				If so, return






       
*------------------ NOP & RTS ADDRESS ------------------------------------------------------
Decode_Constant                                 * Check for NOP & RTS
        JSR         CLEAR_REGISTERS
        LEA         OPCODE, A4                  * Load opcode to A4
        JSR         UNCHANGED_CONSTANT          * NOP & RTS
        RTS


********************************************************************************************
*------------------ PRINT CURRENT ADDRESS IN ASCII -----------------------------------------
PRINT_CURRENT_ADD
        MOVE.L      A6,D2                       * Move current address into D2
        MOVE.B      #0,D5                       * Set counter to read all hex
        MOVE.B      #8,D6                       
CONVERT_HEX_ASCII
        CMP.B       D5,D6                       * Check if last hex character is read
        BNE         SET_COUNTER_4               * Set counter to read 4 bits
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
        CMP.B       #$9,D1
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
GETKEY
        LEA         PROMPTOPTIONS, A1            * Load the prompt message
        MOVE.B      #14,D0
        TRAP        #15 
        MOVE.B      #$00, LINE_COUNT            * Reset Line Count 
        MOVE.B      #5, D0                      * Log keyboard input
        TRAP        #15                 
        CMP.B       #$D, D1                     * Compare the key press with ENTER
        BEQ         OPCODESETUP         
        CMP.B       #$72, D1                    * Compare the key press with R
        BEQ         RESTART             
        CMP.B       #$52, D1                    * Compare the key press with r
        BEQ         RESTART             
        CMP.B       #$71, D1                    * Compare the key press with q
        BEQ         END_PROGRAM             
        CMP.B       #$51, D1                    * Compare the key press with Q
        BEQ         END_PROGRAM            
        CMP.B       #$5D, D1                    * Check the key press with ENTER
        BNE         GETKEY              
OPCODESETUP
        MOVE.B  #11, D0                         * Task 11 - Clear screen
        MOVE.W  #$FF00, D1          
        TRAP    #15                 
        CLR.L   D1
        CLR.L   D0
        RTS                 
*------------------ RESTART ----------------------------------------------------------------
RESTART
        JSR         OPCODESETUP
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
SIZE            DS.B    1
INPUT_HEX       DS.L    1   * Use to temp hold starting and ending address
STARTING_ADD    DS.L    1   ;1 is the size, if I change to 4 then array size changes
ENDING_ADD      DS.L    1
BADCODE         DS.L    1  
OPCODE          DC.L    1
        
        END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
