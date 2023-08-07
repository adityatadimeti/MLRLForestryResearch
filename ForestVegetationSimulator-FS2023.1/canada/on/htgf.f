      SUBROUTINE HTGF
      IMPLICIT NONE
C----------
C CANADA-ON $Id$
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
      INCLUDE 'ARRAYS.F77'
      INCLUDE 'COEFFS.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'MULTCM.F77'
      INCLUDE 'PDEN.F77'
      INCLUDE 'HTCAL.F77'
      INCLUDE 'METRIC.F77'
C
COMMONS
C
      LOGICAL DEBUG
      INTEGER I,ISPC,I1,I2,I3,IS,ITFN
      REAL SCALE,BA10,BARK,BRATIO,DBH10,XHT,XHT2,HTNOW,HT10,GM,TEMHTG
      REAL XTREES,SUMDBHSQ,X,QMD10
      
C----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C----------
      CALL DBCHK (DEBUG,'HTGF',4,ICYC)
      IF (DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE HTGF CYCLE =',I5)
      IF(DEBUG)WRITE(JOSTND,*) 'IN HTGF AT BEGINNING, HTCON=',
     *HTCON,'RMAI=',RMAI,'ELEV=',ELEV
      SCALE=FINT/YR
C----------
C  GET THE HEIGHT GROWTH MULTIPLIERS.
C----------
      CALL MULTS (2,IY(ICYC),XHMULT)
      BA10 = 0.
      XTREES = 0.
      SUMDBHSQ = 0.
C----------
C  DETERMINE BA 10 YEARS FROM NOW
C----------
      DO 20 I=1,ITRN
      BARK = BRATIO(ISP(I),DBH(I),HT(I))
      DBH10= DBH(I)+DG(I)/BARK
      X = PROB(I)*DBH10**2
      BA10 = BA10 + 0.0054542 * X
      XTREES = XTREES + PROB(I)
      SUMDBHSQ = SUMDBHSQ + X
   20 CONTINUE
      QMD10 = 0.0
      IF (XTREES .GT. 0.0) QMD10 = SQRT(SUMDBHSQ/XTREES)

      IF(DEBUG) WRITE(JOSTND,*)'  BA,BA10= ',BA,BA10
C----------
C  FOR CALCULATION OF HEIGHT GROWTH, IF BA10 IS LESS THAN BA (E.G. AS
C  WOULD HAPPEN IN A THIN) SET BA10 TO BA TO AVOID SHRINKING TREES
C----------
      IF(BA10 .LT. BA) BA10 = BA
C----------
C  BEGIN SPECIES LOOP.
C----------
      DO 40 ISPC=1,MAXSP
      I1 = ISCT(ISPC,1)
      IF (I1 .EQ. 0) GO TO 40
      I2 = ISCT(ISPC,2)
      XHT=XHMULT(ISPC)
      XHT2=HCOR2(ISPC)
C----------
C  BEGIN TREE LOOP WITHIN SPECIES LOOP
C----------
      DO 30 I3 = I1,I2
      I=IND1(I3)
      IS=ISP(I)
      BARK=BRATIO(IS,DBH(I),HT(I))
      HTG(I)=0.
      DBH10=DBH(I)+DG(I)/BARK

      IF(DEBUG) WRITE(JOSTND,*) 'I=',I,'  ISPC=',ISPC,'  DBH=',DBH(I),
     & ' SITEAR(ISPC)=',SITEAR(ISPC)

C----------
C BEGIN SECTION FOR CALCULATING USING THE ONTARIO EQUATIONS.
C     NOTE THAT ALL CALCS ARE NOW DONE IN A SUBROUTINE.
C----------

      CALL HTONT(ISPC,DBH(I),RMSQD,BA,HTNOW)
      CALL HTONT(ISPC,DBH10,QMD10,BA10,HT10)

C----------
C  HEIGHT GROWTH EQUATION EVALUATED FOR EACH TREE EACH CYCLE
C  MULTIPLIED BY SCALE TO CHANGE FROM A YR. PERIOD TO FINT
C  AND MULTIPLIED BY XHT TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C----------
      HTG(I)=HT10-HTNOW
C----------
C  GET MODIFIER BORROWED FROM THE DIAMETER GROWTH EQUATIONS AND
C  ADJUST THE HEIGHT GROWTH ESTIMATE.
C----------
      CALL BALMOD(ISPC,DBH(I),BA,RMSQD,GM,DEBUG)
      HTG(I)=HTG(I)*GM
C
      IF(HTG(I) .LT. 0.1) HTG(I)=0.1
      IF(DEBUG) WRITE(JOSTND,*) 'I=',I,'  HT10=',HT10,'  HTNOW=',
     &  HTNOW, '  HTG(I)=',HTG(I),' XHT=',XHT,' XHT2=',XHT2
      HTG(I)=SCALE*XHT*HTG(I)*XHT2
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
C  LOAD OVERALL INTERCEPT FOR EACH SPECIES
C----------
      DO 60 ISPC= 1,MAXSP
      HTCON(ISPC)= 0.0
   60 CONTINUE
      RETURN
      END