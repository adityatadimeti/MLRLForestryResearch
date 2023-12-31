      SUBROUTINE RDIOUT
      IMPLICIT NONE
C----------
C RD $Id$
C----------
C
C  PRODUCES OPTIONAL OUTPUT (IN A SEPARATE FILE) OF THE RESULTS
C  OF MONTE CARLO SIMULATIONS OF INFECTION WITHIN A CENTER
C
C  CALLED BY :
C     RDCNTL  [ROOT DISEASE]
C
C  CALLS     :
C     DBCHK   (SUBROUTINE)   [PROGNOSIS]
C
C  PARAMETERS :
C     NONE
C
C  COMMON BLOCK VARIABLES :
C     ANUINF: ARRAY CONTAINING INDIVIDUAL SIMULATION RESULTS
C     CORINF: ARRAY CONTAINING THE AVERAGE RESULT AND THE TOTAL UNINF. TREES BEFORE
C             ANY INFECTION OCCURS
C
C  LOCAL VARIABLES : 
C     ISDOUT:  NUMBER OF OUTPUT FILE
C
C  REVISION HISTORY:
C  18-JUN-2001 Lancd R. David (FHTET)
C    Added Stand ID and Management ID line to report header.
C   08/28/14 Lance R. David (FMSC)
C     Added implicit none and declared variables.
C
C----------------------------------------------------------------------
C
C.... PARAMETER INCLUDE FILES
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'RDPARM.F77'
C
C.... COMMON INCLUDE FILES
C
      INCLUDE 'ARRAYS.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'RDARRY.F77'
      INCLUDE 'RDCOM.F77'
      INCLUDE 'RDCRY.F77'
      INCLUDE 'RDADD.F77'
C
C
      CHARACTER*1 CHTYPE(ITOTRR)
      INTEGER  ISIM, J, JYR, MAXSIM, N
      REAL     AVG, SD, SUMX, UINUM
      
      DATA CHTYPE /'P','S','A','W'/
      
      IF (IROOT .EQ. 0) RETURN 

C     IF MONTE CARLO OUTPUT WAS NOT REQUESTED THEN RETURN

      IF (ISDOUT .LE. 0) RETURN          
      
      MAXSIM = MIN(NINSIM,10)
      
      IF (ICYC .EQ. 1) THEN 
C
C         WRITE THE TABLE HEADERS
C
          WRITE (ISDOUT,1100)
          WRITE (ISDOUT,1105)
          WRITE (ISDOUT,1100)
          WRITE (ISDOUT,1110) NPLT, MGMID
          WRITE (ISDOUT,1115)
          WRITE (ISDOUT,1120)
          WRITE (ISDOUT,1155) (N,N=1,MAXSIM)
          WRITE (ISDOUT,1160)

      ENDIF
      
      JYR = IY(ISTEP) - 1
      
      DO 5000 IRRSP=MINRR,MAXRR
         
         IF (PAREA(IRRSP) .LE. 0.0) GOTO 5000
         
         AVG = CORINF(IRRSP,1)                   
         UINUM = CORINF(IRRSP,2)
         
         SUMX = 0.0
         SD = 0.0
         DO 100 ISIM=1,NINSIM
            SUMX = SUMX + (ANUINF(IRRSP,ISIM) - AVG)**2
  100    CONTINUE
         IF (NINSIM .GT. 1) SD = SQRT(SUMX) / FLOAT(NINSIM - 1)

         WRITE(ISDOUT,2099) JYR,CHTYPE(IRRSP),NINSIM,AVG,SD,UINUM,
     &                      (ANUINF(IRRSP,J),J=1,MAXSIM)
         WRITE(ISDOUT,2199) (INFISD(IRRSP,J),J=1,MAXSIM)
C         WRITE(ISDOUT,2200) (SPRQMD(IRRSP,J),J=1,MAXSIM)

 5000 CONTINUE

      WRITE(ISDOUT,1121) 
 
      RETURN

 1100 FORMAT (' ',53('* '))
 1105 FORMAT (' ',43X,'WESTERN ROOT DISEASE MODEL')
 1110 FORMAT (' ',33X,'STAND ID= ',A26,5X,'MANAGEMENT ID= ',A4)
 1115 FORMAT (' ',35X,'INSIDE CENTER INFECTION SIMULATION RESULTS')
 1120 FORMAT (' ',106('-'))
 1121 FORMAT (' ')
 1155 FORMAT (1X,'YEAR',2X,'TYPE',2X,'NUM',2X,'AVG',3X,'SD',3X,
     &        '#UNINF',1X,10(4X,'#',I2))
 1160 FORMAT (1X,106('-'))

 2099 FORMAT (1X,I4,4X,A1,3X,I2,2X,F4.0,2X,F4.0,2X,F6.0,2X,10(3X,F4.0))
 2199 FORMAT (37X,10(4X,I2,1X))
C 2200 FORMAT (37X,10(3X,F4.1))

      END
