      SUBROUTINE TWIGBF(ISPC,H,D,VMAX,BBFV)
      IMPLICIT NONE
C----------
C VBASE $Id: twigbf.f 2450 2018-07-11 17:28:41Z gedixon $
C----------
C  CENTRAL STATES ACCEPTABLE TREE CLASS BD FT VOLUME EQUATION:
C  --SMITH, W. BRAD, C.A. WEIST. 1982. A NET VOLUME EQUATION
C    FOR INDIANA. RESOUR. BULL. NC-63. ST PAUL, MN: USDA, FOREST
C    SERVICE, NORTH CENTRAL FOREST EXPERIMENT STATION. 7 P.
C
C          V = B1*SI**B2*[1-EXP(-B3*DBH**B4)]
C
C  WHERE:
C        V = VOLUME
C       SI = SITE INDEX
C      DBH = DIAMETER BREAST HEIGHT
C    B1-B4 = SPECIES SPECIFIC COEFFICIENTS
C
C----------
C  LAKE STATES ACCEPTABLE TREE CLASS VOLUME EQUATION:
C  --RAILLE, GERHARD K., W.B. SMITH, C.A. WEIST. 1982. A NET VOLUME
C    EQUATION FOR MICHIGAN'S UPPER AND LOWER PENINSULAS. 12 P.
C    USDA FOREST SERVICE GEN TECH REPORT NC-80.
C
C          V = B1*SI**B2*[1-EXP(-B3*DBH)]**B4
C
C  WHERE:
C        V = VOLUME
C       SI = SITE INDEX
C      DBH = DIAMETER BREAST HEIGHT
C    B1-B4 = SPECIES SPECIFIC COEFFICIENTS
C
C----------
C  NORTHEASTERN FOREST SURVEY VOLUME EQUATIONS:
C  --SCOTT, CHARLES, T. 1979. NORTHEASTERN FOREST SURVEY BOARD-FOOT
C    VOLUME EQUATIONS. USDA FOR. SERV RES. NOTE NE-271.
C
C  BFVOL=B1+BS(DBH)^B3+(B4(DBH)^B5)*H^B6
C
C  WHERE H = HEIGHT (IN FEET) TO TOP DIAMETER OUTSIDE BARK (TDOB)
C   TDOB FOR BFVOL = 9 INCHES (HARDWOODS) AND 7 INCHES (SOFTWOODS).
C
C  MERCHANTABLE HEIGHT EQUATIONS:
C  --YAUSSY, D.A. AND M.E. DALE. 1990. SAWLOG AND BOLE LENGTH
C    GENERALIZED MERCHANTABLE HEIGHT EQUATIONS FOR THE NORTHEASTERN
C    UNITED STATES.  USDA FOR. SERV. RES. PAP. NE-??? (IN PRESS).
C
C  HEIGHT=C1*SI^C2*(1-EXP(C3*(DBH-TD)))
C
C------------------------------------------------------------------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
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
C
C  ************** BOARD FOOT MERCHANTABILITY SPECIFICATIONS ********
C
C  BFVOL CALCULATES BOARD FOOT VOLUME OF ANY TREE LARGER THAN A MINIMUM
C  DBH SPECIFIED BY THE USER.  MINIMUM DBH CAN VARY BY SPECIES,
C  BUT CANNOT BE LESS THAN 2 INCHES.  DEFAULTS ARE 7 IN. FOR SOFTWOODS
C  AND 9 IN. FOR HARDWOODS.  MINIMUM MERCHANTABLE DBH IS
C  SET WITH THE BFVOLUME KEYWORD.
C
C  MERCHANTABLE TOP DIAMETER CAN BE SET WITH THE BFVOLUME KEYWORD
C  AT ANY VALUE BETWEEN 2 IN. AND ACTUAL DBH.  THIS DIAMETER IS
C  OUTSIDE BARK -- IF DIB IS DESIRED, ALLOWANCE FOR DOUBLE BARK
C  THICKNESS MUST BE MADE IN SPECIFICATION OF TOP DIAMETER.
C
C----------
C  VARIABLE DECLARATIONS:
C----------
C
      INTEGER ISPC
