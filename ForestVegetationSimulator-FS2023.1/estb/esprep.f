      SUBROUTINE ESPREP (ISER,PNONE,PMECH,PBURN)
      IMPLICIT NONE
C----------
C ESTB $Id$
C----------
C     PREDICT DEFAULT SITE PREP PROBABILITIES.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'ESCOM2.F77'
C
C
      INCLUDE 'PLOT.F77'
C
      REAL PBURN,PMECH,PNONE,PN
      INTEGER ISER
C
COMMONS
C
C     PROB(NO SITE PREP)  15:34 ON 5/5/88
C
      PN= 1.043151 +XPREP(1,ISER) -0.220954*COS(ASPECT)*SLOPE
     &    +0.369575*SIN(ASPECT)*SLOPE +0.769112*SLOPE
     &    +0.260178*ALOG(BA+1.0) -0.029689*ELEV
      PNONE = 1.0/(1.0+EXP(-PN))
C
C     PROB(MECH SITE PREP)     16:29 ON 5/5/88
C
      PN= -1.852031 +XPREP(2,ISER) +0.492668*COS(ASPECT)*SLOPE
     &    +0.192020*SIN(ASPECT)*SLOPE -0.966674*SLOPE
     &    -0.085920*ALOG(BA+1.0) +0.024939*ELEV
      PMECH = 1.0/(1.0+EXP(-PN))
C
C     PROB(BURN SITE PREP)
C
      PN= -15.195303 +XPREP(3,ISER) +0.0519477*COS(ASPECT)*SLOPE
     &    -0.6135848*SIN(ASPECT)*SLOPE -0.0890163*SLOPE -0.377915*
     &    ALOG(BA+1.0) +0.5303707*ELEV -0.0049081*ELEV*ELEV
      PBURN = 1.0/(1.0+EXP(-PN))
      RETURN
      END
