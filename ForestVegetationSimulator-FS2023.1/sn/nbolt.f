      SUBROUTINE NBOLT(ISPC,H,D,DBHMIN,BFMIND,SINDX,TOPDOB,BFTDOB,
     &           JOSTND,DEBUG,IHT1,IHT2)
      IMPLICIT NONE
C----------
C SN $Id$
C----------
C THIS ROUTINE CALCULATES THE NUMBER OF 8' BOLTS TO SPECIFIED SAWTIMBER
C TOP DIAMETER AND THE NUMBER OF 8' BOLTS TO A SPECIFIED PULPWOOD TOP
C DIAMETER.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
COMMONS
C
      LOGICAL DEBUG
C
      REAL B1(MAXSP),B2(MAXSP),B3(MAXSP),B4(MAXSP),B5(MAXSP),
     &          B6(MAXSP),DBHMIN(MAXSP),BFMIND(MAXSP)
      REAL CSB1(MAXSP),CSB2(MAXSP),CSB3(MAXSP),CSB4(MAXSP),
     &          CSB5(MAXSP),CSB6(MAXSP)
      INTEGER IHT1,IHT2,JOSTND,ISPC
      REAL BFTDOB,TOPDOB,SINDX,D,H,C1,C2,C3,C4,C5,C6,FACTOR,ESTTHT
      REAL ESTCHT,PULBOL,ESTSHT,SAWBOL
C
      IF (DEBUG) WRITE(JOSTND,10)
   10 FORMAT(' ENTERING NBOLT ')
C
C----------
C  LOADING SPECIES SPECIFIC COEFFICIENTS FOR HEIGHT EQUATIONS FROM
C  EK ET AL. 1984
C----------
      DATA B1/
     & 14.30400,  8.20790, 31.95700, 36.85100, 36.85100,
     & 36.85100, 36.85100, 36.85100, 36.85100, 36.85100,
     & 36.85100, 16.28100, 16.28100, 16.93400,  6.95720,
     &  5.34160,  5.31170,  5.34160, 13.62500,  6.86000,
     &  5.34160,  5.34160,  6.68440,  7.18520,  7.18520,
     & 13.62500,  6.10340,  6.43010,  6.68440, 13.62000,
     & 13.62500,  6.68440,  9.20780,  8.17820,  8.17820,
     &  8.17820,  8.17820,  6.43010,  6.86000,  6.86000,
     &  6.68440,  6.68440,  6.68440,  8.17820,  8.17820,
     &  6.68440,  8.17820,  6.10340,  6.68440,  6.68440,
     &  6.68440, 13.62000,  6.68440,  6.68440,  6.86000,
     & 13.62500,  6.68440,  6.68440,  6.68440, 13.62500,
     &  6.43010,  8.17820,  9.20780,  3.80110,  6.68440,
     &  6.68440,  9.20780,  3.80110,  9.20780,  3.80110,
     &  3.80110,  9.20780,  3.80110,  3.80110,  6.68440,
     &  9.20780,  9.20780,  6.68440,  9.20780,  6.68440,
     &  6.95720,  6.68440,  6.68440,  6.68440,  8.45800,
     &  6.68440,  6.68440, 36.85100,  6.68440, 36.85100/
C
      DATA CSB1/
     & 16.28100,  8.20790, 16.28100, 16.93400, 16.93400,
     & 16.93400, 16.28100, 16.93400, 16.93400, 16.93400,
     & 16.93400, 16.28100, 16.93400, 16.93400,  6.95720,
     &  6.95720, 16.28100,  5.34160,  6.86000,  6.86000,
     &  6.86000,  5.34160,  6.43010,  6.95720,  6.95720,
     & 13.62000,  6.10340,  6.43010,  8.45800, 13.62000,
     & 13.62000,  6.43010,  5.34160,  8.17820,  8.17820,
     & 11.29100,  8.17820,  6.43010, 13.62000, 13.62000,
     & 13.62000, 13.62500, 13.62500,  6.95720,  6.36280,
     & 13.62000, 13.62000, 13.62000, 13.62000, 13.62000,
     &  6.43010, 13.62000,  6.86000,  6.86000,  6.86000,
     & 13.62000, 13.62000, 13.62000,  6.95720, 13.62500,
     &  6.43010,  7.27730,  9.20780,  3.80110,  6.68440,
     &  9.20780,  3.80110,  9.20780,  9.20780,  3.80110,
     &  9.20780,  9.20780,  9.20780,  3.80110,  6.68440,
     &  9.20780,  3.80110,  3.80110,  3.80110,  6.43010,
     &  6.95720,  6.43010,  6.36280,  8.45800,  8.45800,
     &  8.45800,  8.45800, 16.28100, 13.62000, 13.62000/
