      SUBROUTINE TWIGCF(ISPC,H,D,VN,VM,I)
      IMPLICIT NONE
C----------
C ACD $Id$
C----------
C THIS ROUTINE CALCULATES TOTAL CUBIC FOOT VOLUME AND MERCH
C CUBIC FOOT VOLUME FOR A TREE.  CORRECTIONS FOR TOP KILL AND
C DEFECT ARE STILL CALCULATED IN VOLS.
C----------
COMMONS
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
C---------
C  BHB1 --  INTERCEPT COEFFICIENT IN THE MODEL PREDICTING BOLE HEIGHT
C           TO A 4-INCH TOP (ONE COEFFICIENT PER SPECIES).
C  BHB2 --  COEFFICIENT FOR SITE INDEX TERM IN THE MODEL PREDICTING
C           BOLE HEIGHT TO A 4-INCH TOP (ONE COEFFICIENT PER SPECIES).
C  BHB3 --  COEFFICIENT FOR (DBH-TDOB) TERM IN THE MODEL PREDICTING
C           BOLE HEIGHT TO A 4-INCH TOP (ONE COEFFICIENT PER SPECIES).
C  SHB1 --  INTERCEPT COEFFICIENT IN THE MODEL PREDICTING SAWLOG
C           HEIGHT TO A MERCHANTABLE TOP.
C  SHB2 --  COEFFICIENT FOR SITE INDEX TERM IN THE MODEL PREDICTING
C           SAWLOG HEIGHT TO A MERCHANTABLE TOP.
C  SHB3 --  COEFFICIENT FOR (DBH-TDOB) TERM IN THE MODEL PREDICTING
C           SAWLOG HEIGHT TO A MERCHANTABLE TOP.
C  NECF1--  B1 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY CUBIC-
C           FOOT VOLUME EQUATION.
C  NECF2--  B2 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY CUBIC-
C           FOOT VOLUME EQUATION.
C  NECF3--  B3 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY CUBIC-
C           FOOT VOLUME EQUATION.
C  NECF4--  B4 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY CUBIC-
C           FOOT VOLUME EQUATION.
C  NECF5--  B5 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY CUBIC-
C           FOOT VOLUME EQUATION.
C  NECF6--  B6 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY CUBIC-
C           FOOT VOLUME EQUATION.
C---------
C
COMMONS
C----------
C  DIMENSION STATEMENT FOR INTERNAL ARRAYS.
C----------
      REAL B1,B2,B3,B4,B5,B6,BH
      REAL NECF1(MAXSP),NECF2(MAXSP),NECF3(MAXSP)
      REAL NECF4(MAXSP),NECF5(MAXSP),NECF6(MAXSP)
      REAL BHB1(MAXSP),BHB2(MAXSP),BHB3(MAXSP),SHB1(MAXSP),
     & SHB2(MAXSP),SHB3(MAXSP)
      REAL VM,VN,D,H,SH
      INTEGER I,ISPC
      DATA BHB1/
     &  17.394,23.357,25.540,4*24.180, 2.085,33.035, 2.085,12.054,
     &  4*32.794,2*49.866,8*2.085,22.319,3*21.237,5*18.922,5*44.770,
     &  16.430,5*26.321,3*65.206,5*11.015,8.301,5*19.406,4*27.724,
     &  3*10.573,2*34.608,2*13.901,27*48.125,11*26.129/
      DATA BHB2/
     &  .252,.194,.175,4*.186,.791,.138,.791,.351,4*.024,
     &  2*.0,8*.791,.149,3*.182,3*.176,2*.176,5*.036,.212,5*.135,
     &  3*.0,5*.338,.369,5*.206,4*.141,3*.338,2*.062,2*.291,27*.007,
     &  11*.0/
      DATA BHB3/
     &  .326,.286,.258,4*.280,.224,.173,.224,.350,4*.259,
     &  2*.167,8*.224,.342,3*.294,3*.400,2*.400,5*.209,.328,5*.268,
     &  3*.16,5*.371,.310,5*.247,4*.239,3*.301,2*.294,2*.283,27*.206,
     &  11*.493/
      DATA SHB1/
     &  10.366,37.572,32.532,4*17.995,5.199,39.900,5.199,10.278,
     &  4*24.385,2*33.152,8*5.199,14.197,3*25.696,3*22.540,2*20.458,
     &  5*39.321,15.530,5*13.321,3*50.572,5*10.736,11.837,5*11.050,
     &  4*22.206,3*10.405,2*25.095,2*16.636,27*35.152,11*0.0/
      DATA SHB2/
     &  .322,.0,.056,4*.203,.530,.031,.530,.334,4*.024,2*.057,8*.530,
     &  .190,3*.064,3*.05,2*.061,5*.0,.167,5*.238,3*.0,5*.290,.219,
     &  5*.283,4*.132,3*.308,2*.086,2*.201,27*.0,11*.0/
      DATA SHB3/
     &  .467,.431,.327,4*.352,.321,.234,.321,.436,4*.376,2*.216,8*.321,
     &  .437,3*.418,3*.673,2*.882,5*.360,.405,5*.468,3*.276,5*.546,
     &  .337,5*.387,4*.370,3*.379,2*.403,2*.328,27*.369,11*.000/
      DATA NECF1/
     &   -0.10,-0.03,.17,4*.17,.11,.11,.11,-0.03,4*.19,2*.24,
     &   8*-.03,-.45,3*-.19,3*-.27,2*-.27,5*-.27,-.6,5*.06,3*-.45,
     &   5*.06,-.04,5*-.26,4*-.13,3*-.26,31*-0.13,11* 0.00/
      DATA NECF2/
     &   -.05444,-.05604,-.06315,4*-.06315,-.05977,-.05977,
     &   -.05977,-.05604,4*-.05904,2*-.05895,8*-.05604,-.00523,
     &   3*-.01171,3*-.00675,2*-000675,5*-.00466,-0.00711,5*-.02437,
     &   3*-.00523,5*-.02437,-.01783,5*.00038,4*-.00536,3*.00038,
     &   2*-.00536,2*-.00536,27*-.00183,11* 0.00000/
      DATA NECF3/
     &    2.1194,2.0473,2.0654,4*2.0654,2.0498,2.0498,2.0498,
     &    2.0473,4*1.9935,2*2.0362,8*2.0473,2.2323,3*1.8949,3*1.9738,
     &    2*1.9738,5*2.1575,2.2693,5*1.5419,3*2.2323,5*1.5419,1.8109,
     &    5*2.0,4*1.1972,3*2.0,2*1.1972,2*1.1972,27*2.36,11*0.0/
      DATA NECF4/
     &    .04821,.05022,.05122,4*.05122,0.04965,0.04965,0.04965,
     &    .05022,4*.04981,2*.04947,8*.05022,.01338,3*.0134,3*.01327,
     &    2*.01327,5*.01174,.01399,5*.01299,3*.01338,5*.01299,.01358,
     &  5*.01068,4*.01131,3*.01068,2*.01131,2*.01131,27*.00944,11*0.0/
      DATA NECF5/
     &    2.0427,2.0198,2.0264,4*2.0264,2.0198,2.0198,2.0198,2.0198,
     &    4*2.0027,2*2.0172,8*2.0198,2.0093,3*1.9928,5*1.9967,5*2.0035,
     &    2.019,5*1.9885,3*2.0093,5*1.9885,1.9905,5*1.998,4*1.9975,
     &    3*1.9980,2*1.9975,2*1.9975,27*2.0608,11*0.0000/
      DATA NECF6/
     &    .3579,.3242,.3508,4*.3508,0.3468,0.3468,0.3468,0.3242,
     &    4*.3214,2*.3366,8*.3242,.6384,3*.6471,5*.6407,5*.664,
     &    .6518,5*.6453,3*.6384,5*.6453,.6553,5*.6438,4*.6549,3*.6438,
     &    4*.6549,27*0.6516,11*0.0000/
