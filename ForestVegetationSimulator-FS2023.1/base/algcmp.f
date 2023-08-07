      SUBROUTINE ALGCMP (IRC,LIF,CEXPRS,LENEX,JOSTND,LDEBUG,IBASCN,
     >    ISTACK,MXSTCK,IOPCOD,IOPS,MXOPS,CONSTS,ILCONS,ITCONS,MXCONS)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C     CALLED FROM EVIF AND OTHER ROUTINES.  COMPILES EXPRESSIONS.
C
C     AUG 1983 - FORESTRY SCIENCES LABORATORY - MOSCOW, ID 83843
C     RECODED BY N.L. CROOKSTON IN APRIL 1987 TO ALLOW FOR
C     FUNCTIONS WITH MORE THAN ONE ARGUMENT.  THE ORGINIAL ROUTINE
C     WAS TOO HARD TO READ. THIS IS A TOTAL REWRITE.
C
C     OVERALL DESCRIPTION:
C
C     THE GOAL OF THIS ROUTINE IS TO TRANSLATE AN INFIX
C     EXPRESSION STORED IN CEXPRS INTO A POSTFIX SET OF OPERATION CODES
C     STORED IN A PART OF IOPCOD.
C
C     THE POSTFIX REPRESENTATION OF AN EXPRESSION IS A SET OF OPERA-
C     TION CODES ORGANIZED INTO REVERSE POLISH NOTATION.  FOR EXAMPLE
C     CONSIDER THE EXPRESSION: (BTPA NE 100.).  THIS EXPRESSION IS
C     TRANSLATED BY THIS ROUTINE INTO A SET OF OPERATIONS, SUCH AS:
C        103  =    LOAD BTPA ONTO A REAL NUMBER STACK.
C       1001  =    LOAD THE FIRST VALUE IN ARRAY CONSTS ONTO THE STACK.
C                  CODE 1023 WOULD INDECATE THAT CONSTS(23) BE LOADED.
C          5  =    COMPARE THE FIRST TWO VALUES ON THE REAL STACK
C                  USING NOT EQUAL OPERATOR, PLACE THE LOGICAL
C                  RESULT ON A LOGICAL STACK, AND POP THE REAL
C                  REAL STACK TWO POSITIONS.
C          0  =    ZERO INDECATES THAT THE EXPRESSION IS FINNISHED...
C                  TAKE THE VALUE AT THE TOP OF THE LOGICAL STACK AS
C                  THE ANSWER.
C
C     THE EXPRESSIONS ARE EVALUATED IN ALGEVL WHICH IS CALLED BY EVMON.
C     EVMON IS CALLED BY TREGRO TWICE EVERY CYCLE...IN THE FUTURE IT
C     MAY BE CALLED MORE OFTEN.  THE FIRST CALL IS BEFORE CUTS AND THE
C     SECOND IS AFTER CUTS.  ALGEVL IS ALSO CALLED WHEN EXPRESSIONS
C     ARE USED AS PARAMETERS ON KEYWORDS.
C
C     ARGUMENTS:
C
C     IRC   = RETURN CODES: 0= OK, SEE BOTTOM FOR OTHER CODES.
C     LIF   = TRUE IF THE EXPRESSION IS A LOGICAL EXPRESSION, FALSE
C             IF IT IS AN ALGEBRAIC EXPRESSION.
C     CEXPRS= CHAR*1 ARRAY HOLDING THE EXPRESSION TO BE COMPILED.
C     LENEX = LENGTH OF THE EXPRESSION...POINTS TO THE LAST NON-BLANK
C             CHARACTER IN CEXPRS.
C     JOSTND= OUTPUT DATA SET REFERENCE (FOR DEBUG AND ERROR MSGS).
C     LEDBUG= TRUE IF DEBUG OUTPUT IS WANTED.
C     IOPCOD= ARRAY CONTAINING THE OPCODE.
C     IBASCN= THE BASE OPCODE FOR CONSTANT STORAGE...1000 FOR BASE
C             PROGNOSIS.
C     IOPS  = FIRST VACANT POSITION IN OPCODE.
C     MXOPS = MAX LENGTH OF IOPCOD.
C     CONSTS= ARRAY OF CONSTANTS IN THE EXPRESSION.
C     ILCONS= FIRST VACANT POSITION IN BOTTOM OF CONSTS.
C     ITCONS= FIRST VACANT POSITION IN TOP OF CONSTS.
C     MXCONS= MAX LENGTH OF CONSTS.
C     ISTACK= WORK STACK THAT HOLDS THE BROKEN UP PARTS
C             OF THE EXPRESSION (INDIVIDUAL KEYWORDS)
C     MXSTCK= MAX SIZE OF ISTACK
C
C     VARIABLES AND THEIR MEANINGS:
C     CLPAR = THE LEFT PARENTHESE
C     CRPAR = THE RIGHT PARENTHESE
C     CBLNK = THE BLANK CHARACTER
C     ITOP  = POINTER TO THE TOP OF ISTACK
C
      INTEGER MXTMP
      PARAMETER (MXTMP=50)
      LOGICAL LDEBUG,LNUMB,LSTONE,LIF
      CHARACTER CEXPRS(LENEX),CTOKEN(20),CLPAR,CRPAR,CBLNK,CTOK*20,
     >          COMMA,CPLUS,CMINUS,CTIMES,CDIV,CCHAR,CNUMBS*11,COPS*8
      EQUIVALENCE (CTOK,CTOKEN)
      INTEGER ITMP(MXTMP),ISTACK(MXSTCK),IOPCOD(MXOPS)
      REAL CONSTS(MXCONS)
      INTEGER IPRMAP(16)