C
      DATA B2/
     &  0.19894,  0.19672,  0.18511,  0.08298,  0.08298,
     &  0.08298,  0.08298,  0.08298,  0.08298,  0.08298,
     &  0.08298,  0.08621,  0.08621,  0.12972,  0.26564,
     &  0.23044,  0.10357,  0.23044,  0.28668,  0.27725,
     &  0.23044,  0.23044,  0.19049,  0.28384,  0.28384,
     &  0.28668,  0.17368,  0.23545,  0.19049,  0.24255,
     &  0.28668,  0.19049,  0.22208,  0.27316,  0.27316,
     &  0.27316,  0.27316,  0.23545,  0.27725,  0.27725,
     &  0.19049,  0.19049,  0.19049,  0.27316,  0.27316,
     &  0.19049,  0.27316,  0.17368,  0.19049,  0.19049,
     &  0.19049,  0.24255,  0.19049,  0.19049,  0.27725,
     &  0.28668,  0.19049,  0.19049,  0.19049,  0.28668,
     &  0.23545,  0.27316,  0.22208,  0.39213,  0.19049,
     &  0.19049,  0.22208,  0.39213,  0.22208,  0.39213,
     &  0.39213,  0.22208,  0.39213,  0.39213,  0.19049,
     &  0.22208,  0.22208,  0.19049,  0.22208,  0.19049,
     &  0.26564,  0.19049,  0.19049,  0.19049,  0.27527,
     &  0.19049,  0.19049,  0.08298,  0.19049,  0.08298/
C
      DATA CSB2/
     &  0.08621,  0.19672,  0.08621,  0.12972,  0.12972,
     &  0.12972,  0.08621,  0.12972,  0.12972,  0.12972,
     &  0.12972,  0.08621,  0.12972,  0.12972,  0.26564,
     &  0.26564,  0.08621,  0.23044,  0.27725,  0.27725,
     &  0.27725,  0.23044,  0.23545,  0.26564,  0.26564,
     &  0.24255,  0.17368,  0.23545,  0.27527,  0.24255,
     &  0.24255,  0.23545,  0.23044,  0.27316,  0.27316,
     &  0.25250,  0.27316,  0.23545,  0.24255,  0.24255,
     &  0.24255,  0.28668,  0.28668,  0.26564,  0.27859,
     &  0.24255,  0.24255,  0.24255,  0.24255,  0.24255,
     &  0.23545,  0.24255,  0.27725,  0.27725,  0.27725,
     &  0.24255,  0.24255,  0.24255,  0.26564,  0.28668,
     &  0.23545,  0.22721,  0.22208,  0.39213,  0.19049,
     &  0.22208,  0.39213,  0.22208,  0.22208,  0.39213,
     &  0.22208,  0.22208,  0.22208,  0.39213,  0.19049,
     &  0.22208,  0.39213,  0.39213,  0.39213,  0.23545,
     &  0.26564,  0.23545,  0.27859,  0.27527,  0.27527,
     &  0.27527,  0.27527,  0.08621,  0.24255,  0.24255/
