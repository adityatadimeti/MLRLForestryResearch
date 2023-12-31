      SUBROUTINE FORKOD
      IMPLICIT NONE
C----------
C KT $Id$
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
      INCLUDE 'KOTCOM.F77'
C
COMMONS
C
C
C  ------------------------
C  NATIONAL FORESTS:
C  103 = BITTERROOT
C  104 = IDAHO PANHANDLE
C  105 = CLEARWATER
C  106 = COEUR D'ALENE
C  621 = COLVILLE
C  110 = FLATHEAD
C  113 = KANIKSU
C  114 = KOOTENAI
C  116 = LOLO
C  117 = NEZ PERCE
C  118 = ST. JOE
C  613 = KANIKSU ADMINISTERED BY COLVILLE (MAPPED TO KANIKSU 113)
C  ------------------------
C  RESERVATION PSUEDO CODES:
C  8109 = KOOTENAI OFF-RES. TRUST LAND    (MAPPED TO KANIKSU   113)
C  8133 = FLATHEAD RESERVATION            (MAPPED TO FLATHEAD  110)
C  8137 = COEUR D'ALENE RESERVATION       (MAPPED TO ST. JOE   118)
C  ------------------------
      LOGICAL FORFOUND
      INTEGER JFOR(12),KFOR(12),NUMFOR,I,IFORDI,INTER,IFORE,IDIST,ICOMP
      DATA JFOR/103,104,105,106,621,110,113,114,116,117,118,613 /,
     >          NUMFOR /12/
      DATA KFOR/1,1,3,2,1,1,1,1,1,3,2,1 /
      FORFOUND = .FALSE.


C     CROSSWALK FOR RESERVATION PSUEDO CODES & LOCATION CODE
      SELECT CASE (KODFOR)

        CASE (8109)
          WRITE(JOSTND,72)
   72     FORMAT(/,'********   ',T12,'KOOTENAI OFF-RES. TRUST (8109) ',
     &    'BEING MAPPED TO KANIKSU NF (113) FOR FURTHER PROCESSING.')
          KODFOR = 11300000

        CASE (8133)
          WRITE(JOSTND,75)
   75     FORMAT(/,'********   ',T12,'FLATHEAD RESERVATION (8133) ',
     &    'BEING MAPPED TO FLATHEAD NF (110) FOR FURTHER PROCESSING.')
          KODFOR = 11000000

        CASE (8137)
          WRITE(JOSTND,76)
   76     FORMAT(/,'********   ',T12,'COEUR D''ALENE RESERV. (8137) ',
     &    'BEING MAPPED TO ST. JOE NF (118) FOR FURTHER PROCESSING.')
          KODFOR = 11800000

      END SELECT
C     END CROSSWALK FOR RESERVATION PSUEDO CODES & LOCATION CODE

C     PAD SHORTER FOREST LOCATION CODES WITH ZEROS
      IF (KODFOR .GE. 100 .AND. KODFOR .LE. 9999999) THEN

        SELECT CASE (KODFOR)
          CASE (100 : 999)
            KODFOR = KODFOR * 100000
          CASE (1000: 9999)
            KODFOR = KODFOR * 10000
          CASE (10000: 99999)
            KODFOR = KODFOR * 1000
          CASE (100000: 999999)
            KODFOR = KODFOR * 100
          CASE (1000000: 9999999)
            KODFOR = KODFOR * 10
        END SELECT
      ENDIF
C     END PAD SHORTER FOREST LOCATION CODES WITH ZEROS

      IF (KODFOR .GT. 0) THEN
        DO 10 I=1,NUMFOR
          IFORDI=KODFOR/100000
          IF (IFORDI .EQ. JFOR(I)) THEN
            IFOR = I
            IF(I .EQ. 12)THEN
              WRITE(JOSTND,21)
   21         FORMAT(/,'********',T12,'KANIKSU NF (613) BEING MAPPED ',
     &        'TO KANIKSU (113) FOR FURTHER PROCESSING.')
              IFOR = 7
            ENDIF
            IGL=KFOR(IFOR)
            FORFOUND = .TRUE.
            EXIT
          END IF
   10   CONTINUE

C     LOCATION CODE ERROR TRAP
        IF (.NOT. FORFOUND) THEN
          CALL ERRGRO (.TRUE.,3)
          WRITE(JOSTND,200) JFOR(IFOR)
  200     FORMAT(/,'********',T12,'FOREST CODE USED FOR THIS ',
     &    'PROJECTION IS',I4)
        END IF

      END IF

C----------
C  SET DEFAULT KOTFOR TO 8 TO AVOID BLOWUPS IN REGENT & DGF
C  GED 8-29-96.
C----------
      KOTFOR=8
C----------
C  THIS NEXT SECTION TRANSLATES THE FOREST CODES INTO LOCATION
C  CODES FOR THE KOOTENAI VARIANT.
C----------
      INTER = KODFOR - 10000000
      IF(INTER .LT. 0) INTER =0
      IFORE = INTER/100000
      IDIST = INTER/1000
      ICOMP = INTER-IDIST*1000
        IF(IFORE .EQ. 10 .OR. IFORE .EQ. 0) KOTFOR=8
        IF(IFORE .EQ. 14)   KOTFOR=7
        IF(IDIST .EQ. 1402) KOTFOR=2
        IF(IDIST .EQ. 1403) KOTFOR=3
        IF(IDIST .EQ.  406) KOTFOR=7
        IF(IDIST .EQ. 1404 .OR. IDIST .EQ. 407) KOTFOR=4
        IF(IDIST .EQ. 1401) THEN
           IF(ICOMP .GE. 16 .AND. ICOMP .LE. 27) THEN
             KOTFOR = 1
           ELSE
             KOTFOR = 2
           ENDIF
        ENDIF
        IF(IDIST .EQ. 1405) THEN
           IF((ICOMP .GE. 1 .AND. ICOMP .LE. 4) .OR. (ICOMP .GE. 8
     &         .AND. ICOMP .LE. 19) .OR. (ICOMP .EQ. 27)) THEN
             KOTFOR = 5
           ELSE
             KOTFOR = 10
           ENDIF
        ENDIF
        IF(IDIST .EQ. 1406) THEN
           IF(ICOMP .GE. 1 .AND. ICOMP .LE. 4) THEN
             KOTFOR = 6
           ELSE
             KOTFOR = 9
           ENDIF
         ENDIF
      KOTNUM=KODFOR

      KODFOR=JFOR(IFOR)
      RETURN
      END