C
      INTEGER IBOOL,ITEST,ICNT,J,K,ISYM,II,NCOMMA,NTMP,I,NUM,ICCN,IDELTA
      INTEGER I1,I2,NCCN,ITOKEN,ITOP,ICEXP,ISTCON,ISLCON,ISOPS,ILPAR
      INTEGER IRPAR,MXTOK,ICOMMA,MXCONS,MXOPS,MXSTCK
      INTEGER ITCONS,ILCONS,IOPS,IBASCN,JOSTND,IRC,LENEX
      REAL RLNUM
C
      DATA IPRMAP /3,2,1,4,4,4,4,4,4,0,5,5,6,6,8,7/
      DATA CLPAR/'('/,CRPAR/')'/,CBLNK/' '/,CNUMBS/'0123456789.'/,
     >     CPLUS/'+'/,CMINUS/'-'/,CTIMES/'*'/,CDIV/'/'/,
     >     COPS/'()+-*/, '/,COMMA/','/
      DATA ILPAR/-10001/,IRPAR/-10002/,MXTOK/20/,ICOMMA/-10003/
C
C     SYMBOL        PRECEDENCE RANKING      OP CODE
C     ------        ------------------      -------
C     SQRT,EXP,ALOG         9               22,23,24
C     ALOG10,FRAC,INT,ABS   9               25,26,27,34
C     SIN,COS,TAN           9               28,29,30
C     ARCSIN,ARCCOS,ARCTAN  9               31,32,33
C     MOD,DECADE,... AND    9               101NN,... ETC.
C     OTHERS, SEE ALGEVL
C     WHERE NN IS THE NUMBER OF OPERANDS. FOR EXAMPLE 10205 IS DECADE
C     WITH 5 OPERANDS, LIKE: DECADE(10,20,30,40,50).
C
C     **                    8               15
C     - (UNARY MINUS)       7               16
C     *,/                   6               13,14
C     +,-                   5               11,12
C     EQ,NE                 4               4,5
C     LT,LE                 4               8,9
C     GT,GE                 4               6,7
C     NOT                   3               1
C     AND                   2               2
C     OR                    1               3
C
C     THE FOLLOWING ARE CLASSES OF OPERATOR CODES THAT RESULT IN
C     LOADING OPERANDS.
C
C     100'S ARE FROM PROGNOSIS TSTV1
C     200'S ARE FROM PROGNOSIS TSTV2
C     300'S ARE FROM PROGNOSIS TSTV3
C     400'S ARE FROM PROGNOSIS TSTV4
C     500-899 ARE FORM PROGNOSIS TSTV5 (USER DEFINED)
C     900   IS LOAD RANN(X)
C     1000'S ARE PROGNOSIS CONSTANTS LOADED INTO PARMS.
C
C     SAVE THE ORIGINAL VALUES OF IOPS AND ILCONS FOR LATER USE.
C
      IRC=0
      ISOPS=IOPS
      ISLCON=ILCONS
      ISTCON=ITCONS
