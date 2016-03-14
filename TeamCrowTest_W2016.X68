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
    ADDI.B  #111,D1          *Destination
    ADDI.B  #12, (A5)        * (An)
    ADDI.B  #101,(A3)+       * (An)+
    ADDI.B  #10,-(A4)        *-(An)
    ADDI.B  #13, $1234       * (xxx).W
    ADDI.B  #13, $12345678   * (xxx).L
    
    ADDI.W  #9999,D2  
    ADDI.W  #$3334,(A5)     
    ADDI.W  #$9000,(A6)+
    ADDI.W  #$8000,-(A1) 
    ADDI.W  #1313, $1234
    ADDI.W  #1300, $11111111
    
    ADDI.L  #$1010,D1
    ADDI.L  #$1010,(A2)         
    ADDI.L  #$5649,(A6)+   
    ADDI.L  #$5000,-(A2)      
    ADDI.L  #2000, $6666
    ADDI.L  #3000, $11112222
    
    
    
***-----------2. MOVE.B OPCODE-----------
     
     MOVE.B  D3, D2
     MOVE.B  (A1),D4     *DESTINATION CANT BE AN & #<DATA>
     MOVE.B  (A2)+,D3
     MOVE.B  -(A1),D1   
     MOVE.B  $48,D2
     MOVE.B  #1,D1
     MOVE.B  #$AA,D1
*     MOVE.B  #$4444,D2
*     MOVE.B  #$4444888,D2
    
     MOVE.B  D3, (A2)
     MOVE.B  (A1),(A4)     *DESTINATION CANT BE AN & #<DATA>
     MOVE.B  (A2)+,(A3)
     MOVE.B  -(A1),(A1)  
     MOVE.B  $48,(A2)
     MOVE.B  #1,(A1)
     MOVE.B  #$AA,(A1)
*     MOVE.B  #$4444,(D2)
*     MOVE.B  #$4444888,(D2)
    
     MOVE.B  D3, (A2)+
     MOVE.B  (A1),(A4)+     *DESTINATION CANT BE AN & #<DATA>
     MOVE.B  (A2)+,(A3)+
     MOVE.B  -(A1),(A1)+  
     MOVE.B  $48,(A2)+
     MOVE.B  #1,(A1)+
     MOVE.B  #$AA,(A1)+   
                      
     MOVE.B  D3, -(A2)
     MOVE.B  (A1),-(A4)     *DESTINATION CANT BE AN & #<DATA>
     MOVE.B  (A2)+,-(A3)
     MOVE.B  -(A1),-(A1)  
     MOVE.B  $48,-(A2)
     MOVE.B  #1,-(A1)
     MOVE.B  #$AA,-(A1) 
   
     MOVE.B  D3,$12 
     MOVE.B  (A1),$12      *DESTINATION CANT BE AN & #<DATA>
     MOVE.B  (A2)+,$12 
     MOVE.B  -(A1),$12   
     MOVE.B  $48,$12 
     MOVE.B  #1,$12 
     MOVE.B  #$AA,$12    
    
     MOVE.B  D3,$1212 
     MOVE.B  (A1),$1212      *DESTINATION CANT BE AN & #<DATA>
     MOVE.B  (A2)+,$1212 
     MOVE.B  -(A1),$1212   
     MOVE.B  $48,$1212 
     MOVE.B  #1,$1212 
     MOVE.B  #$AA,$1212
     
     MOVE.B  D3,$12124444 
     MOVE.B  (A1),$12124444      *DESTINATION CANT BE AN & #<DATA>
     MOVE.B  (A2)+,$12124444 
     MOVE.B  -(A1),$12124444   
     MOVE.B  $48,$12124444 
     MOVE.B  #1,$12124444 
     MOVE.B  #$AA,$12124444
     


***----------3. MOVE.W-------------------
     MOVE.W  D3, D2
     MOVE.W  (A1),D4     *DESTINATION CANT BE AN & #<DATA>
     MOVE.W  (A2)+,D3
     MOVE.W  -(A1),D1   
     MOVE.W  $48,D2
     MOVE.W  #1,D1
     MOVE.W  #$AA,D1
     MOVE.W  #$4444,D2
