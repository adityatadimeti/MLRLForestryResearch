      SUBROUTINE GRINCR (DEBUG,IPMODI,LTMGO,LMPBGO,LDFBGO,
     1                   LBWEGO,LCVATV)
      IMPLICIT NONE
C----------
C CANADA-BC $Id$
C----------
C
C     COMPUTES GROWTH AND MORTALITY ON EACH TREE RECORD.
C
C     CALLED FROM: TREGRO.
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
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'STDSTK.F77'
C
C
      INCLUDE 'ESHAP.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
COMMONS
C
      REAL PRM(6)
      INTEGER MYACTS(4)
      INTEGER IPMODI,NTODO,ITODO,NP,IACTK,IDATE,I,IS,IGRP,IULIM,IG,IGSP
      INTEGER IC,ICDF,IBDF,ISPCC,ITFN,J,JJ,K
      REAL STAGEA,STAGEB      
      LOGICAL LTMGO,LMPBGO,LDFBGO,LBWEGO,LCVATV,DEBUG,LINCL
      INTEGER IBA,ISTOPRES,IRTNCD
      CHARACTER*20 KARD
      DATA MYACTS/98,99,120,445/
      DATA KARD/'                    '/
C
C     SET THE CYCLE LENGTH AND OPTION POINTERS FOR THE CYCLE.
C
      IF(ICYC .GE. 2) THEN
        OLDFNT = IY(ICYC)-IY(ICYC-1)
      ELSE
        OLDFNT = FINT
      ENDIF
      IFINT=IY(ICYC+1)-IY(ICYC)
      FINT=IFINT
C
C     SET UP THE OPTION POINTERS FOR THE CYCLE.
C
      CALL OPCSET (ICYC)
C
C     SET CYCLE DEPENDENT SWITCHES
C
      LTRIP=(ICYC.LE.ICL4.AND.ITRN.LE.(MAXTRE/3).AND..NOT.NOTRIP)
C
C     GET THE RESTART CODE AND BRANCH ACCORDINGLY
C
      CALL fvsGetRestartCode (ISTOPRES)
      IF (DEBUG) WRITE (JOSTND,5) ICYC,ISTOPRES,NPLT
    5 FORMAT (/' IN GRINCR, ICYC=',I3,'; ISTOPRES=',I3,'; NPLT=',A)
      GOTO (1,16,17,71,72), ISTOPRES+1

C     STOP HAS NOT OCCURED

    1 CONTINUE
C----------
C PROCESS THE SETSITE OPTIONS.
C----------
      CALL OPFIND (1,MYACTS(3),NTODO)
      IF(NTODO.GT.0) THEN
        DO 9 ITODO=1,NTODO
        CALL OPGET (ITODO,6,IDATE,IACTK,NP,PRM)
        IF (IACTK.LT.0) GOTO 9
        CALL OPDONE(ITODO,IY(ICYC))
C        
        IF(PRM(1) .GT. 0.)THEN
          KODTYP=IFIX(PRM(1))
          KARD='                    '
          CPVREF= '          '
          CALL HABTYP (KARD,PRM(1))
          IF(KODTYP .GT. 0)ICL5=KODTYP
          DO 4 I=1,MAXPLT
          IPHAB(I)=ITYPE
    4     CONTINUE
          IF(DEBUG)WRITE(JOSTND,*)' IN GRINCR PROCESSING SETSITE HABITA'
     &    ,'T TYPE: KODTYP,ICL5,ITYPE= ',KODTYP,ICL5,ITYPE
        ENDIF
C
        IF(PRM(2) .GT. 0)THEN
          BAMAX=PRM(2)
          LBAMAX=.TRUE.
          IF(DEBUG)WRITE(JOSTND,*)' IN GRINCR PROCESSING SETSITE',
     &    ' BASAL AREA MAXIMUM = ',BAMAX,'  LBAMAX = ',LBAMAX     
        ENDIF
C 
        IS=IFIX(PRM(3))