C
      DATA B3/
     &  1.41950,  1.31120,  1.70200,  1.00000,  1.00000,
     &  1.00000,  1.00000,  1.00000,  1.00000,  1.00000,
     &  1.00000,  1.00000,  1.00000,  1.00000,  1.00000,
     &  1.15290,  1.00000,  1.15290,  1.61240,  1.42870,
     &  1.15290,  1.15290,  1.00000,  1.44170,  1.44170,
     &  1.61240,  1.00000,  1.33800,  1.00000,  1.28850,
     &  1.61240,  1.00000,  1.00000,  1.72500,  1.72500,
     &  1.72500,  1.72500,  1.33800,  1.42870,  1.42870,
     &  1.00000,  1.00000,  1.00000,  1.72500,  1.72500,
     &  1.00000,  1.72500,  1.00000,  1.00000,  1.00000,
     &  1.00000,  1.28850,  1.00000,  1.00000,  1.42870,
     &  1.61240,  1.00000,  1.00000,  1.00000,  1.61240,
     &  1.33800,  1.72500,  1.00000,  2.90530,  1.00000,
     &  1.00000,  1.00000,  2.90530,  1.00000,  2.90530,
     &  2.90530,  1.00000,  2.90530,  2.90530,  1.00000,
     &  1.00000,  1.00000,  1.00000,  1.00000,  1.00000,
     &  1.00000,  1.00000,  1.00000,  1.00000,  1.96020,
     &  1.00000,  1.00000,  1.00000,  1.00000,  1.00000/
C
      DATA CSB3/
     &  1.00000,  1.31120,  1.00000,  1.00000,  1.00000,
     &  1.00000,  1.00000,  1.00000,  1.00000,  1.00000,
     &  1.00000,  1.00000,  1.00000,  1.00000,  1.00000,
     &  1.00000,  1.00000,  1.15290,  1.42870,  1.42870,
     &  1.42870,  1.15290,  1.33800,  1.00000,  1.00000,
     &  1.28850,  1.00000,  1.33800,  1.96020,  1.28850,
     &  1.28850,  1.33800,  1.15290,  1.72500,  1.72500,
     &  1.42870,  1.72500,  1.33800,  1.28850,  1.28850,
     &  1.28850,  1.61240,  1.61240,  1.00000,  1.72500,
     &  1.28850,  1.28850,  1.28850,  1.28850,  1.28850,
     &  1.33800,  1.28850,  1.42870,  1.42870,  1.42870,
     &  1.28850,  1.28850,  1.28850,  1.00000,  1.61240,
     &  1.33800,  1.96020,  1.00000,  2.90530,  1.00000,
     &  1.00000,  2.90530,  1.00000,  1.00000,  2.90530,
     &  1.00000,  1.00000,  1.00000,  2.90530,  1.00000,
     &  1.00000,  2.90530,  2.90530,  2.90530,  1.33800,
     &  1.00000,  1.33800,  1.72500,  1.96020,  1.96020,
     &  1.96020,  1.96020,  1.00000,  1.28850,  1.28850/
C
      DATA B4/
     &  0.23349,  0.33978,  0.00000,  0.00001,  0.00001,
     &  0.00001,  0.00001,  0.00001,  0.00001,  0.00001,
     &  0.00001,  0.16220,  0.16220,  0.20854,  0.48660,
     &  0.54194,  0.68454,  0.54194,  0.30651,  0.40115,
     &  0.54194,  0.54194,  0.43972,  0.38884,  0.38884,
     &  0.30651,  0.44725,  0.47370,  0.43972,  0.25831,
     &  0.30651,  0.43972,  0.31723,  0.38694,  0.38694,
     &  0.38694,  0.38694,  0.47370,  0.40115,  0.40115,
     &  0.43972,  0.43972,  0.43972,  0.38694,  0.38694,
     &  0.43972,  0.38694,  0.44725,  0.43972,  0.43972,
     &  0.43972,  0.25831,  0.43972,  0.43972,  0.40115,
     &  0.30651,  0.43972,  0.43972,  0.43972,  0.30651,
     &  0.47370,  0.38694,  0.31723,  0.55634,  0.43972,
     &  0.43972,  0.31723,  0.55634,  0.31723,  0.55634,
     &  0.55634,  0.31723,  0.55634,  0.55634,  0.43972,
     &  0.31723,  0.31723,  0.43972,  0.31723,  0.43972,
     &  0.48660,  0.43972,  0.43972,  0.43972,  0.34894,
     &  0.43972,  0.43972,  0.00001,  0.43972,  0.00001/
