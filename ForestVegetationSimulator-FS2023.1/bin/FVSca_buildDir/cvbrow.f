      SUBROUTINE CVBROW (LTHIN)
      IMPLICIT NONE
C----------
C VCOVR $Id$
C----------
C   COMPUTES TOTAL SHRUB COVER, AND PROBABILITY OF OCCURRENCE, HEIGHT,
C   AND PERCENT COVER FOR 31 SHRUB, FORB, GRASS, AND FERN SPECIES
C   IN GRAND FIR, CEDAR, HEMLOCK, DOUGLAS-FIR, AND SUBALPINE FIR
C   HABITAT TYPES.  TOTAL SHRUB COVER, SPECIES PERCENT COVER, AND
C   SPECIES HEIGHT ARE FROM:
C
C      LAURSEN, STEVE.  1984.  MODELING UNDERSTORY DEVELOPMENT IN
C         INTERMOUNTAIN FORESTS: SHRUB HEIGHT AND COVER
C         DYNAMICS.  PH.D THESIS, UNIV. OF IDAHO, COLLEGE
C         OF FORESTRY, WILDLIFE, AND RANGE SCIENCES, MOSCOW.
C         (IN PREP.)
C
C   PROBABILITY OF OCCURRENCE BY SPECIES IS FROM:
C
C      SCHAROSCH, STEVE.  1984.  PREDICTING THE PROBABILITY OF
C         OCCURRENCE FOR SELECTED SHRUB SPECIES IN THE UNDERSTORY OF
C         NORTH AND CENTRAL IDAHO FORESTS.  M.S. THESIS, UNIV. OF IDAHO,
C         COLLEGE OF FORESTRY, WILDLIFE, AND RANGE SCIENCES, MOSCOW.
C         (IN PREP.)
C
C   THESE RELATIONSHIPS REPLACE PROB, COVER, AND HEIGHT EQUATIONS OF
C   IRWIN AND PEEK, AS OF SPRING, 1984.
C
C   TOTAL SHRUB BIOMASS AND TWIG PRODUCTION FOR 16 SPECIES IN GF/CLUN,
C   WRC/CLUN, AND WH/CLUN HABITAT TYPES ONLY, ARE RETAINED FROM:
C
C         IRWIN, L.L. AND J.M. PEEK. 1979. SHRUB PRODUCTION AND BIOMASS
C            TRENDS FOLLOWING LOGGING WITHIN THE CEDAR-HEMLOCK ZONE
C            OF IDAHO. FOR. SCI., VOL. 25, NO.3: PP. 415-426.
C
C   CVBROW CALLS **CVSCON** IN CYCLE 0 TO COMPUTE SHRUB EQUATION
C   CONSTANTS.  IF CALIBRATION IS BEING DONE, **CVBROW** CALLS
C   **CVBCAL** IN CYCLE 0.
C----------
C            ** GENERAL VARIABLES **
C
C-- IHTYPE -- INPUT HABITAT TYPE CODE (MAY BE DIFFERENT FROM
C             STDINFO CODE)
C-- IHCODE(34) -- VECTOR OF ALL VALID HABITAT TYPE CODES
C-- INF, INFOR(11) -- RETURN SUBSCRIPT, AND MAPPING FUNCTION FOR
C             NATIONAL FOREST GROUPINGS
C-- LBROW --  LOGICAL FLAG TO CALL **CVBROW**
C-- SAGE --   THE CURRENT VALUE OF "TIME SINCE DISTURBANCE".
C-- TIMESD(MAXCY1,2) -- TIME SINCE STAND DISTURBANCE, STORED FOR OUTPUT
C             TO SUMMARY DISPLAY
C----------
C     ** VARIABLES ASSOCIATED WITH LAURSEN'S TOTAL SHRUB COVER **
C
C-- ITUN, ITHABU(34) -- RETURN SUBSCRIPT, MAPPING FUNCTION FOR
C             UNDERSTORY HABITAT TYPE GROUPING
C-- TCON(2), TDTSD(4) -- CONSTANT FROM **CVSCON**, AND OTHER
C             VARIABLE COEFFICIENTS
C-- PGT0(MAXCY1,2) --   PROB (COVER > 0)
C-- TCOV --   PREDICTED COVER GIVEN PGT0
C----------
C  ** VARIABLES ASSOCIATED WITH SCHAROSCH'S PROBABILITY OF OCCURRENCE **
C
C-- IOV, IPHABO(34) -- RETURN SUBSCRIPT, MAPPING FUNCTION FOR
C             OVERSTORY HABITAT TYPE GROUPING
C-- IUN, IPHABU(34) -- RETURN SUBSCRIPT, MAPPING FUNCTION FOR
C             UNDERSTORY HABITAT TYPE GROUPING
C-- PCON(31), CSCAL, PDTSD(3,31), POTHER(4,31) -- CONSTANTS FROM
C             **CVSCON**, AND COEFFICIENTS FOR OTHER VARIABLES
C-- PB(31) -- PREDICTED PROBABILITY OF OCCURRENCE
C----------
C  ** VARIABLES ASSOCIATED WITH LAURSEN'S SPECIES HEIGHT **
C
C-- HCON(31), H11DTS(4), H16DTS(4), RESIDC --
C             CONSTANTS FROM **CVSCON**, AND COEFFICIENTS FOR
C             OTHER VARIABLES
C-- SH(31) -- PREDICTED SPECIES HEIGHT
C----------
C  ** VARIABLES ASSOCIATED WITH LAURSEN'S SPECIES COVER **
C
C-- CCON(31), ALNHT(31), RESIDH(31), -- CONSTANTS
C             FROM **CVSCON**, AND COEFFICIENTS FOR OTHER VARIABLES
C-- CV(31) -- PREDICTED SPECIES COVER, UNWEIGHTED BY PB(I)
C-- HTINDX(31), CABHT(31) -- SPECIES SUBSCRIPTS SORTED BY HEIGHT, AND
C             CUMULATIVE COVER ABOVE CURRENT HEIGHT
C-- PBCV(31) -- PREDICTED COVER WEIGHTED BY PROBABILITY OF
C             OCCURRENCE (PB(I)*CV(I)).  REPORTED AS SPECIES COVER
C-- TOTLCV(MAXCY1,2) -- REPORTED TOTAL COVER, EQUAL TO THE SUM OF
C             INDIVIDUAL SPECIES COVER WEIGHTED BY PROB. OF
C             OCCURRENCE (PBCV(I))
C----------
C     ** VARIABLES ASSOCIATED WITH IRWIN AND PEEK EQUATIONS **
C
C-- ICEHAB, IGFHAB -- HABITAT TYPE DUMMY VARIABLES
C-- SBMASS(MAXCY1,2) - PREDICTED SHRUB BIOMASS
C-- TWIGS(MAXCY1,2) -- PREDICTED TWIG PRODUCTION
C----------
C     ** VARIABLES ASSOCIATED WITH CALIBRATION **
C
C-- LCALIB -- .TRUE. IF SHRUB CALIBRATION FACTORS ARE STILL IN
C             EFFECT.  CALIBRATION STOPS AFTER THINNING
C-- SHRBHT(31), SHRBPC(31) -- INPUT SPECIES HEIGHT AND COVER
C-- BHTCF(31), BPCCF(31) -- CORRECTION FACTORS COMPUTED BY **CVBCAL**
C----------
C  ** CODES AND SUBSCRIPTS USED IN SHRUB MODELS **
C
C     N.FOREST             REGION 1   FOREST
C     GROUP                CODE       NAME
C     (INF)      (IFOR)
C     --------   ------    --------   ---------------
C        N/A       N/A          1     PAYETTE
C        N/A       N/A          2     BOISE
C         3         1           3     BITTERROOT
C         4         2           4     IDAHO PANHANDLE
C         3         3           5     CLEARWATER
C         3         4           6     COEUR D'ALENE
C         4         5           7     COLVILLE
C         4         6          10     FLATHEAD
C         4         7          13     KANIKSU
C         4         8          14     KOOTENAI
C         3         9          16     LOLO
C         2        10          17     NEZPERCE
C         3        11          18     ST. JOE
C
C
C  OVERSTORY  UNDERSTORY  UNDERSTORY
C  SERIES     UNION FOR   UNION FOR
C             PB          TCOV,SH,CV
C  (IOV)      (IUN)       (ITUN)       (IHCODE)  CODE    HABITAT TYPE
C  ---------  ----------  ----------   --------  ----    ------------
C    1          5           6             1       210     DF / AGSP
C    1          5           6             2       220     DF / FEID
C    1          2           2             3       260     DF / PHMA
C    1          3           4             4       310     DF / SYAL
C    1          5           6             5       320     DF / CARU
C    1          5           6             6       330     DF / CAGE
C    1          3           4             7       340     DF / SPBE
C    1          3           4             8       380     DF / SYOR
C    1          2           2             9       390     DF / ACGL
C    1          3           4            10       395     DF / BERE
C    2          3           4            11       505     GF / SPBE
C    2          1           1            12       510     GF / XETE
C    2          1           1            13       511     GF / COOC
C    2          2           2            14       515     GF / VAGL
C    2          1           1            15       520     GF / CLUN
C    2          2           2            16       525     GF / ACGL
C    3          1           3            17       530     WRC/ CLUN
C    3          1           3            18       540     WRC/ ATFI
C    3          1           3            19       550     WRC/ OPHO
C    4          4           5            20       570     WH / CLUN
C    2          1           1            21       590     GF / LIBO
C    5          4           5            22       620     AF / CLUN
C    5          1           1            23       635     AF / STAM
C    5          2           2            24       645     AF / ACGL
C    5          5           6            25       650     AF / CACA
C    5          2           2            26       670     AF / MEFE
C    5          1           1            27       690     AF / XETE
C    5          3           4            28       705     AF / SPBE
C    5          1           1            29       710     MH / XETE
C    5          2           2            30       720     AF / VAGL
C    5          2           2            31       721     AF / VAGL
C    5          2           1            32       730     AF / VASC
C    5          5           6            33       790     AF / CAGE
C    5          1           1            34       830     AF / LUHI
C
C  (IPHYS)   PYHSIOGRAPHY
C  -------   ------------
C     1      BOTTOM
C     2      LOWER SLOPE
C     3      MID SLOPE
C     4      UPPER SLOPE
C     5      RIDGE
C
C  (IDIST)   DISTURBANCE TYPE
C  -------   ----------------
C     1      NONE
C     2      MECHANICAL
C     3      BURN
C     4      ROAD
C
C            LOW SHRUBS
C  ---------------------------------
C  ISP CODE    SPECIES
C  --- ---- ------------------------
C   1) ARUV:ARCTOSTAPHYLOS UVA-URSI
C   2) BERB:BERBERIS SPP.
C   3) LIBO:LINNAEA BOREALIS
C   4) PAMY:PACHISTIMA MYRSINITES
C   5) SPBE:SPIRAEA BETULIFOLIA
C   6) VASC:VACCINIUM SCOPARIUM
C   7) CARX:CAREX SPP.
C
C         MEDIUM SHRUBS
C  ---------------------------------
C  ISP CODE    SPECIES
C  --- ---- ------------------------
C   8) LONI:LONICERA SPP.
C   9) MEFE:MENZIESIA FERRUGINEA
C  10) PHMA:PHYSOCARPUS MALVACEUS
C  11) RIBE:RIBES SPP.
C  12) ROSA:ROSA SPP.
C  13) RUPA:RUBUS PARVIFLORUS
C  14) SHCA:SHEPHERDIA CANADENSIS
C  15) SYMP:SYMPHORICARPOS SPP.
C  16) VAME:VACCINIUM MEMBRANACEUM
C  17) XETE:XEROPHYLLUM TENAX
C  18) FERN:FERNS
C  19) COMB:OTHER SHRUBS COMBINED
C
C         TALL SHRUBS
C  ---------------------------------
C  ISP CODE    SPECIES
C  --- ---- ------------------------
C  20) ACGL:ACER GLABRUM
C  21) ALSI:ALNUS SINUATA
C  22) AMAL:AMELANCHIER ALNIFOLIA
C  23) CESA:CEANOTHUS SANGUINEUS
C  24) CEVE:CEANOTHUS VELUTINUS
C  25) COST:CORNUS STOLONIFERA
C  26) HODI:HOLODISCUS DISCOLOR
C  27) PREM:PRUNUS EMARGINATA
C  28) PRVI:PRUNUS VIRGINIANA
C  29) SALX:SALIX SPP.
C  30) SAMB:SAMBUCUS SPP.
C  31) SORB:SORBUS SPP.
C
C-----------------------------------------------------------------------
COMMONS
C
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
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'CVCOM.F77'
C
COMMONS
C
      LOGICAL LTHIN,DEBUG
      CHARACTER*4 SNAME(31)
      INTEGER INFOR(11),HTINDX(31)