C----------
C     IF (IS<0) CHANGE ALL SPECIES IN THE GROUP
C     IF SITE SPECIES HAS NOT BEEN SET, SET IT TO THE FIRST SPECIES
C     IN THE GROUP.
C----------
        IF(IS .LT. 0) THEN
          IGRP = -IS
          IULIM = ISPGRP(IGRP,1)+1
          IF (ISISP .EQ. 0) ISISP=ISPGRP(IGRP,2)
          LSITE=.TRUE.
          DO 6 IG=2,IULIM
          IGSP = ISPGRP(IGRP,IG)
          IF(PRM(5) .EQ. 0)THEN
            IF(PRM(4).GT.0.)SITEAR(IGSP)=PRM(4)
          ELSE
            IF(PRM(4).NE.0.)SITEAR(IGSP)=SITEAR(IGSP)+SITEAR(IGSP)*
     &                      PRM(4)/100.
          ENDIF
          IF(SITEAR(IGSP).LT.1.)SITEAR(IGSP)=1.
          IF(PRM(6) .GT. 0.) THEN
            SDIDEF(IGSP)=PRM(6)
            MAXSDI(IGSP)=1
          ENDIF
    6     CONTINUE
C----------
C     IF (IS=0) ALL SPECIES WILL BE CHANGED IN FOLLOWING CODE:
C----------
        ELSEIF(IS .EQ. 0)THEN
          DO 7 I=1,MAXSP
          IF(PRM(5) .EQ. 0)THEN
            IF(PRM(4).GT.0.)SITEAR(I)=PRM(4)
          ELSE
            IF(PRM(4).NE.0.)SITEAR(I)=SITEAR(I)+SITEAR(I)*PRM(4)/100.
          ENDIF
          IF(SITEAR(I).LT.1.)SITEAR(I)=1.
          IF(PRM(6) .GT. 0.) THEN
            SDIDEF(I)=PRM(6)
            MAXSDI(I)=1
          ENDIF
    7     CONTINUE
C----------
C     SPECIES CODE IS SPECIFIED (IS>0).
C----------
        ELSE
          IF(PRM(5) .EQ. 0)THEN
            IF(PRM(4).GT.0.)SITEAR(IS)=PRM(4)
          ELSE
            IF(PRM(4).NE.0.)SITEAR(IS)=SITEAR(IS)+SITEAR(IS)*PRM(4)/100.
          ENDIF
          IF(SITEAR(IS).LT.1.)SITEAR(IS)=1.
          IF(PRM(6) .GT. 0.) THEN
            SDIDEF(IS)=PRM(6)
            MAXSDI(IS)=1
          ENDIF
        ENDIF
C
        IF(DEBUG .AND. (PRM(4).GT.0. .OR. PRM(6).GT.0.))THEN
          WRITE(JOSTND,*)' IN GRINCR PROCESSING SETSITE SITE INDEX ',
     &      'AND/OR SDIMAX:'
C
          DO 992 I=1,15
          J=(I-1)*10 + 1
          JJ=J+9
          IF(JJ.GT.MAXSP)JJ=MAXSP
          WRITE(JOSTND,990)(NSP(K,1)(1:2),K=J,JJ)
  990     FORMAT(/'    SPECIES ',5X,10(A2,6X))
          WRITE(JOSTND,994)(SITEAR(K),K=J,JJ )
  994     FORMAT(' SITE INDEX ',   10F8.0)
          WRITE(JOSTND,991)(SDIDEF(K),K=J,JJ )
  991     FORMAT('    SDI MAX ',   10F8.0)
          IF(JJ .EQ. MAXSP)GO TO 993
  992     CONTINUE
  993     CONTINUE
        ENDIF
    9   CONTINUE
        IF(ISISP.GT.0 .AND. ISISP.LE.MAXSP)THEN
          STNDSI=SITEAR(ISISP)
        ELSE
          STNDSI=0.
        ENDIF
        CALL RCON
      ENDIF