C
      REAL BBFV,D,H,RDANUW,SH,VMAX
C
      REAL CSB1(96),CSB2(96),CSB3(96),CSB4(96)
      REAL LSB1(68),LSB2(68),LSB3(68),LSB4(68)
      REAL NEBF1(108),NEBF2(108),NEBF3(108),NEBF4(108),NEBF5(108),
     &     NEBF6(108),SHB1(108),SHB2(108),SHB3(108)
C
C----------
C  VARIABLE INITIALIZATIONS:
C----------
C  CENTRAL STATES VARIANT
C  COEFFICIENTS FOR NET BOARD FOOT VOLUME EQUATION FOR ACCEPTABLE
C  TREES (TREE CLASS 1 & 2).
C----------
      DATA CSB1/
     &  2*68.6358,5*68.6528,2*68.6472,4*178.1367,10*1151.2737,343.5727,
     &  3*68.6341,68.6298,3*68.6272,68.6298,8*693.5429,261.7747,68.6283,
     &  68.6272,3*68.6341,103.7664,5*871.4258,7*103.7664,
     &  8*871.4258,29*164.5671/
      DATA CSB2/
     &  2*.6359,5*.9374,2*.5722,4*.3116,10*.0,.3245,3*.7813,.6536,
     &  3*.5665,.5869,8*.0476,.3820,.6229,.5665,3*.7813,.6707,5*.0682,
     &  7*.6707,8*.0682,29*.4052/
      DATA CSB3/
     &  2*.000082,5*.00004,2*.000087,4*.000083,10*.000077,.000081,
     &  3*.000079,.000053,3*.000140,.000045,8*.000071,.000088,.000045,
     &  .000140,3*.000079,.000076,5*.000112,7*.00076,8*.000112,
     &  29*.000061/
      DATA CSB4/
     &  2*2.8486,5*2.6643,2*2.8488,4*2.8811,10*2.7331,2.6745,3*2.5203,
     &  2.8696,3*2.7006,3.0054,8*2.9203,2.6472,3.0375,2.7006,3*2.5203,
     &  2.6670,5*2.5879,7*2.6670,8*2.5879,29*2.8766/
C----------
C  LAKE STATES VARIANT
C  COEFFICIENTS FOR NET BOARD FOOT VOLUME EQUATION FOR ACCEPTABLE
C  TREES (TREE CLASS 1 & 2).
C----------
      DATA LSB1/
     &  2*168.57868,2*2969.2993,36276658.,2*35253.479,27980.016,
     &  28937072.,
     &  62.984496,5756054.6,2586729.4,2*168.57868,2*10925208.,
     &  15938236.,
     &  3*120.30581,3*1211352.6,400.48678,201.41217,3*711.68082,
     &  10925208.,
     &  7*1007.3288,3*8070.0366,3*393.32540,9103704.2,
     &  25*8070.0366/
C
      DATA LSB2/
     &  2*.39510939,2*.2551933,.14235722,2*.0,.33410389,.063071273,
     &  .22695026,.0,.054371839,2*.39510939,2*.022442414,.7571799,
     &  3*.27194223,3*.57651474,.31603106,.26548744,3*.0,.022442414,
     &  7*.000,3*.63809141,3*.19531946,.000,25*.63809141/
C
      DATA LSB3/
     &  2*.051243289,2*.017900628,.00082741036,2*.011088055,
     &  .0096929089,
     &  .0014004165,.32849793,.00079044754,.0013929982,2*.051243289,
     &  2*.00082185175,.00029248070,3*.17342255,3*.00012726733,
     & .045870491,
     &  .11156278,3*.099521009,.00082185175,7*.068868975,
     &  3*.00039508458,
     &  3*.064037756,.00017368079,25*.00039508458/
C
      DATA LSB4/
     &  2*3.1962314,2*2.7608809,2.9729355,2*2.8661399,3.2610843,
     &  3.1647187,
     &  26.890578,2.4631793,2.6363294,2*3.1962314,2*2.5637377,
     &  2.7398161,
     &  3*11.675789,3*1.8336385,3.4177655,6.4197635,3*5.8660766,
     &  2.5637377,
     &  7*4.3821328,3*1.3461604,3*3.6809576,1.882183,
     &  25*1.3461604/
