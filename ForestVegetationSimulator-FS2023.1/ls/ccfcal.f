      SUBROUTINE CCFCAL(ISPC,D,H,JCR,P,LTHIN,CCFT,CRWDTH,MODE)
      IMPLICIT NONE
C----------
C LS $Id$
C----------
C  THIS ROUTINE COMPUTES CROWN WIDTH AND CCF FOR INDIVIDUAL TREES.
C  CALLED FROM DENSE, PRTRLS, SSTAGE, AND CVCW.
C
C  ARGUMENT DEFINITIONS:
C    ISPC = NUMERIC SPECIES CODE
C       D = DIAMETER AT BREAST HEIGHT
C       H = TOTAL TREE HEIGHT
C     JCR = CROWN RATIO IN PERCENT (0-100)
C       P = TREES PER ACRE
C   LTHIN = .TRUE. IF THINNING HAS JUST OCCURRED
C         = .FALSE. OTHERWISE
C    CCFT = CCF REPRESENTED BY THIS TREE
C  CRWDTH = CROWN WIDTH OF THIS TREE
C    MODE = 1 IF ONLY NEED CCF RETURNED
C           2 IF ONLY NEED CRWDTH RETURNED
C
C  CROWN WIDTH EQUATIONS FOR REGIONS 8 & 9:  SEE DOCUMENTATION IN
C  SUBROUTINE **CWCALC**.
C
C     CONVERTING CROWN WIDTH TO CCF:
C     THE CONSTANT 0.001803 CAN BE USED TO CONVERT CROWN WIDTH
C     IN FEET TO THE PERCENT OF AN ACRE COVERED BY THE CROWN
C     CCF = (PIE * (CRWDTH/2)**2 / 43560) * 100
C     CCF = 0.001803 * CRWDTH**2
C----------
      LOGICAL LTHIN
      INTEGER MODE,ISPC,IWHO,IICR,JOSTND,JCR
      REAL CRWDTH,CCFT,P,H,D,TEMCW,CR
      REAL RDANUW
      LOGICAL LDANUW
      INTEGER IDANUW
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = CRWDTH
      IDANUW = JCR
      IDANUW = MODE
      LDANUW = LTHIN
C----------
C  INITIALIZE RETURN VARIABLES.
C----------
      CCFT = 0.
C----------
C CALL CWCALC TO GET CROWN WIDTH
C----------
      TEMCW=0.
      CR=90.
      IWHO=1
      CALL CWCALC(ISPC,P,D,H,CR,IICR,TEMCW,IWHO,JOSTND)
C----------
C  COMPUTE CCF
C----------
      IF(D .GT. 0.1) THEN
        CCFT = 0.001803 * TEMCW**2.
      ELSE
        CCFT=0.001
      ENDIF
        CCFT = CCFT * P
      RETURN
      END