C----------
C PROCESS THE PERMFRST OPTION WHICH IS ONLY VALID FOR AK VARIANT.
C----------
      CALL OPFIND (1,MYACTS(4),NTODO)
      IF(NTODO.GT.0) THEN
        DO ITODO = 1,NTODO
          CALL OPGET (ITODO,1,IDATE,IACTK,NP,PRM)
          IF (IACTK.GE.0) THEN
            CALL OPDONE(ITODO,IY(ICYC))
            IF(PRM(1) .EQ. 0.)THEN
              LPERM = .FALSE.
            ELSEIF(PRM(1) .EQ. 1.)THEN
              LPERM = .TRUE.
            ENDIF
            IF(DEBUG) WRITE(JOSTND,*)
     &      ' IN GRINCR PROCESSED PERMFRST - LPERM: ',LPERM
          ENDIF
        ENDDO
      ENDIF      
C
C     WESTERN ROOT DISEASE VER. 3.0 MODEL PROJECTION SETUP.
C
      CALL RDMN2 (OLDFNT)
      CALL RDTRP (LTRIP)
C
C     FIRE MODEL PROJECTION SETUP
C
      CALL FMSDIT
C
C     CALL SILFTY (ENTRY IN SDICAL) TO COMPUTE SILVAH FOREST TYPE
C     BEFORE THINNING
C
      CALL SILFTY
C
      IF (DEBUG) WRITE(JOSTND,10)BTSDIX,SDIBC,SDIBC2,ICYC
   10 FORMAT(' BEFORE SDICAL, BTSDIX, SDIBC, SDIBC2, CYCLE=',
     &F9.1,2F9.1,I2)
C
C     CALL SDICAL TO GET CYCLE 0 BEFORE CUT SDI MAX.
C
      CALL SDICAL(0,BTSDIX)
      CALL SDICLS(0,0.,999.,1,SDIBC,SDIBC2,STAGEA,STAGEB,0)
C
      IF (DEBUG) WRITE(JOSTND,15) BTSDIX, SDIBC, SDIBC2, ICYC
   15 FORMAT(' AFTER SDICAL, BTSDIX, SDIBC, SDIBC2, CYCLE=',
     &       F9.1,2F9.1,I2) 
C 
      IBA = 1
      CALL SSTAGE (IBA,ICYC,.FALSE.)
C
C     IS THIS A STOPPING POINT?
C
      CALL fvsStopPoint (1,ISTOPRES)
      IF (ISTOPRES.NE.0) RETURN
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN
   16 CONTINUE
C
C     IF PROCESSING A PHASE 1 SKIP CALL TO EVENT MONITOR.
C
      CALL EVMON (1,1)
C
C     IS THIS A STOPPING POINT?
C
      CALL fvsStopPoint (2,ISTOPRES)
      IF (ISTOPRES.NE.0) RETURN
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN
   17 CONTINUE
C
C     EVALUATE ECON EXTENSTION STATUS
C     0 MEANS THIS CALL TO ECSTATUS.F IS BEFORE THE CALL TO CUTS.F
C
      CALL ECSTATUS(ICYC, NCYC, IY, 0)
C
C     PRINT THE VISULIZATION FOR BEGINING CYCLE. SKIP IN FIRST CYCLE.
C
      IF (ICYC.GT.1) CALL SVOUT(IY(ICYC),1,'Beginning of cycle')
C
C     SAVE LAST CYCLE DENSITY STATS.
C
      OLDTPA=TPROB
      OLDAVH=AVH
      OLDBA=BA
      RELDM1=RELDEN
      ORMSQD=RMSQD
C
C     CALL **CUTS** TO INVOKE THINNING.
C
      IF (DEBUG) WRITE(JOSTND,20) ICYC
   20 FORMAT(' CALLING CUTS, CYCLE=',I2)
      CALL CUTS
