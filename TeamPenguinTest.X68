;*-----------------------------------------------------------
* Title      : 68K FINAL PROJECT
* Written by : Nguyen Vo, Dat Nguyen, Andreas Chew
* Date       : 3/7/2014
* Description: Test case for our program
*-----------------------------------------------------------
    ORG    $7000

START:                  ; first instruction of program

*-----------MOVE OPCODE-----------
    MOVE.B  #101,D1
    MOVE.B  $48,D2
    MOVE.B  #$AA,D1
    MOVE.B  D4,(A6)+
    MOVE.B  D2,(A5)
    MOVE.B  D5,-(A2)
    MOVE.B  (A1),D4
    MOVE.B  (A2)+,D3
    MOVE.B  -(A1),D1
    MOVE.B  #$44,D2
    MOVE.B  D0,-(A7)
    MOVE.B  D0, $E111
    MOVE.B  D0, $E1234560
 
*----------MOVE.W-------------------
    MOVE.W  #1201,D1
    MOVE.W  $418,D2
    MOVE.W  #$BA,D1
    MOVE.W  D1,(A6)+
    MOVE.W  D0,(A2)
    MOVE.W  D0,-(A0)
    MOVE.W  (A1),D1
    MOVE.W  (A1)+,D1
    MOVE.W  -(A1),D1
    MOVE.W  #$4120,D2
    MOVE.W  D0,D1
    MOVE.W  D0,$E111
    MOVE.W  D0,$1234   
  
*-----------MOVE.L---------------
 
    MOVE.L  #1201,D1
    MOVE.L  $418,D2
    MOVE.L  #$BA,D1
    MOVE.L  D1,(A6)+
    MOVE.L  D0,(A2)
    MOVE.L  D0,-(A0)
    MOVE.L  (A1),D1
    MOVE.L  (A1)+,D1
    MOVE.L  -(A1),D1
    MOVE.L  #$4120,D2
    MOVE.L  D2,D4
    MOVE.L  D4,$AE11  
    MOVE.L  D5,$E123 
    
*----------LSL----------------------------

    LSL.B   D0,D2
    LSL.L   D0,D2
    lSR.B   #7,D4  ;  bad case for LSL
    LSL.L   #8,D4
    LSL.W   $0FF00000 ; 
    LSL.W   (A4)+
    LSL.W   -(a6)
     
    ASR.L   #8,D6
    ASL.L   #8,D4  ; bad case for ASR , fin
    ASR.W   $0FF00000
    ASR.W   (a4)+
    ASR.W   -(a6)

*-----------ROR-----------------
    ROR.W   #6,D0
    ROL.B   D0,D2
    ROR.L   D0,D2
    ROL.B   #7,D4  ;  bad case for LSL
    ROL.L   #8,D4
    ROR.W   $0FF00000 ; 
    ROR.W   (a4)+
    ROL.w   -(a6)
    ROL.W   (a4)+ 
    
*-----------CMPI--------------
    
    CMPI     #3,D0
    CMPI.B   #$03,D4
    CMPI.W   #$0908,D7
    CMPI.L   #$7834,D0
    CMPI.B   #$2F,(A2)
    CMPI.W   #$12F4,-(A5)
    CMPI.L   #$12A2,(A3)+
    CMPI.W   #1110,(A4)  
    CMPI     #$2000,-(A1) 
 
*-----------EORI--------------
   
    EORI    #%10000111,D3
    EORI    #$3E50,$1224
    EORI.B  #$10,(A2)+
    EORI.w  #$F1,-(A4) 
    EORI.L  #$FD,(A5)
    EORI    #$FE,(A2)
    EORI    #$123,(A2)+ 
    
*----------ADDI------------------

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

*-----------ANDI------------------
        
    ANDI    #%10001111,D4
    ANDI.L  #$FE00,$1334
    ANDI.B  #$F0,(A4)+
    ANDI.W  #$F3,-(A3) 
    ANDI.L  #$123,(A5)
    ANDI    #$F1,(A6)
    ANDI    #$1534,(A1)
    
*------------BCHG------------------

    BCHG    #$20,(A1)
    BCHG    D1, (A4)+
    BCHG    D4,D3
    BCHG    D3,-(A3)
    BCHG    #$0293,-(A3)
    BCHG.L  #%11,D4
    BCHG.B  #$00FE,$1334
    BCHG.B  #$F0,(A2)+
    BCHG.B  #$F3,-(A2) 
    BCHG.B  #$23,(A5)
    BCHG    #$F0,(A6)
    BCHG    #$1234,(A1)
         
*----------SUBQ--------------------
       
    ADDQ.B  #1,D1       ; bad case for SUBQ
    ADDQ.B  #2,D1       ; bad case for SUBQ
    SUBQ.B  #3,D1
    SUBQ.B  #4,D3
    SUBQ.W  #$1,D5
    SUBQ.L  #$04,A2
    SUBQ.B  #3,(A1)
    SUBQ.B  #5,(A2)+
    SUBQ.W  #5, $2000
    SUBQ.W  #6, $E1234560
    SUBQ.W  #$05, -(A3)
    SUBQ.L  #7,D1
    SUBQ.L  #$4,(A7)
*-----------MOVEQ ------------------
 
    MOVEQ    #1, D4
    MOVEQ    #2, D4
    MOVEQ    #3,D4
    MOVEQ    #45, D5
    MOVEQ    #255,D4