C
C     PARSE THE STRING IN THE CEXPRS VECTOR.  AS THE STRING IS PARSED,
C     THE VARIOUS OPERANDS AND OPERATORS THAT ARE FOUND ARE PLACED INTO
C     ISTACK. IF A LEFT OR RIGHT PARENTHSIS IS FOUND THEN ITS INTEGER
C     EQUIVALENT IS PLACED INTO ISTACK.  IF AN ALGEBRAIC SYMBOL (+,-,
C     *,/,**) IS FOUND THEN ITS OPCODE IS PLACED IN ISTACK.  IF THE
C     STRING LOCATED IS NOT AN ALGEBRAIC OPERATOR OR PARENTHESIS THEN
C     IT IS FIRST PASSED TO THE EVREAL ROUTINE TO SEE IF IT IS A REAL
C     NUMBER.  IF IT IS NOT A REAL NUMBER, THEN IT IS SENT TO ALGKEY. IF
C     THE STRING IS NOT A KEYWORD THEN AN ERROR CODE IS ISSUED. IF THE
C     STRING IS A KEYWORD THEN ITS OPCODE IS PLACED ONTO ISTACK.
C
      ICEXP = 1
      ITOP = 1
C
C     LSTONE IS TRUE IF A + OR - WILL BE UNARY, FALSE IF BINARY.
C
      LSTONE=.TRUE.
C
   10 CONTINUE
      CCHAR=CEXPRS(ICEXP)
C
C     CHECK FOR THE LEFT PARENTHESIS
C
      IF (CCHAR.EQ.CLPAR) THEN
C
C        PLACE THE LEFT PARENTHESIS ON THE STACK
C
         ISTACK(ITOP)=ILPAR
         LSTONE=.TRUE.
         GOTO 40
      ENDIF
C
C     CHECK FOR THE RIGHT PARENTHESIS
C
      IF (CCHAR.EQ.CRPAR) THEN
C
C        PLACE THE RIGHT PARENTHESIS ON THE STACK
C
         ISTACK(ITOP)=IRPAR
         LSTONE=.FALSE.
         GOTO 40
      ENDIF
C
C     CHECK FOR COMMA
C
      IF (CCHAR.EQ.COMMA) THEN
C
C        PLACE THE COMMA ON THE STACK
C
         ISTACK(ITOP)=ICOMMA
         LSTONE=.TRUE.
         GOTO 40
      ENDIF
C
C     CHECK FOR THE PLUS SIGN
C
      IF (CCHAR.EQ.CPLUS) THEN
C
C        CHECK TO SEE IF THIS IS A BINARY PLUS, KEEP IT. IF UNARY PLUS
C        THEN THROW IT AWAY.
C
         IF (LSTONE) THEN
            LSTONE=.FALSE.
            GOTO 50
         ELSE
C
C           PLACE THE PLUS SIGN ONTO THE STACK
C
            ISTACK(ITOP)=11
            GOTO 40
         ENDIF
      ENDIF
C
C     CHECK FOR THE MINUS SIGN
C
      IF (CCHAR.EQ.CMINUS) THEN
C
C        IF THIS IS A BINARY MINUS, PUT IT ON THE STACK. IF IT IS
C        A UNARY MINUS, THEN PLACE THAT ON THE STACK.
C
         IF (LSTONE) THEN
            LSTONE=.FALSE.
            ISTACK(ITOP)=16
         ELSE
            ISTACK(ITOP)=12
         ENDIF
         GOTO 40
      ENDIF
C
C     CHECK FOR THE DIVISION SYMBOL
C
      IF (CCHAR.EQ.CDIV) THEN
C
C        PLACE THE DIVISION SIGN ONTO THE STACK
C
         ISTACK(ITOP)=14
         LSTONE=.FALSE.
         GOTO 40
      ENDIF
C
C     CHECK FOR THE MULTIPLICATION OR EXPONENTIATION SYMBOL
C
      IF (CCHAR.EQ.CTIMES) THEN