*     MOVE.W  #$4444888,D2
    
     MOVE.W  D3, (A2)
     MOVE.W  (A1),(A4)     *DESTINATION CANT BE AN & #<DATA>
     MOVE.W  (A2)+,(A3)
     MOVE.W  -(A1),(A1)  
     MOVE.W  $48,(A2)
     MOVE.W  #1,(A1)
     MOVE.W  #$AA,(A1)
     MOVE.W  #$4444,(A2)
*     MOVE.W  #$4444888,(D2)
    
     MOVE.W  D3, (A2)+
     MOVE.W  (A1),(A4)+     *DESTINATION CANT BE AN & #<DATA>
     MOVE.W  (A2)+,(A3)+
     MOVE.W  -(A1),(A1)+  
     MOVE.W  $48,(A2)+
     MOVE.W  #1,(A1)+
     MOVE.W  #$AA,(A1)+   
                      
     MOVE.W  D3, -(A2)
     MOVE.W  (A1),-(A4)     *DESTINATION CANT BE AN & #<DATA>
     MOVE.W  (A2)+,-(A3)
     MOVE.W  -(A1),-(A1)  
     MOVE.W  $48,-(A2)
     MOVE.W  #1,-(A1)
     MOVE.W  #$AA,-(A1) 
   
     MOVE.W  D3,$12 
     MOVE.W  (A1),$12      *DESTINATION CANT BE AN & #<DATA>
     MOVE.W  (A2)+,$12 
     MOVE.W  -(A1),$12   
     MOVE.W  $48,$12 
     MOVE.W  #1,$12 
     MOVE.W  #$AA,$12    
    
     MOVE.W  D3,$1212 
     MOVE.W  (A1),$1212      *DESTINATION CANT BE AN & #<DATA>
     MOVE.W  (A2)+,$1212 
     MOVE.W  -(A1),$1212   
     MOVE.W  $48,$1212 
     MOVE.W  #1,$1212 
     MOVE.W  #$AA,$1212
     
     MOVE.W  D3,$12124444 
     MOVE.W  (A1),$12124444      *DESTINATION CANT BE AN & #<DATA>
     MOVE.W  (A2)+,$12124444 
     MOVE.W  -(A1),$12124444   
     MOVE.W  $48,$12124444 
     MOVE.W  #1,$12124444 
     MOVE.W  #$AA,$12124444
     

 
*  
***-----------4. MOVE.L---------------
 MOVE.W  D3, D2
     MOVE.L  (A1),D4     *DESTINATION CANT BE AN & #<DATA>
     MOVE.L  (A2)+,D3
     MOVE.L  -(A1),D1   
     MOVE.L  $48,D2
     MOVE.L  #1,D1
     MOVE.L  #$AA,D1
     MOVE.L  #$4444,D2
     MOVE.L  #$4444888,D2
    
     MOVE.L  D3, (A2)
     MOVE.L  (A1),(A4)     *DESTINATION CANT BE AN & #<DATA>
     MOVE.L  (A2)+,(A3)
     MOVE.L  -(A1),(A1)  
     MOVE.L  $48,(A2)
     MOVE.L  #1,(A1)
     MOVE.L  #$AA,(A1)
     MOVE.L  #$4444,(A2)
     MOVE.L  #$4444888,(A2)
    
     MOVE.L  D3, (A2)+
     MOVE.L  (A1),(A4)+     
     MOVE.L  (A2)+,(A3)+
     MOVE.L  -(A1),(A1)+  
     MOVE.L  $48,(A2)+
     MOVE.L  #1,(A1)+
     MOVE.L  #$AA,(A1)+ 
     MOVE.L  #$4444888,(A2)+  
                      
     MOVE.L  D3, -(A2)
     MOVE.L  (A1),-(A4)     *DESTINATION CANT BE AN & #<DATA>
     MOVE.L  (A2)+,-(A3)
     MOVE.L  -(A1),-(A1)  
     MOVE.L  $48,-(A2)
     MOVE.L  #1,-(A1)
     MOVE.L  #$AA,-(A1) 
     MOVE.L  #$4444888,-(A2)
   
     MOVE.L  D3,$12 
     MOVE.L  (A1),$12      *DESTINATION CANT BE AN & #<DATA>
     MOVE.L  (A2)+,$12 
     MOVE.L  -(A1),$12   
     MOVE.L  $48,$12 
     MOVE.L  #1,$12 
     MOVE.L  #$AA,$12 
     MOVE.L  #$4444888,$34   
    
     MOVE.L  D3,$1212 
     MOVE.L  (A1),$1212      *DESTINATION CANT BE AN & #<DATA>
     MOVE.L  (A2)+,$1212 
     MOVE.L  -(A1),$1212   
     MOVE.L  $48,$1212 
     MOVE.L  #1,$1212 
     MOVE.L  #$AA,$1212
     MOVE.L  #$4444888,$1234
     
     MOVE.L  D3,$12124444 
     MOVE.L  (A1),$12124444      *DESTINATION CANT BE AN & #<DATA>
     MOVE.L  (A2)+,$12124444 
     MOVE.L  -(A1),$12124444   
     MOVE.L  $48,$12124444 
     MOVE.L  #1,$12124444 
     MOVE.L  #$AA,$12124444
     MOVE.L  #$4444888,$12341234
   
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

    MOVEM.L  D0-D7,-(SP)
    MOVEM.L  A3/D2,-(SP)
    MOVEM.L  A1-A5/D1-D4,-(SP)
    MOVEM.L  A1-A3,-(SP)
    MOVEM.L  (SP)+,D0-D7
    MOVEM.L  (SP)+,A3/D2
    MOVEM.L  (SP)+,A1-A5/D1-D4
    MOVEM.L  (SP)+,A1-A6/D2/D3   


