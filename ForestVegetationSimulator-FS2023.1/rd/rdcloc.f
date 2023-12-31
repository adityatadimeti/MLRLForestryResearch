      SUBROUTINE RDCLOC
      IMPLICIT NONE
C----------
C RD $Id$
C----------
C
C  THIS ROUTINE LOCATES THE ROOT DISEASE CENTERS IN THE STAND
C  INSURING THAT NONE OF THE CENTERS OVERLAP.
C
C  CALLED BY :
C     RDSETP  [ROOT DISEASE]
C
C  CALLS     :
C     RDRANN  (FUNCTION)  [ROOT DISEASE]
C
C  Revision History :
C   02/01/94 - Last revision date.
C   08/27/14 Lance R. David (FMSC)
C     Added implicit none and declared variables.
C
C----------------------------------------------------------------------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'RDPARM.F77'
C
C
      INCLUDE 'RDCOM.F77'
C
C
      INCLUDE 'RDARRY.F77'
C
C
      INCLUDE 'RDADD.F77'
C
C
COMMONS
C
      INTEGER  II, JJ, NTRY
      REAL     AX1(100), AX2(100), AY1(100), AY2(100)
      REAL     RDRANN
      
      DATA AX1, AX2, AY1, AY2 /400*0.0/

      DIMEN = SQRT(SAREA) * 208.7
C
C     BEGIN TO LOCATE THE CENTERS RANDOMLY. SET THE COUNTER NTRY.
C     IF TOO MANY TRIES ARE REQUIRED TO LOCATE A CENTER SO THAT IT
C     DOES NOT OVERLAP ANY PREVIOUS CENTERS THEN WE ASSUME THAT
C     CENTERS ARE SO NUMMEROUS THAT NON-OVERLAPPING CENTERS IS NOT
C     ATTAINABLE.
C

C     IF THE STAND IS TO BE RUN AS ONE CENTER THEN MAKE SURE THAT STAND
C     AREA IS COMPLETELY COVERED BY THE CENTER. ASSUME THAT THE RADIUS 
C     OF THE CENTER IS EQUAL TO HALF THE DIAGONAL OF THE STAND (USE
C     PYTHAGORAS: R^2 = (.5 * DIMEN)^2 + (.5 * DIMEN)^2). ALSO ASSUME
C     THAT THE CENTER OF THE CENTER IS IN THE CENTER OF THE STAND.

c      IF (LONECT(IRRSP) .EQ. 1) THEN
c         PCENTS(IRRSP,1,3) = 0.5 * DIMEN * SQRT(2.0)
c         PCENTS(IRRSP,1,1) = 0.5 * DIMEN
c         PCENTS(IRRSP,1,2) = 0.5 * DIMEN
c         GOTO 200
c      ENDIF   

c     SINCE USING THE DIAGONAL DOESN'T SEEM TO WORK, TRY SETTING THE RADIUS TO BE
C     THE SAME AS ONE SIDE OF THE SQUARE STAND 

      IF (LONECT(IRRSP) .EQ. 1) THEN
         PCENTS(IRRSP,1,3) = DIMEN
         PCENTS(IRRSP,1,1) = 0.5 * DIMEN
         PCENTS(IRRSP,1,2) = 0.5 * DIMEN
         GOTO 200
      ENDIF   

      DO 100 II=1,NCENTS(IRRSP)
         NTRY = 0
         PCENTS(IRRSP,II,3) = SQRT(PAREA(IRRSP) /
     >                        (3.14159 * NCENTS(IRRSP))) * 208.7 
         
  101    CONTINUE
         NTRY = NTRY + 1
         IF (NTRY .GT. 20) GOTO 100
         PCENTS(IRRSP,II,1) = RDRANN(0) * DIMEN
         PCENTS(IRRSP,II,2) = RDRANN(0) * DIMEN
C
C        CALCULATE MAXIMUN EXTENT OF DISEASE CIRCLE IN X AND Y
C        DIRECTIONS.
C
         AX2(II) = PCENTS(IRRSP,II,1) + PCENTS(IRRSP,II,3)
         AX1(II) = PCENTS(IRRSP,II,1) - PCENTS(IRRSP,II,3)
         AY2(II) = PCENTS(IRRSP,II,2) + PCENTS(IRRSP,II,3)
         AY1(II) = PCENTS(IRRSP,II,2) - PCENTS(IRRSP,II,3)
C
C        LOOP THROUGH ALL PREVIOUS CENTER LOCATIONS TO SEE IF THIS
C        CENTER OVERLAPS ANY OF THEM. IF ANY OVERLAP RETURN TO CHOOSE
C        NEW LOCATION FOR CURRENT CENTER.
C
         IF (II .EQ. 1) GOTO 100

         DO 110 JJ=1, II-1
            IF ((PCENTS(IRRSP,II,1) .LT. AX2(JJ) .AND.
     &          PCENTS(IRRSP,II,1) .GT.
     &          AX1(JJ)) .OR. (PCENTS(IRRSP,II,2) .LT. AY2(JJ) .AND.
     &          PCENTS(IRRSP,II,2) .GT. AY1(JJ))) GOTO 101
  110    CONTINUE
  100 CONTINUE
  200 CONTINUE
  
      RETURN
      END