C
C     STORE THE REMOVED TPA IN WK4 FOR USE IN THE SECOND CALL TO THE
C     EVENT MONITOR (SPMCDBH INVOLVING CUT TREES).
C
      DO 21 IC=1,MAXTRE
      WK4(IC)=WK3(IC)
   21 CONTINUE
C
C     CALL **CVGO** TO DETERMINE IF THE COVER EXTENSION IS ACTIVE.
C
      CALL CVGO (LCVATV)
C
C     CALL **DENSE** TO UPDATE STAND DENSITY STATISTICS IF THINNING
C     OCCURRED.
C
      IF (ONTREM(7).GT.0.0) THEN
         IF (DEBUG) WRITE(JOSTND,40) ICYC
   40    FORMAT (' CALLING DENSE (POST THIN), CYCLE=',I3)
         CALL DENSE
      ENDIF
C
C     SAVE POST-THIN DENSITY.
C
      ATAVD=RMSQD
      ATAVH=AVH
      ATBA=BA
      ATCCF=RELDEN
      ATTPA=TPROB
      CALL SDICAL(0,ATSDIX)
      CALL SDICLS(0,0.,999.,1,SDIAC,SDIAC2,STAGEA,STAGEB,0)
C
C     CALL SILFTY (ENTRY IN SDICAL) TO COMPUTE SILVAH FOREST TYPE
C     AFTER THINNING
C
      CALL SILFTY
C
C     CALL CVBROW & CVCNOP TO COMPUTE POST-THIN STAND SHRUB AND COVER
C     STATISTICS.
C
      IF (ONTREM(7).GT.0.0 .AND. LCVATV) THEN
         IF (DEBUG) WRITE(JOSTND,60) ICYC
   60    FORMAT (' CALLING CVBROW, CYCLE =',I2)
         CALL CVBROW (.TRUE.)
         IF (DEBUG) WRITE(JOSTND,70) ICYC
   70    FORMAT (' CALLING CVCNOP, CYCLE =',I2)
         CALL CVCNOP (.TRUE.)
      ENDIF
C
C     COMPUTE THE STRUCTURAL STAGE OF THE STAND AFTER CALL TO CUTS.
C
      IBA = 2
      CALL SSTAGE (IBA,ICYC,.FALSE.)
C
C     IS THIS A STOPPING POINT?
C
      CALL fvsStopPoint (3,ISTOPRES)
      IF (ISTOPRES.NE.0) RETURN
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN
   71 CONTINUE
C
C     CALL EVENT MONITOR FOR PHASE II CHECKING.
C
      CALL EVMON (2,1)
C
C     IS THIS A STOPPING POINT?
C
      CALL fvsStopPoint (4,ISTOPRES)
      IF (ISTOPRES.NE.0) RETURN
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN
   72 CONTINUE
C
C     EVALUATE ECON EXTENSTION STATUS
C     1 MEANS THIS CALL TO ECSTATUS.F IS AFTER THE CALL TO CUTS.F 
C
      CALL ECSTATUS(ICYC, NCYC, IY, 1)
C----------
C  SET PAST VOLUME VARIABLES FOR USE NEXT CYCLE
C----------
      DO 215 I=1,ITRN
      PTOCFV(I)=CFV(I)
      PMRCFV(I)=WK1(I)
      PMRBFV(I)=BFV(I)
      PDBH(I)=DBH(I)
      PHT(I)=HT(I)
      ICDF=(DEFECT(I)-((DEFECT(I)/10000)*10000))/100
      IBDF= DEFECT(I)-((DEFECT(I)/100)*100)
      NCFDEF(I)=ICDF
      NBFDEF(I)=IBDF
  215 CONTINUE
C
C     CALL COMCUP TO COMPRESS THE TREE LIST.
C
      IF (DEBUG) WRITE (JOSTND,30) ICYC
   30 FORMAT (' CALLING COMCUP, CYCLE=',I3)
      CALL COMCUP