C
      INTEGER ITHABU(34)
      REAL TDTSD(4)
C
      INTEGER IHCODE(34),IPHABO(34),IPHABU(34)
      REAL POTHER(4,31),POTH1(56),POTH2(68)
      EQUIVALENCE (POTH1(1),POTHER(1,1)),(POTH2(1),POTHER(1,15))
      REAL PDTSD(4,31),PDTSD1(56),PDTSD2(68)
      EQUIVALENCE (PDTSD1(1),PDTSD(1,1)),(PDTSD2(1),PDTSD(1,15))
C
      REAL H11DTS(4),H16DTS(4)
C
      REAL ALNHT(31),RESIDH(31),CABHT(31),CV(31),A(1)
      INTEGER MYACT(2)
      DATA MYACT/443,900/
      INTEGER IP1,NTODO,I,NP,IACT,KDT,ICODE,ITHN,ISPI,J,K,JM1,KM1
      REAL RESIDC,PCTEST,VTEST,CSCAL,BAREA,ALNBA,ALDTS, BAC10,BAC23
      REAL BAC29,SHH,PBCUM
C
      DATA SNAME /
     & 'ARUV','BERB','LIBO','PAMY','SPBE','VASC','CARX','LONI',
     & 'MEFE','PHMA','RIBE','ROSA','RUPA','SHCA','SYMP','VAME',
     & 'XETE','FERN','COMB','ACGL','ALSI','AMAL','CESA','CEVE',
     & 'COST','HODI','PREM','PRVI','SALX','SAMB','SORB'/
