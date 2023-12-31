      SUBROUTINE HTCALC(SINDX,ISPC,AG,HGUESS,JOSTND,DEBUG)
      IMPLICIT NONE
C----------
C NC $Id$
C----------
C THIS ROUTINE CALCULATES A POTENTIAL HT GIVEN AN SPECIES SITE AND AGE
C IT IS USED TO CAL POTHTG AND SITE
C----------
      LOGICAL DEBUG
      INTEGER ISPC,JOSTND
      REAL HGUESS,AG,SINDX,Z,A,B,C,X1,X2
C----------
      IF(DEBUG)WRITE(JOSTND,15)ISPC,AG,SINDX
   15 FORMAT(' ENTERING HTCALC ISPC,AG,SINDX= ',I5,2F10.4)
C----------
C GO TO A DIFFERENT POTENTIAL HEIGHT CURVE DEPENDING ON THE SPECIES
C----------
      SELECT CASE (ISPC)
C----------
C DOUGLAS FIR USE KING
C OTHER SOFTWOODS USE DOUGLAS-FIR
C SPECIES: OS, DF, RW
C POTENTIAL HEIGHT GROWTH IS CALCULATED FOR RW
C BUT NOT USED.
C----------
      CASE(1,3,12)
        Z = 2500.0/(SINDX - 4.5)
        A = -0.954038 + 0.109757*Z
        B = 0.055818 + 0.0079224*Z
        C = -0.0007338 + 0.0001977*Z
        HGUESS = ((AG*AG)/(A + B*AG + C*AG*AG)) + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC DF/OS Z,A,B,C,HGUESS= ',
     &  Z,A,B,C,HGUESS   
C----------
C WHITE FIR USE DOLPH
C INCENSE CEDAR USE WF
C RED FIR USE WF
C SPECIES: WF, IC, RF
C----------
      CASE(4,6,9)
        X1 = (38.0202*AG**(-1.05213)*EXP(0.009557*AG))
        X2 = 101.842894*(1.0 - EXP(-0.001442*AG**1.679259))
        HGUESS = (SINDX - 69.91 + X1*X2)/X1 + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WF/IC/RF X1,X2,HGUESS= ',
     &  X1,X2,HGUESS
C----------
C MADRONE USE PORTER AND WIANT
C SPECIES: MA
C----------
      CASE(5)
        HGUESS=SINDX/(0.375 + 31.233/AG)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC MA HGUESS= ',HGUESS
C----------
C BLACK OAK   POWERS
C SCALE FACTOR ADDED SO THAT TREES WOULD HIT SITE HEIGHT
C SPECIES: BO
C----------
      CASE(7)
        A = SQRT(AG) - SQRT(50.0)
        HGUESS = SINDX*(1.0+0.322*(A))-6.413*A
        HGUESS = HGUESS*.80
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC BO A,HGUESS= ',A,HGUESS
C----------
C TANOAK USE WIANT
C SCALE FACTOR ADDED SO THAT TREES WOULD HIT SITE HEIGHT
C MISC SPECIES USE TANOAK
C SPECIES: TO, OH
C----------
      CASE(8,11)
        HGUESS = SINDX /(0.204 + 39.787/AG)
        HGUESS = HGUESS*0.85
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC TO/OH HGUESS= ',HGUESS
C----------
C PONDEROSA PINE USE POWERS AND OLIVER
C SUGAR PINE USE POWERS  PONDEROSA PINE
C SPECIES: SP, PP
C----------
      CASE(2,10)
        HGUESS = (1.88*SINDX - 7.178) * (1.0-EXP(-0.025*AG))**
     &           (0.001*SINDX+1.64)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC SP/PP HGUESS= ',HGUESS
C----------
C  FUTURE SPECIES
C----------
      CASE DEFAULT
        HGUESS = 0.
C
      END SELECT
C
      IF(DEBUG)WRITE(JOSTND,*)' LEAVING HTCALC HGUESS= ',HGUESS
C
      RETURN
      END
