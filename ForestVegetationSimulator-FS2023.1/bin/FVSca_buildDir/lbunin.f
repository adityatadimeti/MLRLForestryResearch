      SUBROUTINE LBUNIN (LEN1,SET1,LEN2,SET2,LNUNIN,UNION,KODE)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     SET UNION OPERATION
C
C     PART OF THE LABEL PROCESSING COMPONENT OF THE PROGNOSIS SYSTEM
C     N.L. CROOKSTON -- INTERMOUNTAIN RESEARCH STATION -- JAN 1987
C
C     LEN1  = LENGTH OF THE DEFINED PART OF THE STRING SET1 IS IN
C     SET1  = C*250 STRING CONTAINING THE FIRST SET
C     LEN2  = LENGTH OF SECOND STRING
C     SET2  = C*250 STRING CONTAINING THE SECOND SET
C     LNUNIN= THE LENGTH OF THE UNION SET STRING
C     UNION = C*250 SET CONTAINING THE UNION
C     KODE  = RETURN CODES: 0= OK, 1=UNION IS OVER 250 CHARS
C             (THE ROUTINE CREATES AS MUCH OF A UNION IS POSSIBLE
C             WITHOUT CREATING A PARTIAL LABEL).
C
      CHARACTER*250 SET1,SET2,UNION,WRKS1,WRKS2
      LOGICAL LBMEMR
      INTEGER KODE,LNUNIN,LEN1,LEN2,IP,LENWRK
C
C     INITIALIZE THE RETURN CODE TO ZERO AND THE UNION TO ZERO LENGTH.
C
      KODE=0
      LNUNIN=0
      UNION=' '
C
C     IF EITHER OF THE SETS HAVE ZERO LENGTH OR IF THEY ARE UNDEFINED,
C     THE UNION IS THE OTHER SET (UNLESS IT, TOO, IS UNDEFINED OR HAS
C     ZERO LENGTH).
C
      IF (LEN1.LE.0) THEN
         IF (LEN2.GT.0) THEN
            LNUNIN=LEN2
            UNION=SET2
         ENDIF
         GOTO 20
      ENDIF
      IF (LEN2.LE.0) THEN
         IF (LEN1.GT.0) THEN
            LNUNIN=LEN1
            UNION=SET1
         ENDIF
         GOTO 20
      ENDIF
C
C     BOTH SETS HAVE GREATER THAN ZERO LENGTH...PROCEED WITH THE
C     UNION.  START WITH THE FIRST SET AS THE UNION.
C
      UNION=SET1
      LNUNIN=LEN1
C
C     CONCATINATE MEMBERS OF THE SECOND SET THAT ARE NOT ALREADY
C     MEMBERS OF THE UNION.
C
C     LOOP THRU ALL OF THE MEMBERS OF THE SECOND SET.
C
      IP=1
   10 CONTINUE
C
C     IF IP IS EQUAL TO THE LENGTH OF THE SECOND SET, END THE LOOP.
C
      IF (IP.GT.LEN2) GOTO 20
C
C     LET WRKS1 BE THE FIRST MEMBER OF SET2 BETWEEN LOCATION IP
C     AND THE END OF THE STRING HOLDING SET2.
C
      CALL LB1MEM (IP,LEN2,SET2,LENWRK,WRKS1)
C
C     FIND OUT IF WRKS1 IS IN THE UNION.  IF IT IS NOT, THEN ADD IT
C     ONTO THE END (IF THERE IS ROOM).
C
      IF (.NOT.LBMEMR(LENWRK,WRKS1,LNUNIN,UNION)) THEN
         IF (LNUNIN+LENWRK+2.LE.250) THEN
            WRKS2 = UNION(1:LNUNIN) // ', ' // WRKS1(1:LENWRK)
            LNUNIN = LNUNIN+LENWRK+2
            UNION = WRKS2
         ELSE
            KODE = 1
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