C----------
C  NORTHEAST VARIANT
C----------
      DATA NEBF1/
     &  -12.29,-6.78,-13.03,4*-13.03,-12.25,-12.25,-12.25,-6.78,4*-8.89,
     &  2*-8.36,8*-6.78,2.84,3*3.73,3*8.23,2*8.23,5*-1.24,-0.84,5*9.20,
     &  3*2.84,5*9.20,1.58,5*4.46,4*1.01,3*4.46,4*1.01,27*0.03,11*.0/
C
      DATA NEBF2/
     &  -.08212,-.00841,-.05197,4*-.05197,-0.02418,-0.02418,
     &  -.02418,-.00841,4*-.07324,2*-0.01433,8*-.00841,-.00557,
     &  3*-.00182,3*-.00039,2*-.00039,5*-.00385,-.01207,5*.00052,
     &  3*-.00557,5*.00052,-.00151,5*-.00061,4*-.00192,3*-.00061,
     &  2*-.00192,2*-.00192,27*-.00196,11*0.00000/
C
      DATA NEBF3/
     &   2.5641,2.7001,2.5248,4*2.5248,2.6865,2.6865,2.6865,2.7001,
     &   4*2.4556,2*2.7878,8*2.7001,3.1808,3*3.3766,5*3.0,5*3.1648,
     &   3.0043,5*3.0,3*3.1808,5*3.0,3.3878,5*3.5972,4*3.3188,3*3.5972,
     &   4*3.3188,27*3.3236,11*0.0000/
C
      DATA NEBF4/
     &   .1416,.0645,.1200,4*.1200,0.0961,0.0961,0.0961,0.0645,
     &   4*.1216,2*.0771,8*.0645,.0296,3*.0262,3*.0206,2*.0206,5*.0312,
     &   .0419,5*.0193,3*.0296,5*.0193,.0287,5*.0182,4*.0246,3*.0182,
     &   2*.0246,2*.0246,27*.0263,11*.0000/
C
      DATA NEBF5/
     &   2.2657,2.1938,5*2.1999,2.2281,2.2281,2.2281,2.1938,
     &   4*2.2382,2*2.2593,8*2.1938,2.4606,3*2.4291,5*2.2116,5*2.3888,
     &   2.3951,5*2.2165,3*2.4606,5*2.2165,2.3875,5*2.4804,4*2.4268,
     &   3*2.4804,4*2.4268,27*2.4162,11*0.0/
C
      DATA NEBF6/
     &   .3744,.4713,.4227,4*.4227,.4222,.4222,.4222,.4713,
     &   4*.3249,2*.4202,8*.4713,.5771,3*.6139,3*.8019,2*.8019,5*.6067,
     &   .5912,5*.8043,3*.5771,5*.8043,.6356,5*.5922,4*.6000,3*.5922,
     &   4*.6000,27*0.6012,11*0.0000/
C
      DATA SHB1/
     &  10.366,37.572,32.532,4*17.995, 5.199,39.900, 5.199,10.278,
     &  4*24.385,2*33.152,8*5.199,14.197,3*25.696,3*22.540,2*20.458,
     &  5*39.321,15.530,5*13.321,3*50.572,5*10.736,11.837,5*11.050,
     &  4*22.206,3*10.405,2*25.095,2*16.636,27*35.152,11*0.000/
C
      DATA SHB2/
     &  0.322,.0,.056,4*.203,0.530,0.031,0.530,0.334,4*.024,2*.057,
     &  8*.530,.190,3*.064,3*.050,2*.061,5*.000,.167,5*.238,3*.0,
     &  5*.290,.219,5*.283,4*.132,3*.308,2*.086,2*.201,27*.0,11*.0/