C
C        LOAD THE MULTIPLICATION OPERATION ONTO THE STACK
C
         ISTACK(ITOP)=13
C
C        LOOK FOR ANOTHER *, IF SO IT IS EXPONENTIATION
C
         IF (ICEXP.LT.LENEX) THEN
            IF (CEXPRS(ICEXP+1).EQ.CTIMES) THEN
               ISTACK(ITOP)=15
               ICEXP=ICEXP+1
            ENDIF
         ENDIF
         LSTONE=.FALSE.
         GOTO 40
      ENDIF
C
C     CHECK FOR THE BLANK CHARACTER, IF BLANK, SKIP TO THE NEXT CHAR.
C
      IF (CCHAR.EQ.CBLNK) GOTO 50
C
C     THIS PORTION OF THE EXPRESSION DOES NOT CONTAIN AN OPERATOR
C     AS SUCH.  THEREFORE, IT MUST CONTAIN A NUMBER OR A KEYWORD.
C     LOAD THE FIRST CHARACTER ONTO THE CTOKEN ARRAY AND SCAN FOR
C     THE END OF THE TOKEN.  SET LNUMB TRUE IF THE TOKEN IS A
C     NUMBER, AND SET LNUMB FALSE OTHERWISE.
C
      ITOKEN=1
      CTOK=' '
      CTOKEN(1)=CCHAR
      LNUMB=INDEX(CNUMBS,CCHAR).GT.0
   25 CONTINUE
      CCHAR=CEXPRS(ICEXP)
      IF (LNUMB) THEN
         IF (CCHAR.EQ.'E') THEN
            CTOKEN(ITOKEN)=CCHAR
            ITOKEN=ITOKEN+1
            IF (ITOKEN.GT.MXTOK) GOTO 460
            ICEXP=ICEXP+1
            IF (ICEXP.GT.LENEX) GOTO 100
            CCHAR=CEXPRS(ICEXP)
            IF (CCHAR.EQ.'+' .OR. CCHAR.EQ.'-') GOTO 20
         ENDIF
      ENDIF
      IF (INDEX(COPS,CCHAR).GT.0) GOTO 100
   20 CONTINUE
      CTOKEN(ITOKEN)=CCHAR
      ITOKEN=ITOKEN+1
      IF (ITOKEN.GT.MXTOK) GOTO 460
      ICEXP=ICEXP+1
      IF (ICEXP.GT.LENEX) GOTO 100
C
C     BRANCH BACK TO GET ANOTHER CHARACTER.
C
      GOTO 25
   40 CONTINUE
      ITOP=ITOP+1
      IF(ITOP.GT.MXSTCK) GOTO 430
   50 CONTINUE
      ICEXP=ICEXP+1
      IF(ICEXP.GT.LENEX) GOTO 200
      GOTO 10
  100 CONTINUE
C
C     NOW THAT A STRING OF CHARACTERS HAS BEEN FOUND, PASS THEM TO THE
C     REAL NUMBER SUBROUTINE TO CHECK IF IT IS A REAL NUMBER.
C
      ITOKEN=ITOKEN-1
      IF (LDEBUG) WRITE(JOSTND,'(A20)') CTOK
      IF (LNUMB) THEN
         IF (INDEX(CTOK,'.').LE.0) THEN
            ITOKEN=ITOKEN+1
            CTOKEN(ITOKEN)='.'
         ENDIF
         READ (CTOK,'(G20.0)') RLNUM
C
C        SET THE SEARCH RANGE...SEARCH FROM I1 TO I2 USING IDELTA
C        FOR THE INCREMENT.  IF ITCONS IS POSITIVE, THEN SEARCH FROM
C        THE 'TOP' OF CONSTS TO ITCONS.  IF ITCONS IS -1, THEN
C        SEARCH FROM NORMALLY.
C
         IF (ITCONS.GT.-1) THEN
            IF (ILCONS.GT.ITCONS) GOTO 450
            IF (ITCONS.EQ.MXCONS) THEN
