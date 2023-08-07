      SUBROUTINE DUBSCR(D,CR)
      IMPLICIT NONE
C----------
C SN $Id$
C----------
C  THIS SUBROUTINE CALCULATES CROWN RATIOS FOR CYCLE 0.0
C  DEAD TREES
C----------
COMMONS
C
C
C      INCLUDE 'PRGPRM.F77'
C
C
C      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C      EXTERNAL RANN
C----------
C  EXPECTED CROWN RATIO IS A FUNCTION OF, DBH,
C  AND RETURNS A VALUE BETWEEN 0.30 ZERO AND 0.70
C
      REAL CR,D
C----------
      IF (D .LE. 24.) THEN
      CR= 0.70-0.40/24.*D
      ELSE
      CR= 0.30
      ENDIF
C----------
C  RANDOM COMPONENT NOT CURRENTLY IMPLEMENTED
C
C  A RANDOM ERROR IS ASSIGNED TO THE CROWN RATIO PREDICTION
C  PRIOR TO THE LOGISTIC TRANSFORMATION.  LINEAR REGRESSION
C  WAS USED TO FIT THE MODEL AND THE ELEMENTS OF CRSD ARE THE
C  STANDARD ERRORS FOR THE LINEARIZED MODEL BY SPECIES.
C----------
C      SD=CRSD(ISPC)
C   10 CONTINUE
C      FCR=0.0
C      IF (DGSD.GE.1.0) FCR=BACHLO(0.0,SD,RANN)
C      IF(ABS(FCR).GT.SD) GO TO 10
C      CR=1.0/(1.0 + EXP(CR+FCR))
C
      IF(CR.LT.0.05) CR=0.05
      IF(CR.GT.0.95) CR=0.95
      RETURN
      END