C
      DATA SHB3/
     &  .467,.431,.327,4*.352,.321,.234,.321,.436,4*.376,2*.216,
     &  8*.321,.473,3*.418,3*.673,2*.882,5*.360,.405,5*.468,3*.276,
     &  5*.546,.337,5*.387,4*.370,3*.379,2*.403,2*.328,27*.369,11*.0/
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
C  COMPUTE TOTAL BOARD FOOT VOLUME (VMAX)
C
        VMAX = CSB1(ISPC)*SITEAR(ISPC)**CSB2(ISPC)*
     &         (1.0 - EXP(-1.0*CSB3(ISPC)*(D**CSB4(ISPC))))
C
C  COMPUTE MERCH BOARD FOOT VOLUME (BBFV)
C
        BBFV = VMAX
C----------
C  LAKE STATES VARIANT
C----------
      CASE ('LS')
C
C  COMPUTE TOTAL BOARD FOOT VOLUME (VMAX)
C
        VMAX = LSB1(ISPC)*SITEAR(ISPC)**LSB2(ISPC)*
     &         (1.0 - EXP(-1.0*LSB3(ISPC)*D))**LSB4(ISPC)
C
C  COMPUTE MERCH BOARD FOOT VOLUME (BBFV)
C
        BBFV = VMAX
C----------
C  NORTHEASE VARIANT
C----------
      CASE ('NE')
C
C  ************** BOARD FOOT MERCHANTABILITY SPECIFICATIONS ********
C
C  BFVOL CALCULATES BOARD FOOT VOLUME OF ANY TREE LARGER THAN A MINIMUM
C  DBH SPECIFIED BY THE USER.  MINIMUM DBH CAN VARY BY SPECIES,
C  BUT CANNOT BE LESS THAN 2 INCHES.  DEFAULTS ARE 7 IN. FOR SOFTWOODS
C  AND 9 IN. FOR HARDWOODS.  MINIMUM MERCHANTABLE DBH IS
C  SET WITH THE BFVOLUME KEYWORD.
C
C  MERCHANTABLE TOP DIAMETER CAN BE SET WITH THE BFVOLUME KEYWORD
C  AT ANY VALUE BETWEEN 2 IN. AND ACTUAL DBH.  THIS DIAMETER IS
C  OUTSIDE BARK -- IF DIB IS DESIRED, ALLOWANCE FOR DOUBLE BARK
C  THICKNESS MUST BE MADE IN SPECIFICATION OF TOP DIAMETER.
C
C----------
C  SHB1   -- INTERCEPT COEFFICIENT IN THE MODEL PREDICTING SAWLOG
C            HEIGHT (ONE COEFFICIENT PER SPECIES).
C  SHB2   -- COEFFICIENT FOR SITE INDEX TERM IN THE MODEL PREDICTING
C            SAWLOG HEIGHT (ONE COEFFICIENT PER SPECIES).
C  SHB3   -- COEFFICIENT FOR (DBH-TDOB) TERM IN THE MODEL PREDICTING
C            SAWLOG HEIGHT (ONE COEFFICIENT PER SPECIES).
C  NEBF1  -- B1 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY
C            BOARD FOOT VOLUME EQUATION.
C  NEBF2  -- B2 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION.
C  NEBF3  -- B3 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION.
C  NEBF4  -- B4 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION.
C  NEBF5  -- B5 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION
C  NEBF6  -- B6 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION
C----------
C
        SH = SHB1(ISPC)*SITEAR(ISPC)**SHB2(ISPC)*
     &       (1.0 - EXP(-1.0*SHB3(ISPC)*(D-BFTOPD(ISPC))))
C
C  COMPUTE MERCH BOARD FOOT VOLUME (BBFV)
C
        BBFV = NEBF1(ISPC) + NEBF2(ISPC)*D**NEBF3(ISPC) +
     &         NEBF4(ISPC)*D**NEBF5(ISPC)*SH**NEBF6(ISPC)
C
C  SET VMAX
C
        VMAX = BBFV
C----------
C  WESTERN AND SOUTHERN VARIANTS
C----------
      CASE DEFAULT
        BBFV = 0.
        VMAX = 0.
C
      END SELECT
C
        RETURN
        END