*-----------MOVEM.L----------------

    MOVEM.L  D0-D7,-(SP)
    MOVEM.L  A3/D2,-(SP)
    MOVEM.L  A1-A5/D1-D4,-(SP)
    MOVEM.L  A1-A3,-(SP)
    MOVEM.L  (SP)+,D0-D7
    MOVEM.L  (SP)+,A3/D2
    MOVEM.L  (SP)+,A1-A5/D1-D4
    MOVEM.L  (SP)+,A1-A6/D2/D3

TEST_BACK     RTS

    LEA     $9800,A1
    LEA     $0001,A2
    LEA     (A3),A3
    LEA     $4000,A7
    LEA.L   $1230,A5
    LEA     $1301,A5
    LEA     $01001,A1

  
*-------JRS & RTS-------------
   JSR      $0000
   JSR      $A000
   JSR      (A4)
   JSR      DUMB
DUMB        RTS 
  
*-------CLR-------------------
    CLR.B   (A0)
    CLR.W   (A0)
    CLR.L   (A0)
    CLR.B   D0
    CLR.W   D0   
    CLR.L   D0
    CLR.B   $0001
    CLR.W   $0011
    CLR.L   $0001  
    CLR.B   $AAAA
    CLR.W   $BBBB
    CLR.L   $CCCC

*---------CMPA----------------
    CMPA.W   $1000,A1
    CMPA.W   $A000,A3
    CMPA.L   A0,A1
    CMPA.L   #$1000,A4
    CMPA.L   D5,A2
    CMPA.L   -(A2),A3
    CMPA.L   (A3),A3
    CMPA.W   (A3)+,A6
   

**----------EOR---------------
    EOR.B       D0,D1
    EOR.B       D0,(A3)
    EOR.B       D0,(A4)+
    EOR.B       D0,-(A5)
    EOR.B       D0,$0001
    EOR.B       D0,$A000
    
    EOR.W       D0,D1
    EOR.W       D0,(A3)
    EOR.W       D0,(A4)+
    EOR.W       D0,-(A5)
    EOR.W       D0,$0001
    EOR.W       D0,$A000
    
    EOR.L       D0,D1
    EOR.L       D0,(A3)
    EOR.L       D0,(A4)+
    EOR.L       D0,-(A5)
    EOR.L       D0,$0001
    EOR.L       D0,$A000

**----------ADD--------------------------
    ADD.B   $11,D5
    ADD.W   $1111,D5
    ADD.L   $11111111,D5
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
    ADD.B   D5,$11
    ADD.W   D5,$1111
    ADD.L   D5,$11111111

**----------ADDA-------------------------

    ADDX    -(A0),-(A1)  ; bad case
    ADDA.W  D0,A0
    ADDA.L  D1,A1
    ADD.L   A0,A1  
    ADDA.W  #123,A5
    ADDA.L  #123,A5
    ADD.L   #$123,A5

**----------SUB-------------------------
    SUB.B   $11,D0
    SUB.W   $1111,D0
    SUB.L   $11111111,D0 
    SUB.B   $1111,D0
    SUB.W   $11111111,D0
    SUB.B   D0,$11
    SUB.W   D0,$1111
    SUB.L   D0,$11111111 
    
**----------SUBA--------------------
    ;SUBX.L  -(A0),-(A1)    
    SUBA.W  $1111,A0
    SUBA.L  $11111111,A0
    SUBA.W  A1,A5
    SUBA.W  D1,A6
    SUBA.W  #$06,A5
    SUBA.W  #07,A4
    SUBA.L  #$7,A2

**----------DIVU---------------------
    DIVU    D0,D1
    DIVU    #$1000,D0
    DIVU    (A0),D1
    DIVU    $11111111,D4

*----------BLE PASS---------------------  
    MOVE.B  #$04,D0
    MOVE.B  #$06,D1
    CMP.B   D0,D1
    BLE     TEST_FORWARD
    MOVE.L  #$04,D0  
    MOVE.L  #$06,D1
    CMP.B   D0,D1
    BLE     TEST_BACK


*----------BCC PASS----------------------     
    
    MOVE.L  #$101,D1
    ADD.L   #$89,D1
    BCC     TEST_FORWARD
    MOVE.B  #4,D0
    MOVE.B  #6,D1
    CMP.B   D0,D1
    MOVE.L  #$101,D1
    ADD.L   #$89,D1
    BCC     TEST_BACK


*----------BGT PASS----------------------
    MOVE.B  #4,D0
    MOVE.B  #6,D1
    CMP.B   D0,D1
    BGT     TEST_FORWARD
    MOVE.L  #$04,D0  
    MOVE.L  #$06,D1
    CMP.B   D0,D1
    BGT     TEST_BACK


*---------BVS PASS------------------------
    MOVE.W #$A000,D1
    ADD.W  #$A000,D1
    BVS    TEST_FORWARD
    MOVE.B  #4,D0
    MOVE.B  #6,D1
    CMP.B   D0,D1
    MOVE.W #$A000,D1
    ADD.W  #$A000,D1
    BVS    TEST_BACK

**-----------MULS------------------   
    MULS    $11,D0
    MULS    $1111,D2
    MULS    $11111111,D5
    MULS.W  #1,D4
    MULS.W  D0,D5
    MULS.W  #$00001,D4
    MULS.W  #$03,D3
    MULS.W  D0,D6

TEST_FORWARD   RTS



**-----------AND-------------------
    AND.B   $11,D5
    AND.W   $1111,D5
    AND.L   $11111111,D5
    AND.B   $1111,D5
    AND.W   $11111111,D5  
    AND.B   D5,$11
    AND.W   D5,$1111
    AND.L   D5,$11111111
 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source











































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
