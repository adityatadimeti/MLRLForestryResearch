      SUBROUTINE ESTOCK (ELEV,IFT,XBA,XTPA,PN,DEBUG)
      IMPLICIT NONE
C----------
C AK $Id$
C----------
C     CALCULATES PROBABILITY OF STOCKING FOR REGENERATION MODEL.
C     COEFFICIENTS FOR PLANTING ARE NOT INCLUDED IN EQUATIONS.
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
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
C----------
C  VARIABLE DEFINITIONS:
C----------
C
C  IFT      -- STAND FOREST TYPE CATEGORY WHERE:
C                1 = 122
C                2 = 125
C                3 = 270
C                4 = 271
C                5 = 281
C                6 = 301
C                7 = 304
C                8 = 305
C                9 = 703
C               10 = 901
C               11 = 902
C               12 = 904 (MAPPED TO 703)
C               13 = 911
C               14 = OTHER (MAPPED TO 122)
C  XBA      -- PLOT BASAL AREA PER ACRE >= REGNBK
C  XPTA     -- PLOT TREES PER ACRE >= REGNBK
C  XQMD     -- PLOT LEVEL QMD >= REGNBK
C  SLO      -- PLOT SLOPE AS PROPORTION (ESCOMN.F77)
C  ELEV     -- STAND ELEVATION (100S OF FEET)
C  ELEVSQ   -- STAND ELEVATION (100S OF FEET) SQUARED (ESCOMN.F77)
C  XCOS     -- COSINE(ASPECT IN RADIANS) * SLOPE (ESCOMN.F77)
C  PNFT     -- FOREST TYPE COEFFICIENT (B1)
C  PNSBA    -- BASAL AREA COEFFICIENT (B2)
C  PNQMD    -- QMD COEFFICIENT (B3)
C  PNSLO    -- SLOPE COEFFICIENT (B4)
C  PNEVEL   -- ELEVATION COEFFICIENT (B5)
C  PNELEVSQ -- ELEVATION SQUARED COEFFICIENT (B6)
C  PNXCOS   -- COS(ASPECT)*SLOPE COEFFICIENT (B7)
C  PNBAQMD  -- BASAL AREA AND QMD INTERACTION COEFFICIENT (B8)
C  PN       -- USED IN DETERMINING PROBABILITY OF STOCKING
C----------
C  VARIABLE DECLARATIONS:
C----------  
      REAL PNFT(14),PNELEV(14),PNXCOS(14)
      REAL PNSLO,PNELEVSQ,PNSBA,PNQMD,PNBAQMD
      REAL B1,B2,B3,B4,B5,B6,B7,B8,PN
      REAL ELEV,ADJSLO,ADJXC,XBA,XTPA,XQMD
      INTEGER IFT
      LOGICAL DEBUG

      DATA PNFT /
     & 1.428325, 3.401549, 1.906730, 3.481250, 3.172262,
     & 2.816007, 4.073819, 1.255094, 0.357560, 2.756703,
     & 1.471673, 1.428325, 1.554008, 1.428325 /

      DATA PNSBA / -0.00212/

      DATA PNQMD / -0.194748/

      DATA PNSLO / -0.002364/

      DATA PNELEV / 
     &  0.022431, -0.045237, 0.036110, 0.006615, 0.017794,
     &  0.072023,  0.012058, 0.066790, 0.135631, 0.012600,
     &  0.032712,  0.022431, 0.037521, 0.022431/

      DATA PNELEVSQ / -0.000742 /

      DATA PNXCOS / 
     &  0.006748,  0.000011,  0.000738, -0.000432,  -0.000715,
     & -0.002044,  0.000694, -0.003398, -0.013222,   0.003788,
     & -0.009518,  0.006748, -0.001041,  0.006748/

      DATA PNBAQMD / 0.000316 /
C      
C      SET COEFFICIENTS FOR COMPUTING PN           
C      LP,YC,RC FOREST TYPES: USE WESTERN HEMLOCK FOREST TYPE 
C      COEFFICIENTS.
C
C      B1 = PNFT(IFT)
C      B2 = PNBA
C      B3 = PNQMD
C      B4 = PNSLO
C      B5 = PNELEV
C      B6 = PNELEVSQ
C      B7 = PNXCOS
C      B8 = PNBAQMD

C     SET COEFFICIENTS FOR COMPUTING PN           
      B1 = PNFT(IFT)
      B2 = PNSBA
      B3 = PNQMD
      B4 = PNSLO
      B5 = PNELEV(IFT)
      B6 = PNELEVSQ
      B7 = PNXCOS(IFT)
      B8 = PNBAQMD

C     CALCULATE PLOT QMD FROM PLOT BA AND TPA
      IF(XTPA .GT. 0.0) THEN
        XQMD = SQRT((XBA/XTPA)/0.005454)
      ELSE
        XQMD = 0.0
      ENDIF

C     ADJUST PLOT SLO-BASED VARIABLES TO PERCENT SLOPE.  
      ADJSLO = SLO*100
      ADJXC  = XCOS*100

C----------
C  PREDICT STOCKING PROBABILITY
C
C  PN = B1 + B2 * XBA + B3 * XQMD + B4 * ADJSLO + B5 * ELEV +
C  B6 * ELEVSQ + B7 * ADJXC + B8 * XQMD*XBA
C
C  VARIABLES DEFINED IN SECTION ABOVE
C  PN IS CONVERTED TO PROBABILITY OF STOCKING IN ESTAB.F BY
C  EXP(PN)/(1 + EXP(PN))
C----------

C     PREDICT STOCKING PROBABILITY      
      PN = B1 + B2 * XBA + B3 * XQMD + B4 * ADJSLO + B5 * ELEV + 
     &    B6 * ELEVSQ + B7 * ADJXC + B8 * XBA * XQMD

      IF(DEBUG)WRITE(JOSTND,*)'IN ESTOCK CHECKING VALUES',' XBA=',
     & XBA,' XTPA=',XTPA,' XQMD=',XQMD,' ADJSLO=',ADJSLO,' ELEV=',ELEV,
     & ' ELEVSQ=',ELEVSQ,' ADJXC=',ADJXC,' PN=',PN
C
      RETURN
      END
