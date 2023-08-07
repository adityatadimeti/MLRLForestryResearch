      SUBROUTINE HABTYP (KARD2,ARRAY2)
      IMPLICIT NONE
C----------
C PN $Id$
C----------
C
C     TRANSLATES HABITAT TYPE  CODE INTO A SUBSCRIPT, ITYPE, AND IF
C     KODTYP IS ZERO, THE ROUTINE RETURNS THE DEFAULT CODE.
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
      INCLUDE 'VARCOM.F77'
C
C
COMMONS
C----------
      INTEGER NPA,IHB
      PARAMETER (NPA=75)
      REAL ARRAY2
      CHARACTER*10 KARD2
      CHARACTER*8 PCOML(NPA)
      LOGICAL DEBUG
      LOGICAL LPVCOD,LPVREF,LPVXXX
C----------
      DATA PCOML/
C 1-25
     &'CDS221  ', 'CDS255  ', 'CDS651  ', 'CEF321  ', 'CES212  ',
     &'CES321  ', 'CES621  ', 'CFF111  ', 'CFF211  ', 'CFF311  ',
     &'CFF611  ', 'CFF612  ', 'CFF911  ', 'CFS156  ', 'CFS211  ',
     &'CFS212  ', 'CFS213  ', 'CFS214  ', 'CFS215  ', 'CFS217  ',
     &'CFS218  ', 'CFS219  ', 'CFS311  ', 'CFS611  ', 'CFS612  ',
C 26-50
     &'CHF112  ', 'CHF121  ', 'CHF122  ', 'CHF131  ', 'CHF132  ',
     &'CHF211  ', 'CHF511  ', 'CHF911  ', 'CHM111  ', 'CHS121  ',
     &'CHS122  ', 'CHS123  ', 'CHS131  ', 'CHS132  ', 'CHS133  ',
     &'CHS134  ', 'CHS136  ', 'CHS137  ', 'CHS138  ', 'CHS139  ',
     &'CHS221  ', 'CHS222  ', 'CHS321  ', 'CHS322  ', 'CHS323  ',
C 51-75
     &'CHS324  ', 'CHS331  ', 'CHS332  ', 'CHS333  ', 'CHS334  ',
     &'CHS335  ', 'CHS421  ', 'CHS422  ', 'CHS423  ', 'CHS512  ',
     &'CHS521  ', 'CHS610  ', 'CHS621  ', 'CHS622  ', 'CHS623  ',
     &'CHS624  ', 'CMS242  ', 'CSF111  ', 'CSF121  ', 'CSF321  ',
     &'CSS221  ', 'CSS321  ', 'CSS521  ', 'CSS522  ', 'CSS621  '/
C
      LPVREF=.FALSE.
      LPVCOD=.FALSE.
      LPVXXX=.FALSE.
C-----------
C  CHECK FOR DEBUG.
C-----------
      CALL DBCHK (DEBUG,'HABTYP',6,ICYC)
      IF(DEBUG) WRITE(JOSTND,*)
     &'ENTERING HABTYP CYCLE,KODTYP,KODFOR,KARD2,ARRAY2= ',
     &ICYC,KODTYP,KODFOR,KARD2,ARRAY2
C----------
C  IF REFERENCE CODE IS NON-ZERO THEN MAP PV CODE/REF. CODE TO
C  FVS HABITAT TYPE/ECOCLASS CODE. THEN PROCESS FVS CODE
C----------
      IF(CPVREF.NE.'          ') THEN
        CALL PVREF6(KARD2,ARRAY2,LPVCOD,LPVREF)
        ICL5=0
        IF(DEBUG)WRITE(JOSTND,*)'AFTER PVREF KARD2,ARRAY2= ',
     &  KARD2,ARRAY2
        IF((LPVCOD.AND.LPVREF).AND.
     &      (KARD2.EQ.'          '))THEN
          CALL ERRGRO(.TRUE.,34)
          ITYPE=40
          LPVXXX=.TRUE.
          GO TO 30
        ELSEIF((.NOT.LPVCOD).AND.(.NOT.LPVREF))THEN
          CALL ERRGRO(.TRUE.,33)
          CALL ERRGRO(.TRUE.,32)
          ITYPE=40
          LPVXXX=.TRUE.
          GO TO 30
        ELSEIF((.NOT.LPVREF).AND.LPVCOD)THEN
          CALL ERRGRO(.TRUE.,32)
          ITYPE=40
          LPVXXX=.TRUE.
          GO TO 30
        ELSEIF((.NOT.LPVCOD).AND.LPVREF)THEN
          CALL ERRGRO(.TRUE.,33)
          ITYPE=40
          LPVXXX=.TRUE.
          GO TO 30
        ENDIF
      ENDIF
C----------
C  DECODE HABITAT TYPE/PLANT ASSOCIATION FIELD.
C----------
      CALL HBDECD (KODTYP,PCOML(1),NPA,ARRAY2,KARD2)
      IF(DEBUG)WRITE(JOSTND,*)'AFTER HAB DECODE,KODTYP= ',KODTYP
      IF (KODTYP .LE. 0) GO TO 20
C
      PCOM = PCOML(KODTYP)
      ITYPE=KODTYP
      IF(LSTART)WRITE(JOSTND,10) PCOM
   10 FORMAT(/,T12,'PLANT ASSOCIATION CODE USED IN THIS',
     &' PROJECTION IS ',A8)
      GO TO 40
C----------
C  NO MATCH WAS FOUND, TREAT IT AS A SEQUENCE NUMBER.
C----------
   20 CONTINUE
      IF(DEBUG)WRITE(JOSTND,*)'EXAMINING FOR INDEX, ARRAY2= ',ARRAY2
      IHB = IFIX(ARRAY2)
      IF(IHB.GT.0 .AND. IHB.LE.NPA)THEN
        KODTYP=IHB
        ITYPE=IHB
        PCOM = PCOML(KODTYP)
        GO TO 40
      ELSE
C----------
C  DEFAULT CONDITIONS --- PA = CHS133
C----------
        ITYPE=40
        GO TO 30
      ENDIF
C
   30 CONTINUE
      IF(.NOT.LPVXXX)CALL ERRGRO(.TRUE.,14)
      KODTYP=ITYPE
      PCOM = PCOML(KODTYP)
      IF(LSTART)WRITE(JOSTND,10) PCOM
C
   40 CONTINUE
      ICL5=KODTYP
      KARD2=PCOM
C
      IF(DEBUG)WRITE(JOSTND,*)'LEAVING HABTYP KODTYP,ITYPE,ICL5,KARD2',
     &' PCOM =',KODTYP,ITYPE,ICL5,KARD2,PCOM
C
      RETURN
      END
