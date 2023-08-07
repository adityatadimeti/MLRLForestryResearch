! The functions from NIMS_VOL_R5610 package
! Created by YW 2018/08/13
!
! Dippold, R.M. and W.A. Farr 1971
! Volume Tables and Equations for White Spruce, Balsam Popular, and Paper Birch of the Kuskokwim River Valley, Alaska
! USDA Forest Service Pacific NorthWest Forest and Range Experiment Station Research Notes PNW-147
! CU094001 FUNCTION PIGL_DIP_CU(DBH IN NUMBER, THT IN NUMBER)
! BD094001 FUNCTION PIGL_DIP_BD(DBH IN NUMBER, THT IN NUMBER)
! CU741001 FUNCTION POBA2_DIP_CU(DBH IN NUMBER, THT IN NUMBER)
! Valid species code: 094, 375, 741
! NVEL Equation Number:
! P01DIP0094, P01DIP0741, P01DIP0375
      SUBROUTINE DIPPOLD_PNW147(VOLEQ,DBHOB,HTTOT,BFMIND,VOL,ERRFLG)
      CHARACTER*10 VOLEQ
      REAL DBHOB,HTTOT,VOL(15),BFMIND,MTOPP
      INTEGER ERRFLG,SPN
      REAL DBH,THT,CV4,IV7,SV7,D2H
      DBH = DBHOB
      THT = HTTOT
      READ(VOLEQ(8:10),'(I3)')SPN
      IF(BFMIND.LT.0.1) BFMIND = 9.0
      VOL = 0.0
      D2H = DBH*DBH*THT
      IF(SPN.EQ.94)THEN
        CV4 = - .40972 + .0021198 * D2H
        SV7 = -28.74136 + .0111643 * D2H
        IV7 = -24.62022 + .0125346 * D2H
      ELSEIF(SPN.EQ.375.OR.SPN.EQ.741)THEN
        CV4 = - .37551 + .0019624 * D2H
      ELSE
        ERRFLG = 6
        RETURN
      ENDIF
      VOL(4) = CV4
      IF(DBH.GE.BFMIND)THEN
        VOL(2) = SV7
        VOL(10) = IV7
      ENDIF
      RETURN
      END SUBROUTINE DIPPOLD_PNW147
! ---------------------------------------------------------------------
! Wensel, L.C. and Olson, C.M. 1995. Tree Volume Equations for major california Conifers.
! Hilgardia, Vol. 62, Num. 5, december 1995
! BD000011 FUNCTION WENSEL_RN37_4BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000012 FUNCTION WENSEL_RN37_6BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000013 FUNCTION WENSEL_RN37_8BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000014 FUNCTION WENSEL_RN37_M4BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000015 FUNCTION WENSEL_RN37_M6BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000016 FUNCTION WENSEL_RN37_M8BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000011 FUNCTION WENSEL_RN37_0CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000012 FUNCTION WENSEL_RN37_4CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000013 FUNCTION WENSEL_RN37_M4CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! Valid Species code: 015, 020, 081, 108, 116, 117, 122, 202
! NVEL Equation Number:
! P02WEN0015, P02WEN0020, P02WEN0081, P02WEN0108, P02WEN0116, P02WEN0117, P02WEN0122, P02WEN0202, 
      SUBROUTINE WENSEL_RN37(VOLEQ,DBHOB,HTTOT,HT1PRD,MTOPP,BFMIND,VOL,
     & ERRFLG)
      REAL DBHOB,HTTOT,HT1PRD,MTOPP,BFMIND,VOL(15)
      INTEGER SPN,ERRFLG,VOLSP(8),I,J,IDX,CNT
      CHARACTER*10 VOLEQ
      REAL TCV0COEF(8,5),TCV4COEF(8,5),TSV4COEF(8,5),TSV6COEF(8,5)
      REAL TSV8COEF(8,5),TIV4COEF(8,5),TIV6COEF(8,5),TIV8COEF(8,5)
      REAL MCV4COEF(8,5),MSV4COEF(8,5),MSV6COEF(8,5),MSV8COEF(8,5)
      REAL MIV4COEF(8,5),MIV6COEF(8,5),MIV8COEF(8,5)
      REAL DBH,HT,CVT,CV4,SV4,SV6,SV8,IV4,IV6,IV8
      REAL B0,B1,B2,B3
      DATA VOLSP/015, 020, 081, 108, 116, 117, 122, 202/