****----------10. BCC PASS---------------------- 
   CMP.B    D0,D2
   BCC      AAAA    
    
****----------11. BLE PASS---------------------  
AAAA 
    CMP.W    #1,D4
    BLE      BBBB
        
****----------12. BGT PASS----------------------
BBBB   
    CMP.B    $5, D4
    BGT      CCCC
CCCC  
    MOVEA.W   #4,A4         
****-----------14. MOVEQ ------------------
 
    MOVEQ    #1, D4   * BYTE AND An ONLY
    MOVEQ    #2, D4
    MOVEQ    #3,D4
    MOVEQ    #45, D5
    MOVEQ    #$12,D1
    MOVEQ    #$23,D3
    MOVEQ    #$12,D4
    MOVEQ    #255,D4 
    
*MOVEQ DON'T HAVE BAD OPCODE

****----------15. DIVU---------------------
    DIVU    D0,D1
    DIVU    #$1000,D0
    DIVU    (A0),D1
    DIVU    $11111111,D4
 
****----------16. SUB-------------------------
    SUB.B   D1,D0
*    SUB.B   A4,D0
    SUB.B   (A4)+,D0 
    SUB.B   -(A5),D0
    SUB.B   $11,D0
    SUB.B   $1234,D2
    SUB.B   $AAAABBBB,D5
    SUB.B   #1,D7
    SUB.B   #12,D7  
*    SUB.B   #1212,D7
*    SUB.B   #12121234,D7

    SUB.W   D1,D0
    SUB.W   A4,D0
    SUB.W   (A4)+,D0 
    SUB.W   -(A5),D0
    SUB.W   $11,D0
    SUB.W   $1234,D2
    SUB.W   $AAAABBBB,D5
    SUB.W   #1,D7
    SUB.W   #12,D7  
    SUB.W   #1212,D7
*    SUB.B   #12121234,D7

    SUB.L   D1,D0
    SUB.L   A4,D0
    SUB.L   A4,D0
    SUB.L   (A4)+,D0 
    SUB.L   -(A5),D0
    SUB.L   $11,D0
    SUB.L   $1234,D2
    SUB.L   $AAAABBBB,D5
    SUB.L   #1,D7
    SUB.L   #12,D7  
    SUB.L   #1212,D7
    SUB.L   #12121234,D7
****-----------17. CMP----------------- 
     CMP.B  D0, D6   * DESTINATION IS DN ONLY AND EA CANT BE AN
