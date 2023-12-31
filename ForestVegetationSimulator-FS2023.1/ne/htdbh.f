      SUBROUTINE HTDBH (IFOR,ISPC,D,H,MODE)
      IMPLICIT NONE
C----------
C NE $Id$
C----------
C  THIS SUBROUTINE CONTAINS THE DEFAULT HEIGHT-DIAMETER RELATIONSHIPS
C  FROM THE INVENTORY DATA.  IT IS CALLED FROM CRATET TO DUB MISSING
C  HEIGHTS, AND FROM REGENT TO ESTIMATE DIAMETERS (PROVIDED IN BOTH
C  CASES THAT LHTDRG IS SET TO .TRUE.).
C
C  COEFFICIENTS DEVELOPED FOR THE SN VARIANT USING SOUTHERN TREE DATA.
C
C  DEFINITION OF VARIABLES:
C         D = DIAMETER AT BREAST HEIGHT
C         H = TOTAL TREE HEIGHT (STUMP TO TIP)
C         DB= BUDWIDTH(INCHES) AT HEIGHT = 5.51 FT.
C
C  LOCAL ARRAYS
C         SNALL = CURTIS-ARNEY COEFFICIENTS FOR ALL SPECIES.  ALL
C                 SOUTHERN TREE DATA WERE USED IN DEVELOPMENT OF
C                 THESE COEFFS.
C        SNDBAL = BUDWITH, TRANSITION DIAMETER, ESTIMATES FOR ALL
C                 SPECIES
C        IWYKCA = 0 IF USING WKYOFF EQNS; 1 IF USING CURTIS-ARNEY
C
C      MODE = MODE OF OPERATING THIS SUBROUTINE
C             0 IF DIAMETER IS PROVIDED AND HEIGHT IS DESIRED
C             1 IF HEIGHT IS PROVIDED AND DIAMETER IS DESIRED
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
COMMONS
C
      INTEGER MODE,ISPC,IFOR,J,I
      REAL H,D,P2,P3,P4,DB,HAT3
      REAL SNALL(3,108), SNDBAL(108)
      INTEGER IWYKCA(108)
      LOGICAL DEBUG
      INTEGER IDANUW
