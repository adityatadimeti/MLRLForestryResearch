      SUBROUTINE TWIGCF(ISPC,H,D,VN,VM,I)
      IMPLICIT NONE
C----------
C LS $Id: twigcf.f 2450 2018-07-11 17:28:41Z gedixon $
C----------
C THIS ROUTINE CALCULATES TOTAL CUBIC FOOT VOLUME AND MERCH
C CUBIC FOOT VOLUME FOR A TREE.  CORRECTIONS FOR TOP KILL AND
C DEFECT ARE STILL CALCULATED IN VOLS.
C------------------------------------------------------------------
C  CENTRAL STATES VARIANT
C
C  CENTRAL STATES ACCEPTABLE TREE CLASS VOLUME EQUATION:
C  --SMITH, W. BRAD; WEIST, CAROL A. 1982. A NET VOLUME EQUATION
C    FOR INDIANA. RESOURCE BULL. NC-63. ST. PAUL, MN: US DEPT OF
C    AG, FS, NCFES.
C
C         V = A*SI**B*[1-EXP(-C*(DBH**D)]
C
C  WHERE:
C      V = VOLUME
C     SI = SITE INDEX
C    DBH = DIAMETER BREAST HEIGHT
C    A-D = SPECIES SPECIFIC COEFFICIENTS
C
C----------
C  LAKE STATES VARIANT
C
C  LAKE STATES ACCEPTABLE TREE CLASS VOLUME EQUATION:
C  --RAILE, GERHARD K., W.B. SMITH, C.A.WEIST. 1982. A NET VOLUME
C    EQUATION FOR MICHIGAN'S UPPER AND LOWER PENINSULAS. 12 P.
C    USDA FOREST SERVICE GEN TECH REPORT NC-80.
C
C         V = A*SI**B*[1-EXP(-C*DBH)]**D
C
C  WHERE:
C      V = VOLUME
C     SI = SITE INDEX
C    DBH = DIAMETER BREAST HEIGHT
C    A-D = SPECIES SPECIFIC COEFFICIENTS
C
C  UNDESIRABLE TREE VOLUME IS CALCULATED WITH THE SAME EQUATION BUT
C  VOLUME IS REDUCED BY A REDUCTION FACTOR.
C
C----------
C  NORTHEAST VARIANT
C
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
C----------
COMMONS
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
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C----------
C  VARIABLE DEFINITIONS:
C----------
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
C
C----------
C  VARIABLE DECLARATIONS:
C----------
C
      INTEGER I,ISPC
C
      REAL BH,D,D1,D2,D3,D4,H,RDANUW,SH,VM,VN
C
      REAL BHB1(108),BHB2(108),BHB3(108)
      REAL CSA1(96),CSA2(96),CSA3(96),CSA4(96)
      REAL CSB1(96),CSB2(96),CSB3(96),CSB4(96)
      REAL CSC1(96),CSC2(96),CSC3(96),CSC4(96)
      REAL LSA1(68),LSA2(68),LSA3(68),LSA4(68)
      REAL LSB1(68),LSB2(68),LSB3(68),LSB4(68)
      REAL LSC1(68)
      REAL NECF1(108),NECF2(108),NECF3(108)
      REAL NECF4(108),NECF5(108),NECF6(108)
      REAL SHB1(108),SHB2(108),SHB3(108)
C
C----------
C VARIABLE INITIALIZATIONS:
C----------
C
C  CENTRAL STATES VARIANT
C
C  COEFFICIENTS FOR NET CUBIC FOOT VOLUME FOR ACCEPTABLE TREES
C  (TREE CLASS 1)
C----------
      DATA CSA1/
     &  2*24.3201,5*32.7134,2*65.4786,4*15.8460,10*24.3795,252.1400,
     &  3*168.5280,14.1604,3*948.9211,21.9481,8*341.7616,23.6994,
     &  16.8823,948.9211,3*168.5280,21.1498,5*126.1555,7*21.1498,
     &  8*126.1555,29*16.7211/
C
      DATA CSA2/
     &  2*.8216,5*.3785,2*.0383,4*.5938,10*.5106,.0336,3*.0904,.8812,
     &  3*.0,.4170,8*.0,.5052,.5723,.0,3*.0904,.5754,5*.2152,7*.5754,
     &  8*.2152,29*.5991/
C
      DATA CSA3/
     &  2*.000044,5*.000089,2*.000265,4*.000063,10*.000086,.000110,
     &  3*.000099,.000056,3*.000059,.000263,8*.000083,.000097,.000100,
     &.000059,3*.000099,.000110,5*.000081,7*.00011,8*.000081,29*.000080/
C
      DATA CSA4/
     &  2*2.5616,5*2.7986,2*2.7537,4*2.8574,10*2.7597,2.5349,3*2.6121,
     &  2.4651,3*2.3163,2.5539,8*2.5673,2.7495,2.7071,2.3163,3*2.6121,
     &  2.5942,5*2.5973,7*2.5942,8*2.5973,29*2.7109/
C----------
C  COEFFICIENTS TO CALCULATE NET MERCHANTABLE CUBIC FOOT VOLUME
C  FOR ACCEPTABLE TREES (TREE CLASS 1)
C----------
      DATA CSB1/
     &  2*32.7134,5*8.5339,2*528.3431,4*4.0386,10*142.5035,1173.2462,
     &  3*527.1757,75.3457,3*190.0165,50.047,8*77.4351,26.6412,34.0091,
     &  190.0165,3*527.1757,32.6541,5*108.1743,7*32.6541,8*108.1743,
     &  29*15.0211/
C
      DATA CSB2/
     &  2*.3785,5*.5167,2*.1433,4*.6312,10*.0034,4*.0,.4188,3*.0,.2127,
     &  8*.0922,.4204,.2952,4*.0,.4767,5*.0818,7*.4767,8*.0818,
     &  29*.4755/
C
      DATA CSB3/
     &  2*.000089,5*.000231,2*.00003,4*.000064,10*.000116,.000025,
     &  3*.000078,.000016,3*.000199,.000064,8*.000154,.000135,.000025,
     &  .000199,3*.000078,.000084,5*.000175,7*.000084,8*.000175,
     &  29*.000087/
C
      DATA CSB4/
     &  2*2.7986,5*2.7641,2*2.4206,4*3.1986,10*2.6411,2.4259,3*2.2867,
     &  2.8728,3*2.3569,2.8882,8*2.6564,2.5659,3.2982,2.3569,3*2.2867,
     &  2.6689,5*2.4623,7*2.6689,8*2.4623,29*2.8131/
C----------
C  COEFFICIENTS FOR NET CUBIC FOOT VOLUME FOR UNDESIRABLE TREES
C  (TREE CLASS 2)
C----------
      DATA CSC1/
     &  7*22.7769,6*57.1662,10*18.6983,4.0681,3*5.0944,62.0266,
     &  3*72.0477,8.9688,8*25.5502,2*57.1662,72.0477,3*5.0944,104.1617,
     &  5*21.1882,7*104.1617,8*21.1882,17*57.1662,12*42.6350/
C
      DATA CSC2/
     &  7*.4240,6*.4545,10*.4097,.5642,3*.6960,.4397,3*.0743,.3930,
     &  8*.1927,2*.4545,.0743,3*.696,.089,5*.6788,7*.0890,8*.6788,
     &  17*.4545,12*.000/
C
      DATA CSC3/
     &  7*.000057,6*.000048,10*.000132,.000099,3*.000158,.000037,
     &  3*.000166,.000253,8*.0002,2*.000048,.000166,3*.000158,.000119,
     &  5*.000073,7*.000119,8*.000073,17*.000048,12*.000454/
C
      DATA CSC4/
     &  7*2.9092,6*2.5027,10*2.7085,3.2936,3*2.6118,2.6637,3*2.7068,
     &  2.8160,8*2.7686,2*2.5027,2.7068,3*2.6118,2.5916,5*2.4026,
     &  7*2.5916,8*2.4026,17*2.5027,12*2.5315/
C----------
C  LAKE STATES VARIANT
C
C  COEFFICIENTS FOR NET CUBIC FOOT VOLUME FOR ACCEPTABLE TREES
C  (TREE CLASS 1 & 2)
C----------
      DATA LSA1/
     &  2*43.247485,2*208.32365,7116253.8,2*794.19003,5907203.2,
     &  23975164.,
     &  43.505403,829653.86,7702181.2,2*43.247485,2*26920.19,7257392.8,
     &  3*84.104919,3*139.7892,4117941.8,220.79399,3*500.41063,26920.19,
     &  7*226.02403,3*14.440272,3*157.68489,7256.1098,
     &  25*14.440272/
C
      DATA LSA2/
     &  2*.24941515,2*.10151272,.24602412,2*.086980381,.21263512,
     &  .1483895,
     &  .000000,.05521671,.30586654,2*.24941515,2*.14046086,1.0162752,
     &  3*.13854827,3*.43870753,.29139894,.12195831,3*.0074206334,
     &  .14046086,7*.060183087,3*.33868853,3*.21360547,.1099344,
     &  25*.33868853/
C
      DATA LSA3/
     &  2*.063376007,2*.043477233,.00051614952,2*.024685442,
     &  .00055610656,
     &  .00035627913,.16016055,.0006650422,.00027449826,2*.063376007,
     &  2*.0031300326,.0001747494,3*.057639827,3*.019136939,
     &  .00021053854,
     &  .035924765,3*.028252482,.0031300326,7*.040777352,3*.11816693,
     &  3*.031542612,.0036265833,25*.11816693/
C
      DATA LSA4/
     &  2*3.3981105,2*3.2804598,2.7798709,2*3.0336154,2.7160711,
     &  2.6940649,
     &  5.6227874,2.339424,2.5641204,2*3.3981105,2*2.4281485,2.8369659,
     &  3*3.1838326,3*2.5388324,2.3009231,2.9439603,3*2.7577068,
     &  2.4281485,
     &  7*3.0682442,3*4.4887831,3*2.7168275,2.0925534,
     &  25*4.4887831/
C----------
C  COEFFICIENTS TO CALCULATE NET MERCHANTABLE CUBIC FOOT VOLUME
C  FOR ACCEPTABLE TREES (TREE CLASS 1 & 2)
C----------
      DATA LSB1/
     &  2*8.9466691,2*172.73418,27973496.,2*764.85471,349.63623,
     &  13205354.,
     &  11.845142,329.29724,13741.625,2*8.9466691,2*2361292.2,9227411.1,
     &  3*34.254409,3*315785.92,232.73999,32.535858,3*115.72444,
     &  2361292.2,
     &  7*92.097232,3*2361292.2,4*35.518497,25*115.72444/
C
      DATA LSB2/
     &  2*.53395855,2*.13296097,.15544995,2*.026436619,.39521623,
     &  .028683905,
     &  .22306358,.045490132,.093237867,2*.53395855,2*.081937656,
     &  .62754931,
     &  3*.18167758,3*.63848181,.18111402,.23507649,3*.0,.081937656,
     &  7*.000,3*.081937656,4*.25512529,25*.000/
C
      DATA LSB3/
     &  2*.085485402,2*.041905919,.00034307498,2*.027726162,
     &  .024435399,.0008993865,.29331203,.031842406,.0050556151,
     &  2*.085485402,2*.00048471246,.00017030448,3*.14024847,
     &  3*.000099734065,
     &  .02859564,.13247401,3*.097135794,.00048471246,7*.11297551,
     &  3*.00048471246,4*.089551607,25*.097135794/
C
      DATA LSB4/
     &  2*4.2155052,2*3.1660669,2.7757982,2*3.1681185,3.5026299,
     &  3.0467575,20.22362,3.1317028,2.6433358,2*4.2155052,2*2.3999128,
     &  2.6055323,3*8.5515876,3*1.8863520,2.9713878,8.2301993,
     &  3*5.752438,2.3999128,7*6.7209282,3*2.3999128,4*4.7270033,
     &  25*5.7524381/
C----------
C  NET CUBIC FOOT REDUCTION FACTOR FOR ACCEPTABLE TREES (TREE CLASS 2).
C----------
      DATA LSC1/
     &  2*.822,2*.888,.834,2*.883,.889,.879,.832,.828,.751,2*.780,
     &  2*.798,.803,.832,2*.832,3*.868,.803,.860,3*.823,.822,4*.860,
     & .856,2*.893,3*.848,.793,2*.782,.857,5*.790,20*.832/
C----------
C  NORTHEAST VARIANT
C
C----------
      DATA BHB1/
     &  17.394,23.357,25.540,4*24.180, 2.085,33.035, 2.085,12.054,
     &  4*32.794,2*49.866,8*2.085,22.319,3*21.237,5*18.922,5*44.770,
     &  16.430,5*26.321,3*65.206,5*11.015,8.301,5*19.406,4*27.724,
     &  3*10.573,2*34.608,2*13.901,27*48.125,11*26.129/
C
      DATA BHB2/
     &  .252,.194,.175,4*.186,.791,.138,.791,.351,4*.024,
     &  2*.0,8*.791,.149,3*.182,3*.176,2*.176,5*.036,.212,5*.135,
     &  3*.0,5*.338,.369,5*.206,4*.141,3*.338,2*.062,2*.291,27*.007,
     &  11*.0/
C
      DATA BHB3/
     &  .326,.286,.258,4*.280,.224,.173,.224,.350,4*.259,
     &  2*.167,8*.224,.342,3*.294,3*.400,2*.400,5*.209,.328,5*.268,
     &  3*.16,5*.371,.310,5*.247,4*.239,3*.301,2*.294,2*.283,27*.206,
     &  11*.493/
C
      DATA NECF1/
     &   -0.10,-0.03,.17,4*.17,.11,.11,.11,-0.03,4*.19,2*.24,
     &   8*-.03,-.45,3*-.19,3*-.27,2*-.27,5*-.27,-.6,5*.06,3*-.45,
     &   5*.06,-.04,5*-.26,4*-.13,3*-.26,31*-0.13,11* 0.00/
C
      DATA NECF2/
     &   -.05444,-.05604,-.06315,4*-.06315,-.05977,-.05977,
     &   -.05977,-.05604,4*-.05904,2*-.05895,8*-.05604,-.00523,
     &   3*-.01171,3*-.00675,2*-000675,5*-.00466,-0.00711,5*-.02437,
     &   3*-.00523,5*-.02437,-.01783,5*.00038,4*-.00536,3*.00038,
     &   2*-.00536,2*-.00536,27*-.00183,11* 0.00000/
C
      DATA NECF3/
     &    2.1194,2.0473,2.0654,4*2.0654,2.0498,2.0498,2.0498,
     &    2.0473,4*1.9935,2*2.0362,8*2.0473,2.2323,3*1.8949,3*1.9738,
     &    2*1.9738,5*2.1575,2.2693,5*1.5419,3*2.2323,5*1.5419,1.8109,
     &    5*2.0,4*1.1972,3*2.0,2*1.1972,2*1.1972,27*2.36,11*0.0/
C
      DATA NECF4/
     &    .04821,.05022,.05122,4*.05122,0.04965,0.04965,0.04965,
     &    .05022,4*.04981,2*.04947,8*.05022,.01338,3*.0134,3*.01327,
     &    2*.01327,5*.01174,.01399,5*.01299,3*.01338,5*.01299,.01358,
     &  5*.01068,4*.01131,3*.01068,2*.01131,2*.01131,27*.00944,11*0.0/
C
      DATA NECF5/
     &    2.0427,2.0198,2.0264,4*2.0264,2.0198,2.0198,2.0198,2.0198,
     &    4*2.0027,2*2.0172,8*2.0198,2.0093,3*1.9928,5*1.9967,5*2.0035,
     &    2.019,5*1.9885,3*2.0093,5*1.9885,1.9905,5*1.998,4*1.9975,
     &    3*1.9980,2*1.9975,2*1.9975,27*2.0608,11*0.0000/
C
      DATA NECF6/
     &    .3579,.3242,.3508,4*.3508,0.3468,0.3468,0.3468,0.3242,
     &    4*.3214,2*.3366,8*.3242,.6384,3*.6471,5*.6407,5*.664,
     &    .6518,5*.6453,3*.6384,5*.6453,.6553,5*.6438,4*.6549,3*.6438,
     &    4*.6549,27*0.6516,11*0.0000/
C
      DATA SHB1/
     &  10.366,37.572,32.532,4*17.995,5.199,39.900,5.199,10.278,
     &  4*24.385,2*33.152,8*5.199,14.197,3*25.696,3*22.540,2*20.458,
     &  5*39.321,15.530,5*13.321,3*50.572,5*10.736,11.837,5*11.050,
     &  4*22.206,3*10.405,2*25.095,2*16.636,27*35.152,11*0.0/
C
      DATA SHB2/
     &  .322,.0,.056,4*.203,.530,.031,.530,.334,4*.024,2*.057,8*.530,
     &  .190,3*.064,3*.05,2*.061,5*.0,.167,5*.238,3*.0,5*.290,.219,
     &  5*.283,4*.132,3*.308,2*.086,2*.201,27*.0,11*.0/
C
      DATA SHB3/
     &  .467,.431,.327,4*.352,.321,.234,.321,.436,4*.376,2*.216,8*.321,
     &  .437,3*.418,3*.673,2*.882,5*.360,.405,5*.468,3*.276,5*.546,
     &  .337,5*.387,4*.370,3*.379,2*.403,2*.328,27*.369,11*.000/
C
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = H
C
      SELECT CASE (VARACD)
C----------
C  CENTRAL STATES VARIANT
C----------
      CASE ('CS')
C
C----------
C SET INITIAL VALUES.  IF DIAMETER LIMITS NOT MET THEN RETURN.
C----------
       IF(IMC(I) .EQ. 1)THEN
          D1=CSA1(ISPC)
          D2=CSA2(ISPC)
          D3=CSA3(ISPC)
          D4=CSA4(ISPC)
         ELSE
          D1=CSC1(ISPC)
          D2=CSC2(ISPC)
          D3=CSC3(ISPC)
          D4=CSC4(ISPC)
        ENDIF
C----------
C  CALCULATE NET CUBIC FOOT VOLUME (VN)
C----------
       VN = D1*(SITEAR(ISPC)**D2)*(1.-EXP(-1.0*D3*(D**D4)))
C----------
C  CALCULATE MERCHANTABLE CUBIC FOOT VOLUME (VM)
C----------
       VM = 0.
       IF ((IMC(I) .GT. 1) .OR. (D .LT. BFMIND(ISPC))) GOTO 100
       VM = CSB1(ISPC)*SITEAR(ISPC)**CSB2(ISPC) *
     &      (1.0-EXP(-1.0*CSB3(ISPC)*(D**CSB4(ISPC))))
  100  CONTINUE
C----------
C  LAKE STATES VARIANT
C----------
      CASE ('LS')
C----------
C  CALCULATE NET CUBIC FOOT VOLUME (VN)
C----------
       VN = LSA1(ISPC)*SITEAR(ISPC)**LSA2(ISPC) *
     &      (1.0-EXP(-1.0*LSA3(ISPC)*D))**LSA4(ISPC)
C----------
C  REDUCE SOUND VOLUME IF TREE IS UNDESIREABLE
C----------
       IF (IMC(I) .EQ. 2) VN = LSC1(ISPC)*VN
C----------
C  CALCULATE MERCHANTABLE CUBIC FOOT VOLUME (VM)
C----------
       VM = 0.
       IF ((IMC(I) .GT. 1) .OR. (D .LT. BFMIND(ISPC))) GOTO 200
       VM = LSB1(ISPC)*SITEAR(ISPC)**LSB2(ISPC) *
     &      (1.0-EXP(-1.0*LSB3(ISPC)*D))**LSB4(ISPC)
  200  CONTINUE
C----------
C  NORTHEASE VARIANT
C----------
      CASE ('NE')
        SH = 0.
        VM = 0.
        VN = 0.
C----------
C  CALCULATE BOLE HEIGHT
C----------
        BH = BHB1(ISPC)*SITEAR(ISPC)**BHB2(ISPC)
     $       *(1.0-EXP(-1.0*(BHB3(ISPC)*(D-TOPD(ISPC)))))
        IF(BH .LE. 0.0) GOTO 300
C----------
C  CALCULATE TOTAL CUBIC FOOT VOLUME (VN)
C----------
       VN = NECF1(ISPC) + NECF2(ISPC)*D**NECF3(ISPC) + 
     &      NECF4(ISPC)*D**NECF5(ISPC)*BH**NECF6(ISPC)  
C----------
C  CALCULATE MERCH CUBIC FOOT VOLUME (VM)
C----------
       IF ((D .LT. BFMIND(ISPC)) .OR. IMC(I) .NE. 1)GOTO 300
C----------
C  CALCULATE SAWLOG HEIGHT
C----------
       SH = SHB1(ISPC)*SITEAR(ISPC)**SHB2(ISPC) *
     &      (1.0-EXP(-1.0*(SHB3(ISPC)*(D-BFTOPD(ISPC)))))
       VM = NECF1(ISPC) + NECF2(ISPC)*D**NECF3(ISPC) + 
     &      NECF4(ISPC)*D**NECF5(ISPC)*SH**NECF6(ISPC)
  300  CONTINUE
C----------
C  WESTERN AND SOUTHERN VARIANTS
C----------
      CASE DEFAULT
        VN = 0.
        VM = 0.
C
      END SELECT
C
       RETURN
       END                                    

