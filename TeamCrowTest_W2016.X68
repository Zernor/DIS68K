*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program

* Put program code here
*    NOP
*    RTS
*    JSR     $1234
*    JSR     (A1)
*    JSR     (A2)
*    JSR     (A3)
*    JSR     (A4)
*    JSR     (A5)
    

**-----------MOVE OPCODE-----------
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
**----------MOVE.W-------------------
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
**-----------MOVE.L---------------
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
**----------ADDI------------------

    ADDI.B  #111,D1
    ADDI.B  #45,D1
    ADDI.W  #$101,D1
    ADDI.W  #$310, $2111
    ADDI.W  #10, $E1234560
    ADDI.L  #$101,D1
    ADDI.B  #101,(A3)+
    ADDI.B  #10,-(A4)
    ADDI.L  #$101,D1
    ADDI.L  #$5649,(A6)+
**-----------MOVEQ ------------------
* 
*    MOVEQ    #1, D4
*    MOVEQ    #2, D4
*    MOVEQ    #3,D4
*    MOVEQ    #45, D5
*    MOVEQ    #255,D4
*    
**-----------MOVEM.L----------------
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
*TEST_BACK     RTS

*    LEA     $9800,A1
*    LEA     $0001,A2
*    LEA     (A3),A3
*    LEA     $4000,A7
*    LEA     $1230,A5
*    LEA     $1301,A5
*    LEA     $01001,A1
***-------JRS & RTS-------------
*   JSR      $0000
*   JSR      $A000
*   JSR      (A4)
*   JSR      DUMB
*DUMB        
*    RTS 

*-------CLR-------------------
*    CLR.B   (A0)
*    CLR.W   (A0)
*    CLR.L   (A0)
*    CLR.B   D0
*    CLR.W   D0   
*    CLR.L   D0
*    CLR.B   $0001
*    CLR.W   $0011
*    CLR.L   $0001  
*    CLR.B   $7FFF
*    CLR.B   $8000       
*    CLR.B   $AAAA
*    CLR.W   $BBBB
ADD
*    
***----------ADD--------------------------
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
*
***----------ADDA-------------------------
*
*    ADDX    -(A0),-(A1)  ; bad case
*    ADDA.W  D0,A0
*    ADDA.L  D1,A1
*    ADD.L   A0,A1  
*    ADDA.W  #123,A5
*    ADDA.L  #123,A5
*    ADD.L   #$123,A5
*
***----------SUB-------------------------
*    SUB.B   $11,D0
*    SUB.W   $1111,D0
*    SUB.L   $11111111,D0 
*    SUB.B   $1111,D0
*    SUB.W   $11111111,D0
*    SUB.B   D0,$11
*    SUB.W   D0,$1111
*    SUB.L   D0,$11111111 
*    
***----------DIVU---------------------
*    DIVU    D0,D1
*    DIVU    #$1000,D0
*    DIVU    (A0),D1
*    DIVU    $11111111,D4
*    
**----------BLE PASS---------------------  
*    MOVE.B  #$04,D0
*    MOVE.B  #$06,D1
*    CMP.B   D0,D1
*    BLE     TEST_FORWARD
*    MOVE.L  #$04,D0  
*    MOVE.L  #$06,D1
*    CMP.B   D0,D1
*    BLE     TEST_BACK
*
**----------BCC PASS----------------------     
*    
*    MOVE.L  #$101,D1
*    ADD.L   #$89,D1
*    BCC     TEST_FORWARD
*    MOVE.B  #4,D0
*    MOVE.B  #6,D1
*    CMP.B   D0,D1
*    MOVE.L  #$101,D1
*    ADD.L   #$89,D1
*    BCC     TEST_BACK
**----------BGT PASS----------------------
*    MOVE.B  #4,D0
*    MOVE.B  #6,D1
*    CMP.B   D0,D1
*    BGT     TEST_FORWARD
*    MOVE.L  #$04,D0  
*    MOVE.L  #$06,D1
*    CMP.B   D0,D1
*    BGT     TEST_BACK
***-----------MULS------------------   
*    MULS    $11,D0
*    MULS    $1111,D2
*    MULS    $11111111,D5
*    MULS.W  #1,D4
*    MULS.W  D0,D5
*    MULS.W  #$00001,D4
*    MULS.W  #$03,D3
*    MULS.W  D0,D6
*
*TEST_FORWARD   RTS
*
***-----------AND-------------------
*    AND.B   $11,D5
*    AND.W   $1111,D5
*    AND.L   $11111111,D5
*    AND.B   $1111,D5
*    AND.W   $11111111,D5  
*    AND.B   D5,$11
*    AND.W   D5,$1111
*    AND.L   D5,$11111111    
*    
**-----------ROR-----------------
*    ROR.W   #6,D0
*    ROL.B   D0,D2
*    ROR.L   D0,D2
*    ROL.B   #7,D4  ;  bad case for LSL
*    ROL.L   #8,D4
*    ROR.W   $0FF00000 ; 
*    ROR.W   (a4)+
*    ROL.w   -(a6)
*    ROL.W   (a4)+ 
*            
**----------LSL----------------------------
*    LSL.B   D0,D2
*    LSL.L   D0,D2
*    lSR.B   #7,D4  ;  bad case for LSL
*    LSL.L   #8,D4
*    LSL.W   $0FF00000 ; 
*    LSL.W   (a4)+
*    LSL.W   -(a6)
*     
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
*    ASR.B       D1, D0
*    ASR.B       D2, D0
*    ASR.B       D3, D0
*    ASR.B       D4, D0
*    ASR.B       D5, D6
*    ASR.B       D1, D6
*    ASR.B       D2, D6
*    ASR.B       D3, D6
*

    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
