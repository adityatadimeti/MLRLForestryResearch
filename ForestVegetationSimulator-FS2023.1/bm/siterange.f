      SUBROUTINE SITERANGE(IWHO,IS,SILOW,SIHIGH)
      IMPLICIT NONE
C----------
C BM $Id$
C----------
C
C SUBROUTINE TO RETURN THE SITE INDEX RANGE FOR A SPECIES.
C
C THIS SUBROUTINE IS CALLED FROM **HTGF**,**REGENT**, AND **SITSET**.  
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
COMMONS
C
C----------
C  VARIABLE DEFINITIONS:
C----------
C      IS -- FVS SPECIES INDEX NUMBER
C    IWHO -- 1 IF CALLED FROM SUBROUTINE **SITSET**
C            2 IF CALLED FROM SUBROUTINE **REGENT**
C            3 IF CALLED FROM SUBROUTINE **HTGF**
C  SITEHI -- UPPER SITE INDEX VALUES 
C  SITELO -- LOWER SITE INDEX VALUES 
C----------
C  VARIABLE DECLARATIONS:
C----------
C
      INTEGER IS,IWHO
C
      REAL SIHIGH,SILOW
C
      REAL SITEHI(MAXSP),SITELO(MAXSP)
C
C----------
C  DATA STATEMENTS
C
C  SPECIES ORDER:
C   1=WP,  2=WL,  3=DF,  4=GF,  5=MH,  6=WJ,  7=LP,  8=ES,
C   9=AF, 10=PP, 11=WB, 12=LM, 13=PY, 14=YC, 15=AS, 16=CW,
C  17=OS, 18=OH
C
C  SPECIES EXPANSION:
C  WJ USES SO JU (ORIGINALLY FROM UT VARIANT; REALLY PP FROM CR VARIANT)
C  WB USES SO WB (ORIGINALLY FROM TT VARIANT)
C  LM USES UT LM
C  PY USES SO PY (ORIGINALLY FROM WC VARIANT)
C  YC USES WC YC
C  AS USES SO AS (ORIGINALLY FROM UT VARIANT)
C  CW USES SO CW (ORIGINALLY FROM WC VARIANT)
C  OS USES BM PP BARK COEFFICIENT
C  OH USES SO OH (ORIGINALLY FROM WC VARIANT)
C----------
C  THESE VALUES SHOULD BE BASED ON THE BASE-AGE OF THE SITE CURVE
C  BEING USED FOR THAT SPECIES.
C----------
      DATA SITELO/
     &  20.,  50.,  50.,  50.,  15.,   5.,  30.,  40.,  50.,  70.,
     &  20.,  20.,   5.,  50.,  30.,  10.,  70.,   5./
C
      DATA SITEHI/
     &  80., 110., 110., 110.,  30.,  40.,  70., 120., 150., 140.,
     &  65.,  50.,  75., 110.,  66., 191., 140., 125./
C----------
      SELECT CASE (IWHO)
C
C  CALLED FROM SUBROUTINES **SITSET** AND **REGENT**
C
        CASE (1,2,3)
          SILOW = SITELO(IS)
          SIHIGH = SITEHI(IS)
C
C  SPACE FOR ADDITIONAL CALLS
C
        CASE DEFAULT
          SILOW = 0.
          SIHIGH = 999.
C
      END SELECT
C
      RETURN
      END