C
C================================================
C     SPECIES LIST FOR NORTHEASTERN UNITED STATES
C================================================
C     1 = BALSAM FIR (BF)
C     2 = TAMARACK (TA)
C     3 = WHITE SPRUCE (WS)
C     4 = RED SPRUCE (RS)
C     5 = NORWAY SPRUCE (NS)
C     6 = BLACK SPRUCE (BS)
C     7 = OTHER SPRUCE (PI)
C     8 = RED PINE (RN)
C     9 = EASTERN WHITE PINE (WP)
C    10 = LOBLOLLY PINE (LP)
C    11 = VIRGINIA PINE (VP)
C    12 = N. WHITE CEDAR (WC)
C    13 = ATLANTIC WHITE CEDAR (AW)
C    14 = EASTERN REDCEDAR (RC)
C    15 = OTHER CEDAR (OC)
C    16 = EASTERN HEMLOCK (EH)
C    17 = OTHER HEMLOCK (HM)
C    18 = OTHER PINE (OP)
C    19 = JACK PINE (JP)
C    20 = SHORLEAF PINE (SP)
C    21 = TABLE MOUNTAIN PINE (TM)
C    22 = PITCH PINE (PP)
C    23 = POND PINE (PD)
C    24 = SCOTCH PINE (SC)
C    25 = OTHER SOFTWOODS (OS)
C    26 = RED MAPLE (RM)
C    27 = SUGAR MAPLE (SM)
C    28 = BLACK MAPLE (BM)
C    29 = SILVER MAPLE (SV)
C    30 = YELLOW BIRCH (YB)
C    31 = SWEET BIRCH (SB)
C    32 = RIVER BIRCH (RB)
C    33 = PAPER BIRCH (PB)
C    34 = GRAY BIRCH (GB)
C    35 = HICKORY (HI)
C    36 = PIGNUT HICKORY (PH)
C    37 = SHELLBARK HICKORY (SL)
C    38 = SHAGBARK HICKORY (SH)
C    39 = MOCKERNUT HICKORY (MH)
C    40 = AMERICAN BEECH (AB)
C    41 = ASH (AS)
C    42 = WHITE ASH (WA)
C    43 = BLACK ASH (BA)
C    44 = GREEN ASH (GA)
C    45 = PUMPKIN ASH (PA)
C    46 = YELLOW POPLAR (YP)
C    47 = SWEETGUM (SU)
C    48 = CUCUMBERTREE (CT)
C    49 = QUAKING ASPEN (QA)
C    50 = BALSAM POPLAR (BP)
C    51 = EASTERN COTTONWOOD (EC)
C    52 = BIGTOOTH ASPEN (BT)
C    53 = SWAMP COTTONWOOD (PY)
C    54 = BLACK CHERRY (BC)
C    55 = WHITE OAK (WO)
C    56 = BUR OAK (BR)
C    57 = CHINKAPIN OAK (CK)
C    58 = POST OAK (PO)
C    59 = OTHER OAKS (OK)
C    60 = SCARLET OAK (SO)
C    61 = SHINGLE OAK (QI)
C    62 = WATER OAK (WK)
C    63 = PIN OAK (NP)
C    64 = CHESTNUT OAK (CO)
C    65 = SWAMP WHITE OAK (SW)
C    66 = SWAMP CHESTNUT OAK (SN)
C    67 = N. RED OAK (RO)
C    68 = S. RED OAK (SK)
C    69 = BLACK OAK (BO)
C    70 = CHERRYBARK OAK (CB)
C    71 = OTHER HARDWOODS (OH)
C    72 = BUCKEYE (BU)
C    73 = YELLOW BUCKEYE (YY)
C    74 = WATER BIRCH (WR)
C    75 = HACKBERRY (HK)
C    76 = PERSIMMON (PS)
C    77 = AMERICAN HOLLY (HY)
C    78 = BUTTERNUT (BN)
C    79 = BLACK WALNUT (WN)
C    80 = OSAGE-ORANGE (OO)
C    81 = MAGNOLIA (MG)
C    82 = SWEETBAY (MV)
C    83 = APPLE SP. (AP)
C    84 = WATER TUPELO (WT)
C    85 = BLACKGUM (BG)
C    86 = SOURWOOD (SD)
C    87 = PAULOWNIA (PW)
C    88 = SYCAMORE (SY)
C    89 = WILLOW OAK (WL)
C    90 = BLACK LOCUST (BK)
C    91 = BLACK WILLOW (BL)
C    92 = SASSAFRAS (SS)
C    93 = AMERICAN BASSWOOD (BW)
C    94 = WHITE BASSWOOD (WB)
C    95 = OTHER ELM (EL)
C    96 = AMERICAN ELM (AE)
C    97 = SLIPPERY ELM (RL)
C    98 = NON-COMM HARDWOODS (NC)
C    99 = BOXELDER (BE)
C   100 = STRIPED MAPLE (ST)
C   101 = AILANTHUS (AI)
C   102 = SERVICEBERRY (SE)
C   103 = AMERICAN HORNBEAM (AH)
C   104 = FLOWERING DOGWOOD (DW)
C   105 = HAWTHORN (HT)
C   106 = E. HOPHORNBEAM (HH)
C   107 = CHERRY,PLUM (PL)
C   108 = PIN CHERRY (PR)
C----------
C
C----------
C     CURTIS-ARNEY COEFFICIENTS
C     ALL SOUTHERN DATA SNALL(I,J) I1=>P2, I2=>P3, I3=>P4, J= SPECIES
C----------
C
      DATA ((SNALL(I,J),I=1,3), J= 1,15)/
C 1=BALSAM FIR             USE SN FIR (SP.) (1)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 2=TAMARACK               USE SN FIR (SP.) (1)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 3=WHITE SPRUCE           USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 4=RED SPRUCE             USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 5=NORWAY SPRUCE          USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 6=BLACK SPRUCE           USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 7=OTHER SPRUCE           USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 8=RED PINE               USE SN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 9=EASTERN WHITE PINE     USE SN EASTERN WHITE PINE (12)
     & 2108.844224,     5.65948135,     -0.18563136 ,
C 10=LOBLOLLY PINE         USE SN LOBLOLLY PINE (13)
     & 243.860648,      4.28460566,     -0.47130185 ,
