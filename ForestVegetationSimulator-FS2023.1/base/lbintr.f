      SUBROUTINE LBINTR (LEN1,SET1,LEN2,SET2,LNINTR,INTRST,KODE)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     SET INTERSECTION OPERATION
C
C     PART OF THE LABEL PROCESSING COMPONENT OF THE PROGNOSIS SYSTEM
C     N.L. CROOKSTON -- INTERMOUNTAIN RESEARCH STATION -- JAN 1987
C
C     LEN1  = LENGTH OF THE DEFINED PART OF THE STRING SET1
C     SET1  = C*250 STRING CONTAINING THE FIRST SET
C     LEN2  = LENGTH OF SECOND STRING
C     SET2  = C*250 STRING CONTAINING THE SECOND SET
C     LNINTR= THE LENGTH OF THE INTRST SET STRING
C     INTRST= C*250 SET CONTAINING THE INTERSECTION
C     KODE  = RETURN CODES: 0= OK, 1=INTRST IS OVER 250 CHARS
C             (THE ROUTINE CREATES AS MUCH OF AN INTERSECTION AS
C             POSSIBLE WITHOUT CREATING A PARTIAL LABEL)
C
      CHARACTER*250 SET1,SET2,INTRST,WRKS1,WRKS2
      LOGICAL LBMEMR
      INTEGER KODE,LNINTR,LEN1,LEN2,IP,LENWRK
C
C     INITIALIZE THE RETURN CODE TO ZERO AND THE INTRST TO ZERO LENGTH.
C
      KODE=0
      LNINTR=0
      INTRST=' '
C
C     IF EITHER OF THE SETS HAVE ZERO LENGTH OR IF EATHER SET IS
C     UNDEFINED, THE INTERSECTION IS AN EMPTY SET.
C
      IF (LEN1.LE.0 .OR. LEN2.LE.0) THEN
         LNINTR=0
         GOTO 20
      ENDIF
C
C     BOTH SETS HAVE GREATER THAN ZERO LENGTH...PROCEED WITH THE
C     INTERSECTION.
C
C     LOOP THRU ALL OF THE MEMBERS OF THE FIRST SET.
C
      IP=1
   10 CONTINUE
C
C     IF IP IS EQUAL TO THE LENGTH OF THE FIRST SET, END THE LOOP.
C
      IF (IP.GT.LEN1) GOTO 20
C
C     LET WRKS1 BE THE FIRST MEMBER OF SET1 BETWEEN LOCATION IP
C     AND THE END OF THE STRING HOLDING SET1.
C
      CALL LB1MEM (IP,LEN1,SET1,LENWRK,WRKS1)
C
C     FIND OUT IF WRKS1 IS IN SET2.  IF IT IS, THEN ADD IT
C     ONTO THE END OF THE INTERSECTION SET (IF THERE IS ROOM).
C
      IF (LBMEMR(LENWRK,WRKS1,LEN2,SET2)) THEN
         IF (LNINTR.EQ.0) THEN
            INTRST = WRKS1
            LNINTR = LENWRK
         ELSE
            IF (LNINTR+LENWRK+2.LE.250) THEN
               WRKS2 = INTRST(1:LNINTR) // ', ' // WRKS1(1:LENWRK)
               LNINTR = LNINTR+LENWRK+2
               INTRST = WRKS2
            ELSE
               KODE = 1
            ENDIF
         ENDIF
      ENDIF
C
C     SET THE IP TO THE LAST CHARACTER OF THE CURRENT MEMBER PLUS 2
C     (ONE FOR THE COMMA AND ANOTHER FOR THE BLANK THAT PRECEDES EACH
C     OF THE MEMBERS PAST THE FIRST ONE).
C
      IP=IP+LENWRK+2
C
C     BRANCH BACK TO PROCESS THE NEXT LABEL.
C
      GOTO 10
   20 CONTINUE
      RETURN
      END