C
      DATA CSB4/
     &  0.16220,  0.33978,  0.16220,  0.20854,  0.20854,
     &  0.20854,  0.16220,  0.20854,  0.20854,  0.20854,
     &  0.20854,  0.16220,  0.20854,  0.20854,  0.48660,
     &  0.48660,  0.16220,  0.54194,  0.40115,  0.40115,
     &  0.40115,  0.54194,  0.47370,  0.48660,  0.48660,
     &  0.25831,  0.44725,  0.47370,  0.34894,  0.25831,
     &  0.25831,  0.47370,  0.54194,  0.38694,  0.38694,
     &  0.35711,  0.38694,  0.47370,  0.25831,  0.25831,
     &  0.25831,  0.30651,  0.30651,  0.48660,  0.49589,
     &  0.25831,  0.25831,  0.25831,  0.25831,  0.25831,
     &  0.47370,  0.25831,  0.40115,  0.40115,  0.40115,
     &  0.25831,  0.25831,  0.25831,  0.48660,  0.30651,
     &  0.47370,  0.41179,  0.31723,  0.55634,  0.43972,
     &  0.31723,  0.55634,  0.31723,  0.31723,  0.55634,
     &  0.31723,  0.31723,  0.31723,  0.55634,  0.43972,
     &  0.31723,  0.55634,  0.55634,  0.55634,  0.47370,
     &  0.48660,  0.47370,  0.49589,  0.34894,  0.34894,
     &  0.34894,  0.34894,  0.16220,  0.25831,  0.25831/
C
      DATA B5/
     &  0.76878,  0.76173,  0.68967,  0.63884,  0.63884,
     &  0.63884,  0.63884,  0.63884,  0.63884,  0.63884,
     &  0.63884,  0.86833,  0.86833,  0.77792,  0.76954,
     &  0.83440,  0.71410,  0.83440,  1.02920,  0.85299,
     &  0.83440,  0.83440,  0.82962,  0.82157,  0.82157,
     &  1.02920,  1.02370,  0.73385,  0.82962,  0.68128,
     &  1.02920,  0.82962,  0.83560,  0.75822,  0.75822,
     &  0.75822,  0.75822,  0.73385,  0.85299,  0.85299,
     &  0.82962,  0.82962,  0.82962,  0.75822,  0.75822,
     &  0.82962,  0.75822,  1.02370,  0.82962,  0.82962,
     &  0.82962,  0.68128,  0.82962,  0.82962,  0.85299,
     &  1.02920,  0.82962,  0.82962,  0.82962,  1.02920,
     &  0.73385,  0.75822,  0.83560,  0.84317,  0.82962,
     &  0.82962,  0.83560,  0.84317,  0.83560,  0.84317,
     &  0.84317,  0.83560,  0.84317,  0.84317,  0.82962,
     &  0.83560,  0.83560,  0.82962,  0.83560,  0.82962,
     &  0.76954,  0.82962,  0.82962,  0.82962,  0.89213,
     &  0.82962,  0.82962,  0.63884,  0.82962,  0.63884/