!     Total height CVT coef
      DATA ((TCV0COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0017880,	1.9289,	1.0653,	0.99971,
     & 20,	0.0011950,	1.8702,	1.2034,	0.99748,
     & 81,	0.00193000,	2.0677,	0.9017,	0.99848,
     & 108,	0.0018000,	2.0549,	0.9959,	0.99846,
     & 116,	0.0022050,	1.9105,	0.9951,	1.00396,
     & 117,	0.0023770,	1.9719,	0.9374,	1.00346,
     & 122,	0.0025250,	1.8518,	1.0004,	1.00791,
     & 202,	0.0022440,	1.9342,	0.9964,	0.99919/
!     Total height CV4 coef
      DATA ((TCV4COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0016870,	1.9475,	1.0664,	0.99932,
     & 20,	0.0011420,	1.8857,	1.2033,	0.99717,
     & 81,	0.00174900,	2.0973,	0.9042,	0.9979,
     & 108,	0.0015680,	2.1117,	0.99395,	0.99688,
     & 116,	0.0020610,	1.9338,	0.9949,	1.0035,
     & 117,	0.0022560,	1.9884,	0.9379,	1.00316,
     & 122,	0.0022540,	1.8764,	1.0005,	1.00647,
     & 202,	0.0021670,	1.9448,	0.9969,	0.999/
!     Total height IV4 coef
      DATA ((TIV4COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0002836,	2.129,	1.2445,	0.99639,
     & 20,	0.0001657,	2.0324,	1.4335,	0.99448,
     & 81,	0.00014720,	2.4209,	1.1236,	0.99267,
     & 108,	0.0001085,	2.3985,	1.2924,	0.99181,
     & 116,	0.0002578,	2.1483,	1.21198,	1.00062,
     & 117,	0.0003938,	2.1868,	1.0886,	1.0008,
     & 122,	0.0004075,	2.0813,	1.1521,	1.00412,
     & 202,	0.0003888,	2.1662,	1.1345,	0.99561/
!     Total height IV6 coef
      DATA ((TIV6COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0002667,	2.1533,	1.243,	0.99589,
     & 20,	0.0001573,	2.0504,	1.4343,	0.99402,
     & 81,	0.00014470,	2.4291,	1.1221,	0.99255,
     & 108,	0.000102,	2.4274,	1.2904,	0.99099,
     & 116,	0.0002422,	2.1768,	1.2087,	0.99996,
     & 117,	0.0003797,	2.2056,	1.0848,	1.00045,
     & 122,	0.0003910,	2.0987,	1.1503,	1.00377,
     & 202,	0.0003759,	2.1791,	1.1334,	0.99539/
!     Total height IV8 coef
      DATA ((TIV8COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0002247,	2.2153,	1.241,	0.99468,
     & 20,	0.0001297,	2.1207,	1.4323,	0.9926,
     & 81,	0.00010380,	2.5355,	1.1249,	0.99063,
     & 108,	0.0000684,	2.6117,	1.274,	0.98579,
     & 116,	0.0002117,	2.2303,	1.2043,	0.99888,
     & 117,	0.0003178,	2.2696,	1.0825,	0.99926,
     & 122,	0.0003308,	2.1595,	1.1484,	1.00257,
     & 202,	0.0003115,	2.2411,	1.1338,	0.99428/
!     Total height SV4 coef
      DATA ((TSV4COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0001414,	2.3337,	1.2553,	0.99266,
     & 20,	0.0000896,	2.2078,	1.4345,	0.99168,
     & 81,	0.00007882,	2.5998,	1.12,	0.99016,
     & 108,	0.0000891,	2.3617,	1.3213,	0.99593,
     & 116,	0.0001539,	2.3078,	1.2102,	0.998,
     & 117,	0.0002089,	2.3777,	1.0922,	0.9976,
     & 122,	0.0002187,	2.2713,	1.155,	1.00085,
     & 202,	0.0002054,	2.3562,	1.1372,	0.9926/
!     Total height SV6 coef
      DATA ((TSV6COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0001170,	2.4,	1.255,	0.99131,
     & 20,	0.0000751,	2.2783,	1.4369,	0.99009,
     & 81,	0.00006144,	2.6885,	1.1237,	0.98855,
     & 108,	0.0000469,	2.6326,	1.3115,	0.98812,
     & 116,	0.0001334,	2.3642,	1.2058,	0.9969,
     & 117,	0.0001796,	2.432,	1.0898,	0.99663,
     & 122,	0.0001798,	2.3406,	1.1542,	0.99945,
     & 202,	0.0001805,	2.3988,	1.137,	0.99187/
!     Total height SV8 coef
      DATA ((TSV8COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0000940,	2.4786,	1.2537,	0.98971,
     & 20,	0.0001522,	2.1052,	1.4253,	0.99211,
     & 81,	0.00004384,	2.7966,	1.1266,	0.98661,
     & 108,	0.0000236,	2.9391,	1.2941,	0.97912,
     & 116,	0.0001137,	2.425,	1.2025,	0.99562,
     & 117,	0.0001454,	2.5106,	1.0857,	0.99515,
     & 122,	0.0001446,	2.4149,	1.1515,	0.99797,
     & 202,	0.0001453,	2.471,	1.1371,	0.99058/
!     Merch height CV4 coef
      DATA ((MCV4COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0033990,	1.7722,	1.0535,	1.00161,
     & 20,	0.0021790,	1.7398,	1.1771,	0.99954,
     & 81,	0.00351600,	1.9292,	0.8827,	1.0003,
     & 108,	0.0037700,	1.9591,	0.9193,	1.00005,
     & 116,	0.0036080,	1.8591,	0.9481,	1.00373,
     & 117,	0.0041900,	1.8215,	0.9368,	1.00495,
     & 122,	0.0041440,	1.742,	0.9909,	1.00757,
     & 202,	0.0036420,	1.8126,	0.9906,	1.00074/
!     Merch height IV4 coef
      DATA ((MIV4COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0005887,	1.9635,	1.2266,	0.99807,
     & 20,	0.0003486,	1.8759,	1.4002,	0.99665,
     & 81,	0.00035440,	2.2354,	1.0827,	0.99496,
     & 108,	0.0004051,	2.2064,	1.1585,	0.99488,
     & 116,	0.0005508,	2.0751,	1.1261,	1.00067,
     & 117,	0.0007080,	2.0389,	1.0874,	1.00195,
     & 122,	0.0008072,	1.9367,	1.1295,	1.00511,
     & 202,	0.0007992,	1.9849,	1.1194,	0.99819/
!     Merch height IV6 coef
      DATA ((MIV6COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0009939,	1.8321,	1.2137,	0.99996,
     & 20,	0.0005272,	1.8074,	1.3679,	0.99781,
     & 81,	0.00048450,	2.1559,	1.085,	0.99563,
     & 108,	0.0004882,	2.1912,	1.1422,	0.99534,
     & 116,	0.0008513,	2.0401,	1.0722,	1.00065,
     & 117,	0.0012570,	1.8766,	1.0838,	1.00419,
     & 122,	0.0011510,	1.8434,	1.1302,	1.00583,
     & 202,	0.0011120,	1.8954,	1.1201,	0.99922/
!     Merch height IV8 coef
      DATA ((MIV8COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0013220,	1.7387,	1.2313,	1.00057,
     & 20,	0.0007231,	1.7592,	1.3493,	0.99793,
     & 81,	0.00048870,	2.1489,	1.1104,	0.9944,
     & 108,	0.0007510,	2.072,	1.129,	0.99848,
     & 116,	0.0011120,	2.0446,	1.0339,	0.99932,
     & 117,	0.0016730,	1.8136,	1.0838,	1.00414,
     & 122,	0.0014110,	1.8181,	1.1254,	1.00491,
     & 202,	0.0014810,	1.8341,	1.1152,	0.99959/
!     Merch height SV4 coef
      DATA ((MSV4COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0003001,	2.1649,	1.235,	0.9944,
     & 20,	0.0001741,	2.0941,	1.4007,	0.99281,
     & 81,	0.00019440,	2.4106,	1.0844,	0.99241,
     & 108,	0.0003120,	2.1813,	1.1964,	0.99847,
     & 116,	0.0003185,	2.2488,	1.1239,	0.99761,
     & 117,	0.0004203,	2.1861,	1.0927,	0.99972,
     & 122,	0.0004176,	2.1383,	1.1339,	1.0015,
     & 202,	0.0003918,	2.1989,	1.1239,	0.99464/
!     Merch height SV6 coef
      DATA ((MSV6COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0004576,	2.0727,	1.2194,	0.99552,
     & 20,	0.0002359,	2.0582,	1.3724,	0.99321,
     & 81,	0.00025400,	2.3454,	1.0861,	0.99289,
     & 108,	0.0003802,	2.1281,	1.186,	1.00019,
     & 116,	0.0004050,	2.2883,	1.0655,	0.99611,
     & 117,	0.0006610,	2.0611,	1.0921,	1.0012,
     & 122,	0.0005775,	2.0541,	1.1338,	1.00221,
     & 202,	0.0005323,	2.1217,	1.121,	0.99554/
!     Merch height SV8 coef
      DATA ((MSV8COEF(J,I), I=1,5), J=1,8) /
     & 15,	0.0005811,	1.9949,	1.2376,	0.9958,
     & 20,	0.0002985,	2.0287,	1.36,	0.9929,
     & 81,	0.00023910,	2.3627,	1.1104,	0.99124,
     & 108,	0.0005851,	2.0105,	1.1743,	1.00446,
     & 116,	0.0005120,	2.3111,	1.0238,	0.99434,
     & 117,	0.0008063,	2.0301,	1.091,	1.0005,
     & 122,	0.0006901,	2.0415,	1.1263,	1.00107,
     & 202,	0.0006879,	2.0688,	1.1161,	0.99586/
      V(DBH,HT,B0,B1,B2,B3) = B0*DBH**B1*HT**B2*B3**DBH
      READ(VOLEQ(8:10),'(I3)')SPN
      CNT = 8
      IDX = 0
      CALL SEARCH_SP(CNT,VOLSP,SPN,IDX,ERRFLG)
      IF(IDX.LE.0) THEN
        ERRFLG = 6
        RETURN
      ENDIF
      DBH = DBHOB
      HT = HTTOT
      IF(IDX.GT.0.AND.SPN.EQ.TCV0COEF(IDX,1)) THEN
        B0 = TCV0COEF(IDX,2)
        B1 = TCV0COEF(IDX,3)
        B2 = TCV0COEF(IDX,4)
        B3 = TCV0COEF(IDX,5)
        CVT = V(DBH,HT,B0,B1,B2,B3)
        VOL(1) = CVT
        B0 = TCV4COEF(IDX,2)
        B1 = TCV4COEF(IDX,3)
        B2 = TCV4COEF(IDX,4)
        B3 = TCV4COEF(IDX,5)
        CV4 = V(DBH,HT,B0,B1,B2,B3)
        VOL(4) = CV4
        IF(MTOPP.EQ.4.0)THEN
          IF(HT1PRD.GT.0.0)THEN
            HT = HT1PRD
            B0 = MCV4COEF(IDX,2)
            B1 = MCV4COEF(IDX,3)
            B2 = MCV4COEF(IDX,4)
            B3 = MCV4COEF(IDX,5)
            CV4 = V(DBH,HT,B0,B1,B2,B3)
            B0 = MSV4COEF(IDX,2)
            B1 = MSV4COEF(IDX,3)
            B2 = MSV4COEF(IDX,4)
            B3 = MSV4COEF(IDX,5)
            SV4 = V(DBH,HT,B0,B1,B2,B3)
            B0 = MIV4COEF(IDX,2)
            B1 = MIV4COEF(IDX,3)
            B2 = MIV4COEF(IDX,4)
            B3 = MIV4COEF(IDX,5)
            IV4 = V(DBH,HT,B0,B1,B2,B3)
          ELSE
            B0 = TSV4COEF(IDX,2)
            B1 = TSV4COEF(IDX,3)
            B2 = TSV4COEF(IDX,4)
            B3 = TSV4COEF(IDX,5)
            SV4 = V(DBH,HT,B0,B1,B2,B3)
            B0 = TIV4COEF(IDX,2)
            B1 = TIV4COEF(IDX,3)
            B2 = TIV4COEF(IDX,4)
            B3 = TIV4COEF(IDX,5)
            IV4 = V(DBH,HT,B0,B1,B2,B3)
          ENDIF
          VOL(4) = CV4
          VOL(2) = SV4*10
          VOL(10) = IV4*10
        ELSEIF(MTOPP.EQ.6.0)THEN
          IF(HT1PRD.GT.0.0)THEN
            HT = HT1PRD
            B0 = MSV6COEF(IDX,2)
            B1 = MSV6COEF(IDX,3)
            B2 = MSV6COEF(IDX,4)
            B3 = MSV6COEF(IDX,5)
            SV6 = V(DBH,HT,B0,B1,B2,B3)
            B0 = MIV6COEF(IDX,2)
            B1 = MIV6COEF(IDX,3)
            B2 = MIV6COEF(IDX,4)
            B3 = MIV6COEF(IDX,5)
            IV6 = V(DBH,HT,B0,B1,B2,B3)
          ELSE
            B0 = TSV6COEF(IDX,2)
            B1 = TSV6COEF(IDX,3)
            B2 = TSV6COEF(IDX,4)
            B3 = TSV6COEF(IDX,5)
            SV6 = V(DBH,HT,B0,B1,B2,B3)
            B0 = TIV6COEF(IDX,2)
            B1 = TIV6COEF(IDX,3)
            B2 = TIV6COEF(IDX,4)
            B3 = TIV6COEF(IDX,5)
            IV6 = V(DBH,HT,B0,B1,B2,B3)
          ENDIF
          VOL(2) = SV6*10
          VOL(10) = IV6*10
        ELSEIF(MTOPP.EQ.8.0)THEN
          IF(HT1PRD.GT.0.0)THEN
            HT = HT1PRD
            B0 = MSV8COEF(IDX,2)
            B1 = MSV8COEF(IDX,3)
            B2 = MSV8COEF(IDX,4)
            B3 = MSV8COEF(IDX,5)
            SV8 = V(DBH,HT,B0,B1,B2,B3)
            B0 = MIV8COEF(IDX,2)
            B1 = MIV8COEF(IDX,3)
            B2 = MIV8COEF(IDX,4)
            B3 = MIV8COEF(IDX,5)
            IV8 = V(DBH,HT,B0,B1,B2,B3)
          ELSE
            B0 = TSV8COEF(IDX,2)
            B1 = TSV8COEF(IDX,3)
            B2 = TSV8COEF(IDX,4)
            B3 = TSV8COEF(IDX,5)
            SV8 = V(DBH,HT,B0,B1,B2,B3)
            B0 = TIV8COEF(IDX,2)
            B1 = TIV8COEF(IDX,3)
            B2 = TIV8COEF(IDX,4)
            B3 = TIV8COEF(IDX,5)
            IV8 = V(DBH,HT,B0,B1,B2,B3)
          ENDIF
          VOL(2) = SV8*10
          VOL(10) = IV8*10
        ENDIF
      ENDIF
      RETURN
      END SUBROUTINE WENSEL_RN37
! ---------------------------------------------------------------------
! Wensel, L.C. and Krumland, B. 1983
! Volume and Taper Relationship for Redwood, Douglas Fir and Other Conifers in CA North Coast
! Bulletin 1907 (University of California (System), Division of Agriculture Science)
! CU000028 WENSEL_1907_5CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000029 WENSEL_1907_6CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000030 WENSEL_1907_7CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000031 WENSEL_1907_8CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000032 WENSEL_1907_5MCU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000033 WENSEL_1907_6MCU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000034 WENSEL_1907_7MCU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000035 WENSEL_1907_8MCU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000017 WENSEL_1907_5BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000018 WENSEL_1907_6BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000019 WENSEL_1907_7BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000020 WENSEL_1907_8BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000021 WENSEL_1907_5MBD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000022 WENSEL_1907_6MBD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000023 WENSEL_1907_7MBD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000024 WENSEL_1907_8MBD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! Valid Species code: 211, 202, 17
! NVEL Equation Number:
! P02WEN1017, P02WEN1202, P02WEN1211
! THE 7TH CHARACTER IN THE VOLUME EQUATION: 0 = CA WIDE, 1 = CA NORTH COAST
      SUBROUTINE WENSEL_1907(VOLEQ,DBHOB,HTTOT,HT1PRD,MTOPP,BFMIND,VOL,
     & ERRFLG)
      CHARACTER*10 VOLEQ
      REAL DBHOB,HTTOT,HT1PRD,MTOPP,BFMIND,VOL(15)
      INTEGER ERRFLG,SPN,I,J
      REAL B0,B1,B2,CV,SV,DBH,HT
      REAL TCUCOEF(9,5),TBDCOEF(9,5),MCUCOEF(9,5),MBDCOEF(9,5)
!     Total height Coefs for cubic volume to top 5(column 2), 6(column 3), 7(column 4), and 8(column 5)     
      DATA ((TCUCOEF(J,I), I=1,5), J=1,9) /
     & 211,	0.0007903,	0.0006605,	0.0005501,	0.0004241,	!	B0
     & 211,	1.7920000,	1.8330000,	1.8720000,	1.9350000,	!	B1
     & 211,	1.2820000,	1.2900000,	1.2990000,	1.3060000,	!	B2
     & 202,	0.0007938,	0.0009947,	0.0010220,	0.0007104,	!	B0
     & 202,	1.5900000,	1.6250000,	1.6640000,	1.7030000,	!	B1
     & 202,	1.4360000,	1.3660000,	1.3330000,	1.3790000,	!	B2
     & 17,	0.0005621,	0.0003982,	0.0002873,	0.0001273,	!	B0
     & 17,	1.6480000,	1.7090000,	1.6830000,	1.7020000,	!	B1
     & 17,	1.4730000,	1.5020000,	1.5840000,	1.7360000/	!	B2
!     Total height Coefs for Scribner BD to top 5(column 2), 6(column 3), 7(column 4), and 8(column 5)     
      DATA ((TBDCOEF(J,I), I=1,5), J=1,9) /
     & 211,	0.0001875,	0.0003507,	0.0004300,	0.0004702,	!	B0
     & 211,	2.0260000,	2.0120000,	2.0020000,	2.0260000,	!	B1
     & 211,	1.7890000,	1.6640000,	1.6320000,	1.5970000,	!	B2
     & 202,	0.0001584,	0.0004968,	0.0010280,	0.0010690,	!	B0
     & 202,	1.7320000,	1.7250000,	1.7720000,	1.7930000,	!	B1
     & 202,	2.0370000,	1.8090000,	1.6310000,	1.6090000,	!	B2
     & 17,	0.00009157,	0.00009457,	0.0001479,	0.0001061,	!	B0
     & 17,	1.8640000,	1.7670000,	1.7590000,	1.7540000,	!	B1
     & 17,	2.0700000,	2.1280000,	2.0410000,	2.1130000/	!	B2
!     Merch height Coefs for cubic volume to top 5(column 2), 6(column 3), 7(column 4), and 8(column 5)     
      DATA ((MCUCOEF(J,I), I=1,5), J=1,9) /
     & 211,	0.0050020,	0.0060880,	0.0069510,	0.0081080,	!	B0
     & 211,	1.5960000,	1.5600000,	1.5280000,	1.4850000,	!	B1
     & 211,	1.0690000,	1.0600000,	1.0630000,	1.0690000,	!	B2
     & 202,	0.0082950,	0.0094130,	0.0108900,	0.0121900,	!	B0
     & 202,	1.5560000,	1.5400000,	1.5150000,	1.4750000,	!	B1
     & 202,	1.0150000,	1.0060000,	0.9997000,	1.0110000,	!	B2
     & 17,	0.0072150,	0.0078630,	0.0090430,	0.0100100,	!	B0
     & 17,	1.5020000,	1.5000000,	1.4890000,	1.4400000,	!	B1
     & 17,	1.0820000,	1.0740000,	1.0590000,	1.0810000/	!	B2
!     Merch height Coefs for Scribner BD to top 5(column 2), 6(column 3), 7(column 4), and 8(column 5)     
      DATA ((MBDCOEF(J,I), I=1,5), J=1,9) /
     & 211,	0.0023090,	0.0061620,	0.0103300,	0.0174100,	!	B0
     & 211,	1.6940000,	1.6410000,	1.5600000,	1.4870000,	!	B1
     & 211,	1.5460000,	1.3850000,	1.3450000,	1.2970000,	!	B2
     & 202,	0.0039600,	0.0092280,	0.0181300,	0.0295600,	!	B0
     & 202,	1.6020000,	1.5850000,	1.5770000,	1.5290000,	!	B1
     & 202,	1.5180000,	1.3630000,	1.2370000,	1.1770000,	!	B2
     & 17,	0.0030860,	0.0066460,	0.0126900,	0.0219000,	!	B0
     & 17,	1.5940000,	1.5110000,	1.5220000,	1.4760000,	!	B1
     & 17,	1.5800000,	1.4880000,	1.3540000,	1.2830000/	!	B2
      V(DBH,HT,B0,B1,B2) = B0 * (DBH ** B1) * (HT ** B2)
      
      READ(VOLEQ(8:10),'(I3)')SPN
      IF(SPN.EQ.211)THEN
        I = 1
      ELSEIF(SPN.EQ.202)THEN
        I = 4
      ELSEIF(SPN.EQ.17)THEN
        I = 7
      ELSE
        ERRFLG = 6
        RETURN
      ENDIF
      IF(MTOPP.LT.6.0)THEN
        J = 2
      ELSEIF(MTOPP.LT.7.0)THEN
        J = 3
      ELSEIF(MTOPP.LT.8.0)THEN
        J = 4
      ELSEIF(MTOPP.GE.8.0)THEN
        J = 5
      ENDIF
      DBH = DBHOB
      IF(HT1PRD.GT.4.5)THEN
        HT = HT1PRD
        B0 = MCUCOEF(I+0,J)
        B1 = MCUCOEF(I+1,J)
        B2 = MCUCOEF(I+2,J)
        CV = V(DBH,HT,B0,B1,B2)
        B0 = MBDCOEF(I+0,J)
        B1 = MBDCOEF(I+1,J)
        B2 = MBDCOEF(I+2,J)
        SV = V(DBH,HT,B0,B1,B2)
      ELSE
        HT = HTTOT
        B0 = TCUCOEF(I+0,J)
        B1 = TCUCOEF(I+1,J)
        B2 = TCUCOEF(I+2,J)
        CV = V(DBH,HT,B0,B1,B2)
        B0 = TBDCOEF(I+0,J)
        B1 = TBDCOEF(I+1,J)
        B2 = TBDCOEF(I+2,J)
        SV = V(DBH,HT,B0,B1,B2)
      ENDIF
      VOL(2) = SV
      VOL(4) = CV
      RETURN  
      END SUBROUTINE WENSEL_1907
! ---------------------------------------------------------------------
!  --Hornibrook, et. al.
!  --Board-foot and Cubic-foot Volume Tables for Some California Hardwoods
!  --Forest Service, No. 67, California Station      
! CU000023 FUNCTION HORN67_CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! Valid species code: 818, 815, 361, 631
! NVEL Equation Number:
! P02HOR0818, P02HOR0815, P02HOR0361, P02HOR0631
      SUBROUTINE HORN67(VOLEQ,DBHOB,HTTOT,VOL,ERRFLG)
      CHARACTER*10 VOLEQ
      REAL DBHOB,HTTOT,VOL(15)
      INTEGER SPN, ERRFLG
      REAL A,B,C,D,F
      
      READ(VOLEQ(8:10),'(I3)')SPN
      IF(SPN.EQ.818)THEN
        A = 2.2425
        B = 0.5482
        C = 0.0047
        D = -2.5349
        F = 65
      ELSEIF (SPN.EQ.815) THEN
        A = 2.4306
        B = 0.6008
        C = 0.0037
        D = -2.7519
        F = 63
      ELSEIF (SPN.EQ.361) THEN
        A = 2.3098
        B = 0.4481
        C = 0.0042
        D = -2.3746
        F = 68
      ELSEIF (SPN.EQ.631) THEN
        A = 2.1300
        B = 0.7560
        C = 0.0092
        D = -3.1624
        F = 65
      ELSE
        ERRFLG = 6
        RETURN
      END IF;
      VOL(4) = 10**((A*(LOG10(DBHOB)))+(B*(LOG10(HTTOT)))+(C*F)+D)
      RETURN
      END SUBROUTINE HORN67
! ---------------------------------------------------------------------
! Biging, G. S. 1981. Volume Tables for Young-growth Mixed Conifers of Northern CA based upon the Stem Analysis Data
! Res. Note 7
! CU000037 FUNCTION BIG7_4CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! CU000038 FUNCTION BIG7_6CU(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000025 FUNCTION BIG7_6BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! BD000026 FUNCTION BIG7_8BD(SPC IN VARCHAR2, DBH IN NUMBER, THT IN NUMBER)
! Valid species code: 122, 202, 020, 015, 117, 081
! NVEL Equation Number:
! P02BIG0122, P02BIG0202, P02BIG0202, P02BIG0015, P02BIG0117, P02BIG0081, 
      SUBROUTINE BIGING7(VOLEQ,DBHOB,HTTOT,MTOPP,BFMIND,VOL,
     & ERRFLG)
      CHARACTER*10 VOLEQ
      REAL DBHOB,HTTOT,MTOPP,BFMIND,VOL(15)
      INTEGER ERRFLG,SPN,I,J
      REAL C0,C1,C2,CV4,CV6,SV6,SV8,DBH,HT
      REAL COEF(18,5)
!     Coefficients: CU4(column 2), CU6(column 3), BD6(column 4), BD8(column 5)     
      DATA ((COEF(J,I), I=1,5), J=1,18) /
     & 122,	-5.87037,	-6.27940,	-6.69958,	-7.31642,	!	C0
     & 122,	2.07856,	2.27130,	2.46342,	2.86479,	!	C1
     & 122,	0.84577,	0.80214,	1.13365,	0.99215,	!	C2
     & 202,	-6.77371,	-7.31263,	-7.56070,	-9.00895,	!	C0
     & 202,	1.74091,	1.86620,	2.01373,	2.45348,	!	C1
     & 202,	1.27009,	1.30151,	1.62982,	1.65063,	!	C2
     & 20,	-7.42110,	-8.19624,	-9.65279,	-10.74943,	!	C0
     & 20,	1.69539,	1.74634,	1.86991,	2.15186,	!	C1
     & 20,	1.46867,	1.60370,	2.22310,	2.27388,	!	C2
     & 15,	-6.58856,	-7.07110,	-7.71557,	-8.47169,	!	C0
     & 15,	1.74371,	1.82530,	1.94935,	2.26747,	!	C1
     & 15,	1.25399,	1.30290,	1.73931,	1.69054,	!	C2
     & 117,	-6.30458,	-6.64006,	-7.31125,	-9.05036,	!	C0
     & 117,	1.89487,	1.98574,	2.17057,	2.51420,	!	C1
     & 117,	1.05278,	1.06021,	1.44848,	1.58614,	!	C2
     & 81,	-6.20820,	-6.85535,	-8.49627,	-8.55107,	!	C0
     & 81,	1.86583,	2.09022,	2.09810,	2.77447,	!	C1
     & 81,	1.02396,	1.01111,	1.73953,	1.26352/	!	C2
      V(DBH,HT,C0,C1,C2) = (EXP(C0 + (C1 * LOG(DBH)) + (C2 * LOG(HT))))
      READ(VOLEQ(8:10),'(I3)')SPN
      IF(SPN.EQ.122)THEN
        I = 1
      ELSEIF(SPN.EQ.202)THEN
        I = 4
      ELSEIF(SPN.EQ.20)THEN
        I = 7
      ELSEIF(SPN.EQ.15)THEN
        I = 10
      ELSEIF(SPN.EQ.117)THEN
        I = 13
      ELSEIF(SPN.EQ.81)THEN
        I = 16
      ELSE
        ERRFLG = 6
        RETURN
      ENDIF
      DBH = DBHOB
      HT = HTTOT
      J = 2
      C0 = COEF(I+0,J)
      C1 = COEF(I+1,J)
      C2 = COEF(I+2,J)
      CV4 = V(DBH,HT,C0,C1,C2)
      VOL(4) = CV4
      IF(MTOPP.EQ.6.0)THEN
!       Calculate cubic volume to top 6        
        J = 3
        C0 = COEF(I+0,J)
        C1 = COEF(I+1,J)
        C2 = COEF(I+2,J)
        CV6 = V(DBH,HT,C0,C1,C2)
!       Calculate Scribner volume to top 6        
        J = 4
        C0 = COEF(I+0,J)
        C1 = COEF(I+1,J)
        C2 = COEF(I+2,J)
        SV6 = V(DBH,HT,C0,C1,C2)
        VOL(2) = SV6
        VOL(4) = CV6
        VOL(7) = CV4 - CV6
      ELSEIF(MTOPP.EQ.8.0)THEN
!       Calculate Scribner volume to top 8        
        J = 5
        C0 = COEF(I+0,J)
        C1 = COEF(I+1,J)
        C2 = COEF(I+2,J)
        SV8 = V(DBH,HT,C0,C1,C2)
        VOL(2) = SV8
      ENDIF
      RETURN
      END SUBROUTINE BIGING7