C
      DATA IHCODE /210,220,260,310,320,330,340,380,390,395,
     &             505,510,511,515,520,525,530,540,550,570,
     &             590,620,635,645,650,670,690,705,710,720,
     &             721,730,790,830/
C
      DATA INFOR /3,4,3,3,4,4,4,4,3,2,3/
C----------------------------------------------------------------------
C  VARIABLE GROUPINGS FOR TOTAL SHRUB COVER, SPECIES HEIGHT AND COVER
      DATA RESIDC /0.0/
      DATA ITHABU /2*6,2,4,2*6,2*4,2,2*4,2*1,2,1,2,3*3,
     &             5,1,5,1,2,6,2,1,4,1,2*2,1,6,1/
C                  TIME*NONE    TIME*MECH    TIME*BURN    ROAD
      DATA TDTSD /-0.02001682,  0.01211542,  0.00767395,  0.00/
      DATA H11DTS / 0.001316,  0.002771,  0.001187,  -0.005310/
      DATA H16DTS /-0.013230,  0.049648,  0.143607,  -0.102255/
      DATA RESIDH /31*0.0/
C----------------------------------------------------------------------
C  VARIABLE GROUPINGS FOR PROB. OCCURRENCE MODELS
      DATA IPHABO /10*1,6*2,3*3,4,2,13*5/
      DATA IPHABU /2*5,2,3,2*5,2*3,2,2*3,2*1,2,1,2,3*1,
     &             4,1,4,1,2,5,2,1,3,1,3*2,5,1/
C----------
C PROB. OF OCCURRENCE COEFFICIENTS
C SP      TCOV        BA       1/SAGE    BA/SAGE
      DATA POTH1 /
     &  0.011558, -0.003476, -4.717070, -0.015309,
     &  0.013073, -0.006486, -4.885640,  0.058535,
     &  0.017331,  0.008484, -2.697824,  0.018135,
     &  0.016048, -0.001808, -2.666703, -0.081739,
     &  0.017789,  0.003092,  0.755702, -0.015269,
     &  0.006343,  0.016910, -4.969932, -0.077932,
     & -0.003413,  0.005090, -7.844033, -0.020012,
     &  0.012374, -0.004095, -0.422440,  0.006656,
     &  0.015961, -0.001766,  2.348577,  0.023978,
     &  0.019857,  0.003355,  2.063106, -0.033853,
     &  0.008987, -0.012976, -3.379406,  0.042276,
     &  0.013767,  0.005637,  4.700924, -0.024066,
     &  0.015314, -0.006543,  0.647053,  0.001973,
     &  0.014120,  0.001780,-20.147840,  0.034757/
      DATA POTH2 /
     &  0.017693,  0.001188,  0.381343,  0.000390,
     &  0.013852,  0.000796,  0.872434,  0.029311,
     &  0.019001, -0.026023,  0.629758,  0.127159,
     & -0.002198, -0.011778,  1.334858,  0.052637,
     &  0.012473, -0.000119,  2.681394, -0.001130,
     &  0.020034, -0.000620,  3.167380,  0.014952,
     &  0.018084, -0.003382, -5.644269,  0.007870,
     &  0.014920, -0.001082, -1.860893,  0.020735,
     &  0.020936, -0.013398, -0.968741,  0.013742,
     &  0.018872, -0.021482, -5.591056,  0.016878,
     &  0.007739, -0.014455, -2.976664,  0.046610,
     &  0.017762,  0.003649, -1.424454, -0.013778,
     &  0.021698, -0.005112, -8.778732,  0.024828,
     &  0.017873, -0.004751, -1.536393, -0.009653,
     &  0.014568,  0.002879, -5.250633, -0.062526,
     &  0.003294, -0.014991,  1.209158,  0.038918,
     &  0.019810, -0.004930,  3.130198, -0.007978/
C----------
C 1/SAGE*DISTURBANCE TYPE COEFFICIENTS
C SP      NONE       MECH       BURN    ROAD
      DATA PDTSD1 /
     & -6.107311,  5.902798,  0.204514,  0.0,
     & -4.723021,  3.865583,  0.857437,  0.0,
     &  0.945456,  5.703588, -6.649044,  0.0,
     & -2.480139,  1.423352,  1.056787,  0.0,
     &  0.512271, -0.751467,  0.239196,  0.0,
     &  1.471227,  0.730630, -2.201857,  0.0,
     & -2.008472,  1.021768,  0.986705,  0.0,
     & -0.259681, -0.052514,  0.312195,  0.0,
     &  0.961347,  2.235664, -3.197011,  0.0,
     & -1.837033,  0.455432,  1.381601,  0.0,
     &  0.725868, -2.567226,  1.841358,  0.0,
     & -0.905012, -0.585221,  1.490232,  0.0,
     & -0.094418, -1.813987,  1.908404,  0.0,
     & -5.870269, 17.217840,-11.347580,  0.0/
      DATA PDTSD2 /
     & -1.099482, -2.018118,  3.117599,  0.0,
     & -0.533537,  0.883687, -0.350149,  0.0,
     & -1.197717,  3.193539, -1.995821,  0.0,
     & -0.306601, -1.556538,  1.863138,  0.0,
     &  3.543876, -2.077322, -1.466554,  0.0,
     &  1.083944, -1.509908,  0.425963,  0.0,
     &  5.573135, -0.359563, -5.213573,  0.0,
     & -1.058366,  2.130129, -1.071762,  0.0,
     & -2.008768,  1.897653,  0.111116,  0.0,
     & -2.802399, -1.026632,  3.829032,  0.0,
     &  0.971046, -7.029215,  6.058168,  0.0,
     &  0.462000,  4.296114, -4.758114,  0.0,
     &  7.517502, -2.886484, -4.631018,  0.0,
     &  1.465091, -2.525816,  1.060724,  0.0,
     & -0.984921,  2.809616, -1.824695,  0.0,
     &  0.372300, -1.068950,  0.696649,  0.0,
     & -1.836557,  0.267258,  1.569299,  0.0/