C
      DATA CSB5/
     &  0.86833,  0.76173,  0.86833,  0.77792,  0.77792,
     &  0.77792,  0.86833,  0.77792,  0.77792,  0.77792,
     &  0.77792,  0.86833,  0.77792,  0.77792,  0.76954,
     &  0.76954,  0.86833,  0.83440,  0.85299,  0.85299,
     &  0.85299,  0.83440,  0.73385,  0.76954,  0.76954,
     &  0.68128,  1.02370,  0.73385,  0.89213,  0.68128,
     &  0.68128,  0.73385,  0.83440,  0.75822,  0.75822,
     &  0.75060,  0.75822,  0.73385,  0.68128,  0.68128,
     &  0.68128,  1.02920,  1.02920,  0.76954,  0.76169,
     &  0.68128,  0.68128,  0.68128,  0.68128,  0.68128,
     &  0.73385,  0.68128,  0.85299,  0.85299,  0.85299,
     &  0.68128,  0.68128,  0.68128,  0.76954,  1.02920,
     &  0.73385,  0.76498,  0.83560,  0.84317,  0.82962,
     &  0.83560,  0.84317,  0.83560,  0.83560,  0.84317,
     &  0.83560,  0.83560,  0.83560,  0.84317,  0.82962,
     &  0.83560,  0.84317,  0.84317,  0.84317,  0.73385,
     &  0.76954,  0.73385,  0.76169,  0.89213,  0.89213,
     &  0.89213,  0.89213,  0.86833,  0.68128,  0.68128/
C
      DATA B6/
     &  0.12399,  0.11666,  0.16200,  0.18231,  0.18231,
     &  0.18231,  0.18231,  0.18231,  0.18231,  0.18231,
     &  0.18231,  0.23316,  0.23316,  0.12902,  0.01618,
     &  0.06372,  0.00000,  0.06372,  0.07460,  0.12403,
     &  0.06372,  0.06372,  0.10806,  0.11411,  0.11411,
     &  0.07460,  0.14610,  0.08228,  0.10806,  0.10771,
     &  0.07460,  0.10806,  0.13465,  0.10847,  0.10847,
     &  0.10847,  0.10847,  0.08228,  0.12403,  0.12403,
     &  0.10806,  0.10806,  0.10806,  0.10847,  0.10847,
     &  0.10806,  0.10847,  0.14610,  0.10806,  0.10806,
     &  0.10806,  0.10771,  0.10806,  0.10806,  0.12403,
     &  0.07460,  0.10806,  0.10806,  0.10806,  0.07460,
     &  0.08228,  0.10847,  0.13465,  0.09593,  0.10806,
     &  0.10806,  0.13465,  0.09593,  0.13465,  0.09593,
     &  0.09593,  0.13465,  0.09593,  0.09593,  0.10806,
     &  0.13465,  0.13465,  0.10806,  0.13465,  0.10806,
     &  0.01618,  0.10806,  0.10806,  0.10806,  0.12594,
     &  0.10806,  0.10806,  0.18231,  0.10806,  0.18231/

C
      DATA CSB6/
     &  0.23316,  0.11666,  0.23316,  0.12902,  0.12902,
     &  0.12902,  0.23316,  0.12902,  0.12902,  0.12902,
     &  0.12902,  0.23316,  0.12902,  0.12902,  0.01618,
     &  0.01618,  0.23316,  0.06372,  0.12403,  0.12403,
     &  0.12403,  0.06372,  0.08228,  0.01618,  0.01618,
     &  0.10771,  0.14610,  0.08228,  0.12594,  0.10771,
     &  0.10771,  0.08228,  0.06372,  0.10847,  0.10847,
     &  0.06859,  0.10847,  0.08228,  0.10771,  0.10771,
     &  0.10771,  0.07460,  0.07460,  0.01618,  0.05841,
     &  0.10771,  0.10771,  0.10771,  0.10771,  0.10771,
     &  0.08228,  0.10771,  0.12403,  0.12403,  0.12403,
     &  0.10771,  0.10771,  0.10771,  0.01618,  0.07460,
     &  0.08228,  0.11046,  0.13465,  0.09593,  0.10806,
     &  0.13465,  0.09593,  0.13465,  0.13465,  0.09593,
     &  0.13465,  0.13465,  0.13465,  0.09593,  0.10806,
     &  0.13465,  0.09593,  0.09593,  0.09593,  0.08228,
     &  0.01618,  0.08228,  0.05841,  0.12594,  0.12594,
     &  0.12594,  0.12594,  0.23316,  0.10771,  0.10771/