C
C     IF IPMODI IS EQUAL TO 2, SKIP THESE BUG MODELS
C
      IF (IPMODI.EQ.2) GOTO 120
C
C     CALL DFTMGO, MPBGO, AND DFBGO, TO DETERMINE IF INSECT
C     OUTBREAK WILL OCCUR THIS CYCLE.
C
      IF(DEBUG) WRITE(JOSTND,80) ICYC
   80 FORMAT(' CALLING DFTMGO, CYCLE=',I2)
      CALL DFTMGO(LTMGO)
      IF(DEBUG) WRITE(JOSTND,90) ICYC
   90 FORMAT(' CALLING MPBGO, CYCLE=',I2)
      CALL MPBGO(LMPBGO)
      IF (DEBUG) WRITE(JOSTND,95) ICYC
   95 FORMAT(' CALLING DFBGO, CYCLE=',I2)
      CALL DFBGO(LDFBGO)
C----------
C     ADAPTATION FOR BUDLITE MODEL
C----------
      IF(DEBUG) WRITE(JOSTND,105) ICYC
  105 FORMAT(' CALLING BWEGO, CYCLE=',I2)
      CALL BWEGO(LBWEGO)
C
C     BRANCH TO STATEMENT 40 IF NO TUSSOCK MOTH OUTBREAK THIS CYCLE.
C
      IF (LTMGO) THEN
C
C        THERE IS A TUSSOCK MOTH OUTBREAK; COMPUTE BIOMASS.
C
         IF (DEBUG) WRITE(JOSTND,110) ICYC
  110    FORMAT(' CALLING TMBMAS, CYCLE=',I2)
         CALL TMBMAS
      ENDIF
C
C     BRANCH TO THIS LOCATION IF PROCESSING A BRANCH WHICH WAS CREATED
C     BY A PHASE II EVENT.
C
  120 CONTINUE
C
C     CALL **DGDRIV** TO COMPUTE TREE DIAMETER INCREMENT.  THE ARRAY DG
C     WILL RETURN WITH DIAMETER GROWTHS SCALED TO YR-YEAR BASIS.
C
      IF (DEBUG) WRITE(JOSTND,130) ICYC
  130 FORMAT(' CALLING DGDRIV, CYCLE=',I2)
      CALL DGDRIV
C
C     CALL **HTGF** TO COMPUTE TREE HEIGHT INCREMENTS.
C
      IF (DEBUG) WRITE(JOSTND,140) ICYC
  140 FORMAT(' CALLING HTGF, CYCLE=',I2)
      CALL HTGF
C
C     CALL **REGENT** TO COMPUTE HEIGHT AND DIAMETER INCREMENT.
C
      IF (DEBUG) WRITE(JOSTND,150) ICYC
  150 FORMAT(' CALLING REGENT, CYCLE=',I2)
      CALL REGENT(.FALSE.,1)
