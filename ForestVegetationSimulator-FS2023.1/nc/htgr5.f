      SUBROUTINE HTGR5(ISP,SSITE,BAA,YHTG,RELHT,CR,H,DEBUG)
      IMPLICIT NONE
C----------
C NC $Id$
C----------
C
C SUBROUTINE TO CALCULATE 5-YEAR HEIGHT GROWTH
C SPECIES INDEX 1-OC, 2-WP, 3-DF, 4-WF, 5-M , 6-IC, 7-BO,
C               8-TO, 9-RF, 10-PP, 11-OTHER, 12 - RW
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
C----------
      LOGICAL DEBUG
      REAL HRELHT(12),HCRSQ(12),HHT(12),HBA(12),HSITE(12),HCON(12)
      REAL H,CR,RELHT,YHTG,BAA,SSITE,HTGR
      REAL HTMAX,AGE1,AGE2,H1,H2
      INTEGER IMETH(12),ISP
      DATA HRELHT/12*4.292/
      DATA HCRSQ/12*0.0566/
      DATA HHT/12*0.1699/
      DATA HBA/4*-0.00828,-0.54648,-0.00828,-0.78296,-0.58984,
     &         2*-0.00828,-0.54984, -0.00828/
      DATA HSITE/12*0.00768/
      DATA IMETH/1,1,1,1,2,1,2,2,1,1,2,3/
      DATA HCON/4*-2.193,3.560,-2.193,3.817,3.385,2*-2.193,
     &          3.385, -2.193/

C  CALCULATE HTGR FOR SPECIES GROUP 2
      IF(IMETH(ISP) .EQ. 2) THEN
        IF(BAA .LE. 5.0)BAA=5.0
        HTGR = EXP(HCON(ISP) + HBA(ISP)*ALOG(BAA))

C  CALCULATE HTGR FOR SPECIES GROUP 1
      ELSE IF (IMETH(ISP) .EQ. 1) THEN
        HTGR=HCON(ISP) + RELHT*HRELHT(ISP) + HCRSQ(ISP)*CR*CR
     &    + HHT(ISP) * H + HBA(ISP)*BAA + HSITE(ISP)*SSITE

C  CALCULATE HTGR FOR COAST REDWOOD
      ELSE
        HTMAX=(2.242202*SSITE)
        IF(HTMAX-H.LE.1.) THEN
          HTGR = 0.0

C  CALCULATE CURRENT AGE AND AGE 5 YEARS HENCE
        ELSE
          AGE1 = 1/-0.010742*
     &         LOG(1-((H)/2.242202/SSITE)**(1/0.919076))
          AGE2 = AGE1 + 5

C ESTIMATE H1 BASED ON AGE1 AND H2 BASED ON AGE2
          H1 = 2.242202*SSITE*(1-EXP(-0.010742*AGE1))**0.919076
          H2 = 2.242202*SSITE*(1-EXP(-0.010742*AGE2))**0.919076

C COMPUTE HEIGHT INCREMENT BASED ON SUBTRACTION OF H2 AND H1
          HTGR = H2 - H1
        ENDIF
        IF(DEBUG)WRITE(JOSTND,*) "RW DEBUG"," H=", H, ' AGE1=', AGE1,
     & " AGE2=", AGE2, " H1=", H1, " H2=", H2," SI=", SSITE,
     & " HTGR=", HTGR
      ENDIF
C----------
C  ROUTINE FOR HARDWOODS
C----------
      IF(HTGR .LE. 0.0)HTGR = 0.01
      YHTG=HTGR
      RETURN
      END
