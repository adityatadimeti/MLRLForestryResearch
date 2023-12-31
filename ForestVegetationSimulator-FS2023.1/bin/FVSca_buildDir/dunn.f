      SUBROUTINE DUNN (SS)
      IMPLICIT NONE
C----------
C CA $Id$
C----------
C THIS SUBROUTINE PROCESSES THE DUNNING CODE INFORMATION THAT WAS
C ENTERED BY KEYWORD.
C
C WHEN A DUNNING CODE IS ENTERED (IE ANY OF THE SITEAR VALUES BETWEEN
C 0 AND 7)  THEN SITE VALUES FOR ALL SPECIES ARE AUTOMATICALLY SET.  IF
C ANY SITEAR VALUES ARE BETWEEN 8 AND 10 THIS IS AN ERROR AND THE
C DEFAULT VALUE SPECIFIED IN GRINIT IS MAINTAINED.
C THIS ROUTINE IS CALLED FROM INITRE.
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
      REAL ADJFAC(MAXSP),DUNN50(8),XST2(8),SS,DU50
      INTEGER IST,ISPC,I
C----------
C  IF THESE ADJUSTMENT FACTORS CHANGE, ALSO CHANGE THEM IN SITSET.
C----------
      DATA ADJFAC/
     & 0.90, 0.76, 0.90, 1.00, 1.00, 1.00, 1.00, 0.90, 0.90, 0.90,
     & 0.90, 0.90, 0.90, 0.90, 1.00, 1.00, 0.90, 1.00, 0.90, 0.90,
     & 0.76, 0.76, 1.00, 0.76, 0.90, 0.57, 0.57, 0.57, 0.57, 0.57,
     & 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57,
     & 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57, 1.00/
C
      DATA DUNN50/106.,90.,75.,56.,49.,39.,31.,23./
C
C
      IST=INT(SS+1.0)
      DU50=DUNN50(IST)
C----------
C   SET SITE INDEX VALUES BASED ON DUNNING VALUES ENTERED.
C----------
      DO 20 ISPC=1,MAXSP
      SITEAR(ISPC) = DU50 * ADJFAC(ISPC)
   20 CONTINUE
      RETURN
C----------
C   CA FIRE MODEL NEEDS SITE INDICES FOR DUNNING CODES.
C----------
      ENTRY GETDUNN(XST2)
      DO I=1,8
      XST2(I) = DUNN50(I)
      ENDDO
      RETURN
      END