C----------
C  SET NATIONAL FOREST GROUPING SUBSCRIPT.
C  IF THE MODEL IS BEING USED OUTSIDE THE AREA IT WAS CALIBRATED FOR,
C  SET TO THE BOISE/PAYETTE GROUP (FOR GROUPINGS, SEE PG 33, INT-190).
C----------
C
      SELECT CASE (VARACD)
C
      CASE('IE')
        INF = INFOR(IFOR)
C
      CASE('CI')
        IF(IFOR .EQ. 1)THEN
          INF=2
        ELSE
          INF=1
        ENDIF
C
      CASE('EM')
        INF=3
C
C  OTHER VARIANTS USE THE BOISE/PAYETTE GROUPING
C
      CASE DEFAULT
        INF=1
C
      END SELECT
C----------
C  CHECK FOR DEBUG.
C----------
      CALL DBCHK(DEBUG,'CVBROW',6,ICYC)
C----------
C  BEGIN EXECUTION.
C----------
      IP1 = ICYC + 1
      IF (LCOV) GO TO 2
C----------
C  CALL THE OPTION PROCESSOR TO FIND WHETHER THE COVER KEYWORD
C  HAS BEEN BEEN SCHEDULED THIS CYCLE.
C----------
      CALL OPFIND (1,MYACT(2),NTODO)
      IF (NTODO .EQ. 0) GO TO 2
C----------
C  GET THE ACTIVITY, AND SIGNAL THAT IT IS DONE.
C----------
      DO 1 I=1,NTODO
      CALL OPGET (I,0,KDT,IACT,NP,A)
      IF (IACT.LT.0) GOTO 1
      CALL OPDONE (I,KDT)
      LCOV = .TRUE.
      ICVBGN = IP1
    1 CONTINUE
    2 CONTINUE
C----------
C  RETURN IF THE SHRUBS KEYWORD HAS NOT BEEN SPECIFIED.
C----------
      IF (.NOT. LBROW) RETURN
C----------
C  IF COVER NOT ACTIVE IN THE FIRST CYLE, DO THE SHRUB CALCULATIONS
C  ANYWAY TO COMPUTE CALIBRATION VALUES.
C----------
C
      LSAGE = .FALSE.
C======================================================================
C *** START OF PROJECTION (CYCLE=0) ***
C----------
      IF (.NOT. LSTART) GO TO 30
C----------
C  SET HABITAT TYPE TO STAND HABITAT TYPE IF NOT INPUT ON
C  SHRUBS KEYWORD.
C----------
      IF (IHTYPE .EQ. 0) IHTYPE = ICL5
C------------------
C  CHECK FOR VALID HABITAT TYPE.
C  SET OVERSTORY UNION, UNDERSTORY UNION SUBSCRIPTS.
C------------------
      DO 5 I=1,34
      IF (IHTYPE .EQ. IHCODE(I)) GO TO 10
    5 CONTINUE
      LBROW = .FALSE.
      WRITE (JOSTND,9007) IHTYPE
 9007 FORMAT (/'********  WARNING: ',I5,' IS AN INVALID HABITAT TYPE',
     >        ' CODE FOR PROCESSING SHRUBS OPTIONS.')
      CALL RCDSET (10,.TRUE.)
      RETURN
   10 CONTINUE
      ICODE = I
      IOV = IPHABO(ICODE)
      IUN = IPHABU(ICODE)
      ITUN = ITHABU(ICODE)
C----------
C  SET HAB. TYPE DUMMY VARIABLES  FOR IRWIN AND PEEK RELATIONSHIPS, IF
C  APPROPRIATE:  520=GF/CLUN  530=WC/CLUN  570=WH/CLUN.
C----------
      IGFHAB=0
      ICEHAB=0
      IF (IHTYPE .EQ. 520) IGFHAB=1
      IF (IHTYPE .EQ. 530) ICEHAB=1
C----------
C  SET TIME SINCE DISTURBANCE:
C   1) TIME SINCE DISTURBANCE =  STAND AGE IF NOT READ FROM SHRUBS
C      KEYWORD.
C   2) IF SAGE AND IAGE BOTH ARE LESS THAN 3.0, SET SAGE = 3.0 YEARS,
C      AND FLAG WITH LSAGE.
C----------
      IF (SAGE .LT. 0.0) SAGE = FLOAT(IAGE)
      IF (SAGE .GE. 3.0) GO TO 20
      SAGE = 3.0
      LSAGE = .TRUE.
   20 CONTINUE
C======================================================================
C  CALL **CVSCON TO COMPUTE CONSTANTS WHICH HOLD FOR THE
C  DURATION OF THE PROJECTION.  **CVSCON** RETURNS PIECES OF
C  EQUATIONS OF THE FORM X'B FOR SPECIES PROBABILITY (PCON), TOTAL SHRUB
C  COVER (TCON), SPECIES HEIGHT (HCON), AND SPECIES COVER (CCON).
C----------
      CALL CVSCON 
   30 CONTINUE
C======================================================================
C  *** START PROJECTION CYCLE CALCULATIONS ***
C----------
C  INCREMENT "TIME SINCE DISTURBANCE".
C
C  1) RESET SAGE TO IAGE IF RESETAGE HAS BEEN SCHEDULED THIS CYCLE.
C  2) IF THE SECOND CALL IN THE CYCLE (AFTER TREES HAVE BEEN UPDATED),
C     INCREMENT BY THE LENGTH OF THE CYCLE.
C----------
C  CALL THE OPTION PROCESSOR TO SEE IF RESETAGE HAS BEEN
C  SCHEDULED THIS CYCLE.
C----------
      IF ((LTHIN).OR.(LSTART)) GO TO 35
      CALL OPFIND (1,MYACT(1),NTODO)
