      SUBROUTINE ESGENT (ITRNIN)
      IMPLICIT NONE
C----------
C ESTB $Id: esgent.f 2448 2018-07-10 17:04:02Z gedixon $
C----------
C     USES REGENT TO ADD HEIGHT INCREMENT TO REGENERATED TREES
C     DIFFERS FROM ESTB/ESGENT.F AT DBH ASSIGNED TO TREES AT HEIGHT
C     MAXIMUM: 0.95 INSTEAD OF 2.95. THIS MATCHES SMALL TREE/LARGE
C     TREE SIZES IN AK VARIANT
C
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
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'ESCOM2.F77'
C
C
      INCLUDE 'ESHAP.F77'
C
C
      INCLUDE 'ESHAP2.F77'
C
C
COMMONS
C
      INTEGER ITRNIN,I,N
      REAL HTEMP
      LOGICAL DEBUG
      CALL DBCHK (DEBUG,'ESGENT',6,ICYC)
C
      IF(DEBUG) WRITE(JOSTND,10) ITRNIN,ITRN
   10 FORMAT('IN ESGENT: ITRNIN=',I5,'  ITRN=',I5)
C
C     SET VALUE OF IREC1 TO POINT TO THE LAST LOCATION IN THE TREELIST.
C     THEN CALL SPESRT TO RE-ESTABLISH THE SPECIES ORDER SORT.
C
      IREC1=ITRN
      CALL SPESRT
C
C     'GROW' TREES TO THE END OF THE CYCLE.  THEN SUMMARIZE HEIGHTS.
C
      CALL REGENT (.TRUE.,ITRNIN)
      DO 100 I=ITRNIN,ITRN
      N=ISP(I)
      HTEMP=HT(I) +HTG(I)
      HTG(I)=HTG(I)*WK4(I)
      HT(I)=HT(I) +HTG(I)
      IF(WK4(I).LT.1.0) THEN
        IF(HT(I).LT.4.5) THEN
          DBH(I)= 0.1+0.001*(HT(I))
          DG(I)=0.0
        ELSE
          DBH(I)=DBH(I)*(HT(I)/HTEMP)
          DG(I)=DG(I)*(HT(I)/HTEMP)
        ENDIF
      ENDIF
      IF(HT(I).GT.HHTMAX(N)) THEN
        HT(I)=HHTMAX(N)
C        DBH(I)=0.95
      ENDIF
      IF(DEBUG) WRITE(JOSTND,20) I,N,HT(I),HTG(I),DBH(I),DG(I),WK4(I)
   20 FORMAT('IN ESGENT: RECORD#',I5,'  SPECIES=',I3,'  HT=',F5.1,
     &  '  HTG=',F5.2,'  DBH=',F5.2,'  DG=',F5.2,'  WK4=',F5.3)
      IF(IMC(I).NE.1) GO TO 100
      SUMPX(N)=SUMPX(N) +PROB(I)*HT(I)
      SUMPI(N)=SUMPI(N) +PROB(I)
  100 CONTINUE
      RETURN
      END
