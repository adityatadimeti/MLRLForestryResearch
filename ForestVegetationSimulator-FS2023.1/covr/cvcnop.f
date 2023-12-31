      SUBROUTINE CVCNOP (LTHIN)
      IMPLICIT NONE
C----------
C COVR $Id$
C----------
C  **CVCNOP** CONTROLS THE CALLS TO THE CROWN WIDTH, CROWN SHAPE,
C  CROWN FOLIAGE BIOMASS, SUMMARY, AND CLASSIFICATION SUBPROGRAMS.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'CVCOM.F77'
C
COMMONS
C
      LOGICAL LTHIN,DEBUG
C----------
C  CHECK FOR DEBUG.
C----------
      CALL DBCHK(DEBUG,'CVCNOP',6,ICYC)
C
      IF (.NOT. LCOV) RETURN
C
      IF (LTHIN) LTHIND(ICYC) = .TRUE.
C----------
C  CALL **CVCW** TO COMPUTE CROWN WIDTH.
C----------
      IF (DEBUG) WRITE (JOSTND,9000) ICYC
 9000 FORMAT ('**CALLING CVCW, CYCLE =',I2)
      CALL CVCW (LTHIN)
C----------
C  CALL **CVSHAP** TO COMPUTE CROWN SHAPE.
C----------
      IF (.NOT.LCNOP) GO TO 10
      IF (DEBUG) WRITE (JOSTND,9001) ICYC
 9001 FORMAT ('**CALLING CVSHAP, CYCLE =',I2)
      CALL CVSHAP (LTHIN)
C----------
C  CALL **CVCBMS** TO COMPUTE CROWN BIOMASS.
C----------
      IF (DEBUG) WRITE (JOSTND,9002) ICYC
 9002 FORMAT ('**CALLING CVCBMS, CYCLE =',I2)
      CALL CVCBMS (LTHIN)
C----------
C  CALL **CVSUM** TO COMPUTE SUMS.
C----------
   10 CONTINUE
      IF (DEBUG) WRITE (JOSTND,9003) ICYC
 9003 FORMAT ('**CALLING CVSUM, CYCLE =',I2)
      CALL CVSUM (LTHIN)
C----------
C  CALL **CVCLAS** TO COMPUTE THE 'STAND SUCCESSIONAL STAGE' CODE.
C----------
      IF (.NOT.LBROW) RETURN
      IF (DEBUG) WRITE (JOSTND,9004) ICYC
 9004 FORMAT ('**CALLING CVCLAS, CYCLE =',I2)
      CALL CVCLAS(LTHIN)
      RETURN
      END