C----------
C  IF NOT, SKIP TO STATEMENT 35.
C----------
      IF (NTODO .EQ. 0) GO TO 35
C----------
C  SET TIME SINCE DISTURBANCE TO THE NEW STAND AGE.
C----------
      DO 32 I=1,NTODO
      CALL OPGET (I,0,KDT,IACT,NP,A)
   32 CONTINUE
      SAGE = A(1)
   35 CONTINUE
C
      IF ((.NOT. LSTART).AND.(.NOT. LTHIN))
     & SAGE = SAGE + (IY(IP1) - IY(ICYC))
C----------
C  USE POST-THIN DENSITY STATISTICS IF THINNING HAS JUST OCCURRED.
C  CALL **CVCW** TO CALCULATE CRAREA FOR THINNING TEST.
C  IF THINNING HAS LOWERED CANOPY CLOSURE BELOW 50%, AND IF THE
C  VOLUME REMOVED IS AT LEAST 20% OF THE VOLUME BEFORE REMOVAL,
C  SET "TIME SINCE DISTURBANCE" BACK TO 3.0 YEARS, AND FLAG
C  THAT IT HAS BEEN RESET.
C  TURN OFF CALIBRATION FOLLOWING A THINNING.
C----------
      ITHN = 1
      IF (.NOT. LTHIN) GO TO 40
      IP1 = ICYC
      ITHN = 2
      CALL CVCW (LTHIN)
      PCTEST = CRAREA/43560.
      VTEST = OCVREM(7)/OCVCUR(7)
      IF ((VTEST .LT. .20).OR.(PCTEST .GT. .50)) GO TO 37
      SAGE = 3.0
      LSAGE = .TRUE.
   37 CONTINUE
      LCALIB = .FALSE.
   40 CONTINUE
      IF (DEBUG) WRITE (JOSTND,9001) ICYC,SAGE,IP1,ITHN,IY(IP1),
     &      PCTEST,VTEST
 9001 FORMAT (/'**CALLING CVBROW, ICYC =',I2 /
     & 'SAGE=',F5.1,'  IP1=',I2,'  ITHN=',I2,'  IY(IP1)=',I4,
     & '  PCTEST=',F5.2,'  VTEST=',F5.2)
      IF (DEBUG) WRITE (JOSTND,7001) IHTYPE,IOV,IUN,ITUN,IPHYS,INF,
     &    IDIST
 7001 FORMAT ('IHTYPE=',I5,'  IOV=',I5,'  IUN=',I5,'  ITUN=',I5,
     &   '  IPHYS=',I5,'  INF=',I5,'  IDIST=',I5)
C----------
C SAVE TIME SINCE DISTURBANCE FOR OUTPUT.
C----------
      TIMESD(IP1,ITHN) = SAGE
C----------
C  DON'T COMPUTE SHRUBS IF TIME SINCE DISTURBANCE IS GREATER THAN
C  40 YEARS.
C----------
      IF (.NOT. LCOV) GO TO 80
      IF (SAGE .GT. 40.) RETURN
C----------------------------------------------------------------------
C  COMPUTE TOTAL COVER OF SHRUBS. (LAURSEN 1984)
C----------------------------------------------------------------------
C  1)  PROBABILITY THAT TOTAL SHRUB COVER ON THE PLOT EXCEEDS ZERO.
C        P(COV>0) = 1/(1+EXP(-XB))
C----------
      PGT0(IP1,ITHN) = 1/(1 + EXP(-(TCON(1) + .0138*SAGE -
     &                 0.00412*BA - .000213*BA*SAGE)))
C----------
C  2) TOTAL COVER GIVEN THAT COVER >0
C  (CORRECTED FOR BIAS BY ADDING .5*MSE=.3238953).
C  LN(TCOV) = A+BX
C----------
      TCOV = EXP(TCON(2) + .02885483*SAGE - .00020194*BA*SAGE +
     &       SAGE*TDTSD(IDIST) + .3238953)
      IF (DEBUG) WRITE (JOSTND,9553) TCON(1),SAGE,BA,
     &                PGT0(IP1,ITHN),TCON(2),TDTSD(IDIST),TCOV
 9553 FORMAT (/'TCON(1)=',F15.10,'  SAGE=',F5.1,'  BA=',F10.4,
     &     '  PGT0=',F15.10/'TCON(2)=', F15.10,
     &     '  TDTSD(IDIST)=',F15.10,'  TCOV=',F15.10)
C----------------------------------------------------------------------
C  SHRUB SPECIES PROBABILITY OF OCCURRENCE.  (SCHAROSCH 1984)
C----------------------------------------------------------------------
      DO 42 ISPI=1,31
      CSCAL = POTHER(1,ISPI)*TCOV +
     &        POTHER(2,ISPI)*BA + POTHER(3,ISPI)/SAGE +
     &        POTHER(4,ISPI)*BA/SAGE + PDTSD(IDIST,ISPI)/SAGE
      PB(ISPI) = 1.0/(1.0 + EXP(-(PCON(ISPI) + CSCAL)))
   42 CONTINUE
C----------------------------------------------------------------------
C  SHRUB SPECIES HEIGHT (FEET).   (LAURSEN 1984)
C  (LOG-LINEAR EQNS ARE CORRECTED FOR BIAS BY ADDING .5*MSE)
C----------------------------------------------------------------------
C  IF CALIBRATION BY HEIGHT LAYER IS BEING PERFORMED, COMPUTE
C  RESIDUAL COVER (OBSERVED - PREDICTED).  DO IN CYCLE 0, AND
C  CARRY THE VALUE THROUGH THE PROJECTION.
C----------
      IF ((LCAL1).AND.(LSTART)) RESIDC = SUMCVR - TCOV
C
      BAREA = BA
      IF (BA .LE. 1.0) BAREA = 1.0
      ALNBA = ALOG(BAREA)
      ALDTS = ALOG(SAGE)
      BAC10 = BA - 30.573
      BAC23 = BA - 11.945
      BAC29 = BA - 20.119
