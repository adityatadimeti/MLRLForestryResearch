      SUBROUTINE CFVOL(ISPC,D,H,D2H,VN,VM,VMAX,TKILL,LCONE,BARK,ITHT,
     1                 CTKFLG)
      IMPLICIT NONE
C----------
C CANADA-BC $Id$
C----------
C THIS ROUTINE CALCULATES TOTAL CUBIC FOOT VOLUME USING A NUMBER OF
C DIFFERENT METHODS.
C----------
COMMONS
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
C----------
C  DIMENSION STATEMENT FOR INTERNAL ARRAYS.
C----------
      LOGICAL TKILL,LCONE,CTKFLG
      INTEGER ISPC,ITHT,FIZ

      REAL D,H,D2H,VN,VM,VMAX,BARK,VOLT,VOLM
      REAL HTRUNC

      DATA FIZ /2/
C----------
C  INITIALIZE VOLUME ESTIMATES.
C----------
      VN=0.0
      VM=0.0
      VMAX=0.0
C----------
C  METHC=4 -- COMPUTE VOLUMES BASED ON KOZAK'S TAPER FUNCTIONS. IF HEIGHT IS LESS THAN
C             4.5 FT OR DBH IS LESS THAN MINIMUM, OR DBH IS LESS THAN TOP DIAMETER
C             THEN THE TREE IS COMPLETELY IGNORED IN MERCHANTABILITY CALCULATIONS. ALL
C             TREES ARE USED FOR TOTAL VOLUME CALCULATIONS.
C----------

        HTRUNC = FLOAT(ITHT)
        IF (HTRUNC .GT. 0.0) HTRUNC = HTRUNC / 100.0
        IF (HTRUNC .EQ. 0.0) HTRUNC = H
        IF (H .GE. 4.5) THEN
c
c         This needs to be updated to use Kozak's 2002 refit; also to calculate log
c         volumes by BEC zone; which the new LOG(...) subroutine uses.
c
          CALL MIN(ISPC,IAGE,FIZ,D,H,STMP(ISPC),TOPD(ISPC),
     +             HTRUNC,VOLT,VOLM)
          IF (D .GE. DBHMIN(ISPC) .AND. D .GE. TOPD(ISPC)) THEN
            VN = VOLT
            VM = VOLM
          ELSE
            VN = VOLT
            VM = 0.0
          ENDIF
        ENDIF
        RETURN
      
      RETURN
      END