C
C              THIS IS THE FIRST CONSTANT IN THE LIST.
C
               NCCN=MXCONS
               ITCONS=ITCONS-1
               GOTO 120
            ENDIF
            I1=MXCONS
            I2=ITCONS+1
            IDELTA=-1
         ELSE
            IF (ILCONS.GT.MXCONS) GOTO 450
            IF (ILCONS.EQ.1) THEN
C
C              THIS IS THE FIRST CONSTANT IN THE LIST.
C
               NCCN=1
               ILCONS=ILCONS+1
               GOTO 120
            ENDIF
            I1=1
            I2=ILCONS-1
            IDELTA=1
         ENDIF
C
C        SEARCH THE LIST TO SEE IF THE CONSTANT IS ALREADY PRESENT.
C
         DO 110 ICCN=I1,I2,IDELTA
         IF (CONSTS(ICCN).EQ.RLNUM) THEN
            NCCN=ICCN
            GOTO 130
         ENDIF
  110    CONTINUE
C
C        IT IS NOT PRESENT.  PLACE IT IN THE LIST AND INCREMENT
C        THE POINTER.  PLACE AT THE BOTTOM IF ITCONS IS GT -1 AND
C        AT THE TOP OTHERWISE.
C
         IF (ITCONS.GT.-1) THEN
            NCCN=ITCONS
            ITCONS=ITCONS-1
         ELSE
            NCCN=ILCONS
            ILCONS=ILCONS+1
         ENDIF
  120    CONTINUE
         CONSTS(NCCN)=RLNUM
  130    CONTINUE
         ISTACK(ITOP)=IBASCN+NCCN
         IF (LDEBUG) WRITE(JOSTND,140) ILCONS,ITCONS,NCCN,CONSTS(NCCN),
     >                                 CTOK,ITOP,ISTACK(ITOP)
  140    FORMAT(' ILCONS=',I4,'; ITCONS=',I4,'; CONSTS(',I4,') = ',
     >          E15.7,'; CTOK= ',A20,'; ISTACK(',I4,')=',I7)
         LSTONE=.FALSE.
      ELSE
         CALL ALGKEY (CTOK,ITOKEN,NUM,IRC)
         IF(IRC.NE.0) THEN
            CALL EVMKV  (CTOK)
            CALL ALGKEY (CTOK,ITOKEN,NUM,IRC)
         ENDIF
         IF(IRC.NE.0) GOTO 470
         LSTONE=(NUM.GE.1.AND.NUM.LE.9)
         ISTACK(ITOP)=NUM
      ENDIF
      ITOP=ITOP+1
      IF(ITOP.GT.MXSTCK) GOTO 430
      IF(ICEXP.GT.LENEX) GOTO 200
      GOTO 10
C
  200 CONTINUE
      ITOP=ITOP-1
      IF (ITOP.LE.0) GOTO 490
C
C     IF DEBUG IS ON, WRITE THE LIST OF OPS ON THE STACK.
C
      IF (LDEBUG) WRITE (JOSTND,210) (I,ISTACK(I),I=1,ITOP)
  210 FORMAT (5(:' ISTACK(',I4,')=',I6))
C
C     ***** INFIX TO POSTFIX CONVERSION *****
C
C     LOAD THE OPERATORS AND OPERANDS INTO IOPCOD IN POSTFIX
C     NOTATION. (REVERSE POLISH NOTATION).
C
      NTMP=0
      NCOMMA=0
C
C     LOOP THROUGH THE STACK OF OPERATORS AND OPERANDS.
C
      DO 350 II=1,ITOP
      ISYM=ISTACK(II)
C
C     IF THE CODE IS A LOAD OPERAND, THEN PLACE IT IN THE
C     OPERATION CODE ARRAY.
C
      IF (ISYM.LT.0 .AND. ISYM.GT.-10000 .OR.
     >   (ISYM.GE.100 .AND. ISYM.LT.10000)) THEN
         IOPCOD(IOPS)=ISYM
         IOPS=IOPS+1
         IF (IOPS.GT.MXOPS) GOTO 400
      ELSE
C
C     ELSE: THE CODE IS A PARENTHESIS, COMMA, OR OPERATOR.
C
C        IF THE TEMPORARY OPERATOR STACK IS EMPTY, OR IF THE
C        CODE IS A LEFT PAREN, THEN: LOAD IT ONTO THE TEMP STACK.
C
         IF (NTMP.EQ.0 .OR. ISYM.EQ.ILPAR) THEN
