      SUBROUTINE RCDSET (IC,LRETRN)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     SETS THE RETURN CODE FOR THE PROGNOSIS MODEL.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
      INTEGER IC
      LOGICAL LRETRN
C
      IF (IC.GT.ICCODE) ICCODE=IC
      IF (.NOT.LRETRN) CALL fvsSetRtnCode (1)
      RETURN
      END
