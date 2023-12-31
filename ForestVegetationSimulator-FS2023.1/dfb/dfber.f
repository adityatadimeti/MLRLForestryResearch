      SUBROUTINE DFBER (NOER)
      IMPLICIT NONE
C----------
C DFB $Id$
C----------
C
C  TESTS TO MAKE SURE MINIMUM CONDITIONS ARE MET FOR AN OUTBREAK TO
C  OCCUR.  CALCULATES BASAL AREA FOR DOUGLAS-FIR.
C
C  CALLED BY :
C     DFBGO  [DFB]
C
C  CALLS :
C     NONE
C
C  PARAMETERS :
C     NOER   - SET TO .TRUE. WHEN MINIMUM CONDITIONS MET FOR AN
C              OUTBREAK.
C
C  LOCAL VARIABLES :
C     BADF   - BASAL AREA FOR EACH DOUGLAS-FIR RECORD.
C     D      - DBH FOR TREE RECORD (SET TO DBH(TREE #)).
C     I      - INDEX FOR TREE RECORD (SET TO IND1(TREE PTR)).
C     II     - COUNTER INDEX.
C     I1,I2  - INDEXES FOR THE ARRAY IND1.  I1 IS THE STARTING
C              INDEX FOR A SPECIES IN ARRAY IND1 (DF = IDFSPC).
C              I2 IS THE ENDING INDEX FOR A SPECIES IN ARRAY IND1
C              (DF = IDFSPC).
C     P      - PROB FOR TREE RECORD (SET TO PROB(TREE #)).
C     TDF45  - NUMBER OF DOUGLAS-FIR (TREES/ACRE) THAT HAVE A DBH >= 4.5
C              INCHES.
C     BADF45 - BASAL AREA FOR ALL DOUGLAS-FIR TREES WITH DBH >= 4.5
C              INCHES.
C
C  COMMON BLOCK VARIABLES USED :
C     A45DBH - (DFBCOM)  OUTPUT
C     BA     - (PLOT)    INPUT
C     BA9    - (DFBCOM)  OUTPUT
C     BADF9  - (DFBCOM)  OUTPUT
C     DBH    - (ARRAYS)  INPUT
C     DEBUIN - (DFBCOM)  INPUT
C     IDFSPC - (DFBCOM)  INPUT
C     IND1   - (ARRAYS)  INPUT
C     ISCT   - (CONTRL)  INPUT
C     ITRN   - (CONTRL)  INPUT
C     JODFB  - (DFBCOM)  INPUT
C     PBADF4 - (DFBCOM)  OUTPUT
C     PROB   - (ARRAYS)  INPUT
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
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'DFBCOM.F77'
C
C
COMMONS
C
      LOGICAL NOER

      INTEGER I, II, I1, I2

      REAL BADF, BADF45, TDF45, D, P

      IF (DEBUIN) WRITE (JODFB,*) ' ** ENTERING SUBROUTINE DFBER'

C.... INITIALIZE VARIABLES.

      NOER   = .TRUE.
      BADF45 = 0.0
      BADF9  = 0.0
      A45DBH = 0.0
      TDF45  = 0.0
      PBADF4 = 0.0
      BA9    = 0.0

C.... CALCULATE THE BASAL AREA FOR ALL TREES IN THE STAND WITH A DBH
C.... GREATER THEN OR EQUAL TO 9.0 INCHES.

      DO 100 II = 1,ITRN
         IF (DBH(II) .GE. 9.0) THEN
            BA9 = BA9 + 0.005454154 * DBH(II) * DBH(II) * PROB(II)
         ENDIF
  100 CONTINUE

C.... CALCULATE THE BASAL AREA, AVERAGE DBH VALUES, AND TREES/ACRE FOR
C.... DIFFERENT SIZE GROUPS IN DOUGLAS-FIR.

      I1 = ISCT(IDFSPC,1)
      IF (I1 .EQ. 0) GOTO 300
      I2 = ISCT(IDFSPC,2)

      DO 200 II = I1, I2
         I = IND1(II)
         P = PROB(I)
         D = DBH(I)
         BADF =  0.005454154 * D * D * P

         IF (D .GE. 4.5) THEN
            TDF45 = TDF45 + P
            A45DBH = A45DBH + D * P
            BADF45 = BADF45 + BADF
         ENDIF

         IF (D .GE. 9.0) THEN
            BADF9 = BADF9 + BADF
         ENDIF
  200 CONTINUE

C.... NOT ENOUGH DF FOR OUTBREAK TO OCCUR.  GO TO THE END.

      IF (TDF45 .LT. 1.0) GOTO 300

C.... PROPORTION BASAL AREA IN DF GREATER THEN 4.5 INCHES

      PBADF4 = BADF45 / BA

C.... AVERAGE DBH FOR DOUGLAS-FIR TREES WITH A DBH >= 4.5 INCHES.

      A45DBH = A45DBH  / TDF45
      GOTO 400

  300 CONTINUE

C.... SET FLAG TO SAY NO OUTBREAK WILL OCCUR.

      NOER = .FALSE.

  400 CONTINUE
      IF (DEBUIN) WRITE (JODFB,*) ' ** LEAVING SUBROUTINE DFBER'

      RETURN
      END
