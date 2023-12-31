      SUBROUTINE DUBSCR(ISPC,D,H,CR,TPCT,TPCCF)
      IMPLICIT NONE
C----------
C SO $Id$
C----------
C  THIS SUBROUTINE CALCULATES CROWN RATIOS FOR TREES INSERTED BY
C  THE REGENERATION ESTABLISHMENT MODEL.  IT ALSO DUBS CROWN RATIOS
C  FOR TREES IN THE INVENTORY THAT ARE MISSING CROWN RATIO
C  MEASUREMENTS AND ARE LESS THAN 5.0 INCHES DBH.  FINALLY, IT IS
C  USED TO REPLACE CROWN RATIO ESTIMATES FOR ALL TREES THAT
C  CROSS THE THRESHOLD BETWEEN THE SMALL AND LARGE TREE MODELS.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
COMMONS
C
      EXTERNAL RANN
      LOGICAL DEBUG
      INTEGER ISPC
      REAL D,H,CR,TPCT,TPCCF,BACHLO,FCR,SD
      REAL BCR0(MAXSP),BCR1(MAXSP),BCR2(MAXSP),BCR3(MAXSP),
     & CRSD(MAXSP),BCR5(MAXSP),BCR6(MAXSP),
     & BCR8(MAXSP),BCR9(MAXSP),BCR10(MAXSP)
      REAL RDANUW
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = TPCT
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'DUBSCR',6,ICYC)
       IF(DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE DUBSCR  CYCLE =',I5)
C----------
C  SPECIES ORDER:
C  1=WP,  2=SP,  3=DF,  4=WF,  5=MH,  6=IC,  7=LP,  8=ES,  9=SH,  10=PP,
C 11=JU, 12=GF, 13=AF, 14=SF, 15=NF, 16=WB, 17=WL, 18=RC, 19=WH,  20=PY,
C 21=WA, 22=RA, 23=BM, 24=AS, 25=CW, 26=CH, 27=WO, 28=WI, 29=GC,  30=MC,
C 31=MB, 32=OS, 33=OH
C----------
      DATA BCR2/
     &   .000000,   .000000,   .022409,   .022409,   .022409,
     &   .022409,   .000000,   .022409,  0.007198,   .000000,
     &   .000000,   .022409,   .022409,   .022409,  0.007198,
     &   .000000,   .000000,   .022409, -0.015637, -0.029815,
     &   .000000,   .000000,   .000000,   .022409,   .000000,
     &   .000000, -0.029815,   .000000,   .000000,   .000000,
     &   .000000,   .022409,   .000000/
C
      DATA BCR1/
     &  -.209765,  -.209765,  -.093105,  -.093105,  -.093105,
     &  -.093105,  -.209765,  -.093105,       0.0,  -.209765,
     &   .000000,  -.093105,  -.093105,  -.093105,   .000000,
     &  -.209765,  -.209765,  -.093105,   .000000,   .000000,
     &   .000000,   .000000,   .000000,  -.093105,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,  -.093105,   .000000/
C
      DATA BCR5/
     &   .011032,   .011032,   .000000,   .000000,   .000000,
     &   .000000,   .011032,   .000000,   .000000,   .011032,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .011032,   .011032,   .000000,   .000000,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,   .000000,   .000000/

      DATA BCR6/
     &   .000000,   .000000,  -.045532,  -.045532,  -.045532,
     &  -.045532,   .000000,  -.045532,       0.0,   .000000,
     &   .000000,  -.045532,  -.045532,  -.045532,   .000000,
     &   .000000,   .000000,  -.045532,   .000000,   .000000,
     &   .000000,   .000000,   .000000,  -.045532,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,  -.045532,   .000000/
C
      DATA BCR8/
     &   .017727,   .017727,   .000000,   .000000,   .000000,
     &   .000000,   .017727,   .000000,   .000000,   .017727,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .017727,   .017727,   .000000,   .000000,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,   .000000,   .000000/
C
      DATA BCR3/
     &   .003359,   .003359,   .002633,   .002633,   .002633,
     &   .002633,   .003359,   .002633, -0.016163,   .003359,
     &   .000000,   .002633,   .002633,   .002633, -0.016163,
     &   .003359,   .003359,   .002633, -0.009064, -0.009276,
     &   .000000,   .000000,   .000000,   .002633,   .000000,
     &   .000000, -0.009276,   .000000,   .000000,   .000000,
     &   .000000,   .002633,   .000000/
C
      DATA BCR9/
     &  -.000053,  -.000053,   .000022,   .000022,   .000022,
     &   .000022,  -.000053,   .000022,       0.0,  -.000053,
     &   .000000,   .000022,   .000022,   .000022,   .000000,
     &  -.000053,  -.000053,   .000022,   .000000,   .000000,
     &   .000000,   .000000,   .000000,   .000022,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,   .000022,   .000000/
C
      DATA BCR10/
     &   .014098,   .014098,  -.013115,  -.013115,  -.013115,
     &  -.013115,   .014098,  -.013115,       0.0,   .014098,
     &   .000000,  -.013115,  -.013115,  -.013115,   .000000,
     &   .014098,   .014098,  -.013115,   .000000,   .000000,
     &   .000000,   .000000,   .000000,  -.013115,   .000000,
     &   .000000,   .000000,   .000000,   .000000,   .000000,
     &   .000000,  -.013115,   .000000/
C
      DATA BCR0/
     &  -1.66949, -1.669490,  -.426688,  -.426688,  -.426688,
     &  -.426688, -1.669490,  -.426688,  8.042774, -1.669490,
     &  -2.19723,  -.426688,  -.426688,  -.426688,  8.042774,
     &  -1.66949, -1.669490,  -.426688,  7.558538,  6.489813,
     &       5.0,       5.0,       5.0,  -.426688,       5.0,
     &       5.0,  6.489813,       5.0,       5.0,       5.0,
     &       5.0,  -.426688,       5.0/
C
      DATA CRSD/
     &  .5000, .5000, .6957, .6957, .6957,
     &  .9310, .6124, .6957,1.3167, .4942,
     &  0.200, .6957, .6957, .6957,1.3167,
     &  .5000, .5000, .6957,1.9658,2.0426,
     &  0.500, 0.500, 0.500, .9310, 0.500,
     &  0.500,2.0426, 0.500, 0.500, 0.500,
     &  0.500, .6957, 0.500/
C-----------
C  CHECK FOR DEBUG.
C-----------
C     CALL DBCHK (DEBUG,'DUBSCR',6,ICYC)
C----------
C  EXPECTED CROWN RATIO IS A FUNCTION OF SPECIES, DBH, BASAL AREA, BAL,
C  AND PCCF.  THE MODEL IS BASED ON THE LOGISTIC FUNCTION,
C  AND RETURNS A VALUE BETWEEN ZERO AND ONE.
C----------
      CR = BCR2(ISPC)*H
     *   + BCR1(ISPC)*D
     *   + BCR5(ISPC)*TPCCF
     *   + BCR6(ISPC)*(AVH/H)
     *   + BCR8(ISPC)*AVH
     *   + BCR3(ISPC)*BA
     *   + BCR9(ISPC)*(BA*TPCCF)
     *   + BCR10(ISPC)*RMAI
     *   + BCR0(ISPC)
C----------
C  A RANDOM ERROR IS ASSIGNED TO THE CROWN RATIO PREDICTION
C  PRIOR TO THE LOGISTIC TRANSFORMATION.  LINEAR REGRESSION
C  WAS USED TO FIT THE MODELS AND THE ELEMENTS OF CRSD
C  ARE THE STANDARD ERRORS FOR THE LINEARIZED MODELS BY SPECIES.
C----------
      SD=CRSD(ISPC)
   10 FCR=BACHLO(0.0,SD,RANN)
      IF(ABS(FCR).GT.SD) GO TO 10
C
      SELECT CASE (ISPC)
      CASE(1:8,10:14,16:18,24,32)
        IF(ABS(CR+FCR).GE.86.)CR=86.
        CR=1.0/(1.0+EXP(CR+FCR))
      CASE DEFAULT
        CR=((CR-1.0)*10.0 + 1.0)/100.
      END SELECT
C
      IF(CR .GT. .95) CR = .950
      IF(CR .LT. .05) CR=.05
      IF(DEBUG)WRITE(JOSTND,600)ISPC,D,H,BA,TPCCF,CR,FCR,RMAI,AVH
  600 FORMAT(' IN DUBSCR, ISPC=',I2,' DBH=',F4.1,' H=',F5.1,
     & ' TBA=',F7.3,' TPCCF=',F8.4,' CR=',F4.3,
     &   ' RAN ERR = ',F6.4,' RMAI= ',F9.4,' TAVH=',F9.4)
      RETURN
      END