C
      SH(1) = HCON(1)
      SH(2) = HCON(2)
      SH(3) = HCON(3)
      SH(4) = EXP(HCON(4)-0.582791/SAGE+0.001952*RESIDC+
     &        0.007388*TCOV+.07339)
      SH(5) = EXP(HCON(5)+0.002937*TCOV+0.002149*RESIDC
     &        -0.000621*BA+.06798)
      SH(6) = EXP(HCON(6)+0.068334*ALNBA+0.174239*ALDTS+
     &        .007149*TCOV+.007753*RESIDC+.16350)
      SH(7) = HCON(7)
      SH(8) = EXP(HCON(8)+0.001631*RESIDC+0.001889*TCOV+
     &  0.178257*ALDTS-0.012620*SAGE+0.023587*ALNBA-0.000341*BA+.06231)
      SH(9) = HCON(9)+0.070653*ALNBA+0.267706*ALDTS-0.005634*SAGE+
     &        0.016909*TCOV+0.008538*RESIDC
      SH(10)= HCON(10)+0.010595*ALNBA-1.313471/SAGE+0.009158*RESIDC+
     &        0.015028*TCOV
      SH(11)= EXP(HCON(11)+0.001716*RESIDC+0.003271*TCOV-
     &        0.014447*BA/SAGE+BA*H11DTS(IDIST)+.05623)
      SH(12)= EXP(HCON(12)-0.009299*ALNBA+0.001613*TCOV+
     &        0.001325*RESIDC+.07756)
      SH(13)= EXP(HCON(13)+0.039276*ALNBA-0.001362*BA+0.024601*ALDTS+
     &        0.004278*TCOV+0.003161*RESIDC+.07116)
      SH(14)= EXP(HCON(14)-0.692003/SAGE+0.036054*ALNBA+0.003684*RESIDC+
     &        0.004300*TCOV+.02645)
      SH(15)= EXP(HCON(15)-0.000522*BA+0.094560*ALDTS+
     &        0.005903*TCOV+0.002175*RESIDC+.10828)
      SH(16)= EXP(HCON(16)+0.000797*BA+H16DTS(IDIST)*ALDTS+
     &        0.004205*TCOV+0.003230*RESIDC+.06272)
      SH(17)= EXP(HCON(17)-0.941824/SAGE-0.002898*TCOV+
     &        0.000816*RESIDC+.03773)
      SH(18)= EXP(HCON(18)+.08319)
      SH(19)= EXP(HCON(19)+0.004244*TCOV+0.003993*RESIDC+
     &        0.073122*ALNBA+0.334423*ALDTS+.29502)
      SH(20)= EXP(HCON(20)+0.010526*TCOV+0.003868*RESIDC-
     &        0.391740/SAGE-0.000384*BA+.11944)
      SH(21)= EXP(HCON(21)+0.003185*RESIDC+0.008998*TCOV+
     &        0.103704*ALDTS+0.002357*BA+.09106)
      SH(22)= EXP(HCON(22)+0.228213*ALDTS-0.013028*SAGE+0.003357*BA-
     &  0.000003*BA*BA+0.013626*TCOV+0.002758*RESIDC+.12963)
      SH(23)= EXP(HCON(23)+0.002668*TCOV+0.003559*RESIDC-
     & 1.708042/SAGE+0.002716*BAC23-0.000027*BAC23*BAC23+.05472)
      SH(24)= HCON(24)+0.025771*TCOV+0.017823*RESIDC-
     &        1.349370/SAGE
      SH(25)= EXP(HCON(25)+0.002177*TCOV+
     &        0.002429*RESIDC+.06477)
      SH(26)= EXP(HCON(26)+0.038519*ALNBA+0.274757*ALDTS-0.012626*SAGE+
     &        0.004241*TCOV+0.002252*RESIDC+.07819)
      SH(27)= EXP(HCON(27)+0.008813*TCOV+
     &        0.005733*RESIDC+.08837)
      SH(28)= EXP(HCON(28)+0.004620*RESIDC-
     &        3.798911/SAGE+.128902)
      SH(29)= EXP(HCON(29)+0.005564*RESIDC+0.010411*TCOV+
     &  0.115970*ALDTS+0.004220*BAC29-0.000023*BAC29*BAC29+.11118)
      SH(30)= EXP(HCON(30)+0.163050*ALDTS-0.002211*TCOV+
     &        0.001493*RESIDC+.04912)
      SH(31)= EXP(HCON(31)+.004520*TCOV+0.001510*RESIDC-
     &        0.173325/SAGE+.08724)
C----------------------------------------------------------------------
C  SHRUB SPECIES PERCENT COVER   (LAURSEN 1984)
C  (LOG-LINEAR EQNS ARE CORRECTED FOR BIAS BY ADDING .5*MSE)
C----------------------------------------------------------------------
C  FIRST, COMPUTE LOG OF PREDICTED SPECIES HEIGHT, AND RESIDH(I)
C  (OBS - PRED) IF SHRUB HEIGHT CALIBRATION BY SPECIES IS BEING
C  PERFORMED. DO IN CYCLE 0, AND CARRY THROUGH THE PROJECTION.
C----------
      TOTLCV(IP1,ITHN) = 0.0
      DO 48 ISPI = 1,31
      SHH = SH(ISPI)
      IF (SHH .LE. 0.0) SHH = .1
      ALNHT(ISPI) = ALOG(SHH)
      IF ((LSTART).AND.(SHRBHT(ISPI).GE.0.0))
     &     RESIDH(ISPI) = SHRBHT(ISPI) - SH(ISPI)
   48 CONTINUE
C----------
C  SORT THE SHRUBS BY PREDICTED HEIGHT TO DETERMINE PERCENT
C  COVER ABOVE THE CURRENT HEIGHT.
C----------
      CALL RDPSRT (31,SH,HTINDX,.TRUE.)
C
      PBCUM = 0.0
      DO 501 J=1,31
      K =HTINDX(J)
      IF (J .EQ. 1) CABHT(K) = 0.0
      IF (J .EQ. 1) GO TO (51,52,53,54,55,56,57,58,59,510,511,512,
     &                     513,514,515,516,517,518,519,520,521,522,
     &                     523,524,525,526,527,528,529,530,531),K
      JM1 = J - 1
      KM1 = HTINDX(JM1)
      PBCUM = PBCUM + PBCV(KM1)
      CABHT(K) = PBCUM
      GO TO (51,52,53,54,55,56,57,58,59,510,511,512,
     &       513,514,515,516,517,518,519,520,521,522,
     &       523,524,525,526,527,528,529,530,531),K
