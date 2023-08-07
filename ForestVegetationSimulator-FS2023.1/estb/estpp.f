      SUBROUTINE ESTPP (VAL,TPP)
      IMPLICIT NONE
C----------
C ESTB $Id$
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'ESCOM2.F77'
C
C
COMMONS
C
C
      REAL TPP,VAL,BB,CC
C
C     CALCULATION OF TREES PER STOCKED PLOT.
C
      BB= 0.697061 +.715825*XCOS -.203452*XSIN -2.762848*SLO
     &    +.041235*REGT +.031435*BWAF
      IF(IHAB.GT.4.AND.IHAB.LT.9) BB=BB+.294473
      IF(IHAB.EQ.9.OR.IHAB.EQ.10) BB=BB+1.237000
      IF(IHAB.GT.10) BB=BB+.465788
      BB=EXP(BB)
C
      CC= 0.6836
C
      TPP= ((-(ALOG(1.0-VAL)))**(1.0/CC)) *BB   +0.9
      RETURN
      END
