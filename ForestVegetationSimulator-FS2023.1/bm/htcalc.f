      SUBROUTINE HTCALC (SINDX,ISPC,AG,HGUESS,JOSTND,DEBUG)
      IMPLICIT NONE
C----------
C BM $Id$
C----------
C THIS ROUTINE CALCULATES A POTENTIAL HT GIVEN AN SPECIES SITE AND AGE
C IT IS USED TO CAL POTHTG AND SITE
C----------
C  VARIABLE DECLARATIONS:
C----------
C
      LOGICAL DEBUG
C
      INTEGER ISPC,JOSTND
C
      REAL AG,HGUESS,SINDX,X2,X3
C
C----------
C  SPECIES ORDER:
C   1=WP,  2=WL,  3=DF,  4=GF,  5=MH,  6=WJ,  7=LP,  8=ES,
C   9=AF, 10=PP, 11=WB, 12=LM, 13=PY, 14=YC, 15=AS, 16=CW,
C  17=OS, 18=OH
C----------
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
      IF(DEBUG) WRITE(JOSTND,10)
   10 FORMAT(' ENTERING HTCALC')
      IF(DEBUG)WRITE(JOSTND,30)ISPC,AG,SINDX
   30 FORMAT(' IN HTCALC 30F ISPC,AG,SINDX= ',I4,2F13.8)
C----------
C GO TO A DIFFERENT POTENTIAL HEIGHT CURVE DEPENDING ON THE SPECIES
C----------
C
      SELECT CASE (ISPC)
C
C----------
C WESTERN WHITE PINE USE BRICKELL EQUATIONS
C----------
      CASE (1)
        HGUESS=SINDX/(0.37504453*(1.0-0.92503*
     &         EXP(-0.0207959*AG))**(-2.4881068))
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WP HGUESS= ',HGUESS
C----------
C WESTERN LARCH USE COCHRAN PNW 424
C----------
      CASE (2)
        HGUESS=4.5 + 1.46897*AG + 0.0092466*AG*AG - 0.00023957*AG**3 +
     &         1.1122E-6*AG**4 + (SINDX -4.5)*(-0.12528 + 0.039636*AG
     &         - 0.0004278*AG*AG + 1.7039E-6*AG**3) -
     &         73.57*(-0.12528 + 0.039636*AG - 0.0004278*AG*AG 
     &         + 1.7039E-6*AG**3)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WL HGUESS= ',HGUESS
C----------
C DOUGLAS-FIR USE COCHRAN PNW 251. THIS EQUATION ALSO USED FOR MISC. SPP
C----------
      CASE (3)
        HGUESS=4.5 + EXP(-0.37496 + 1.36164*ALOG(AG) 
     &         - 0.00243434*(ALOG(AG))**4)
     &         - 79.97*(-0.2828 + 1.87947*
     &         (1.0 - EXP(-0.022399*AG))**0.966998) + (SINDX - 4.5)*
     &         (-0.2828 + 1.87947*(1.0 - EXP(-0.022399*AG)**0.966998))
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC DF HGUESS= ',HGUESS
C----------
C GRAND FIR USE COCHRAN PNW 252
C----------
      CASE (4)
        X2= -0.30935 + 1.2383*ALOG(AG) + 0.001762*(ALOG(AG))**4
     &      - 5.4E-6*(ALOG(AG))**9 + 2.046E-7*(ALOG(AG))**11
     &      - 4.04E-13*(ALOG(AG))**18
        X3= -6.2056 + 2.097*ALOG(AG) - 0.09411*(ALOG(AG))**2
     &      - 0.00004382*(ALOG(AG))**7 + 2.007E-11*(ALOG(AG))**16
     &      - 2.054E-17*(ALOG(AG))**24
        HGUESS=EXP(X2) - 84.73*EXP(X3) + (SINDX - 4.5)*EXP(X3)
     &         + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC GF HGUESS= ',HGUESS
C----------
C MTN HEMLOCK USE INTERIM MEANS PUB
C----------
      CASE (5)
        HGUESS=(22.8741 + 0.950234*SINDX)*(1.0 - 
     &         EXP(-0.00206465*SQRT(SINDX)*AG))
     &         **(1.365566 + 2.045963/SINDX)
        HGUESS=(HGUESS + 1.37)*3.281
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC MH HGUESS= ',HGUESS
C----------
C WESTERN JUNIPER
C----------
      CASE(6)
        HGUESS = 0.
C----------
C LODGEPOLE PINE USE DAHMS PNW 8
C----------
      CASE(7)
        HGUESS = SINDX*(-0.0968 + 0.02679*AG - 0.00009309*AG*AG)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC LP HGUESS= ',HGUESS
C----------
C ENGLEMANN SPRUCE USE ALEXANDER
C----------
      CASE(8)
        HGUESS=4.5+((2.75780*SINDX**0.83312)*
     &         (1.0-EXP(-0.015701*AG))**(22.71944*SINDX**(-0.63557)))
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC ES HGUESS= ',HGUESS
C----------
C SUBALPINE FIR USE JOHNSON'S EQUIV OF DEMARS
C----------
      CASE(9)
        HGUESS=SINDX*(-0.07831 + 0.0149*AG - 4.0818E-5*AG*AG)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC AF HGUESS= ',HGUESS
C----------
C PONDEROSA PINE AND OTHER SOFTWOODS USE BARRETT
C----------
      CASE(10,17)
        HGUESS=( 128.8952205*(1.0 -EXP(-0.016959*AG))**1.23114)
     &         - ((-0.7864 + 2.49717*(1.0-EXP(-0.0045042*AG))**0.33022)*
     &         100.43) + ((-0.7864 + 2.49717*(1.0 - EXP(-0.0045042*AG))
     &         **0.33022)*(SINDX-4.5))+ 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC PP/OS HGUESS= ',HGUESS
C----------
C   WHITEBARK PINE (11)
C   LIMBER PINE (12)
C   QUAKING ASPEN (15)
C----------
      CASE(11,12,15)
        HGUESS = 0.
C----------
C  MISC SPECIES FROM THE WC VARIANT - USE CURTIS, FOR. SCI. 20:307-316.  
C  CURTIS'S CURVES ARE PRESENTED IN METRIC (3.2808 ?). 
C  BECAUSE OF EXCESSIVE HT GROWTH -- APPROX 30-40 FT/CYCLE, TOOK OUT 
C  THE METRIC MULTIPLIER DIXON 11-05-92
C    PACIFIC YEW (13)
C    ALASKA CEDAR (14)
C    BLACK COTTONWOOD (16)
C    OTHER HARDWOODS (18)
C----------
      CASE(13,14,16,18)
        HGUESS = (SINDX - 4.5) / (0.6192 - 5.3394/(SINDX-4.5)
     &         + 240.29*AG**(-1.4) +(3368.9/(SINDX-4.5))*AG**(-1.4))
        HGUESS = HGUESS + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC PY/YC/BC/OH HGUESS= ',HGUESS
C----------
C  FUTURE SPECIES
C----------
      CASE DEFAULT
        HGUESS = 0.
C
      END SELECT
C
      RETURN
      END