C
C           IF THE CODE IS A COMMA OR A RIGHT PAREN, THEN: THERE
C           IS A MISSING OPERATOR.  BRANCH TO ISSUE ERROR CODE.
C
            IF (ISYM.EQ.IRPAR .OR. ISYM.EQ.ICOMMA) GOTO 410
            NTMP=NTMP+1
            IF (NTMP.GT.MXTMP) GOTO 430
C
C           IF THE CURRENT CODE QUALIFIES FOR COMMAS THEN:  STORE THE
C           COMMA COUNT AS PART OF THE OPERATION AND RESET NCOMMA.
C
            IF (ISYM.GT.10000) THEN
               ISYM=ISYM+NCOMMA
               NCOMMA=0
            ENDIF
            ITMP(NTMP)=ISYM
         ELSE
C
C           IF THE CODE IS A RIGHT PAREN OR A COMMA, THEN: POP THE
C           TEMPORARY STACK AND PLACE THE CONTENTS ONTO THE OP CODE
C           ARRAY.  POP THE STACK UNTIL A LEFT PAREN IS REACHED OR
C           UNTIL THE TEMP STACK IS EMPTY.
C
C           IF THERE IS A LEFT PAREN ON THE STACK, THEN: IF THE CODE
C           IS A COMMA, THEN COUNT THE COMMAS AND LEAVE THE LEFT
C           PAREN ON THE TEMP STACK.  IF THE CODE IS A RIGHT PAREN,
C           CLEAR THE LEFT PAREN FROM THE STACK.
C
            IF (ISYM.EQ.IRPAR .OR. ISYM.EQ.ICOMMA) THEN
               DO 310 K=1,NTMP
               J=NTMP-K+1
               IF (ITMP(J).NE.ILPAR) THEN
C
C                 IF THE OPERATION CODE CAN HAVE MORE THAN ONE
C                 OPERAND, THEN THE NUMBER OF OPERANDS IS THE NUMBER
C                 OF COMMAS PLUS ONE.  CONVERT THE OPERATION CODE TO
C                 INCLUDE THE NUMBER OF OPERANDS.  THE CODE ON ITMP
C                 CARRIES THE NUMBER OF COMMAS PRESENT IN THE
C                 EXPRESSION BEFORE THE CURRENT CODE WAS SPECIFIED.
C                 THIS NUMBER IS REMOVED FROM THE CODE AND USED TO
C                 RESET NCOMMA. THIS ALLOWS NESTED MULT-OP-CODE CODES
C                 LIKE: (DECADE(10,MOD(4,5),TIME(MOD(3,2),5)))
C
                  IF (ITMP(J).GT.10000) THEN
                     ICNT=MOD(ITMP(J),100)
                     IOPCOD(IOPS)=(ITMP(J)/100*100)+NCOMMA+1
                     NCOMMA=ICNT
                  ELSE
                     IOPCOD(IOPS)=ITMP(J)
                  ENDIF
                  IOPS=IOPS+1
                  IF (IOPS.GT.MXOPS) GOTO 400
               ELSE
                  IF (ISYM.EQ.ICOMMA) THEN
                     NCOMMA=NCOMMA+1
                     IF (NCOMMA.GT.98) GOTO 446
                  ELSE
                     J=J-1
                  ENDIF
                  GOTO 320
               ENDIF
  310          CONTINUE
  320          CONTINUE
               NTMP=J
            ELSE
C
C              THE CODE IS NOT A LEFT OR RIGHT PAREN, A
C              COMMA, OR A LOAD OPERAND.  IF THE TEMP-STACK-
C              OPERATOR IS A LEFT PAREN, THEN: PLACE THE
C              OPERATOR ONTO THE TEMP STACK. (NOTE THAT THIS
C              IS BRANCH BACK TARGET.  SEE THE COMMENTS IN
C              THE CODE BELOW).
C
  330          CONTINUE
               IF (ITMP(NTMP).EQ.ILPAR) THEN
                  NTMP=NTMP+1
                  IF (NTMP.GT.MXTMP) GOTO 430
                  IF (ISYM.GT.10000) THEN
                     ISYM=ISYM+NCOMMA
                     NCOMMA=0
                  ENDIF
                  ITMP(NTMP)=ISYM
               ELSE
