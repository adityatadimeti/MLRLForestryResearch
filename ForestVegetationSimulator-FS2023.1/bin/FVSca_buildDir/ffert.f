      SUBROUTINE FFERT
      IMPLICIT NONE
C----------
C BASE $Id$
C---------
C  THIS SUBROUTINE COMPUTES A RATIO OF THE FERTILIZATION TREATMENT
C  TO A CONTROL ON DIAMETER GROWTH, AND USES IT AS A MULTIPLICATIVE
C  ADJUSTMENT TO THE PREDICTED VALUES OF DDS (CHANGE IN SQUARED
C  DIAMETER). ALSO, A MULTIPLICATIVE ADJUSTMENT TO THE PREDICTED
C  HEIGHT GROWTH IS APPLIED USING THE RATIO OF AVERAGE HEIGHT
C  INCREMENTS OF FERTILIZER TREATMENT TO A CONTROL. THIS SUBROUTINE
C  IS CALLED BY ** TREGRO **.
C
COMMONS
C
C
      COMMON /FFCOM/ IFFDAT, FFPRMS(4)
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
COMMONS
C
      LOGICAL DEBUG
      INTEGER MYACTS(1),IFFDAT
      INTEGER I,NTODO,NP,IACTK,IDATE,IFSTRT,IFFIN,IFLEN,ISPC,I1,I2,I3
      REAL HTGIT,RHT,DDSIT,FEFF,DDS,DIB,RDDS,BAL,BRATIO,BARKS,D
      REAL CDFGF,FFPRMS,DDSYR
C
C RDDS  - DDSGF RATIO OF FERTILIZER TREATMENT TO CONTROL. USED AS A
C         MULTIPLICATIVE ADJUSTMENT TO THE PREDICTED VALUES OF DDS.
C RHT   - HTGF RATIO OF FERTILIZER TREATMENT TO CONTROL. USED AS A
C         MULTIPLICATIVE ADJUSTMENT TO THE PREDICTED HEIGHT GROWTH
C         VALUES OF EACH TREE.
C
      DATA MYACTS/260/
C
C     SEE IF WE NEED TO DO SOME DEBUG.
C
      CALL DBCHK (DEBUG,'FFERT',5,ICYC)
C
C     IF THIS IS THE FIRST CYCLE, INITIALIZE IFFDAT AND FFPRMS
C
      IF (ICYC .LE. 1) THEN
         IFFDAT=-1
         DO 10 I=1,4
         FFPRMS(I)=0.0
   10    CONTINUE
      ENDIF
C
C     FIND OUT IF THERE IS A FERTILIZATION THIS TIME PERIOD.
C
      CALL OPFIND (1,MYACTS,NTODO)
C
C     IF THERE ARE NONE; THEN: BRANCH TO PROCESS CARRY OVER
C     APPLICATIONS FROM PREVIOUS CYCLE.
C
      IF (NTODO.GT.0) THEN
C
C        GET THE PARAMETERS FOR THE LAST FERTILIZER APPLICATION
C        SCHEDULED FOR THIS CYCLE, AND DELETE/CANCEL ANY OTHERS.
C
         CALL OPGET(NTODO,4,IDATE,IACTK,NP,FFPRMS)
         IF (IACTK.LT.0) GOTO 100
         IFFDAT=IY(ICYC)
C
C        SET THE STATUS OF THE OPTION AS ACCOMPLISHED
C        IN THE BEGINNING OF THE CURRENT CYCLE
C
         CALL OPDONE (NTODO,IY(ICYC))
C
C        IF THERE ARE OTHER FERTILIZE KEYWORDS FOR THE
C        CURRENT CYCLE CANCEL/DELETE ALL BUT THE LAST.
C
         IF (NTODO.GT.1) THEN
           DO 15 I=1,(NTODO-1)
           CALL OPDEL1 (I)
  15       CONTINUE
         ENDIF
      ELSE
         IF (IFFDAT.LT.0) GOTO 100
      ENDIF