*     CMP.B  A2, D2     
     CMP.B  (A4)+,D3     
     CMP.B  D2, D6    
     CMP.B (A3),D5    
     CMP.B  -(A1),D0 
     CMP.B  (A2)+, D1  
     CMP.B  $23,D0 
     CMP.B  $4444, D1 
     CMP.B  $44440000,D7 
     CMP.B  #$1, D4
     CMP.B  #$10, D4   
*     CMP.B  #$2000,D5 
     
     CMP.W  D0, D6      
     CMP.W  (A4)+,D3     
     CMP.W  D2, D6    
     CMP.W (A3),D5    
     CMP.W  -(A1),D0 
     CMP.W  (A2)+, D1  
     CMP.W  $23,D0 
     CMP.W  $4444, D1 
     CMP.W  $44440000,D7 
     CMP.W  #$1, D4
     CMP.W  #$10, D4   
     CMP.W  #$2000,D5

     CMP.L  D0, D6      
     CMP.L  (A4)+,D3     
     CMP.L  D2, D6    
     CMP.L (A3),D5    
     CMP.L  -(A1),D0 
     CMP.L  (A2)+, D1  
     CMP.L  $23,D0 
     CMP.L  $4444, D1 
     CMP.L  $44440000,D7 
     CMP.L  #$1, D4
     CMP.L  #$10, D4   
     CMP.L  #$2000,D5 
     
 
****-----------18. MULS------------------ 
  
     MULS      D0,D6 
     MULS      (A1),D6 
     MULS      (A2)+,D0
     MULS      -(A3),D2
     MULS      $11,D2
     MULS      $1111,D5
     MULS      $11111111,D5
     MULS      #1,D4
     MULS      #$03,D3
     MULS      #$1111,D4
     MULS.W    D0,D6 
     MULS.W    (A1),D6 
     MULS.W    (A2)+,D0
     MULS.W    -(A3),D2
     MULS.W    $11,D2
     MULS.W    $1111,D5
     MULS.W    $11111111,D5
     MULS.W    #1,D4
     MULS.W    #$03,D3
     MULS.W    #$1111,D4
    

****-----------19. AND-------------------
     AND.B  D3, D2
     AND.B  (A1),D4     *DESTINATION CANT BE AN & #<DATA>
     AND.B  (A2)+,D3
     AND.B  -(A1),D1   
     AND.B  $48,D2
     AND.B  #1,D1
     AND.B  #$AA,D1
*     AND.B.B  #$4444,D2
*     MOVE.B  #$4444888,D2
    
    
*     MOVE.B  #$4444,(D2)
*     MOVE.B  #$4444888,(D2)
    
     AND.B    D3, (A2)+
     AND.B  #1,-(A1)
     AND.B  #$AA,-(A1) 
   
     AND.B  D3,$12 
     AND.B #1,$12 
     AND.B  #$AA,$12    
     AND.B  D3,$1212 

     AND.B  #1,$1212 
     AND.B  #$AA,$1212   
     AND.B  D3,$12124444 
     AND.B  #1,$12124444 
     AND.B  #$AA,$12124444    

****----------20. ADD--------------------------

    ADD.B   $11,D5
    ADD.B   $1111,D5
    ADD.B   $11111111,D5
    ADD.B   $1111,D5
    ADD.W   $11111111,D5
    ADD.B   $48,D2
    ADD.B   #$DA,D3
    ADD.B   D3,(A6)+
    ADD.B   D1,(A2)
    ADD.B   D5,-(A0)
    ADD.B   #$40,D2
    ADD.B   D1,$E115
    ADD.B   D5,$E1234567
	
    ADD.W   #101,A6
    ADD.W   $48,D3
    ADD.W   #$AA,D6
    ADD.W   D3,(A5)+
    ADD.W   D5,(A2)
    ADD.W   D2,-(A0)
    ADD.W   (A1),A5
    ADD.W   (A1)+,A1
    ADD.W   -(A1),A6
    ADD.W   #$40,D7
    ADD.W   D0,A2
    ADD.W   D0,$E115
    ADD.W   D0,$E1234567
    ADD.W   D5,$11
    ADD.W    D5,$11111111
    	
    ADD.L   #101,A6
    ADD.L   $48,D3
    ADD.L   #$AA,D6
    ADD.L   D3,(A5)+
    ADD.L   D5,(A2)
    ADD.L   D2,-(A0)
    ADD.L   (A1),A5
    ADD.L   (A1)+,A1
    ADD.L   -(A1),A6
    ADD.L   #$40,D7
    ADD.L   D0,A2
    ADD.L   D0,$E115
    ADD.L   D0,$E1234567
    ADD.L   D5,$11
    ADD.L    D5,$11111111

