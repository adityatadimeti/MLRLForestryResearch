      SUBROUTINE HABTYP (KARD2,ARRAY2)
      IMPLICIT NONE
C----------
C EM $Id$
C----------
C
C     TRANSLATES HABITAT-TYPE CODE INTO A SUBSCRIPT, IEMTYP, AND IF
C     KODTYP IS ZERO, THE ROUTINE RETURNS THE DEFAULT CODE.
C     MAPS HABITAT-TYPE SUBSCRIPT INTO A SUBSCRIPT (ITYPE) REPRESENTING
C     ONE OF THE ORIGINAL 30 NI-VARIANT HABITAT TYPES
C
C     IEMTYP - SUBSCRIPT USED IN **SITSET
C     ITYPE  - SUBSCRIPT USED IN **ESTAB
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
      INCLUDE 'EMCOM.F77'
C
COMMONS
C----------
      REAL ARRAY2
      CHARACTER*10 KARD2
      INTEGER NIHMAP(118),J
      LOGICAL LPVCOD,LPVREF,LPVXXX
      REAL RDANUW
C----------
C  SPECIES ORDER:
C   1=WB,  2=WL,  3=DF,  4=LM,  5=LL,  6=RM,  7=LP,  8=ES,
C   9=AF, 10=PP, 11=GA, 12=AS, 13=CW, 14=BA, 15=PW, 16=NC,
C  17=PB, 18=OS, 19=OH
C
C  SPECIES EXPANSION
C  LM USES IE LM (ORIGINALLY FROM TT VARIANT)
C  LL USES IE AF (ORIGINALLY FROM NI VARIANT)
C  RM USES IE JU (ORIGINALLY FROM UT VARIANT)
C  AS,PB USE IE AS (ORIGINALLY FROM UT VARIANT)
C  GA,CW,BA,PW,NC,OH USE IE CO (ORIGINALLY FROM CR VARIANT)
C----------
C  DATA STATEMENTS
C----------
      DATA NIHMAP/
     & 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
     & 1, 1, 1, 1, 1, 2, 2, 2, 2, 2,
     & 2, 2, 4, 1, 1, 1, 1, 3, 4, 4,
     & 4, 5, 5, 5, 5, 6, 6, 6, 6, 7,
     & 7, 7, 7, 7, 8, 8, 8, 8, 9, 9,
     & 9, 8, 8, 9, 7, 7,10,10, 4,11,
     & 20,29,29,11,11,12,18,19,19,19,
     & 21,21,20,20,20,20,20,20,20,20,
     & 21,21,21,21,22,22,24,24,24,27,
     & 25,26,27,27,27,27,22,24,24,27,
     & 24,27,27,27,28,29,28,28,29,29,
     & 29,27, 9,20,21,27,24,30/
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = ARRAY2
C
      LPVREF=.FALSE.
      LPVCOD=.FALSE.
      LPVXXX=.FALSE.
C----------
C  IF REFERENCE CODE IS NON-ZERO THEN MAP PV CODE/REF. CODE TO
C  FVS HABITAT TYPE/ECOCLASS CODE IN THE KODTYP VARIABLE.
C  THEN PROCESS KODTYP CODE (KODTYP IS PASSED BACK TO HABTYP
C  THROUGH COMMON)
C----------
C  The below ADJSUTL is used to add a leading zero to KODTYPs
C  (PV Code) that are two or less digits. For example, 18
C  would become 018
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
        CALL PVREF1(KARD2,LPVCOD,LPVREF)
        IF((LPVCOD.AND.LPVREF).AND.
     &  (KODTYP.LE.0))THEN
          CALL ERRGRO(.TRUE.,34)
          LPVXXX=.TRUE.
          GOTO 21
        ELSEIF((.NOT.LPVCOD).AND.(.NOT.LPVREF))THEN
          CALL ERRGRO(.TRUE.,33)
          CALL ERRGRO(.TRUE.,32)
          LPVXXX=.TRUE.
          GOTO 21
        ELSEIF((.NOT.LPVREF).AND.LPVCOD)THEN
          CALL ERRGRO(.TRUE.,32)
          LPVXXX=.TRUE.
          GOTO 21
        ELSEIF((.NOT.LPVCOD).AND.LPVREF)THEN
          CALL ERRGRO(.TRUE.,33)
          LPVXXX=.TRUE.
          GOTO 21
        ENDIF
      ENDIF
C
      IF (KODTYP .EQ. 0) GOTO 21
      IF (KODTYP.EQ.0 .OR. KODTYP.LT.JTYPE(1)) GOTO 21
C
      DO 20 J=1,118
      IF(KODTYP .LT. JTYPE(J)) GO TO 100
  20  CONTINUE
  21  CONTINUE
      IF(.NOT.LPVXXX)CALL ERRGRO(.TRUE.,14)
      IEMTYP=ITYPE
      KODTYP= JTYPE(IEMTYP)
      ITYPE=NIHMAP(IEMTYP)
      IF(LSTART)WRITE(JOSTND,23) KODTYP
  23  FORMAT(/,T12,'HABITAT TYPE CODE USED IN THIS PROJECTION IS',I4)
      RETURN
 100  CONTINUE
      IEMTYP=J-1
      IF(IEMTYP.LT.1)IEMTYP=1
      KODTYP= JTYPE(IEMTYP)
      ITYPE=NIHMAP(IEMTYP)
      IF(LSTART)WRITE(JOSTND,30)KODTYP
  30  FORMAT(/,T12,'HABITAT TYPE MAPPED TO',I4,' FOR THIS PROJECTION.')
      RETURN
      END