C 11=VIRGINIA PINE         USE SN VIRGINIA PINE (14)
     & 926.1802712,     4.46209203,     -0.20053974 ,
C 12=N.WHITE CEDAR         USE SN FIR (SP.) (1)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 13=A.WHITE CEDAR         USE SN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 14=EASTERN REDCEDAR      USE SN VIRGINIA PINE (14)
     & 926.1802712,     4.46209203,     -0.20053974 ,
C 15=OTHER CEDAR           USE SN VIRGINA PINE (14)
     & 926.1802712,     4.46209203,     -0.20053974 /
C
      DATA ((SNALL(I,J),I=1,3), J= 16,30)/
C 16=EASTERN HEMLOCK       USE SN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 17=OTHER HEMLOCK         USE SN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 18=OTHER PINE            USE SN PITCH PINE (10)
     & 208.7773185,     3.72806565,     -0.410875   ,
C 19=JACK PINE             USE SN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 20=SHORTLEAF PINE        USE SN SHORTLEAF PINE (5)
     & 444.0921666,     4.11876312,     -0.30617043 ,
C 21=TABLE MTN PINE        USE SN PITCH PINE (10)
     & 208.7773185,     3.72806565,     -0.410875   ,
C 22=PITCH PINE            USE SN PITCH PINE (10)   
     & 208.7773185,     3.72806565,     -0.410875   ,
C 23=POND PINE             USE SN POND PINE (11)
     & 142.7468108,     3.97260802,     -0.5870983  ,
C 24=SCOTCH PINE           USE SN POND PINE (11)   
     & 142.7468108,     3.97260802,     -0.5870983  ,
C 25=OTHER SOFTWOODS       USE SN JUNIPER (SP.) (2)
     & 212.7932729,     3.47154903,     -0.32585230 ,
C 26=RED MAPLE             USE SN RED MAPLE (20)
     & 268.5564351,     3.11432843,     -0.29411156 ,
C 27=SUGAR MAPLE           USE SN SUGAR MAPLE (22)
     & 209.8555358,     2.95281334,     -0.36787496 ,
C 28=BLACK MAPLE           USE SN SUGAR MAPLE (22)
     & 209.8555358,     2.95281334,     -0.36787496 ,
C 29=SILVER MAPLE          USE SN SILVER MAPLE (21)
     & 80.51179925,     26.98331005,     -2.02202808,
C 30=YELLOW BIRCH          USE SN BIRCH (SP.) (24)
     & 170.5253403,     2.68833651,     -0.40080716 /
C
      DATA ((SNALL(I,J),I=1,3), J= 31,45)/
C 31=SWEET BIRCH           USE SN SWEET BIRCH (25)
     & 68.92234069,     43.33832185,     -2.44448482,
C 32=RIVER BIRCH           USE SN BIRCH (SP.) (24)
     & 170.5253403,     2.68833651,     -0.40080716 ,
C 33=PAPER BIRCH           USE SN BIRCH (SP.) (24)
     & 170.5253403,     2.68833651,     -0.40080716 ,
C 34=GRAY BIRCH            USE SN BIRCH (SP.) (24)
     & 170.5253403,     2.68833651,     -0.40080716 ,
C 35=HICKORY               USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 36=PIGNUT HICKORY        USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 37=SHELLBARK HICKORY     USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 38=SHAGBARK HICKORY      USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 39=MOCKERNUT HICKORY     USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 40=AMERICAN BEECH        USE SN AMERICAN BEECH (33)
     & 526.1392688,     3.89232121,     -0.22587084 ,
C 41=ASH                   USE SN ASH (34)
     & 251.4042514,     3.26919806,     -0.35905996 ,
C 42=WHITE ASH             USE SN WHITE ASH (35)
     & 91.35276617,     6.99605268,     -1.22937669 ,
C 43=BLACK ASH             USE SN BLACK ASH (36)
     & 178.9307637,     4.92861465,     -0.63777014 ,
C 44=GREEN ASH             USE SN GREEN ASH (37)
     & 404.9692122,     3.39019741,     -0.255096   ,
C 45=PUMPKIN ASH           USE SN ASH (34)
     & 251.4042514,     3.26919806,     -0.35905996 /
C
      DATA ((SNALL(I,J),I=1,3), J= 46,60)/