C
 51   CV(1) = EXP(CCON(1)-0.007130*CABHT(1)+.23176)
      GO TO 50
 52   CV(2) = EXP(CCON(2)+.078842)
      GO TO 50
 53   CV(3) = EXP(CCON(3)+0.006036*SAGE+.28364)
      GO TO 50
 54   CV(4) = EXP(CCON(4)+1.128531*ALNHT(4)+0.208575*RESIDH(4)+
     &        0.003494*SAGE+0.001445*BA+.123307)
      GO TO 50
 55   CV(5) = EXP(CCON(5)+5.617948*ALNHT(5)-2.102114*SH(5)+
     &        0.083065*RESIDH(5)-0.00488*CABHT(5)+ 0.002444*BA+.195726)
      GO TO 50
 56   CV(6) = EXP(CCON(6)+0.112634*ALNBA-0.010360*CABHT(6)+
     &        0.620216*ALNHT(6)+0.009096*RESIDH(6)+.253561)
      GO TO 50
 57   CV(7) = EXP(CCON(7)-0.004303*CABHT(7)+.306118)
      GO TO 50
 58   CV(8) = EXP(CCON(8)-0.042881*ALNBA+0.745749*SH(8)-
     &        0.039454*SH(8)*SH(8)+0.102498*RESIDH(8)+.147753)
      GO TO 50
 59   CV(9) = 200./(EXP(CCON(9)-3.612059*ALNHT(9)-0.199540*RESIDH(9)+
     &        0.009250*CABHT(9)+0.010110*SAGE)+1.0)
      GO TO 50
 510  CV(10)=200./(EXP(CCON(10)-0.002451*BAC10+0.000035*BAC10*
     &  BAC10+0.248107*ALDTS+0.013535*CABHT(10)-4.936937*ALNHT(10)-
     &       0.123863*RESIDH(10))+1.0)
      GO TO 50
 511  CV(11)=EXP(CCON(11)-0.005229*CABHT(11)+2.786906*ALNHT(11)+
     &       0.145728*RESIDH(11)+0.418976*ALDTS-0.057897*SAGE+.153522)
      GO TO 50
 512  CV(12)=EXP(CCON(12)-0.0034056*SAGE+1.493548*ALNHT(12)+
     &       0.083533*RESIDH(12)-0.002010*CABHT(12)+.09473)
      GO TO 50
 513  CV(13)=EXP(CCON(13)-0.069935*ALNBA-0.007007*CABHT(13)+
     &       1.429518*SH(13)-0.084391*SH(13)*SH(13)+
     &       0.202652*RESIDH(13)+.156056)
      GO TO 50
 514  CV(14)=CCON(14)-0.151413*CABHT(14)+25.163600*ALNHT(14)+
     &       0.603551*RESIDH(14)
      GO TO 50
 515  CV(15)=EXP(CCON(15)+1.511617*ALNHT(15)-0.251851*SH(15)+
     &       0.087134*RESIDH(15)-0.003701*CABHT(15)-
     &       0.091528*ALDTS-0.052584*ALNBA+.249182)
      GO TO 50
 516  CV(16)=200./(EXP(CCON(16)+0.003013*BA-0.147043*RESIDH(16)-
     &       5.284045*ALNHT(16)+0.468977*SH(16)+0.014973*CABHT(16)+
     &       0.119072*ALDTS)+1.0)
      GO TO 50
 517  CV(17)=EXP(CCON(17)-0.004972*CABHT(17)+1.385094*ALNHT(17)+
     &       0.089854*RESIDH(17)-0.226805*ALDTS+.283218)
      GO TO 50
 518  CV(18)=EXP(CCON(18)-0.005018*CABHT(18)+.245277)
      GO TO 50
 519  CV(19)=EXP(CCON(19)+0.040967*SH(19)+.044127*RESIDH(19)+.267191)
      GO TO 50
 520  CV(20)=200./(EXP(CCON(20)+0.007244*SAGE-0.037231*ALNBA+
     &  0.005470*CABHT(20)-1.580698*ALNHT(20)-0.066696*RESIDH(20))+1.0)
      GO TO 50
 521  CV(21)=200./(EXP(CCON(21)+0.011024*CABHT(21)-2.590103*ALNHT(21)-
     &       0.076644*RESIDH(21)+0.005074*BA)+1.0)
      GO TO 50
 522  CV(22)=200./(EXP(CCON(22)-0.642331*ALNHT(22)-0.065580*RESIDH(22)+
     &       0.002359*CABHT(22))+1.0)
      GO TO 50
 523  CV(23)=200./(EXP(CCON(23)-3.761727*ALNHT(23)-0.120113*RESIDH(23)+
     &       0.009849*CABHT(23)+0.817357*ALDTS+0.118734*ALNBA)+1.0)
      GO TO 50
 524  CV(24)=200./(EXP(CCON(24)+0.002371*BA+0.016261*SAGE-
     & 3.633245*ALNHT(24)-0.184807*RESIDH(24)+0.017470*CABHT(24))+1.0)
      GO TO 50
 525  CV(25)=EXP(CCON(25)+.160346)
      GO TO 50
 526  CV(26)=EXP(CCON(26)-0.003541*BA-0.094480*ALDTS-0.004642*CABHT(26)+
     &       0.814695*SH(26)-0.044342*SH(26)*SH(26)+
     &       0.090125*RESIDH(26)+.172664)
      GO TO 50
 527  CV(27)=EXP(CCON(27)-0.011936*CABHT(27)+0.718063*SH(27)-
     &       0.024411*SH(27)*SH(27)+0.020491*RESIDH(27)+.252399)
      GO TO 50
 528  CV(28)=EXP(CCON(28)+0.172636*SH(28)-0.004438*SH(28)*SH(28)+
     &       0.068645*RESIDH(28)+.185518)
      GO TO 50
 529  CV(29)=200./(EXP(CCON(29)+0.181524*ALDTS-1.260551*ALNHT(29)-
     &       0.039281*RESIDH(29)+0.006094*CABHT(29))+1.0)
      GO TO 50
 530  CV(30)=EXP(CCON(30)+0.300947*SH(30)+0.082204*RESIDH(30)-
     &       0.004439*BA+.172504)
      GO TO 50
 531  CV(31)=EXP(CCON(31)-0.004196*CABHT(31)+2.298975*ALNHT(31)+
     &       0.129692*RESIDH(31)-0.059705*ALNBA+.196114)
   50 PBCV(K) = PB(K)*CV(K)