*
****----------21. ADDA-------------------------
*
    ADDA.W  D0,A0
    ADDA.W  A2,A1
    ADDA.W  (A0),A1    
    ADDA.W  (A0)+,A1 
    ADDA.W  $12,A5
    ADDA.W  $123,A5
    ADDA.W  $123,A5
    ADDA.W  #12,A5
    ADDA.W  #$12,A5
    ADDA.W  #$1235,A5
    ADDA.W  #$1235,A5
    
    ADDA.L  D0,A0
    ADDA.L  A2,A1
    ADDA.L  (A0),A1    
    ADDA.L  (A0)+,A1 
    ADDA.L  $12,A5
    ADDA.L  $123,A5
    ADDA.L  $123,A5
    ADDA.L  #12,A5
    ADDA.L  #$12,A5
    ADDA.L  #$1235,A5
    ADDA.L #$1235,A5
*             
***----------22. ASR----------------------------    
* ASR.B EA - EA IS NOT DN, AN, #<DATA>
* ASR.B #DATA, DN   
    ASR.B   #3, D0
    ASR.B   #4, D1
    
    ASR.W   $55555555   
    ASR.W   #7,D1
    ASR.W   #6,D2
    ASR.W   (A5)
    ASR.W   (A7)+
    ASR.W   -(A4)
    ASR.W   $9
    ASR.W   $19
    ASR.W   $191
    ASR.W   $1919
    ASR.W   $0FF00000
   
    ASR.L   #8,D2
    ASR.L   #7,D6

*            
***----------23. LSL----------------------------
    LSL.B   D0,D2
    lSR.B   #7,D4  ;  bad case for LSL
    LSL.B   #8,D4
    
    LSL.W   $0FF00000 ; 
    LSL.W   (a4)+
    LSL.W   -(a6)
    LSL.B   #3, D0
    LSL.B   #4, D1
    LSL.B   D4, D0
    
     
    LSL.W   #7,D1
    LSL.W   #6,D2
    LSL.W   D1, D0
    LSL.W   (A5)
    LSL.W   (A7)+
    LSL.W   -(A4)
    LSL.W   $9
    LSL.W   $19
    LSL.W   $191
    LSL.W   $1919
    LSL.W   $0FF00000
    LSL.W   $55555555  
    
    LSL.L   #8,D2
    LSL.L   #7,D6
    LSL.L   D3, D6
    LSL.L   D0,D2
***-----------24. ROL-----------------
   
    ROL.B   D0,D2
    ROL.B   D6,D2
    ROL.B   #6,D0
    ROL.B   #7,D4  ;  bad case for LSL
    ROL.B   #8,D4
    
    ROL.W   D7, D3
    ROL.W   D6, D0  
    ROL.W   (A1)
    ROL.W   (4)
    ROL.W   (A1)+
    ROL.W   -(a6)
    ROL.W   (a4)+  
    ROL.W   #2,D1
    ROL.W   #1,D2   
    ROL.W   #5, D0
    ROL.W   #7, D1
    ROL.W   $0FF0
    ROL.W   $0FF0000 
    
    ROL.L   #8,D2
    ROL.L   #7,D6
    ROL.L   D3, D6


**--------- TEST FOR BAD OPCODE FOR GROUP 0000 ADDI ----------------

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
    SIMHALT             ; halt simulator

***---------BAD OPCODE FOR GROUP 0100- CLR, MOVEM, LEA, JRS, NOP, RTS------------    
    
 
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
    
