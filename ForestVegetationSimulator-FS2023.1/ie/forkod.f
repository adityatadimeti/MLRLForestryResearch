      SUBROUTINE FORKOD
      IMPLICIT NONE
C----------
C IE $Id$
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
C  117 = NEZPERCE
C  118 = ST. JOE
C  613 = KANIKSU ADMINISTERED BY COLVILLE (MAPPED TO KANIKSU 113)
C  102 = BEAVERHEAD                       (MAPPED TO BITTERROOT 103)
C  109 = DEERLODGE                        (MAPPED TO BITTERROOT 103)
C  112 = HELENA                           (MAPPED TO LOLO 116)
C  ------------------------
C  RESERVATION PSUEDO CODES:
C  8106 = COLVILLE RESERVATION            (MAPPED TO COLVILLE  621)
C  8107 = NEZ PERCE RESERVATION           (MAPPED TO NEZ PERCE 117)
C  8109 = KOOTENAI OFF-RES. TRUST LAND    (MAPPED TO KANIKSU   113)
C  8131 = SPOKANE RESERVATION             (MAPPED TO COLVILLE  621)
C  8132 = KALISPEL RESERVATION            (MAPPED TO KANIKSU   113)
C  8133 = FLATHEAD RESERVATION            (MAPPED TO FLATHEAD  110)
C  8137 = COEUR D'ALENE RESERVATION       (MAPPED TO ST. JOE   118)
C  ------------------------
      INTEGER JFOR(15),KFOR(15),NUMFOR,I
      LOGICAL USEIGL, FORFOUND
      DATA JFOR/103,104,105,106,621,110,113,114,116,117,118,613,
     &          102,109,112/,
     >          NUMFOR /15/
      DATA KFOR/1,1,3,2,1,1,1,1,1,3,2,1,1,1,1 /

      USEIGL = .TRUE.
      FORFOUND = .FALSE.
      

      SELECT CASE (KODFOR)
C       CROSSWALK FOR RESERVATION PSUEDO CODES & LOCATION CODE
        CASE (8106)
          WRITE(JOSTND,70)
   70     FORMAT(/,'********',T12,'COLVILLE RESERVATION (8106) ',
     &    'BEING MAPPED TO COLVILLE NF (621) FOR FURTHER PROCESSING.')
          IFOR = 5

        CASE (8107)
          WRITE(JOSTND,71)
   71     FORMAT(/,'********',T12,'NEZ PERCE RESERVATION (8107) ',
     &    'BEING MAPPED TO NEZ PERCE NF (117) FOR FURTHER PROCESSING.')
          IFOR = 10

        CASE (8109)
          WRITE(JOSTND,72)
   72     FORMAT(/,'********',T12,'KOOTENAI OFF-RES. TRUST (8109) ',
     &    'BEING MAPPED TO KANIKSU NF (113) FOR FURTHER PROCESSING.')
          IFOR = 7

        CASE (8131)
          WRITE(JOSTND,73)
   73     FORMAT(/,'********',T12,'SPOKANE RESERVATION (8131) ',
     &    'BEING MAPPED TO COLVILLE NF (621) FOR FURTHER PROCESSING.')
          IFOR = 5

        CASE (8132)
          WRITE(JOSTND,74)
   74     FORMAT(/,'********',T12,'KALISPEL RESERVATION (8132) ',
     &    'BEING MAPPED TO KANIKSU NF (113) FOR FURTHER PROCESSING.')
          IFOR = 7

        CASE (8133)
          WRITE(JOSTND,75)
   75     FORMAT(/,'********',T12,'FLATHEAD RESERVATION (8133) ',
     &    'BEING MAPPED TO FLATHEAD NF (110) FOR FURTHER PROCESSING.')
          IFOR = 6

        CASE (8137)
          WRITE(JOSTND,76)
   76     FORMAT(/,'********',T12,'COEUR D''ALENE RESERV. (8137) ',
     &    'BEING MAPPED TO ST. JOE NF (118) FOR FURTHER PROCESSING.')
          IFOR = 11
C       END CROSSWALK FOR RESERVATION PSUEDO CODES & LOCATION CODE

        CASE DEFAULT
        
C         CONFIRMS THAT KODFOR IS AN ACCEPTED FVS LOCATION CODE
C         FOR THIS VARIANT FOUND IN DATA ARRAY JFOR
          DO 10 I=1,NUMFOR
            IF (KODFOR .EQ. JFOR(I)) THEN
              IFOR = I
              FORFOUND = .TRUE.
              EXIT
            ENDIF
   10     CONTINUE        
          
C         LOCATION CODE ERROR TRAP       
          IF (.NOT. FORFOUND) THEN
            CALL ERRGRO (.TRUE.,3)
            WRITE(JOSTND,11) JFOR(IFOR)
   11       FORMAT(/,'********',T12,'FOREST CODE USED IN THIS ',
     &      'PROJECTION IS',I4)
            USEIGL = .FALSE.
          ENDIF

      END SELECT

C     FOREST MAPPING CORRECTION
      SELECT CASE (IFOR)
        CASE (12)
          WRITE(JOSTND,22)
   22     FORMAT(/,'********',T12,'KANIKSU NF (613) BEING MAPPED TO ',
     &    'KANIKSU (113) FOR FURTHER PROCESSING.')
          IFOR = 7
        CASE (13)
          WRITE(JOSTND,24)
   24     FORMAT(/,'********',T12,'BEAVERHEAD (102) BEING MAPPED TO ',
     &    'BITTERROOT (103) FOR FURTHER PROCESSING.')
          IFOR = 1
        CASE (14)
          WRITE(JOSTND,26)
   26     FORMAT(/,'********',T12,'DEERLODGE (109) BEING MAPPED TO ',
     &    'BITTERROOT (103) FOR FURTHER PROCESSING.')
          IFOR = 1
        CASE (15)
          WRITE(JOSTND,28)
   28     FORMAT(/,'********',T12,'HELENA (112) BEING MAPPED TO ',
     &    'LOLO (116) FOR FURTHER PROCESSING.')
          IFOR = 9
      END SELECT


C     SET THE IGL VARIABLE ONLY IF DEFAULT FOREST IS USED
C     GEOGRAPHIC LOCATION CODE: 1=NORTH, 2=CENTRAL, 3=SOUTH
C     USED TO SET SOME EQUATIONS IN REGENERATION AND PERHAPS
C     HEIGHT-DIAMETER IN DIFFERENT VARIANTS.
      IF (USEIGL)IGL = KFOR(IFOR)

      KODFOR=JFOR(IFOR)
      RETURN
      END