C
C                 CHECK THE PRECEDENCE OF THE OPERATOR AND THE
C                 OPERATOR ON THE TEMPORARY STACK.  IF THE
C                 PRECEDENCE OF THE OPERATOR IS EQUAL TO THE
C                 PRECEDENCE OF THE TEMP-STACK-OPERATOR, THEN:
C                 MOVE THE TEMP-STACK-OP TO THE OPERATOR CODE
C                 ARRAY AND PLACE THE OPERATOR ONTO THE TEMP
C                 STACK. IF THE OPERATOR HAS GREATER PRECEDENCE
C                 THAN THE TEMP-STACK-OP, THEN ADD IT TO THE
C                 TEMP STACK. IF THE OPERATOR HAS LESS
C                 PRECEDENCE THAN THE TEMP-STACK-OP, THEN MOVE
C                 THE TEMP-STACK-OP TO THE OP-CODE ARRAY, POP
C                 THE TEMP STACK, AND BRANCH BACK TO COMPARE THE
C                 OPERATOR PRECEDENCE TO WHAT IS LEFT ON THE
C                 STACK (IF THE STACK IS EMPTY, SIMPLY ADD THE
C                 OPCODE TO THE TEMP STACK).
C
                  IF (ISYM.LE.16) THEN
                     J=IPRMAP(ISYM)
                  ELSE
                     J=9
                  ENDIF
                  IF (ITMP(NTMP).LE.16) THEN
                     ITEST=IPRMAP(ITMP(NTMP))
                  ELSE
                     ITEST=9
                  ENDIF
                  IF (J.LE.ITEST) THEN
                     IF (ITMP(NTMP).GT.10000) THEN
                        ICNT=MOD(ITMP(NTMP),100)
                        IOPCOD(IOPS)=(ITMP(NTMP)/100*100)+NCOMMA+1
                        NCOMMA=ICNT
                     ELSE
                        IOPCOD(IOPS)=ITMP(NTMP)
                     ENDIF
                     IOPS=IOPS+1
                     IF (IOPS.GT.MXOPS) GOTO 400
C
C                    SEE THE COMMENTS, ABOVE.
C
                     IF (NTMP.EQ.1 .OR. J.EQ.ITEST) THEN
                        ITMP(NTMP)=ISYM
                     ELSE
C
C                       DECREMENT THE TEMP STACK AND BRANCH TO RECHECK.
C
                        NTMP=NTMP-1
                        GOTO 330
                     ENDIF
                  ELSE
C
C                    PLACE THE OPERATOR ONTO THE TEMP STACK.
C
                     NTMP=NTMP+1
                     IF (NTMP.GT.MXTMP) GOTO 430
                     IF (ISYM.GT.10000) THEN
                        ISYM=ISYM+NCOMMA
                        NCOMMA=0
                     ENDIF
                     ITMP(NTMP)=ISYM
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
  350 CONTINUE
C
C     IF THERE ARE MORE OPERATORS ON THE TEMP STACK, THEN PLACE
C     THEM ON THE OPERATION STACK.
C
      IF (NTMP.GT.0) THEN
         DO 360 II=1,NTMP
         J=NTMP-II+1
C
C        IF THE OPERATOR ON THE TEMP STACK IS A LEFT PAREN, THEN:
C        THERE ARE MISMATCHED PARENS.
C
         IF (ITMP(J).EQ.ILPAR) GOTO 410
         IF (ITMP(J).GT.10000) THEN
            ICNT=MOD(ITMP(J),100)
            IOPCOD(IOPS)=(ITMP(J)/100*100)+NCOMMA+1
            NCOMMA=ICNT
         ELSE
            IOPCOD(IOPS)=ITMP(J)
         ENDIF
         IOPS=IOPS+1
         IF (IOPS.GT.MXOPS) GOTO 400
  360    CONTINUE
      ENDIF