C 46=YELLOW-POPLAR         USE SN YELLOW-POPLAR (45)
     & 625.7696614,     3.87320571,     -0.23349496 ,
C 47=SWEETGUM              USE SN SWEETGUM (44)
     & 290.90548,       3.6239536,      -0.3720123  ,
C 48=CUCUMBERTREE          USE SN CUCUMBERTREE (47)
     & 660.1996521,     3.92077102,     -0.21124354 ,
C 49=QUAKING ASPEN         USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 50=BALSAM POPLAR         USE SN WHITE ASH (35)
     & 91.35276617,     6.99605268,     -1.22937669 ,
C 51=EASTERN COTTONWOOD   USE SN COTTONWOOD (60)
     & 190.9797059,     3.69278884,     -0.52730469 ,
C 52=BIGTOOTH ASPEN        USE SN WHITE ASH (35)
     & 91.35276617,     6.99605268,     -1.22937669 ,
C 53=SWAMP COTTONWOOD      USE SN WHITE ASH (35)
     & 91.35276617,     6.99605268,     -1.22937669 ,
C 54=BLACK CHERRY          USE SN BLACK CHERRY (62)
     & 364.0247807,     3.55987361,     -0.27263121 ,
C 55=WHITE OAK             USE SN WHITE OAK (63)
     & 170.1330787,     3.27815866,     -0.48744214 ,
C 56=BUR OAK               USE SN SCARLET OAK (64)
     & 196.0564703,     3.0067167,      -0.38499624 ,
C 57=CHINKAPIN OAK         USE SN CHINKAPIN OAK (72)
     & 72.7907469,      3.67065539,     -1.09878979 ,
C 58=POST OAK              USE SN POST OAK (77)
     & 765.2907525,     4.22375114,     -0.18974706 ,
C 59=OTHER OAKS            USE SN SCARLET OAK (64)
     & 196.0564703,     3.0067167,      -0.38499624 ,
C 60=SCARLET OAK           USE SN SCARLET OAK (64)
     & 196.0564703,     3.0067167,      -0.38499624 /
C
      DATA ((SNALL(I,J),I=1,3), J= 61,75)/
C 61=SHINGLE OAK           USE SN CHESTNUT OAK (74)
     & 94.54465221,     3.42034111,     -0.818759   ,
C 62=WATER OAK             USE SN WATER OAK (73)
     & 470.0617193,     3.78892643,     -0.25123824 ,
C 63=PIN OAK               USE SN SCARLET OAK (64)
     & 196.0564703,     3.0067167,      -0.38499624 ,
C 64=CHESTNUT OAK          USE SN CHESTNUT OAK (74)
     & 94.54465221,     3.42034111,     -0.818759   ,
C 65=SWAMP WHITE OAK       USE SN CHERRYBARK/SWAMP OAK (66)
     & 182.6306309,     3.12897883,     -0.46391125 ,
C 66=SWAMP CHESTNUT OAK    USE SN SWAMP CHESTNUT OAK (71)
     & 281.3413276,     3.51695826,     -0.3336282  ,
C 67=NORTHERN RED OAK      USE SN NORTHERN RED OAK (75)
     & 700.0636452,     4.10607389,     -0.21392785 ,
C 68=SOUTHERN RED OAK      USE SN SOUTHERN RED OAK (65)
     & 150.4300023,     3.13270999,     -0.49925872 ,
C 69=BLACK OAK             USE SN BLACK OAK (78)
     & 224.716279,      3.11648501,     -0.35982064 ,
C 70=CHERRYBARK OAK        USE SN CHERRYBARK/SWAMP OAK (66)
     & 182.6306309,     3.12897883,     -0.46391125 ,
C 71=OTHER HARDWOODS       USE SN MISC HARDWOODS (89)
     & 109.7324294,     2.25025802,     -0.41297463 ,
C 72=BUCKEYE               USE SN BASSWOOD (83)
     & 293.5715132,     3.52261899,     -0.35122247 ,
C 73=YELLOW BUCKEYE        USE SN BASSWOOD (83)
     & 293.5715132,     3.52261899,     -0.35122247 ,
C 74=WATER BIRCH           USE SN BIRCH (SP.) (24)
     & 170.5253403,     2.68833651,     -0.40080716 ,
