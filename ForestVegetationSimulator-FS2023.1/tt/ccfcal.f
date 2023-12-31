      SUBROUTINE CCFCAL(ISPC,D,H,JCR,P,LTHIN,CCFT,CRWDTH,MODE)
      IMPLICIT NONE
C----------
C TT $Id$
C----------
C  THIS ROUTINE COMPUTES CROWN WIDTH AND CCF FOR INDIVIDUAL TREES.
C  CALLED FROM DENSE, REGENT, PRTRLS, SSTAGE, AND CVCW.
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
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
COMMONS
C----------
C  DIMENSION AND DATA STATEMENTS FOR INTERNAL VARIABLES.
C
C     CCF COEFFICIENTS FOR TREES THAT ARE GREATER THAN OR
C     EQUAL TO 1.0 IN. DBH:
C      RD1 -- CONSTANT TERM IN CROWN COMPETITION FACTOR EQUATION,
C             SUBSCRIPTED BY SPECIES
C      RD2 -- COEFFICIENT FOR SUM OF DIAMETERS TERM IN CROWN
C             COMPETITION FACTOR EQUATION,SUBSCRIPTED BY SPECIES
C      RD3 -- COEFFICIENT FOR SUM OF DIAMETER SQUARED TERM IN
C             CROWN COMPETITION EQUATION, SUBSCRIPTED BY SPECIES
C
C     CCF COEFFICIENTS FOR TREES THAT ARE LESS THAN 1.0 IN. DBH AND
C     GREATER THAN 0.10 IN. DBH:
C      RDA -- MULTIPLIER.
C      RDB -- EXPONENT.  CCF(I) = RDA*DBH**RDB
C
C
C SPECIES ORDER FOR TETONS VARIANT:
C
C  1=WB,  2=LM,  3=DF,  4=PM,  5=BS,  6=AS,  7=LP,  8=ES,  9=AF, 10=PP,
C 11=UJ, 12=RM, 13=BI, 14=MM, 15=NC, 16=MC, 17=OS, 18=OH
C
C VARIANT EXPANSION:
C BS USES ES EQUATIONS FROM TT
C PM USES PI (COMMON PINYON) EQUATIONS FROM UT
C PP USES PP EQUATIONS FROM CI
C UJ AND RM USE WJ (WESTERN JUNIPER) EQUATIONS FROM UT
C BI USES BM (BIGLEAF MAPLE) EQUATIONS FROM SO
C MM USES MM EQUATIONS FROM IE
C NC AND OH USE NC (NARROWLEAF COTTONWOOD) EQUATIONS FROM CR
C MC USES MC (CURL-LEAF MTN-MAHOGANY) EQUATIONS FROM SO
C OS USES OT (OTHER SP.) EQUATIONS FROM TT
C
C  SOURCES OF CCF COEFFICIENTS:
C     1 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE 
C     2 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE 
C     3 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: DOUGLAS-FIR
C     4 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE
C     5 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: ENGELMANN SPRUCE
C     6 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: WESTERN RED CEDAR
C     7 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE
C     8 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: ENGELMANN SPRUCE
C     9 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: SUBALPINE FIR
C    10 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: PONDEROSA PINE
C    11 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE
C    12 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE
C    13 = PAINE AND HANN TABLE 2: CALIFORNIA BLACK OAK
C    14 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: WESTERN RED CEDAR
C    15 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: WESTERN HEMLOCK
C    16 = PAINE AND HANN TABLE 2: CALIFORNIA BLACK OAK
C    17 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE 
C    18 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: WESTERN HEMLOCK
C
C      WYKOFF, CROOKSTON, STAGE, 1982. USER'S GUIDE TO THE STAND
C        PROGNOSIS MODEL. GEN TECH REP INT-133. OGDEN, UT:
C        INTERMOUNTAIN FOREST AND RANGE EXP STN. 112P.
C
C----------
      LOGICAL LTHIN
      REAL RD1(MAXSP),RD2(MAXSP),RD3(MAXSP),RDA(MAXSP),RDB(MAXSP)
      REAL CRWDTH,CCFT,P,H,D,BREAK
      INTEGER MODE,JCR,ISPC
      REAL RDANUW
      LOGICAL LDANUW
      INTEGER IDANUW
C----------
      DATA RD1 /
     & .01925, .01925,    .11, .01925,    .03,
     &    .03, .01925,    .03,    .03,    .03,
     & .01925, .01925,  .0204,    .03,    .03, 
     &  .0204, .01925,    .03/
      DATA RD2 /
     &  .0168,  .0168,  .0333, .01676,  .0173,
     &  .0238,  .0168,  .0173,  .0216,  .0180,
     & .01676, .01676,  .0246,  .0238,  .0215, 
     &  .0246,  .0168,  .0215/
      DATA RD3 /
     & .00365, .00365, .00259, .00365, .00259,
     & .00490, .00365, .00259, .00405, .00281,
     & .00365, .00365,  .0074, .00490, .00363, 
     &  .0074, .00365, .00363/
      DATA RDA/
     & 0.009187, 0.009187, 0.017299, 0.009187, 0.007875,
     & 0.008915, 0.009187, 0.007875, 0.011402, 0.007813,
     & 0.009187, 0.009187,      0.0, 0.008915, 0.011109, 
     &      0.0, 0.009187, 0.011109/
      DATA RDB/
     &   1.7600,   1.7600,   1.5571,   1.7600,   1.7360,
     &   1.7800,   1.7600,   1.7360,   1.7560,   1.7680,
     &   1.7600,   1.7600,      0.0,   1.7800,   1.7250, 
     &      0.0,   1.7600,   1.7250/
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = H
      IDANUW = JCR
      IDANUW = MODE
      LDANUW = LTHIN
C
C----------
C  INITIALIZE RETURN VARIABLES.
C----------
      CCFT = 0.
      CRWDTH = 0.
      SELECT CASE (ISPC)
      CASE(10,15,18)
        BREAK=10.0
      CASE DEFAULT
        BREAK=1.0
      END SELECT
C----------
C  COMPUTE CCF
C----------
      IF (D .GE. BREAK) THEN
        CCFT = RD1(ISPC) + D*RD2(ISPC) + D*D*RD3(ISPC)
      ELSEIF (D .GT. 0.1) THEN
        IF(ISPC.EQ.13 .OR. ISPC.EQ.16)THEN
          CCFT = D * (RD1(ISPC)+RD2(ISPC)+RD3(ISPC))
        ELSE
          CCFT = RDA(ISPC) * (D**RDB(ISPC))
        ENDIF
      ELSE
        IF(ISPC.EQ.13 .OR. ISPC.EQ.16)THEN
          CCFT = D * (RD1(ISPC)+RD2(ISPC)+RD3(ISPC))
        ELSEIF(ISPC.EQ.10)THEN
          CCFT = RDA(ISPC) * (D**RDB(ISPC))
        ELSE
          CCFT = 0.001
        ENDIF
      ENDIF
C----------
C  COMPUTE CROWN WIDTH
C----------
      CRWDTH = SQRT(CCFT/0.001803)
      IF(CRWDTH .GT. 99.9) CRWDTH=99.9
C
      CCFT = CCFT * P
C
      RETURN
      END
