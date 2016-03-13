*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program

* Put program code here 
**----------1. ADDI------------------
**EA can't be An and #<data>
*    ADDI.B  #111,D1          *Destination
*    ADDI.B  #12, (A5)        * (An)
*    ADDI.B  #101,(A3)+       * (An)+
*    ADDI.B  #10,-(A4)        *-(An)
*    ADDI.B  #13, $1234       * (xxx).W
*    ADDI.B  #13, $12345678   * (xxx).L
*    
*    ADDI.W  #9999,D2  
*    ADDI.W  #$3334,(A5)     
*    ADDI.W  #$9000,(A6)+
*    ADDI.W  #$8000,-(A1) 
*    ADDI.W  #1313, $1234
*    ADDI.W  #1300, $11111111
*    
*    ADDI.L  #$1010,D1
*    ADDI.L  #$1010,(A2)         
*    ADDI.L  #$5649,(A6)+   
*    ADDI.L  #$5000,-(A2)      
*    ADDI.L  #2000, $6666
*    ADDI.L  #3000, $11112222
    
**--------- TEST FOR BAD OPCODE----------------

    ORI.W   #1234,-(A6)     
    CMPI.B  #12,D0
    ANDI.W  #1234, (A4)
    ADDI.W  #2222,$1111
    SUBI.W  #$55, $2222
    EORI.W  #09,SR
    CMPI.W  #3333,(A5)+
    BTST.B  D2,(A2)
    BTST.L  #12,D5   * BTST.W IS NOT WORK
    BCHG.B  D1,(A2)+
    
    
***-----------2. MOVE.B OPCODE-----------

*    MOVE.B  #101,D1
*    MOVE.B  $48,D2
*    MOVE.B  #$AA,D1
*    MOVE.B  D4,(A6)+
*    MOVE.B  D2,(A5)
*    MOVE.B  D5,-(A2)
*    MOVE.B  (A1),D4
*    MOVE.B  (A2)+,D3
*    MOVE.B  -(A1),D1
*    MOVE.B  #$44,D2
*    MOVE.B  D0,-(A7)
*    MOVE.B  D0, $E111
*    MOVE.B  D0, $E1234560
* 
***----------3. MOVE.W-------------------
*    MOVE.W  #1201,D1
*    MOVE.W  $418,D2
*    MOVE.W  #$BA,D1
*    MOVE.W  D1,(A6)+
*    MOVE.W  D0,(A2)
*    MOVE.W  D0,-(A0)
*    MOVE.W  (A1),D1
*    MOVE.W  (A1)+,D1
*    MOVE.W  -(A1),D1
*    MOVE.W  #$4120,D2
*    MOVE.W  D0,D1
*    MOVE.W  D0,$E111
*    MOVE.W  D0,$1234   
*  
***-----------4. MOVE.L---------------
* 
*    MOVE.L  #1201,D1
*    MOVE.L  $418,D2
*    MOVE.L  #$BA,D1
*    MOVE.L  D1,(A6)+
*    MOVE.L  D0,(A2)
*    MOVE.L  D0,-(A0)
*    MOVE.L  (A1),D1
*    MOVE.L  (A1)+,D1
*    MOVE.L  -(A1),D1
*    MOVE.L  #$4120,D2
*    MOVE.L  D2,D4
*    MOVE.L  D4,$AE11  
*    MOVE.L  D5,$E123 
*    
*
****-----------5. LEA----------------
    LEA     (A3),A0         (An),An
    LEA     (A3),A3
    LEA     $9800,A1
    LEA     $0001,A2
    LEA     $4000,A7
    LEA     $1230,A5
    LEA     $1301,A5
    LEA     $01001,A1    
    LEA     VAR2,A1        (xxx).W,An
    LEA     VAR3,A2        (xxx).L,An
    LEA     $1,A4
    LEA     $123456,A7   
 
***-------6. JRS-------------
    JSR      $0000
    JSR      $A000
    JSR      (A4)
    JSR     $1234
    JSR     (A1)
    JSR     (A2)
    JSR     (A3)
    JSR     (A4)
    JSR     (A5)
    JSR     JUMP1
    JSR     JUMP2
    JSR     (A1)        (An)
    JSR     VAR2       (xxx).W
    JSR     VAR3       (xxx).L   
**-------7. CLR-------------------
** IF THE SIZE IS NOT SPECIFIED, IT AUTOMATICALLY GO WITH SIZE W   
    CLR      D0
*   CLR      A4         *NOT An
    CLR     (A2)        (An)
    CLR     (A3)+       (An)+
    CLR     -(A0)
    CLR     VAR2       (xxx).W
    CLR     VAR3       (xxx).L
    CLR     $1000
    CLR     $20003000