***** TEST BAD OPCODE FOR GROUP 1001- SUB - CODE EOR -----------------
*-------------SUBA- TEST FOR 1001------------------------------------------------
*Subtracts the source operand from the destination address register and stores
*the result in the address register.
     SUBA.W  D0, A6      
     SUBA.W  (A4)+,A3     
     SUBA.W  D2, A6    
     SUBA.W (A3),A5    
     SUBA.W -(A1),A0 
     SUBA.W  (A2)+, A1  
     SUBA.W  $23,A0 
     SUBA.W  $4444, A1 
     SUBA.W $44440000,A7 
     SUBA.W  #$1, A4
     SUBA.W  #$10, A4   
     SUBA.W  #$2000,A5

     SUBA.W  D0, A6      
     SUBA.W  (A4)+,A3     
     SUBA.W  D2, A6    
     SUBA.W (A3),A5    
     SUBA.W  -(A1),A0 
     SUBA.W  (A2)+, A1  
     SUBA.W  $23,A0 
     SUBA.W  $4444, A1 
     SUBA.W $44440000,A7 
     SUBA.W  #$1, A4
     SUBA.W  #$10, A4   
     SUBA.W  #$2000,A5 
     
***** TEST BAD OPCODE FOR GROUP 1011 BCC, BGT, BLE  - CODE EOR -----------------
*----------------CODE BRA   TEST FOR GROUP 1011-----------------------------------    
    BRA    TEST1011
TEST1011
    MOVE.B  12, D0  
  
*----------------CODE BRS   TEST FOR GROUP 1011----------------------------------- 
*Pushes the long-word address of the instruction immediately following the
*BSR instruction onto the system stack
    BSR   TESTBSR1011
TESTBSR1011    
   MOVEA.W  $1234, A3
 
 
 ***** TEST FOR BAD OPCODE DIVU- GROUP - 1000---------------------------  
  

*Divides the signed destination operand by the signed source operand and
*stores the signed result in the destination
    DIVS.W   D2,D0   * EA IS NOT AN
    DIVS.W   (A2),D0
    DIVS.W   (A5)+,D5
    DIVS.W   -(A6),D3 
    DIVS.W  $11,D0
    DIVS.W  $1111,D0
    DIVS.W  $11111111,D6 
    DIVS.W  $1,D0
    DIVS.W  $11,D0
    DIVS.W  $1111,D5
    
    
***** TEST FOR BAD OPCODE DIVU-------------------------
*Subtracts the source operand and the extend bit from the destination operand
*and stores the result in the destination location
   SBCD   D2, D3
   SBCD   -(A1), -(A5)
   
***** TEST FOR BAD OPCODE DIVU   
*Performs an inclusive-OR operation on the source operand and the
*destination operand and stores the result in the destination location
     OR.B  D0,D1
*    OR.B  A2,D2   EA CAN'T BE AN
     OR.B  (A3),D1
*    OR.B  (A4)+,(A6)+   DESTINATION IS NOT DN, AN,(AN) #<DATA>
     OR.B  -(A6),D3
     OR.B  $22,D4
     OR.B  $2222,D5
     OR.B  $22448888,D6
     
     OR.B  D0,(A3)