C
C     COMPUTE HOW MANY YEARS OF FERTILIZER
C     NEED TO BE ACCOUNTED FOR THIS CYCLE
C
      IFSTRT = IY(ICYC) - IFFDAT
      IF ( IFSTRT .GT. 10 ) GOTO 100
      IFFIN = IFSTRT + IFINT
      IF (IFFIN .GT. 10) IFFIN=10
      IFLEN = IFFIN - IFSTRT
      IF (IFLEN .LE. 0 ) GOTO 100
      IF (IFLEN .NE. 10) THEN
         WRITE(JOSTND,21) IFLEN,IFINT
 21      FORMAT(/' ***** WARNING: FERTILIZER EFFECT IS BEING APPLIED ',
     &     'FOR ',I2,' OF ',I2,' YEARS.  BIASED ESTIMATES MAY RESULT.')
         CALL RCDSET (1,.TRUE.)
      ENDIF
C
C     AT THIS POINT, FFPRMS(1) IS N FERT.(LB/AC), FFPRMS(2) IS P FERT.
C     (LB/AC), FFPRMS(3) IS K FERT. (LB/AC), AND FFPRMS(4) IS PROP. OF
C     EFFICACITY OF FERTIL. APPLICATION.
C
C     SEE IF HABITAT TYPE IS OUTSIDE THE RANGE OF THE FERTILIZER
C     MODEL (HABITAT CODES: 520 AND 530). PRINT A WARNING IF YES.
C
      IF (ICL5 .NE. 520 .AND. ICL5 .NE. 530) THEN
         WRITE(JOSTND,26) ICL5
   26    FORMAT(/' ***** WARNING: HABITAT CODE:',I4,
     &           ' IS OUTSIDE THE RANGE OF THE FERTILIZER MODEL.')
         CALL RCDSET (1,.TRUE.)
      ENDIF
C
C     SEE IF SPECIES COMPOSITION IS OUTSIDE THE RANGE OF THE
C     FERTILIZER MODEL (DF AND GF SPECIES). PRINT A WARNING IF YES.
C     (THE CONTRIBUTION TO THE STAND CCF OF DF AND GF < 50%)
C
      CDFGF = (RELDSP(3) + RELDSP(4))/RELDEN
      IF (CDFGF .LT. 0.5) THEN
         WRITE(JOSTND,27)
   27    FORMAT(/' ***** WARNING: SPECIES COMPOSITION IS OUTSIDE',
     &           ' THE RANGE OF THE FERTILIZER MODEL.')
         CALL RCDSET (1,.TRUE.)
      ENDIF
C
C     BEGIN SPECIES LOOP.
C
      DO 40 ISPC=1,MAXSP
C
      I1=ISCT(ISPC,1)
      IF(I1 .EQ. 0) GOTO 40
      I2= ISCT(ISPC,2)
C
C     BEGIN TREE LOOP WITHIN SPECIES ISPC
C
      DO 35 I3=I1,I2
C
      I = IND1(I3)
      D=DBH(I)
      BARKS=BRATIO(ISPC,D,HT(I))
      IF (D .LE. 0.0) GOTO 35
C
      BAL = (1.-(PCT(I)/100.))*BA
      RDDS= EXP(0.1108*ALOG(D)+0.003004*BAL/ALOG(D+1.))
      IF (RDDS.GT.2.6) RDDS=2.6
C
      DIB = D*BARKS
      DDS = 2*DIB*DG(I) + DG(I)*DG(I)
      FEFF = FFPRMS(4)
      DDSIT = (DDS/YR)*(RDDS*IFLEN*FEFF + IFINT-IFLEN)
      DDSYR = DDSIT * YR/FINT
      DG(I) = SQRT(DIB*DIB + DDSYR) - DIB
C
C     COMPUTE AVERAGE HEIGHT GROWTH RATIO OF FERTILIZER
C     TREATMENT ... CURRENTLY A CONSTANT.
C
      RHT= 1.1626
      HTGIT = (HTG(I)/YR)*(RHT*IFLEN*FEFF + IFINT-IFLEN)
      HTG(I)= HTGIT * YR/FINT
C
C     END OF TREE LOOP. PRINT DEBUGING INFORMATION IF DESIRED
C
      IF (DEBUG) THEN
         WRITE (JOSTND,38) I,ISPC,D,DG(I),HTG(I),RDDS
   38    FORMAT(' IN FFERT I=', I4,', ISPC=',I3,', DBH=',F7.2,
     &          ', DG(I)=',F7.4,', HTG(I)=',F7.4,', RDDS=',F7.2)
      ENDIF
C
   35 CONTINUE
   40 CONTINUE
C
  100 CONTINUE
      RETURN
      END
