      SUBROUTINE LBGET1 (IREAD,IRECNT,RECORD,IRPS,LENMEM,MEM,KIND,KODE)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     READ RECORDS FORM IREAD AND PUT THE FIRST MEMBER IN
C     STRING MEM WITH LENGTH LENMEM.  THIS ROUTINE IS DESIGNED
C     TO CREATE TWO KINDS OF MEMBERS, AS DEFINED BELOW (SEE KIND).
C
C     PART OF THE LABEL PROCESSING COMPONENT OF THE PROGNOSIS SYSTEM
C     N.L. CROOKSTON -- INTERMOUNTAIN RESEARCH STATION -- JAN 1987
C
C     IREAD = DATA SET REFERENCE NUMBER
C     IRECNT= NUMBER OF RECORDS READ ON IREAD.
C     RECORD= THE READ RECORD.
C     IRPS  = FIRST POSITION IN RECORD WHERE THE LABEL MAY BE.
C             IF IRPS=0 ON INPUT, A RECORD IS READ.
C     LENMEM= THE LENGTH OF THE STRING HOLDING THE MEMBER
C     MEM   = THE MEMBER.
C     KIND  = 0 FOR A NORMAL LABEL (PERIODS ARE DELETED),
C             1 FOR A HARVEST POLICY LABEL (ONE PERIOD IS KEPT).
C     KODE  = 0 PROCESSING ENDED WITHOUT ERROR.
C             1 STRING MEM IS OVER FULL.
C             2 END-OF-DATA HAS OCCURRED IN IREAD.
C
      CHARACTER*250 MEM
      CHARACTER*(*) RECORD
      LOGICAL LBKADD,LPERD,LPDONE
      INTEGER KODE,KIND,LENMEM,IRPS,IRECNT,IREAD,MXLEN,I,ISTLNB
C
C     INITIALIZE KODE AND MXLEN
C
      KODE=0
      IF (KIND.EQ.0) THEN
         MXLEN=250
      ELSE
         MXLEN=40
      ENDIF
C
C     INITIALIZE LENMEM AND THE MEMBER STRING.
C
      LENMEM=0
      LBKADD=.FALSE.
      LPERD =.FALSE.
      LPDONE=.TRUE.
      MEM=' '
C
C     IF THE POSTION OF THE RECORD IS ZERO, THEN READ A RECORD.
C
   10 CONTINUE
      IF (IRPS.EQ.0) THEN
         READ (IREAD,'(A)',END=200) RECORD
         IRECNT=IRECNT+1
      ENDIF
C
C     LOOP THROUGH THE INPUT STRING AND EXTRACT THE FIRST MEMBER.
C
   20 CONTINUE
      IRPS=IRPS+1
C
C     IF THE END OF THE RECORD IS REACHED, THE END OF THE MEMBER
C     MUST HAVE BEEN REACHED BY DEFINITION.
C
      IF (IRPS.GT.LEN(RECORD)) GOTO 300
C
C     IF THE CHARACTER IS AN AMPERSAND ('&'), THEN READ ANOTHER
C     RECORD.
C
      IF (RECORD(IRPS:IRPS).EQ.'&') THEN
         IRPS=0
         GOTO 10
      ENDIF
C
C     IF THE LENGTH OF THE MEMBER IS ZERO, THEN SKIP ALL BLANKS,
C     COMMAS, AND PERIODS.
C
      IF (LENMEM.EQ.0) THEN
         IF (RECORD(IRPS:IRPS).EQ.' ') GOTO 20
         IF (RECORD(IRPS:IRPS).EQ.',') GOTO 20
         IF (RECORD(IRPS:IRPS).EQ.'.') GOTO 20
      ENDIF
C
C     WHEN THE LENGTH IS GREATER THAN ZERO, A COMMA INDICATES THE END
C     OF THE MEMBER.
C
      IF (RECORD(IRPS:IRPS).EQ.',') GOTO 300
C
C     IF THE CHARACTER IS A BLANK, SET A FLAG INDICATING THAT A BLANK
C     SHOULD BE ADDED TO THE MEMBER BEFORE ANOTHER NON-BLANK CHAR.
C
      IF (RECORD(IRPS:IRPS).EQ.' ') THEN
         LBKADD=.TRUE.
         GOTO 20
      ENDIF
C
C     IF THE CHAR. IS A PERIOD, THEN PROCESS ACCORDING TO VALUE OF
C     KIND. (0=NORMAL,1=HARVEST).
C
      IF (RECORD(IRPS:IRPS).EQ.'.') THEN
         IF (KIND.EQ.0) GOTO 20
         IF (LPERD) GOTO 20
         LPERD=.TRUE.
         LPDONE=.FALSE.
         GOTO 20
      ENDIF
C
C     ADD THE CHARACTER TO THE STRING.
C     IF A KIND IS 1 AND A PERIOD IS NEEDED, THEN THERE MUST BE 3
C     CHARS AVAILABLE.
C     IF A BLANK IS NEEDED, THEN  THERE MUST BE TWO CHARS AVAILABLE,
C     IF A BLANK NOR A PERIOD IS NEEDED, THEN ONE CHAR IS NEEDED.
C
      IF (LPERD .AND. .NOT.LPDONE) THEN
         LPDONE=.TRUE.
         LBKADD=.FALSE.
         IF (LENMEM+3.LE.MXLEN) THEN
            LENMEM=LENMEM+1
            MEM(LENMEM:LENMEM+1)='. '
            LENMEM=LENMEM+2
            MEM(LENMEM:LENMEM)=RECORD(IRPS:IRPS)
            GOTO 20
         ELSE
            KODE=1
            GOTO 310
         ENDIF
      ENDIF
      IF (LBKADD) THEN
         IF (LENMEM+2.LE.MXLEN) THEN
            LENMEM=LENMEM+1
            MEM(LENMEM:LENMEM)=' '
            LENMEM=LENMEM+1
            MEM(LENMEM:LENMEM)=RECORD(IRPS:IRPS)
            LBKADD=.FALSE.
         ELSE
            KODE=1
            GOTO 310
         ENDIF
      ELSE
         IF (LENMEM+1.LE.MXLEN) THEN
            LENMEM=LENMEM+1
            MEM(LENMEM:LENMEM)=RECORD(IRPS:IRPS)
         ELSE
            KODE=1
            GOTO 310
         ENDIF
      ENDIF
C
C     GET THE NEXT CHARACTER.
C
      GOTO 20
  200 CONTINUE
      KODE=2
  300 CONTINUE
      RETURN
C
C     STRING MEM IS OVER FULL. DROP RECORDS AS NECESSARY TO GET PAST 
C     ALL OF THE REMAINING RECORDS THAT DEFINE THE LABEL.
C
  310 CONTINUE
      I=ISTLNB(RECORD)
      IF (I.GT.0) THEN
         IF (RECORD(I:I).EQ.'&') THEN
            READ (IREAD,'(A)',END=200) RECORD
            IRECNT=IRECNT+1
            GOTO 310
         ENDIF
      ENDIF
      RETURN
      END
