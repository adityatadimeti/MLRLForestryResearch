      SUBROUTINE RESAGE
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     RESAGE RESETS THE AGE OF THE STAND TO THE VALUE SPECIFIED
C     BY KEYWORD. THIS ROUTINE IS CALLED FROM MAIN AFTER THE CALL
C     TO DISPLY AND THE REGENERATION/ESTABLISHMENT SYSTEM.
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
      INTEGER MYACT2(1)
      REAL PRMS(1)
      INTEGER NTODO,KDT,NP,IACTK,IDT
      DATA MYACT2/443/
C
C     PROCESS RESETAGE KEYWORD
C
      CALL OPFIND (1,MYACT2,NTODO)
      IF (NTODO.LE.0) RETURN
      KDT=IY(ICYC+1)-1
      CALL OPGET (NTODO,1,IDT,IACTK,NP,PRMS)
      IF (IACTK.LT.0) RETURN
      CALL OPDONE (NTODO,KDT)
      IAGE=IFIX(PRMS(1))-IDT+IY(1)
C
      RETURN
      END