C----------
C  TOTAL COVER, REPORTED FOR ALL SPECIES, IS THE SUM OF INDIVIDUAL
C  SPECIES PREDICTED COVER TIMES PROBABILITY OF OCCURRENCE.
C----------
      TOTLCV(IP1,ITHN) = TOTLCV(IP1,ITHN) + PBCV(K)
  501 CONTINUE
C------------------
C  COMPUTE IRWIN AND PEEK STUFF IF APPROPRIATE HABITAT TYPE.
C------------------
      IF ((IHTYPE .NE. 520).AND.(IHTYPE .NE. 530).AND.
     &     (IHTYPE .NE. 570)) GO TO 62
C----------------------------------------------------------------------
C  SHRUB BIOMASS
C  SBMASS = BIOMASS IN LB/AC
C ( 1 KG/HA )( 2.2046226 LB/KG )( 1 HA/2.4710538 AC ) = 0.8921791 LB/AC
C----------------------------------------------------------------------
      SBMASS(IP1,ITHN) = EXP(5.52+1.29*ALOG(SAGE)-0.1*SAGE-.01*RELDEN)
      SBMASS(IP1,ITHN) = SBMASS(IP1,ITHN)*0.8921791
C----------------------------------------------------------------------
C  TWIG PRODUCTION  (TWIG/SQFT)     (10.76387 SQFT/SQM)
C----------------------------------------------------------------------
      TWIGS(IP1,ITHN) = EXP(2.67+0.98*ALOG(SAGE)-0.08*SAGE-0.09*RELDEN+
     &  0.69*IGFHAB+0.52*ICEHAB)
      TWIGS(IP1,ITHN) = TWIGS(IP1,ITHN)*10.76387
C
      IF (DEBUG) WRITE (JOSTND,9005) SAGE,RELDEN,IGFHAB,ICEHAB,
     &  SBMASS(IP1,ITHN),TWIGS(IP1,ITHN)
 9005 FORMAT (/'SAGE=',F5.1,'   RELDEN=',F5.2,'  IGFHAB=',I5,
     &  '  ICEHAB=',I5/'SBMASS(IP1,ITHN)=',F10.5,
     &  '  TWIGS(IP1,ITHN)=',F10.5)
C
   62 CONTINUE
C----------
C  WRITE DEBUG OUTPUT.
C----------
      IF (.NOT.DEBUG) GO TO 61
      WRITE (JOSTND,9555)
 9555 FORMAT (/'BEFORE CALIBRATION'/
     &'       J       ISPI     SNAME   SH(I)    ',
     &         '   CV(I)     PB(I)    CABHT(I)   PBCV(I)'/)
      DO 60 J=1,31
      K = HTINDX(J)
      WRITE (JOSTND,9554) J,K,SNAME(K),SH(K),
     &                    CV(K),PB(K),CABHT(K),PBCV(K)
 9554 FORMAT (2I10,6X,A4,6F10.5)
   60 CONTINUE
   61 CONTINUE
C======================================================================
C  *** BEGIN CALIBRATION PROCEDURE ***
C----------
C  IF THIS IS START OF PROJECTION, AND CALIBRATION IS BEING
C  DONE, PASS SPECIES SUBSCRIPTS SORTED BY HEIGHT TO **CVBCAL**
C  TO COMPUTE THE SHRUB SCALING FACTORS.
C----------
      IF (LSTART .AND. LCALIB) CALL CVBCAL(HTINDX)
C----------
C  APPLY SCALING FACTORS TO PREDICTIONS IF THEY ARE STILL IN EFFECT.
C----------
      IF (.NOT. LCALIB) GO TO 75
      TOTLCV(IP1,ITHN) = 0.0
C
      IF (.NOT. LCAL1) GO TO 64
      DO 63 ISPI=1,31
      SH(ISPI) = SH(ISPI)*BHTCF(ISPI)
      PBCV(ISPI) = PBCV(ISPI)*BPCCF(ISPI)
      TOTLCV(IP1,ITHN) = TOTLCV(IP1,ITHN) + PBCV(ISPI)
   63 CONTINUE
   64 CONTINUE
C
      IF (.NOT. LCAL2) GO TO 66
      DO 65 ISPI=1,31
      IF ((SHRBHT(ISPI) .NE. 0.0).AND.(SHRBPC(ISPI) .NE. 0.0)) GO TO 67
      PB(ISPI) = 0.0
      SH(ISPI) = 0.0
      PBCV(ISPI) = 0.0
   67 CONTINUE
      SH(ISPI) = SH(ISPI)*BHTCF(ISPI)
      PBCV(ISPI) = PBCV(ISPI)*BPCCF(ISPI)
      TOTLCV(IP1,ITHN) = TOTLCV(IP1,ITHN) + PBCV(ISPI)
   65 CONTINUE
   66 CONTINUE
C
      IF (.NOT.DEBUG) GO TO 71
      WRITE (JOSTND,9755)
 9755 FORMAT (/'AFTER CALIBRATION'/
     &'       J       ISPI     SNAME   SH(I)    ',
     &         '   CV(I)     PB(I)    CABHT(I)   PBCV(I)'/)
      DO 70 J=1,31
      K = HTINDX(J)
      WRITE (JOSTND,9554) J,K,SNAME(K),SH(K),
     &                CV(K),PB(K),CABHT(K),PBCV(K)
   70 CONTINUE
   71 CONTINUE
   75 CONTINUE
C----------
C  *** END CALIBRATION PROCEDURE ***
C======================================================================
      IF (DEBUG) WRITE (JOSTND,9543) PGT0(IP1,ITHN),TCOV,
     & CLOW(IP1,ITHN),CMED(IP1,ITHN),CTALL(IP1,ITHN),TOTLCV(IP1,ITHN)
 9543 FORMAT (/'LAURSEN P(COV>0) :     PGT0(IP1,ITHN) = ',F10.6
     &        /'LAURSEN TOTAL SHRUB COVER :      TCOV = ',F10.6
     &        /'SUM OF CV(I)*PB(I) : LOW = ',F10.6,'  MED = ',F10.6,
     &         '  TALL = ',F10.6/
     &         'SUM OF CV(I)*PB(I) : TOTLCV(IP1,ITHN) = ',F10.6)
C----------
C  IF SAGE HAS BEEN SET TO 3.0 IN CYCLE 0, OR AFTER A THIN,
C  SUBTRACT 3.0 HERE, TO CORRESPOND TO NEXT CYCLE BOUNDARY.
C----------
   80 CONTINUE
      IF (LSAGE) SAGE = SAGE - 3.0
      RETURN
      END