*    OR.B  A2,D2     
*    OR.B  (A3),(A3)      INVALID
*    OR.B  (A4)+,(A6)+    DESTINATION IS NOT DN, AN, #<DATA>
*    OR.B  -(A6),(A3)
     OR.B  $22,D4
     OR.B  $2222,D5
     OR.B  $22448888,D6
     OR.B  #$2,D6
     OR.B  #$22,D4
     OR.B  #$22,D5       ONLY WORK ON BYTE 
 
     OR.B  D0,-(A3)     * OTHER EA NOT WORK FOR -(A3)
     OR.B  D0,-(A3)
     OR.B  #$2,-(A3)
     OR.B  #$22,-(A3)
     OR.B  #$22,-(A3) 
     
     OR.B  D0,$12  * OTHER EA IS NOT WORK FOR DESTINATION $12
   
     OR.W  D0,D1
     OR.W (A3),D1
     OR.W  -(A6),D3
     OR.W $22,D4
     OR.W  $2222,D5
     OR.W  $22448888,D6
     
     OR.W  D0,(A3)
     OR.W  $22,D4
     OR.W  $2222,D5
     OR.W  $22448888,D6
     OR.W  #$2,D6
     OR.W  #$22,D4
     OR.W  #$22,D5       ONLY WORK ON BYTE 
 
     OR.W  D0,-(A3)     * OTHER EA NOT WORK FOR -(A3)
     OR.W  D0,-(A3)
     OR.W  #$2,-(A3)
     OR.W  #$22,-(A3)
     OR.W  #$22,-(A3) 
 
     OR.W  D0,$12  * OTHER EA IS NOT WORK FOR DESTINATION $12
     
     
     OR.L  D0,D1
     OR.L (A3),D1
     OR.L -(A6),D3
     OR.L $22,D4
     OR.L  $2222,D5
     OR.L  $22448888,D6
     
     OR.L  D0,(A3)
     OR.L  $22,D4
     OR.L  $2222,D5
     OR.L  $22448888,D6
     OR.L #$2,D6
     OR.L  #$22,D4
     OR.L  #$22,D5       ONLY WORK ON BYTE 
 
     OR.L  D0,-(A3)     * OTHER EA NOT WORK FOR -(A3)
     OR.L  D0,-(A3)
     OR.L  #$2,-(A3)
     OR.L  #$22,-(A3)
     OR.L  #$22,-(A3) 
 
     OR.L  D0,$12  * OTHER EA IS NOT WORK FOR DESTINATION $12


  ***** TEST BAD OPCODE FOR GROUP 1011 CMP  - CODE EOR -----------------
*Performs an exclusive-OR operation on the destination operand using the
*source operand and stores the result in the destination location 


     EOR.B  D0, D6   
     EOR.B  D2, D6    *THIS IS SO WRONG, 68K SAYS EA CAN'T BE AN AND #<DATA>
     EOR.B  #$1, D4   
     EOR.B  #$10, D4   

     
     EOR.W   D0, D6      
     EOR.W  D2, D6    
     EOR.W  #$1, D4
     EOR.W  #$10, D4   
     EOR.W  #$2000,D5

     EOR.L  D0, D6      
     EOR.L  D2, D6    
     EOR.L  #$1, D4
     EOR.L  #$10, D4   
     EOR.L  #$2000,D5 

  
***** TEST BAD OPCODE FOR GROUP 1011 CMP - CODE CMPA-----------------
*Subtracts the source operand from the destination address register and sets
*the condition codes according to the result     
     CMPA.W  D0, A6      
     CMPA.W  (A4)+,A3     
     CMPA.W  D2, A6    
     CMPA.W (A3),A5    
     CMPA.W  -(A1),A0 
     CMPA.W  (A2)+, A1  
     CMPA.W  $23,A0 
     CMPA.W  $4444, A1 
     CMPA.W  $44440000,A7 
     CMPA.W  #$1, A4
     CMPA.W  #$10, A4   
     CMPA.W  #$2000,A5

     CMPA.L  D0, A6      
     CMPA.L  (A4)+,A3     
     CMPA.L  D2, A6    
     CMPA.L (A3),A5    
     CMPA.L  -(A1),A0 
     CMPA.L  (A2)+, A1  
     CMPA.L  $23,A0 
     CMPA.L  $4444, A1 
     CMPA.L  $44440000,A7 
     CMPA.L  #$1, A4
     CMPA.L  #$10, A4   
     CMPA.L  #$2000,A5 
  
***** TEST BAD OPCODE FOR GROUP 1100 AND,MULS-----------------  
*-----------------  ABCD  -------------------
*Adds the source operand to the destination operand along with the extend bit,
*and stores the result in the destination location
    ABCD.B D2, D4      *OPERATION ON BYTE ONLY, DN ->DN AND AN->AN
    ABCD.B -(A2),-(A6)
*-----------------  EXG EXCHANGE REGISTER-TEST GROUP 1100  -------------------
*Exchanges the contents of two 32-bit registers. The instruction performs three
*types of exchanges.  
   EXG   D3, D4
   EXG   A1, A4
   EXG   D2, A5
   