C----------
C PROCESS THE FIXDG AND FIXHTG OPTIONS.
C----------
      CALL OPFIND (1,MYACTS(1),NTODO)
      IF (NTODO.GT.0) THEN
         DO 300 ITODO=1,NTODO
         CALL OPGET (ITODO,4,IDATE,IACTK,NP,PRM)
         IF (IACTK.LT.0) GOTO 300
         CALL OPDONE(ITODO,IY(ICYC))
         ISPCC=IFIX(PRM(1))
         IF(PRM(2) .LT. 0.) PRM(2)=0.
         IF(PRM(3) .LT. 0.) PRM(3)=0.
         IF(PRM(4) .LE. 0.) PRM(4)=999.
         IF (ITRN.GT.0) THEN
            DO 290 I=1,ITRN
            LINCL = .FALSE.
            IF(ISPCC.EQ.0 .OR. ISPCC.EQ.ISP(I))THEN
              LINCL = .TRUE.
            ELSEIF(ISPCC.LT.0)THEN
              IGRP = -ISPCC
              IULIM = ISPGRP(IGRP,1)+1
              DO 400 IG=2,IULIM
              IF(ISP(I) .EQ. ISPGRP(IGRP,IG))THEN
                LINCL = .TRUE.
                GO TO 401
              ENDIF
  400         CONTINUE
            ENDIF
  401       CONTINUE
            IF (LINCL .AND.
     >         (PRM(3).LE.DBH(I) .AND. DBH(I).LT.PRM(4))) THEN
               DG(I)=DG(I)*PRM(2)
               IF(LTRIP)THEN
                  ITFN=ITRN+2*I-1
                  DG(ITFN)=DG(ITFN)*PRM(2)
                  DG(ITFN+1)=DG(ITFN+1)*PRM(2)
               ENDIF
            ENDIF
  290       CONTINUE
         ENDIF
  300    CONTINUE
      ENDIF
      CALL OPFIND (1,MYACTS(2),NTODO)
      IF (NTODO.GT.0) THEN
         DO 302 ITODO=1,NTODO
         CALL OPGET (ITODO,4,IDATE,IACTK,NP,PRM)
         IF (IACTK.LT.0) GOTO 302
         CALL OPDONE(ITODO,IY(ICYC))
         ISPCC=IFIX(PRM(1))
         IF (PRM(2) .LT. 0.)  PRM(2)=0.
CCCC     IF (PRM(2) .GT. 1.0) PRM(2)=1.0
         IF (ITRN.GT.0) THEN
            DO 301 I=1,ITRN
            LINCL = .FALSE.
            IF(ISPCC.EQ.0 .OR. ISPCC.EQ.ISP(I))THEN
              LINCL = .TRUE.
            ELSEIF(ISPCC.LT.0)THEN
              IGRP = -ISPCC
              IULIM = ISPGRP(IGRP,1)+1
              DO 402 IG=2,IULIM
              IF(ISP(I) .EQ. ISPGRP(IGRP,IG))THEN
                LINCL = .TRUE.
                GO TO 403
              ENDIF
  402         CONTINUE
            ENDIF
  403       CONTINUE
            IF (LINCL .AND.
     >         (PRM(3).LE.DBH(I) .AND. DBH(I).LT.PRM(4))) THEN
               HTG(I)=HTG(I)*PRM(2)
               IF(LTRIP)THEN
                  ITFN=ITRN+2*I-1
                  HTG(ITFN)=HTG(ITFN)*PRM(2)
                  HTG(ITFN+1)=HTG(ITFN+1)*PRM(2)
               ENDIF
            ENDIF
  301       CONTINUE
         ENDIF
  302    CONTINUE
      ENDIF
C
C     CALL **MORTS** TO COMPUTE TREE MORTALITY.
C
      IF (DEBUG) WRITE(JOSTND,160) ICYC
  160 FORMAT(' CALLING MORTS, CYCLE=',I2)
      CALL MORTS
C
C     NOW TRIPLE RECORDS AND REALLIGN POINTERS IF TRIPLING OPTION IS
C     SET.
C
      IF (LTRIP.AND.ITRN.GT.0) THEN
         IF (DEBUG) WRITE(JOSTND,170) ICYC
  170    FORMAT(' CALLING TRIPLE, CYCLE=',I2)
         CALL TRIPLE
C
C        INFLATE THE TREE RECORD COUNT.
C
         ITRN=ITRN*3
C
C        REALLIGN POINTER VECTORS.
C
         IF (DEBUG) WRITE(JOSTND,180) ICYC
  180    FORMAT(' CALLING REASS, CYCLE=',I2)
         CALL REASS
C
C        INFLATE IREC1.
C
         IREC1=IREC1*3
      ENDIF
C
C     CALL **FFERT** TO COMPUTE THE EFFECTS OF APPLYING FERTILIZER.
C
      IF (DEBUG) WRITE(JOSTND,190) ICYC
  190 FORMAT(' CALLING FFERT, CYCLE=',I2)
      CALL FFERT
      RETURN
      END
