      SUBROUTINE BWEADV(IYR1)
      IMPLICIT NONE
C----------
C WSBWE $Id$
C----------
C
C     ADJUST PROGNOSIS VARIABLES.
C
C     PART OF THE WESTERN SPRUCE BUDWORM MODEL/PROGNOSIS LINKAGE CODE.
C     NL CROOKSTON--FORESTRY SCIENCES LAB--MOSCOW, MAY, 1984
c     minor changes by K.Sheehan 7/96 to remove LBWDEB,LBWGRO,IHABIT
c        STNDEL, SCSTAG
C
C     DESCRIPTION :
C
C     THIS ROUTINE ADJUSTS VARIABLES WHICH COME FROM PROGNOSIS SO
C     THEY WILL FIT INTO BUDWORM MODEL COMPONENTS.
C
C     CALLED FROM :
C
C       BWESIT - CREATE A BUDWORM MODEL STAND FROM A PROGNOSIS STAND.
C
C     PARAMETERS :
C
C       IYR1   - INVENTORY YEAR OF THE STAND.
C
C Revision History:
C  17-MAY-2005 Lance R. David (FHTET)
C     Added FVS parameter file PRGPRM.F77.
C  14-JUL-2010 Lance R. David (FMSC)
C     Added IMPLICIT NONE and declared variables as needed.
C-----------------------------------------------------------
C
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'BWESTD.F77'
      INCLUDE 'BWECOM.F77'
C
COMMONS
C
      INTEGER ICROWN, IHOST, IYR1
C
C     IF THERE IS LARCH, ADD THE FOLIAGE TO NON-HOST AND SET
C     THE LARCH FLAG EQUAL TO ZERO.
C
      IF (IFHOST(6).EQ.0) GOTO 1020
      DO 1015 ICROWN=1,NCROWN
      FOLNH(ICROWN)=FOLNH(ICROWN)+FOLADJ(6,ICROWN,1)+
     >   FOLADJ(6,ICROWN,2)+FOLADJ(6,ICROWN,3)+FOLADJ(6,ICROWN,4)
 1015 CONTINUE
      IFHOST(6)=0
 1020 CONTINUE
C
      DO 1040 IHOST=1,NHOSTS
      IF (IFHOST(IHOST).EQ.0) GOTO 1040
      DO 1035 ICROWN=1,NCROWN
      FNEW(ICROWN,IHOST)=FOLADJ(IHOST,ICROWN,1)
      FOLD1(ICROWN,IHOST)=FOLADJ(IHOST,ICROWN,2)*
     *                    PRBIO(IHOST,ICROWN,2)
      FOLD2(ICROWN,IHOST)=FOLADJ(IHOST,ICROWN,3)*
     *                    PRBIO(IHOST,ICROWN,3)
      FREM(ICROWN,IHOST)=FOLADJ(IHOST,ICROWN,4)*
     *                    PRBIO(IHOST,ICROWN,4)
C
 1035 CONTINUE
 1040 CONTINUE
C
C     CHECK THE YEARS.
      IBWYR1=IYR1
C
      RETURN
      END
