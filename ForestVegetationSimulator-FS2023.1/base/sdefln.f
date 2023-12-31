      SUBROUTINE SDEFLN (LNOTBK,ARRAY,KEYWRD,B0,B1,KARD,IS)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
COMMONS
C
C     PROCESSES BFFDLN OR MCFDLN KEYWORDS - CALLED FROM INITRE.
C     NL CROOKSTON - INT. MOSCOW - 4/80.
C
      LOGICAL LNOTBK(7)
      CHARACTER*8 KEYWRD
      CHARACTER*10 KARD(7)
      REAL ARRAY(7),B0(MAXSP),B1(MAXSP)
      INTEGER IS,IGRP,IULIM,IG,IGSP,ILEN,I,JS
C
C     SPECIES CODE PROCESSING.
C
      CALL SPDECD (1,IS,NSP(1,1),JOSTND,IRECNT,KEYWRD,
     &             ARRAY,KARD)
      IF(IS.EQ.-999)RETURN
C
      WRITE (JOSTND,20) KEYWRD
   20 FORMAT (/1X,A8,'   COEFFICIENTS FOR LOG-LINEAR FORM AND',
     >        ' DEFECT CORRECTION EQUATION')
C----------
C     IF (IS<0) CHANGE ALL SPECIES IN THE GROUP
C----------
      IF(IS .LT. 0) THEN
        IGRP = -IS
        IULIM = ISPGRP(IGRP,1)+1
        DO 25 IG=2,IULIM
        IGSP = ISPGRP(IGRP,IG)
        IF (LNOTBK(2)) B0(IGSP)=ARRAY(2)
        IF (LNOTBK(3)) B1(IGSP)=ARRAY(3)
 25     CONTINUE
        ILEN=ISPGRP(-IS,92)
        WRITE (JOSTND,30) KARD(1)(1:ILEN),IS,B0(IGSP),B1(IGSP)
C----------
C     IF (IS=0) ALL SPECIES WILL BE CHANGED IN FOLLOWING CODE:
C----------
      ELSEIF(IS .EQ. 0) THEN
        DO 60 IS=1,MAXSP
        IF (LNOTBK(2)) B0(IS)=ARRAY(2)
        IF (LNOTBK(3)) B1(IS)=ARRAY(3)
   60   CONTINUE
        WRITE (JOSTND,70)
   70   FORMAT (T13,'FOR ALL SPECIES THE FOLLOWING COEFFICIENTS HAVE ',
     >        'BEEN SPECIFIED:')
        DO 100 I=2,3
        JS=I-2
        IF (LNOTBK(I)) WRITE (JOSTND,80) JS,ARRAY(I)
   80   FORMAT (T23,'B',I1,'= ',F8.5)
  100   CONTINUE
C----------
C     SPECIES CODE IS SPECIFIED (IS>0).
C----------
      ELSE
        IF (LNOTBK(2)) B0(IS)=ARRAY(2)
        IF (LNOTBK(3)) B1(IS)=ARRAY(3)
        WRITE (JOSTND,30) KARD(1)(1:3),IS,B0(IS),B1(IS)
   30   FORMAT (T13,'SPECIES= ',A,' (CODE= ',I2,'); B0=',F8.5,'; B1=',
     &  F8.5)
      ENDIF
C
      RETURN
      END