C
C     IF THE NUMBER OF COMMAS IS NOT NOW EQUAL TO ZERO, THEN:
C     THERE WERE COMMAS USED WITH OPERATORS THAT DO NOT ALLOW
C     FOR MORE THAN ONE OPERAND.
C
      IF (NCOMMA.GT.0) GOTO 440
C
C     LOAD THE LAST OP-CODE...THIS ZERO SIGNIFIES THE END OF THE
C     EXPRESSION.
C
      IOPCOD(IOPS) = 0
C
C     ***** THIS IS THE END OF THE INFIX TO POSTFIX CONVERSION *****
C
      IF (LIF) THEN
C
C        CHECK TO SEE IF THE NUMBER OF RELATIONAL OPERATORS
C        IS EQUAL TO THE NUMBER OF BOOLEAN OPERATORS-1. IF THIS
C        IS NOT TRUE THEN ISSUE AN ERROR CODE INDICATING AN
C        INVALID EXPRESSION.
C
         ICNT=0
         IBOOL=0
C
         DO 370 K=ISOPS,IOPS
         ITEST=IOPCOD(K)
         IF (ITEST.LT.10) THEN
            IF (ITEST.GE.2.AND.ITEST.LE.3) IBOOL=IBOOL+1
            IF (ITEST.GE.4.AND.ITEST.LE.9) ICNT=ICNT+1
         ENDIF
  370    CONTINUE
         IF (ICNT-1.NE.IBOOL) GOTO 480
      ENDIF
C
C     BRANCH TO EXIT.
C
      GOTO 500
C
C     ERROR CODES:
C
  400 CONTINUE
      WRITE (JOSTND,405)
  405 FORMAT (/T12,'NOT ENOUGH STORAGE TO STORE EXPRESSION.')
      IRC=1
      GOTO 600
  410 CONTINUE
      WRITE (JOSTND,415)
  415 FORMAT (/T12,'MISMATCHED OR OTHER MISUSE OF PARENTHESIS.')
      IRC=2
      GOTO 600
  430 CONTINUE
      WRITE (JOSTND,435)
  435 FORMAT (/T12,'NOT ENOUGH STORAGE TO COMPILE EXPRESSION.')
      IRC=4
      GOTO 600
  440 CONTINUE
      WRITE (JOSTND,445)
  445 FORMAT (/T12,'A COMMA WAS USED WITHOUT AN OPERATOR THAT',
     >       ' ALLOWS ONE.')
      IRC=5
      GOTO 600
  446 CONTINUE
      WRITE (JOSTND,447)
  447 FORMAT (/T12,'TOO MANY COMMAS IN ONE FUNCTION.')
      IRC=5
      GOTO 600
  450 CONTINUE
      WRITE (JOSTND,455)
  455 FORMAT (/T12,'NOT ENOUGH STORAGE TO STORE CONSTANTS IN',
     >       ' THE EXPRESSION.')
      IRC=6
      GOTO 600
  460 CONTINUE
      WRITE (JOSTND,465)
  465 FORMAT (/T12,'A VARIABLE OR NUMBER (TOKEN) IS TOO LONG.')
      IRC=6
      GOTO 600
  470 CONTINUE
      WRITE (JOSTND,475)
  475 FORMAT (/T12,'AN ILLEGAL VARIABLE WAS FOUND.')
      IRC=7
      GOTO 600
  480 CONTINUE
      WRITE (JOSTND,485)
  485 FORMAT (/T12,'A LOGICAL EXPRESSION WAS EXPECTED BUT NOT FOUND.')
      IRC=8
      GOTO 600
  490 CONTINUE
      WRITE (JOSTND,495)
  495 FORMAT (/T12,'NO EXPRESSION WAS FOUND.')
      IRC=9
      GOTO 600
  500 CONTINUE
      IRC=0
      IF (LDEBUG) WRITE(JOSTND,550) ISOPS,IOPS,(IOPCOD(I),I=ISOPS,IOPS)
  550 FORMAT(/,'LEAVING ALGCMP, IOPCOD(',I5,' TO',I5,') ='/
     >      ((10I7)))
      IOPS=IOPS+1
      IF (IOPS.GT.MXOPS) GOTO 400
      RETURN
  600 CONTINUE
      IOPS= ISOPS
      ILCONS=ISLCON
      ITCONS=ISTCON
      RETURN
      END