**-----------------  MULS SIGNED MULTIPLY TEST GROUP 1100 -------------------
*Multiplies two signed operands yielding a signed result. This instruction has a
*word operand form 
     MULS.W   D2, D1      * EA CANT BE AN
     MULS.W  (A5)+,D2        
     MULS.W  (A3),D5    
     MULS.W   -(A2),D5 
     MULS.W  (A2)+, D4  
     MULS.W  $20,D6 
     MULS.W  $4499,D4 
     MULS.W  $10000000,D5 
     MULS.W  #$9,D2
     MULS.W  #$50,D2   
     MULS.W #$7000,D7
 
***** TEST BAD OPCODE FOR GROUP 1101 ADD,ADDA-----------------
**-----------------  ADDX ADD EXTENDED TEST GROUP 1101 -------------------
    ADDX.B  D2, D3
    ADDX.B  -(A4),-(A5)
    ADDX.W  D4, D6
    SUBX.W  -(A3),-(A4)
    SUBX.L  D0,D5
    SUBX.L  -(A0),-(A3)
 
***** TEST BAD OPCODE FOR GROUP 1110 LSL, ASR, ROL----------------- 
**-----------------  ASR TEST GROUP 1110 -------------------
    ASL.B   #3, D0
    ASL.B   #4, D1
    ASL.B   D4, D0
    
     
    ASL.W   #7,D1
    ASL.W   #6,D2
    ASL.W   D1, D0
    ASL.W   (A5)
    ASL.W   (A7)+
    ASL.W   -(A4)
    ASL.W   $9
    ASL.W   $19
    ASL.W   $191
    ASL.W   $1919
    ASL.W   $0FF00000
    ASL.W   $55555555  
    
    ASL.L   #8,D2
    ASL.L   #7,D6
    ASL.W   D3, D6
**-----------------  LSR TEST GROUP 1110 -------------------
    LSR.B   #5, D0
    LSR.B   #7, D1
    LSR.B   D7, D3
    
     
    LSR.W   #2,D1
    LSR.W   #1,D2
    LSR.W   D6, D0
    LSR.W   (A1)
    LSR.W   (A3)+
    LSR.W   -(A4)
    LSR.W   $9
    LSR.W   $19
    LSR.W   $191
    LSR.W   $1919
    LSR.W   $0FF00000
    LSR.W   $55555555  
    
    LSR.L   #8,D2
    LSR.L   #7,D6
    LSR.L   D3, D6
**-----------------  ROR TEST GROUP 1110 -------------------
    ROR.B   #5, D0
    ROR.B   #7, D1
    ROR.B   D7, D3
    
     
    ROR.W   #2,D1
    ROR.W   #1,D2
    ROR.W   D6, D0
    ROR.W   (A1)
    ROR.W   (A3)+
    ROR.W   -(A4)
    ROR.W   $9
    ROR.W   $19
    ROR.W   $191
    ROR.W   $1919
    ROR.W   $0FF00000
    ROR.W   $55555555  
    
    ROR.L   #8,D2
    ROR.L   #7,D6
    ROR.L   D3, D6
    
**-----------------  ROXL TEST GROUP 1110 -------------------    
    ROXR.B   #5, D0
    ROXR.B   #7, D1
    ROXR.B   D7, D3
    
     
    ROXR.W   #2,D1
    ROXR.W   #1,D2
    ROXR.W   D6, D0
    ROXR.W   (A1)
    ROXR.W   (A3)+
    ROXR.W   -(A4)
    ROXR.W   $9
    ROXR.W   $19
    ROXR.W   $191
    ROXR.W   $1919
    ROXR.W   $0FF00000
    ROXR.W   $55555555  
    
    ROXR.L   #8,D2
    ROXR.L   #7,D6
    ROXR.L   D3, D6
    
**-----------------  ROXL TEST GROUP 1110 -------------------  
    ROXL.B   #5, D0
    ROXL.B   #7, D1
    ROXL.B   D7, D3
    
     
    ROXL.W   #2,D1
    ROXL.W   #1,D2
    ROXL.W   D6, D0
    ROXL.W   (A1)
    ROXL.W   (A3)+
    ROXL.W   -(A4)
    ROXL.W   $9
    ROXL.W   $19
    ROXL.W   $191
    ROXL.W   $1919
    ROXL.W   $0FF00000
    ROXL.W   $55555555  
    
    ROXL.L   #8,D2
    ROXL.L   #7,D6
    ROXL.L   D3, D6
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