C----------
C  SET THE COEFFICIENTS FOR R8 OR R9
C----------
       IF(KODFOR .LT. 900)THEN
         C1=B1(ISPC)
         C2=B2(ISPC)
         C3=B3(ISPC)
         C4=B4(ISPC)
         C5=B5(ISPC)
         C6=B6(ISPC)
       ELSE
         C1=CSB1(ISPC)
         C2=CSB2(ISPC)
         C3=CSB3(ISPC)
         C4=CSB4(ISPC)
         C5=CSB5(ISPC)
         C6=CSB6(ISPC)
       ENDIF
C----------
C  COMPUTE ESTIMATED TOTAL TREE HEIGHT.
C----------
       IF(D .LT. DBHMIN(ISPC)) THEN
         IHT1=0
         IHT2=0
         GO TO 100
       ELSE
         FACTOR = 0.0
         ESTTHT = 4.5+C1*(1.0-EXP(-1.0*C2*D))
     &         **C3*SINDX**C4*(1.00001-FACTOR)
     &         **C5*BA**C6
         IF(DEBUG)WRITE(JOSTND,*)' ESTTHT=',ESTTHT,' ISPC=',ISPC,
     &      ' C1=',C1,' C2=',C2,' C3=',C3,' C4=',
     &      C4,' C5=',C5,' C6=',C6,' D=',D,' H=',H,
     &      ' SINDX=',SINDX,' TOP/D=',TOPDOB/D,' BA=',BA,
     &      ' TOPDOB=',TOPDOB
       ENDIF
C----------
C  COMPUTE THE NUMBER OF 8' BOLTS TO SPECIFIED PULPWOOD TOP DIAMETER.
C----------
       IF(D .LT. DBHMIN(ISPC)) THEN
         IHT1=0
         IHT2=0
         GO TO 100
       ELSE
         FACTOR = TOPDOB/D
         IF(FACTOR .GT. 1.0) FACTOR=1.0
         ESTCHT = 4.5+C1*(1.0-EXP(-1.0*C2*D))
     &         **C3*SINDX**C4*(1.00001-FACTOR)
     &         **C5*BA**C6
         IF(DEBUG)WRITE(JOSTND,*)' ESTCHT=',ESTCHT,' ISPC=',ISPC,
     &      ' C1=',C1,' C2=',C2,' C3=',C3,' C4=',
     &      C4,' C5=',C5,' C6=',C6,' D=',D,' H=',H,
     &      ' SINDX=',SINDX,' TOP/D=',TOPDOB/D,' BA=',BA,
     &      ' TOPDOB=',TOPDOB
         PULBOL=ESTCHT*(H/ESTTHT)
         IHT2=INT(PULBOL/8.333333)
         IF(DEBUG)WRITE(JOSTND,*)' No. PULPWOOD BOLTS (IHT2)= ',IHT2
       ENDIF
C----------
C  COMPUTE THE NUMBER OF 8' BOLTS TO A SPECIFIED SAWTIMBER TOP
C  DIAMETER.
C----------
       IF(D .LT. BFMIND(ISPC)) THEN
         IHT1=0
         GO TO 100
       ELSE
         FACTOR = BFTDOB/D
         IF(FACTOR .GT. 1.0) FACTOR=1.0
         ESTSHT = 4.5+C1*(1.0-EXP(-1.0*C2*D))
     &         **C3*SINDX**C4*(1.00001-FACTOR)
     &         **C5*BA**C6
         IF(DEBUG)WRITE(JOSTND,*)' C1=',C1,' C2=',C2,
     &     ' C3=',C3,' C4=',C4,' C5=',C5,' C6=',
     &     C6,' ISPC=',ISPC,' BA=',BA,' SINDX=',SINDX,
     &     ' BFT/D=',BFTDOB/D,' D=',D,' H=',H,' ESTSHT=',ESTSHT
         SAWBOL=ESTSHT*(H/ESTTHT)
         IHT1=INT(SAWBOL/8.333333)
         IF(DEBUG)WRITE(JOSTND,*)' No. SAWWOOD BOLTS (IHT1)= ',IHT1
      ENDIF
100   CONTINUE
      RETURN
      END
