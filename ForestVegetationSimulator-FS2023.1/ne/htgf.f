      SUBROUTINE HTGF
      IMPLICIT NONE
C----------
C NE $Id$
C----------
C  THIS SUBROUTINE COMPUTES THE PREDICTED PERIODIC HEIGHT
C  INCREMENT FOR EACH CYCLE AND LOADS IT INTO THE ARRAY HTG.
C  HEIGHT INCREMENT IS PREDICTED FROM SPECIES, SITE INDEX,
C  BASAL AREA/ACRE, AND DBH.  THIS ROUTINE IS CALLED FROM
C  **TREGRO** DURING REGULAR CYCLING.  ENTRY **HTCONS**
C  IS CALLED FROM **RCON** TO LOAD SITE DEPENDENT CONSTANTS
C  THAT NEED ONLY BE RESOLVED ONCE.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'MULTCM.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'HTCAL.F77'
C
C
COMMONS
C
      LOGICAL DEBUG
C
      INTEGER ISPC,I1,I2,I3,I,MODE0,IVAR,ITFN
      REAL SCALE,XHT,YRS,H,HTG1,HTMAX,AGET,GMOD,RELHTA,TEMHTG
C
C----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C----------
      CALL DBCHK (DEBUG,'HTGF',4,ICYC)
      IF (DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE HTGF CYCLE =',I5)
      SCALE=FINT/YR
C----------
C  GET THE HEIGHT GROWTH MULTIPLIERS.
C----------
      CALL MULTS (2,IY(ICYC),XHMULT)
C----------
C  BEGIN SPECIES LOOP.
C----------
      DO 40 ISPC=1,MAXSP
      I1 = ISCT(ISPC,1)
      IF (I1 .EQ. 0) GO TO 40
      I2 = ISCT(ISPC,2)
      XHT=XHMULT(ISPC)
C----------
C  BEGIN TREE LOOP WITHIN SPECIES LOOP
C----------
      DO 30 I3 = I1,I2
      I=IND1(I3)
C----------
C   CALL HTCALC TO CALCULATE AGE BASED ON CURRENT TREE HEIGHT
C----------
        MODE0= 0
        IVAR=3
        YRS=10.
        H=HT(I)
        AGET=0.
        CALL HTCALC (MODE0,IVAR,ISPC,SITEAR(ISPC),YRS,H,AGET,HTMAX,
     &               HTG1,JOSTND,DEBUG)
C----------
C   CALL HTCALC TO CALCULATE HTG BASED ON AGE GIVEN CURRENT TREE HEIGHT
C----------
      MODE0=9
      IVAR=3
      YRS=10.
      H=HT(I)
      HTG1=0.
      CALL HTCALC (MODE0,IVAR,ISPC,SITEAR(ISPC),YRS,H,AGET,HTMAX,
     &             HTG1,JOSTND,DEBUG)
      HTG(I)=HTG1
      IF(DEBUG)WRITE(JOSTND,*) ' I,SI,H,AGET,HTMAX,HTG1= ',         
     & I,SITEAR(ISPC),H,AGET,HTMAX,HTG1
C----------
C  GET BAL MODIFIER BORROWED FROM THE DIAMETER GROWTH EQUATIONS AND
C  ADJUST THE HEIGHT GROWTH ESTIMATE. 
C  POTENTIALLY ONLY AFFECT HEIGHT GROWTH HALF AS MUCH AS DIA GROWTH
C  TEMPER THE ADJUSTMENT BY RELATIVE HEIGHT
C  ADD A RANDOM INCREMENT COMMENSURATE WITH DG RANDOM INCREMENT.
C----------
      CALL BALMOD(ISPC,DBH(I),GMOD)
      IF(DEBUG)WRITE(16,*)' AFTER BALMOD GMOD,HT,AVH= ',GMOD,HT(I),AVH
C      GMOD = (GMOD+1.0)/2.0
      RELHTA=0.
      IF(AVH .GT. 0.)RELHTA=MIN((HT(I)/AVH),1.0)
      GMOD=(1.0-((1.0-GMOD)*(1.0-RELHTA)))*0.8
      HTG(I)=HTG(I)*(1.0+OLDRN(I))*GMOD
C
      IF(DEBUG)WRITE(16,*)' I,HTG,RELHTA,GMOD,OLDRN= ',
     &I,HTG(I),RELHTA,GMOD,OLDRN(I)
C
      IF(HTG(I) .LT. 0.1)HTG(I)=0.1
      HTG(I)=SCALE*XHT*HTG(I)*EXP(HTCON(ISPC))
      IF(DEBUG) WRITE(JOSTND,*) 'I= ',I,'  SCALE= ',SCALE,'  XHT= ',
     &  XHT, '  HTG(I)= ',HTG(I),' HTCON= ',HTCON(ISPC)
      TEMHTG=HTG(I)
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(I)+HTG(I)).GT.SIZCAP(ISPC,4))THEN
        HTG(I)=SIZCAP(ISPC,4)-HT(I)
        IF(HTG(I) .LT. 0.1) HTG(I)=0.1
      ENDIF
C
      IF(.NOT.LTRIP) GO TO 30
      ITFN=ITRN+2*I-1
      HTG(ITFN)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN)+HTG(ITFN)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN)=SIZCAP(ISPC,4)-HT(ITFN)
        IF(HTG(ITFN) .LT. 0.1) HTG(ITFN)=0.1
      ENDIF
C
      HTG(ITFN+1)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN+1)+HTG(ITFN+1)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN+1)=SIZCAP(ISPC,4)-HT(ITFN+1)
        IF(HTG(ITFN+1) .LT. 0.1) HTG(ITFN+1)=0.1
      ENDIF
C
      IF (DEBUG) WRITE(JOSTND,9001) HTG(ITFN),HTG(ITFN+1)
 9001 FORMAT( ' UPPER HTG =',F8.4,'LOWER HTG =',F8.4)
C----------
C  END OF TREE LOOP
C----------
   30 CONTINUE
C----------
C  END OF SPECIES LOOP
C----------
   40 CONTINUE
      RETURN
C
      ENTRY HTCONS
C----------
C  ENTRY POINT FOR LOADING HEIGHT INCREMENT MODEL COEFFICIENTS THAT
C  ARE SITE DEPENDENT AND REQUIRE ONE-TIME RESOLUTION.  HGHC
C  CONTAINS HABITAT TYPE INTERCEPTS, HGLDD CONTAINS HABITAT DEPENDENT
C  COEFFICIENTS FOR THE DIAMETER INCREMENT TERM,HGH2 CONTAINS
C  HABITAT DEPENDENT COEFFICIENTS FOR THE HEIGHT-SQUARED TERM, AND
C  HGHC CONTAINS SPECIES DEPENDENT INTERCEPTS.  HABITAT TYPE IS
C  INDEXED BY ITYPE (SEE /PLOT/ COMMON AREA).
C----------
C----------
C  LOAD OVERALL INTERCEPT FOR EACH SPECIES
C----------
      DO 60 ISPC= 1,MAXSP
      HTCON(ISPC)= 0.0
      IF(LHCOR2 .AND. HCOR2(ISPC).GT.0.0) HTCON(ISPC)=
     &    HTCON(ISPC)+ALOG(HCOR2(ISPC))
  60  CONTINUE
      RETURN
      END