C 75=HACKBERRY             USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 /
C
      DATA ((SNALL(I,J),I=1,3), J= 76,90)/
C 76=PERSIMMON             USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 77=AMERICAN HOLLY        USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 78=BUTTERNUT             USE SN BUTTERNUT (42)
     & 285.8797853,     3.52138815,     -0.3193688  ,
C 79=BLACK WALNUT          USE SN BLACK WALNUT (43)
     & 93.71042027,     3.6575094,      -0.88246833 ,
C 80=OSAGE-ORANGE          USE SN MISC HARDWOODS (89)
     & 109.7324294,     2.25025802,     -0.41297463 ,
C 81=MAGNOLIA              USE SN MAGNOLIA (SP.) (46)
     & 585.6609078,     3.41972033,     -0.17661706 ,
C 82=SWEETBAY              USE SN SWEETBAY (49)
     & 184.1931837,     2.84569124,     -0.36952511 ,
C 83=APPLE                 USE SN APPLE (SP.) (51)
     & 574.0200612,     3.86373895,     -0.16318776 ,
C 84=WATER TUPELO          USE SN WATER TUPELO (53)
     & 163.9728054,     2.76819717,     -0.44098009 ,
C 85=BLACKGUM              USE SN BLACKGUM (54)
     & 319.9788466,     3.67313408,     -0.30651323 ,
C 86=SOURWOOD              USE SN SOURWOOD(57)
     & 690.4917743,     4.15983216,     -0.18613455 ,
C 87=PAULOWNIA             USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 88=SYCAMORE              USE SN SYCAMORE (59)
     & 644.3567687,     3.92045786,     -0.21444786 ,
C 89=WILLOW OAK            USE SN COTTONWOOD (60)
     & 190.9797059,     3.69278884,     -0.52730469 ,
C 90=BLACK LOCUST          USE SN BLACK LOCUST (80)
     & 880.2844971,     4.59642097,     -0.21824277 /
C
      DATA ((SNALL(I,J),I=1,3), J= 91,105)/
C 91=BLACK WILLOW          USE SN WILLOW (81)
     & 408.2772475,     3.81808285,     -0.27210505 ,
C 92=SASSAFRAS             USE SN SASSAFRAS (82)
     & 755.1038099,     4.39496421,     -0.21778831 ,
C 93=AMERICAN BASSWOOD     USE SN BASSWOOD (83)
     & 293.5715132,     3.52261899,     -0.35122247 ,
C 94=WHITE BASSWOOD        USE SN BASSWOOD (83)
     & 293.5715132,     3.52261899,     -0.35122247 ,
C 95=OTHER ELM             USE SN ELM (84)
     & 1005.80672,      4.6473994,      -0.20336143 ,
C 96=AMERICAN ELM          USE SN AMERICAN ELM (86)
     & 418.5941897,     3.17038578,     -0.18964025 ,
C 97=SLIPPERY ELM          USE SN SLIPPERY ELM (87)
     & 1337.547184,     4.48953501,     -0.14749529 ,
C 98=NON-COMM HARDWOODS    USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 99=BOXELDER              USE SN BUTTERNUT (42)
     & 285.8797853,     3.52138815,     -0.3193688  ,
C 100=STRIPED MAPLE        USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 101=AILANTHUS            USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 102=SERVICEBERRY         USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 103=A.HORNBEAM           USE SN EASTERN HOPHORNBEAM (56)
     & 109.7324294,     2.25025802,     -0.41297463 ,
C 104=FLOWERING DOGWOOD    USE SN FLOWERING DOGWOOD (31)
     & 863.0501053,     4.38560239,     -0.14812185 ,
C 105=HAWTHORN             USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 /
C
      DATA ((SNALL(I,J),I=1,3), J= 106,108)/
C 106=EASTERN HOPHORNBEAM  USE SN EASTERN HOPHORNBEAM (56)
     & 109.7324294,     2.25025802,     -0.41297463 ,
C 107=CHERRY, PLUM         USE SN APPLE (SP.) (51)
     & 574.0200612,     3.86373895,     -0.16318776 ,