*   CLR     #3          NOT #
   
    CLR.B   D0
    CLR.B   D3
    CLR.B   (A0)
    CLR.B   (A2)
    CLR.B   (A7)+       (An)+
    CLR.B   -(A5)
    CLR.B   $7FFF     
    CLR.B   $8000
    CLR.B   $AAAABBBB 
    
    CLR.W   D0
    CLR.W   D5 
    CLR.W   (A0)
    CLR.W   (A3)+
    CLR.W   -(A5)
    CLR.W   $0011      
    CLR.W   $BBBB
    CLR.W   $23232323
    
    CLR.L   D0
    CLR.L   D3 
    CLR.L   (A0)
    CLR.L   (A0)+ 
    CLR.L   -(A4)       -(An)
    CLR.L   $0001 
    CLR.L   $12351235
    
***---------BAD OPCODE FOR CLR------------    
    
 
    NEGX   D2    * NOT An AND #<DATA>  
    NEGX   (A3) 
    NEGX   (A4)+ 
    NEGX   -(A4) 
    NEGX   $3444 
    NEGX   $4444999
    
    NEG   D0    * NOT An AND #<DATA>  
    NEG   (A2) 
    NEG   (A3)+ 
    NEG   -(A4) 
    NEG   $1234 
    NEG   $44445555
    
    NOT   D3    * NOT An AND #<DATA>  
    NOT   (A2) 
    NOT   (A3)+ 
    NOT   -(A4)
    NOT   $12 
    NOT   $1234 
    NOT   $44445555
    
    EXT.W D2   *ONLY W AND L AND Dn
    EXT.L D7  
    
    *Subtracts the destination operand and the extend bit from zero.
    NBCD.B D0       *BYTE AND Dn ONLY, NO An And #<DATA>
    
    *Exchange the 16-bit words (halves) of a data register.
    SWAP  D3    * ONLY WORD SIZE AND Dn
    
    *Computes the effective address and pushes it onto the stack. The effective address is a long address.
    PEA     (A7)
    PEA     $4000
    PEA     $40001111
    
    *Forces an illegal instruction exception, vector number 4. All other illegalinstruction bit patterns
    * are reserved for future extension of the instruction set and
    *should not be used to force an exception.
    ILLEGAL
    
    *Tests and sets the byte operand addressed by the effective address field.
    TAS   D3     * ONLY ON BYTE AND NOT An AND #<DATA> 
    TAS  (A2) 
    TAS   (A3)+ 
    TAS   -(A6)
    TAS   $22 
    TAS   $1004 
    TAS   $49999995    
    
    *Compares the operand with zero and sets the condition codes according to
    *the results of the test.
    TST.B   D3  
*   TST.B   A4     INVALID   
    TST.B  (A5) 
    TST.B  (A2)+ 
    TST.B  -(A4)
    TST.B   $34 
    TST.B   $6666 
    TST.B   $49995555
