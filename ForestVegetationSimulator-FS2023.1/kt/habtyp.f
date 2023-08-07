      SUBROUTINE HABTYP (KARD2,ARRAY2)
      IMPLICIT NONE
C----------
C KT $Id$
C----------
C
C     TRANSLATES HABITAT TYPE CODE INTO A SUBSCRIPT, ITYPE, AND IF
C     KODTYP IS ZERO, THE ROUTINE RETURNS THE DEFAULT CODE.   THIS
C     ROUTINE ALSO TRANSLATES HABITAT TYPE INTO A SUBSCRIPT FOR THE
C     KOOTENAI CODES WHICH IS USED IN DGF.
C----------
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
      INCLUDE 'KOTCOM.F77'
C
C
COMMONS
C----------
      REAL ARRAY2
      CHARACTER*10 KARD2
      INTEGER KTYPE(95),MTYPE(30),K
      LOGICAL LPVCOD,LPVREF,LPVXXX
      REAL RDANUW
C----------
      DATA KTYPE/
     &  5*1, 4*2, 4, 3*1, 3,4,5,6,7,8,9,8,8,9,7,3, 3*10, 4,11,20,29,11,
     &    11,13,14,17, 4*12, 3*13, 14,15,14,16,14,16, 3*17, 24,12,24,18,
     &    19,21,19,20,20,21,22,19,23,19,24,27,25,25,26,27,22,24,27,24,
     &    27,28,28,29,28,28, 4*29, 27,9,20,24,21,27,24,30/
      DATA MTYPE/
     &            130,170,250,260,280,290,310,320,330,420,
     &            470,510,520,530,540,550,570,610,620,640,
     &            660,670,680,690,710,720,730,830,850,999/
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = ARRAY2
C
      LPVREF=.FALSE.
      LPVCOD=.FALSE.
      LPVXXX=.FALSE.
C----------
C  IF KODTYP IS OUTSIDE THE ALLOWABLE RANGE, USE DEFAULT VALUE.
C
C  IF REFERENCE CODE IS NON-ZERO THEN MAP PV CODE/REF. CODE TO
C  FVS HABITAT TYPE/ECOCLASS CODE IN THE KODTYP VARIABLE.
C  THEN PROCESS KODTYP CODE (KODTYP IS PASSED BACK TO HABTYP
C  THROUGH COMMON)
C----------
      KARD2=ADJUSTL(KARD2)
      IF(LEN_TRIM(KARD2).LE.2)THEN
        IF((ICHAR(KARD2(1:1)).GE.48).AND.
     &     (ICHAR(KARD2(1:1)).LE.57).AND.
     &     (ICHAR(KARD2(2:2)).GE.48).AND.
     &     (ICHAR(KARD2(2:2)).LE.57))THEN
           KARD2='0'//KARD2(1:3)
        ENDIF
      ENDIF
C
      IF(CPVREF.NE.'          ') THEN
        ICL5=0
        CALL PVREF1(KARD2,LPVCOD,LPVREF)
        IF((LPVCOD.AND.LPVREF).AND.
     &  (KODTYP.LT.10.OR.KODTYP.GT.999))THEN
          CALL ERRGRO(.TRUE.,34)
          KKTYPE = 97
          LPVXXX=.TRUE.
        ELSEIF((.NOT.LPVCOD).AND.(.NOT.LPVREF))THEN
          CALL ERRGRO(.TRUE.,33)
          CALL ERRGRO(.TRUE.,32)
          KKTYPE = 97
          LPVXXX=.TRUE.
        ELSEIF((.NOT.LPVREF).AND.LPVCOD)THEN
          CALL ERRGRO(.TRUE.,32)
          KKTYPE = 97
          LPVXXX=.TRUE.
        ELSEIF((.NOT.LPVCOD).AND.LPVREF)THEN
          CALL ERRGRO(.TRUE.,33)
          KKTYPE = 97
          LPVXXX=.TRUE.
        ENDIF
      ENDIF
      IF((KODTYP .LT. 10 .OR. KODTYP .GT.999).AND.(.NOT.LPVXXX)) THEN
        CALL ERRGRO (.TRUE.,14)
        KKTYPE = 97
      ELSE
C----------
C  FIND HABITAT CODE IN KOOTENAI HABITAT TYPE TABLE.
C----------
        DO 120 K=1,175
        IF (KODTYP .LT. KOTHAB(K)) GO TO 130
 120    CONTINUE
        KKTYPE = 97
        GO TO 140
 130    CONTINUE
        KKTYPE = K-1
        IF(KKTYPE .EQ. 0)KKTYPE=97
 140    CONTINUE
      ENDIF
      KODTYP=KOTHAB(KKTYPE)
C----------
C  NOW FIND THE CORRESPONDING NORTH IDAHO HABITAT TYPE.
C  IF KODTYP IS OUTSIDE THE ALLOWABLE RANGE, USE DEFAULT VALUE.
C----------
      DO 100 K=1,95
      IF (KODTYP .LT. JTYPE(K)) GO TO 110
 100  CONTINUE
      K=96
 110  CONTINUE
      ITYPE=KTYPE(K-1)
      KODTYP=MTYPE(ITYPE)
C
      IF(LSTART)WRITE (JOSTND,300) KOTHAB(KKTYPE)
 300  FORMAT(/,T12,'KOOTENAI HABITAT TYPE IS',I4,' FOR THIS PROJECTION.'
     &)
      IF(LSTART)WRITE (JOSTND,200) KODTYP
 200  FORMAT(T12,'INLAND EMPIRE HABITAT TYPE IS',I4,' FOR THIS ',
     &'PROJECTION.')
      RETURN
      END