C 108=PIN CHERRY           USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 /
C----------
C  TRANSITION VALUES (INCHES) IN EXTRAPOLATION TO SHORTER HEIGHTS.
C  THESE CORRESPOND TO THE BUDWIDTH PHYSICAL ATTRIBUTE.  IF THESE
C  ARE MODIFIED, ALSO MODIFY THE DIAM ARRAY IN THE REGCON ENTRY
C  IN **REGENT.
C----------
      DATA (SNDBAL(I), I= 1,108)/
     &   0.1, 0.1, 0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.4, 0.5,
     &   0.5, 0.1, 0.1, 0.5, 0.5, 0.1, 0.1, 0.5, 0.1, 0.4,
     &   0.5, 0.5, 0.5, 0.5, 0.3, 0.2, 0.2, 0.2, 0.2, 0.1,
     &   0.1, 0.1, 0.1, 0.1, 0.3, 0.3, 0.3, 0.3, 0.3, 0.1,
     &   0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.3, 0.2,
     &   0.1, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.1, 0.2, 0.2,
     &   0.2, 0.1, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.2, 0.1,
     &   0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.3, 0.4, 0.1,
     &   0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1,
     &   0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.3, 0.1,
     &   0.1, 0.1, 0.2, 0.1, 0.1, 0.2, 0.2, 0.1/
C----------
C  FLAGS WHETHER TO USE WYKOFF EQUATIONS (0), OR CURTIS-ARNEY 
C  EQUATIONS (1).
C----------
      DATA IWYKCA/
     & 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
     & 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     & 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     & 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
     & 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
     & 0, 0, 1, 0, 0, 0, 0, 0/
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      IDANUW = IFOR
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'HTDBH',5,ICYC)
      IF(DEBUG)WRITE(JOSTND,2) ICYC
    2 FORMAT(' ENTERING SUBROUTINE HTDBH CYCLE =',I4)
C----------
C  SET EQUATION PARAMETERS ACCORDING TO FOREST AND SPECIES.
C----------
      P2 = SNALL(1,ISPC)
      P3 = SNALL(2,ISPC)
      P4 = SNALL(3,ISPC)
      DB = SNDBAL(ISPC)
C
      IF(MODE .EQ. 0) H=0.
      IF(MODE .EQ. 1) D=0.
C----------
C  PROCESS ACCORDING TO MODE AND WHETHER THE SPECIES IS USING
C  A WYKOFF EQUATION OR CURTIS-ARNEY EQUATION.
C----------
      IF(MODE .EQ. 0) THEN
        IF(IWYKCA(ISPC) .EQ. 0) THEN
          H=EXP(HT1(ISPC) + HT2(ISPC)/(D+1.0))+4.5
        ELSE
          IF(D .GE. 3.) THEN
            H=4.5+P2*EXP(-1.*P3*D**P4)
          ELSE
            H=((4.5+P2*EXP(-1.*P3*(3.**P4))-4.51)*(D-DB)/(3.-DB))+4.51
          ENDIF
        ENDIF
      ELSE
        IF(IWYKCA(ISPC) .EQ. 0) THEN
          D=(HT2(ISPC)/(ALOG(H-4.5)-HT1(ISPC)))-1.0
        ELSE
          HAT3 = 4.5 + P2 * EXP(-1.*P3*3.0**P4)
          IF(H .GE. HAT3) THEN
            IF(DEBUG) WRITE(JOSTND,*)' H= ',H,' HAT3= ',HAT3,' P2= ',P2
            D=EXP(ALOG((ALOG(H-4.5)-ALOG(P2))/(-1.*P3)) * 1./P4)
          ELSE
            D=(((H-4.51)*(3.-DB))/(4.5+P2*EXP(-1.*P3*(3.**P4))-4.51))+DB
          ENDIF
        ENDIF
      ENDIF
C
      IF(MODE.NE.0 .AND. D.LT.DB)D=DB
C
      IF (DEBUG) THEN
        WRITE(JOSTND,*) ' IN HTDBH MODE,ISPC,IWYKCA,H,D= ',
     &                    MODE,ISPC,IWYKCA(ISPC),H,D
        WRITE(JOSTND,*) ' IN HTDBH  P2, P3, P4, DB= ', P2, P3, P4, DB
        WRITE(JOSTND,*) ' IN HTDBH  HT1,HT2 = ',HT1(ISPC),HT2(ISPC)
      ENDIF
      RETURN
      END