*   TST.B   #$4    INVALID  
    
    TST.W   D3  
    TST.W  (A5) 
    TST.W  (A2)+ 
    TST.W  -(A4)
    TST.W   $34 
    TST.W   $6666 
    TST.W   $49995555
    
    TST.L   D3  
    TST.L  (A2) 
    TST.L  (A6)+ 
    TST.L  -(A4)
    TST.L   $11 
    TST.L   $ACDA 
    TST.L   $49995555
    
    *Causes a TRAP # < vector > exception.
    TRAP   #1  *UNSIZED
    TRAP   #15
    
    *Pushes the contents of the specified address register onto the stack.
    LINK    A2, #23
    LINK    A3, #12
    
    *Loads the stack pointer from the specified address register, then loads the
    *address register with the long word pulled from the top of the stack.
    UNLK   A3             *UNSIZED, An ONLY
    
    *Moves the contents of the user stack pointer to or from the specified address register.
    MOVE USP, A3
    MOVE A2, USP
    
    *Asserts the RSTO signal for 512 (124 for MC68000, clock periods,
    *resetting all external devices. The processor state, other than the program counter, is
    *unaffected, and execution continues with the next instruction.
    RESET
    
    *Loads the processor state information stored in the exception stack frame
    *located at the top of the stack into the processor.
    RTE
    
    *If the overflow condition is set, causes a TRAPV exception with a vector
    *number 7. If the overflow condition is not set, the processor performs no operation and
    *execution continues with the next instruction
    MOVE.B   $23, D3
    ADDI.W   #1000, D3
    TRAPV    *UNSIZED
    
    *Pulls the condition code and program counter values from the stack. The
    *previous condition code and program counter values are lost. The supervisor portion
    *of the status register is unaffected.
    RTR
    
    *Program execution continues at the effective address specified by the instruction.
    JMP    (A3)
    JMP    $80
    JMP    $2000
    JMP    $10000000
    
    *Compares the value in the data register specified in the instruction to zero and
    *to the upper bound (effective address operand).
    
    CHK.W    D0,D1 
    CHK.W   (A1),D1
    CHK.W   (A0)+,D1
    CHK.W   -(A0),D1
    CHK.W   $1111,D4
    CHK.W   $11111111,D4
    CHK.W   #$1000,D0
    
****-------8. RTS-------------------
   JSR      $0000 
   JSR      $A000
   JSR      (A4)
JUMP1    *For JSR & RTS test
   MOVE.B  D1, D1
   RTS

JUMP2   
    RTS *For JSR & RTS test
    
***-------9. NOP-------------------
*    NOP
***-------10. MOVEM-------------------
*
*    MOVEM.L  D0-D7,-(SP)
*    MOVEM.L  A3/D2,-(SP)
*    MOVEM.L  A1-A5/D1-D4,-(SP)
*    MOVEM.L  A1-A3,-(SP)
*    MOVEM.L  (SP)+,D0-D7
*    MOVEM.L  (SP)+,A3/D2
*    MOVEM.L  (SP)+,A1-A5/D1-D4
*    MOVEM.L  (SP)+,A1-A6/D2/D3   
*
*
****----------10. BCC PASS---------------------- 
*   CMP.B    D0,D2
*   BCC      AAAA    
*    
****----------11. BLE PASS---------------------  
*AAAA 
*    CMP.W    #1,D4
*    BLE      BBBB
*        
****----------12. BGT PASS----------------------
*BBBB   
*    CMP.B    $5, D4
*    BGT      CCCC
*CCCC  
*    MOVEA.W   #4,A4         
****-----------14. MOVEQ ------------------
 
    MOVEQ    #1, D4   * BYTE AND An ONLY
    MOVEQ    #2, D4
    MOVEQ    #3,D4
    MOVEQ    #45, D5
    MOVEQ    #$12,D1
    MOVEQ    #$23,D3
    MOVEQ    #$12,D4
    MOVEQ    #255,D4 

****----------15. DIVU---------------------
    DIVU    D0,D1
    DIVU    #$1000,D0
    DIVU    (A0),D1
    DIVU    $11111111,D4
  
****----------16. SUB-------------------------
*    SUB.B   $11,D0
*    SUB.W   $1111,D0
*    SUB.L   $11111111,D0 
*    SUB.B   $1111,D0
*    SUB.W   $11111111,D0
*    SUB.B   D0,$11
*    SUB.W   D0,$1111
*    SUB.L   D0,$11111111 
****-----------17. CMP----------------- 
*      CMP.W  #1, D6   
*      CMP.W  A2, D2     *An case 
*      CMP.W  D2, A3     *BAD DATA
*      CMP.W  D2, D6     *Dn case
*      CMP.W  (A3),D5    *(An) case
*      CMP.B  -(A1),D0  *-(An) case
*      CMP.B  (A2)+, D1  *(An)+ case
*      CMP.W  #$10, D4   * (xxx).W
*      CMP.L  #$2000,D5  * (xxx).L
****-----------18. MULS------------------   
*     MULS    $11,D0
*     MULS.W  $1111,D2
*     MULS    $1111,D2
*     MULS    $11111111,D5
*     MULS.W  #1,D4
*     MULS.W  D0,D5
*     MULS.W  #$1111,D4
*     MULS.W  #$03,D3
*     MULS.W  D0,D6
*TEST_FORWARD   RTS
****-----------19. AND-------------------
*    AND.B   $11,D5
*    AND.W   $1111,D5
*    AND.L   $11111111,D5
*    AND.B   $1111,D5
*    AND.W   $11111111,D5  
*    AND.B   D5,$11
*    AND.W   D5,$1111
*    AND.L   D5,$11111111
*    AND.B   D1,$300
*    AND.B   D1,D0
*    AND.B   D2,D0
*    AND.W   D3,D0
*    AND.B   D4,D0
*    AND.B   D5,D0
*    AND.L   D6,D0
*    AND.B   D7,D0
*    AND.W   D1,D1
*    AND.L   D1,D1
*    AND.B   (A1),D1
*    AND.B   (A2),D2
*    AND.L   (A3),D2
*    AND.B   (A4),D2
*    AND.W   (A5),D2
*    AND.B   (A6),D2
*    AND.L   (A7),D2
*    AND.B   (A2)+,D2            
*    AND.L   -(A2),D2
*    AND.B   $4000,D2
*    AND.B   $7F,D2
*    AND.B   $80000000,D2
*    AND.W   D2,$80000000
*    AND.W   D3,$80000000
*    AND.W   D4,$80000000
*    AND.W   D5,$80000000
*    AND.W   D6,$80000000
*    AND.W   D7,$80000000
*    
*
****----------20. ADD--------------------------
*    ADD.B   $11,D5
*    ADD.W   $1111,D5
*    ADD.L   $11111111,D5
*    ADD.B   $1111,D5
*    ADD.W   $11111111,D5
*    ADD.B   $48,D2
*    ADD.B   #$DA,D3
*    ADD.B   D3,(A6)+
*    ADD.B   D1,(A2)
*    ADD.B   D5,-(A0)
*    ADD.B   #$40,D2
*    ADD.B   D1,$E115
*    ADD.B   D5,$E1234567	
*    ADD.W   #101,A6
*    ADD.W   $48,D3
*    ADD.W   #$AA,D6
*    ADD.W   D3,(A5)+
*    ADD.W   D5,(A2)
*    ADD.W   D2,-(A0)
*    ADD.W   (A1),A5
*    ADD.W   (A1)+,A1
*    ADD.W   -(A1),A6
*    ADD.W   #$40,D7
*    ADD.W   D0,A2
*    ADD.W   D0,$E115
*    ADD.W   D0,$E1234567
*    ADD.B   D5,$11
*    ADD.W   D5,$1111
*    ADD.L   D5,$11111111
*
**
****----------21. ADDA-------------------------
*
*    ADDX    -(A0),-(A1)  ; bad case
*    ADDA.W  D0,A0
*    ADDA.L  D1,A1
*    ADD.L   A0,A1  
*    ADDA.W  #123,A5
*    ADDA.L  #123,A5
*    ADD.L   #$123,A5
*             
***----------22. ASR----------------------------    
*    ASR.W   #8,D0
*    ASR.W   #7,D1
*    ASR.W   #6,D2
*    ASR.W   #5,D3
*    ASR.W   #4,D4
*    ASR.W   #3,D5
*    ASR.W   #2,D6
*    ASR.W   #1,D7
*    
*    ASR.B   #8,D0
*    ASR.B   #7,D1
*    ASR.B   #6,D2
*    ASR.B   #5,D3
*    ASR.B   #4,D4
*    ASR.B   #3,D5
*    ASR.B   #2,D6
*    ASR.B   #1,D7
*    CLR.B   (A0)
*    ASR.W   $0FF00000
*    ASR.W   $0FF00000
*    
*    ASR.W   $0FF00000
*    ASR.W   (A4)+
*    ASR.W   -(A6)
*
*    ASR.B   D1, D0
*    ASR.B   D2, D0
*    ASR.B   D3, D0
*    ASR.B   D4, D0
*    ASR.B   D5, D6
*    ASR.B   D1, D6
*    ASR.B   D2, D6
*    ASR.B   D3, D6
*    ASR.L   #8,D0
*    ASR.L   #7,D1
*    ASR.L   #8,D2
*    ASR.L   #6,D3
*    ASR.L   #5,D4
*    ASR.L   #4,D5
*    ASR.L   #3,D6
*    ASR.L   #2,D7
*    ASR.L   #1,D7
*            
***----------23. LSL----------------------------
*    LSL.B   D0,D2
*    LSL.L   D0,D2
*    lSR.B   #7,D4  ;  bad case for LSL
*    LSL.L   #8,D4
*    LSL.W   $0FF00000 ; 
*    LSL.W   (a4)+
*    LSL.W   -(a6)
***-----------24. ROL-----------------
*    ROL.W   #6,D0
*    ROL.B   D0,D2
*    ROL.L   D0,D2
*    ROL.B   #7,D4  ;  bad case for LSL
*    ROL.L   #8,D4
*    ROL.W   $0FF00000 ; 
*    ROL.W   (a4)+
*    ROL.w   -(a6)
*    ROL.W   (a4)+     
    
    SIMHALT             ; halt simulator

* Put variables and constants here
    
VAR1    EQU $BA    BVAR
VAR2    EQU $1234   WVAR
VAR3    EQU $FFAA1234  WVAR
VAR4    EQU $12     DVAR
VAR5    EQU $00000000  ZVAR
VAR6   EQU $FCFCFCFC    VBIN1

    END    START        ; last line of source



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