C------------------------------------------------------------------
C  NORTHEASTERN FOREST SURVEY VOLUME EQUATIONS:
C  --SCOTT, CHARLES, T. 1981. NORTHEASTERN FOREST SURVEY REVISED
C    CUBIC-FOOT VOLUME EQUATIONS. USDA. FOR. SERV. RES. NOTE NE-304.
C
C  CFVOL=B1+B2(DBH)^B3+(B4(DBH)^B5)*H^B6
C
C  WHERE H = HEIGHT (IN FEET) TO A TOP DIAMETER OUTSIDE BARK (TDOB)
C  DEFAULT TDOB FOR CFVOL = 4 INCHES FOR ALL SPECIES.
C
C  MERCHANTABLE HEIGHT EQUATIONS.
C  --YAUSSY, DAN. E. AND M.E. DALE. 1990.  SAWLOG AND BOLE LENGTH
C    GENERALIZED MERCHANTABLE HEIGHT EQUATIONS FOR THE NORTHEASTERN
C    UNITED STATES.  USDA. FOR. SERV. RES. PAP. NE-___.
C
C    HEIGHT = C1*SI^C2*(1-EXP(C3*(DBH-TDOB)))
C------------------------------------------------------------------
C  CALCULATE BOLE HEIGHT
C----------
       BH=BHB1(ISPC)*SITEAR(ISPC)**BHB2(ISPC)
     $ *(1.0-EXP(-1.0*(BHB3(ISPC)*(D-TOPD(ISPC)))))
       IF(BH .LE. 0.0) GOTO 100
       B1=NECF1(ISPC)
       B2=NECF2(ISPC)
       B3=NECF3(ISPC)
       B4=NECF4(ISPC)
       B5=NECF5(ISPC)
       B6=NECF6(ISPC)
C----------
C  CALCULATE TOTAL CUBIC FOOT VOLUME (VN)
C----------
       VN=B1+B2*D**B3+B4*D**B5*BH**B6
C----------
C  CALCULATE MERCH CUBIC FOOT VOLUME (VM)
C----------
       IF ((D .LT. BFMIND(ISPC)) .OR. IMC(I) .NE. 1)GOTO 100
C----------
C  CALCULATE SAWLOG HEIGHT
C----------
       SH=SHB1(ISPC)*SITEAR(ISPC)**SHB2(ISPC)
     $ *(1.0-EXP(-1.0*(SHB3(ISPC)*(D-BFTOPD(ISPC)))))
       VM=B1+B2*D**B3+B4*D**B5*SH**B6
  100  CONTINUE
       RETURN
       END
