      SUBROUTINE FORKOD
      IMPLICIT NONE
C----------
C ACD $Id$
C----------
C
C     TRANSLATES FOREST CODE INTO A SUBSCRIPT, IFOR, AND IF
C     KODFOR IS ZERO, THE ROUTINE RETURNS THE DEFAULT CODE.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
C----------
C  NATIONAL FORESTS:
C  914 = WAYNE
C  922 = WHITE MOUNTAIN
C  919 = ALLEGHENY
C  920 = GREEN MTN - FINGER LAKES
C  921 = MONONGAHELA
C  911 = OLD WAYNE-HOOSIER (MAPE TO WAYNE)
C  930 = FINGER LAKES (MAP TO GREEN MTN - FINGER LAKES)
C----------
      INTEGER JFOR(7),KFOR(7),NUMFOR,I
      DATA JFOR/914,922,919,920,921,911,930/
      DATA NUMFOR/7/
      DATA KFOR/7*1/
C
      IF (KODFOR .EQ. 0) GOTO 30
      DO 10 I=1,NUMFOR
      IF (KODFOR .EQ. JFOR(I)) GOTO 20
   10 CONTINUE
      CALL ERRGRO (.TRUE.,3)
      WRITE(JOSTND,11) JFOR(IFOR)
   11 FORMAT(T12,'FOREST CODE USED FOR THIS PROJECTION IS',I4)
      GOTO 30
   20 CONTINUE
      IF(I .EQ. 6)THEN
        WRITE(JOSTND,21)
   21   FORMAT(T12,'WAYNE-HOOSIER NF (911) BEING MAPPED TO WAYNE ',
     &  '(914) FOR FURTHER PROCESSING.')
        I=1
      ELSEIF(I .EQ. 7) THEN
        WRITE(JOSTND,22)
   22   FORMAT(T12,'FINGER LAKES NF (930) BEING MAPPED TO GREEN MTN-',
     &  'FINGER LAKES (920) FOR FURTHER PROCESSING.')
        I=4
      ENDIF
      IFOR=I
      IGL=KFOR(I)
   30 CONTINUE
      KODFOR=JFOR(IFOR)
C----------
C  SET DEFAULT TLAT, TLONG, AND ELEVATION VALUES, BY FOREST
C----------
      SELECT CASE(KODFOR)
        CASE(914)
          IF(TLAT.EQ.0) TLAT=39.33
          IF(TLONG.EQ.0)TLONG=82.10
          IF(ELEV.EQ.0) ELEV=9.
        CASE(919)
          IF(TLAT.EQ.0) TLAT=41.84
          IF(TLONG.EQ.0)TLONG=79.15
          IF(ELEV.EQ.0) ELEV=17.
        CASE(920)
          IF(TLAT.EQ.0) TLAT=43.61
          IF(TLONG.EQ.0)TLONG=72.97
          IF(ELEV.EQ.0) ELEV=19.
        CASE(921)
          IF(TLAT.EQ.0) TLAT=38.93
          IF(TLONG.EQ.0)TLONG=79.85
          IF(ELEV.EQ.0) ELEV=30.
        CASE(922)
          IF(TLAT.EQ.0) TLAT=43.53
          IF(TLONG.EQ.0)TLONG=71.47
          IF(ELEV.EQ.0) ELEV=20.
      END SELECT
      RETURN
      END
