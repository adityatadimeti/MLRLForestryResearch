      SUBROUTINE INTREE (RECORD,IRDPLV,ISDSP,SDLO,SDHI,LKECHO)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     IRDPLV= 0 IF PLOT SPECIFIC SITE VARIABLES ARE NOT BEING READ,
C             1 IF THEY ARE BEING READ.
C
C  THIS ROUTINE READS THE STAND TREE DATA AND SETS ALL VARIABLES
C  WHICH ARE TREE RECORD SPECIFIC.
C
COMMONS
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
      INCLUDE 'HTCAL.F77'
C
C
      INCLUDE 'ESTREE.F77'
C
C
      INCLUDE 'STDSTK.F77'
C
C
COMMONS
C
      INTEGER IG,IULIM,IGRP,IPP,IAXE,ISPI,IUP,IHIT3,IHIT2,IHIT1,I,IK
      INTEGER J,ITREI,ITH,IMC1,ITRRR,ITP1RR,K,NPNVRS,ISCRN,IPTKNT,IMAX
      INTEGER II,INOSPC,IPVARS,IDAMCD,IRDPLV,ISDSP,IRTNCD
      REAL SDHI,SDLO,THT
      LOGICAL DEBUG,LDELTR,LRDGO,LRDTE,LKECHO,LINCL,LCONN
      INTEGER*4 IDCMP1,DBSKODE
      CHARACTER*8 CSPI
      CHARACTER*(*) RECORD
      CHARACTER*8 ANOSPC(1000)
      INTEGER ICNTR1,ICNTR2,I3
      INTEGER IOSTAT,IOSTATUS
      DIMENSION IPVARS(5),IDAMCD(6)
      COMMON / INTREECOM / CSPI
      DATA IDCMP1/10000000/
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'INTREE',6,ICYC)
C
      IF ( .NOT. DEBUG ) GO TO 8
      WRITE (JOSTND,5) ISTDAT,TREFMT(1:80),TREFMT(81:160),MORDAT,IRDPLV
    5 FORMAT (/' ENTERING SUBROUTINE INTREE.',/
     &        ' DATA SET REFERENCE NUMBER =',I2,/
     &        ' TREE DATA FORMAT:',/30X,A80/30X,A80,/,
     &        ' MORDAT: ',L2,'; IRDPLV=',I3)
    8 CONTINUE      
C---------
C     SET INITIAL VALUES FOR SPECIES TRANSLATION.
C---------
      INOSPC=0
      DO ICNTR1 = 1,1000
      ANOSPC(ICNTR1)='        '
      ENDDO
C
C     SET FLAG TO SEE IF A FILE IS CONNECTED TO ISTDAT. WE WILL TRY TO OPEN
C     ONE IF NECESSARY.
C
      LCONN=.FALSE.
C----------
C  IF MORE TREE RECORDS ARE TO BE READ AS IF THEY ARE PART
C  OF THE STAND THAT WAS BEING READ DURING THE LAST CALL TO
C  THIS SUBROUTINE THE LOGICAL VARIABLE 'MORDAT' MUST BE SET
C  TRUE.  IF IT IS FALSE, WE ASSUME THAT A NEW STAND IS BEING READ.
C----------
      IF (.NOT.MORDAT) THEN
C----------
C        SET INITIAL VALUES
C----------
         IRECRD = 0
         IREC2 = MAXTP1
         IMAX=MAXTP1
         LSTKNT = 1
         NSTKNT = 0
         IOSTAT=0
C---------
C     INITIALIZE DAMAGE/SEVERITY ARRAY.
C---------
        DO II = 1,MAXTRE
          DO I = 1,6
            DAMSEV(I,II) = 0
          END DO
        END DO
      ENDIF
      IPTKNT = 0
      IF (LSTKNT.GT.1) IPTKNT=LSTKNT-1
      ISCRN = 0
      DO 9 I=1,5
      IPVARS(I) = 0
    9 CONTINUE
   10 CONTINUE
C---------
C     SET THE UPPER LIMIT ON THE NUMBER OF VALUES BEING READ ON EACH
C     RECORD.
C---------
      NPNVRS=1
      IF (IRDPLV.GT.0) NPNVRS=5
C----------
C   CHECK TO SEE IF THE WESTERN ROOT DISEASE MODEL VER. 3.0 IS ACTIVE
C   AND IF TREELIST INITIALIZATION IS BEING USED. IF IT IS THEN SET
C   MAX NUMBER OF TREE RECORDS THAT MODEL CAN PROCESS TO IRRTRE.
C----------
      CALL RDATV(LRDGO,LRDTE)
      IF(LRDGO .AND. LRDTE) THEN
        CALL RDTRES(ITRRR,ITP1RR)
        IMAX=ITP1RR
      ENDIF
C----------
C  INSURE THERE IS ROOM IN THE ARRAYS TO STORE MORE TREE RECORDS
C----------
      IF (IREC1+1 .LT. MIN0(IREC2,IMAX)) GO TO 30
   15 CONTINUE
      LSTKNT=IPTKNT

      IF (LRDGO .AND. LRDTE) WRITE(JOSTND,895) ITRRR
  895 FORMAT('**** MAX NUMBER OF TREE RECORDS',I5,' EXCEEDED FOR',
     >  ' WESTERN ROOT DISEASE MODEL VER 3.0 ****')

      CALL ERRGRO(.FALSE.,13)
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN
C----------
   30 CONTINUE
      I = IREC1 + 1
C----------
C  READ STAND DATA FILE            **********
C----------
   31 CONTINUE
C----------
C  DETERMINE IF DATA IS COMING FROM DATABASE OR FILE
C----------
      DBSKODE = 1
      CALL DBSTREESIN(ITREI,IDTREE(I),PROB(I),ITH,CSPI,
     &        DBH(I),DG(I),HT(I),THT,HTG(I),ICR(I),IDAMCD(1),IDAMCD(2),
     &        IDAMCD(3),IDAMCD(4),IDAMCD(5),IDAMCD(6),
     &        IMC1,KUTKOD(I),IPVARS(1),IPVARS(2),IPVARS(3),IPVARS(4),
     &        IPVARS(5),DBSKODE,DEBUG,JOSTND,LKECHO,ABIRTH(I),LBIRTH(I))
      IF(DBSKODE.EQ.0)THEN
        IF (.NOT.LCONN) INQUIRE(UNIT=ISTDAT,exist=LCONN)
        IF (LCONN) INQUIRE(UNIT=ISTDAT,opened=LCONN)
        IF (.NOT.LCONN) THEN
          CALL fvsGetKeywordFileName(RECORD,len(RECORD),II)
          IF (RECORD.EQ.' ') GOTO 900
          II=index(RECORD,".k")
          IF (II == 0) II=index(RECORD,".K")
          IF (II == 0) II=len_trim(RECORD)
          RECORD=TRIM(RECORD(:II-1))//".TRE"
          INQUIRE(FILE=TRIM(RECORD),exist=LCONN)
          IF (.NOT.LCONN) THEN
            RECORD=TRIM(RECORD(:II-1))//".tre"
            INQUIRE(FILE=TRIM(RECORD),exist=LCONN)
          ENDIF
          IF (LCONN) OPEN(UNIT=ISTDAT,FILE=TRIM(RECORD),STATUS='OLD')
          INQUIRE(UNIT=ISTDAT,exist=LCONN)
          IF (.NOT.LCONN) GOTO 900
        ENDIF
        READ(ISTDAT,'(A)',IOSTAT=IOSTATUS)RECORD
        IF(IOSTATUS.NE.0)GOTO 900
        IF (RECORD(1:1).EQ.'*') GOTO 31
        IF (INDEX(RECORD,'-999').GT. 0) GOTO 900
        READ (RECORD,TREFMT) ITREI,IDTREE(I),PROB(I),ITH,CSPI,
     &        DBH(I),DG(I),HT(I),THT,HTG(I),ICR(I),(IDAMCD(J),J=1,6),
     &        IMC1,KUTKOD(I),IPVARS(1),IPVARS(2),IPVARS(3),IPVARS(4),
     &        IPVARS(5),ABIRTH(I)
        IF(ABIRTH(I).LE.0) THEN
          ABIRTH(I) = 0
          LBIRTH(I) =.FALSE.
        ELSE
          LBIRTH(I) =.TRUE.
        END IF
      ELSEIF(DBSKODE.EQ.-1) THEN
        GOTO 900
      ENDIF
      IF(NPNVRS.EQ.1)THEN
        DO IK=1,5
        IPVARS(IK)=0
        ENDDO
      ENDIF
      IRECRD = IRECRD + 1
      IF ( DEBUG ) THEN
        WRITE(JOSTND,*) ' ',I,' IRECRD=',IRECRD,' ITREI=',ITREI,' IDT=',
     >     IDTREE(I),' PROB=',PROB(I),' ITH=',ITH,' CSPI=',CSPI,
     >     ' DBH=',DBH(I),' DG=',DG(I),' HT=',HT(I),' THT=',THT
        WRITE(JOSTND,*) ' ',I,' HTG=',HTG(I),' ICR=',ICR(I),' IDAMCD=',
     >     IDAMCD,' IMC1=',IMC1,' KUTKOD= ',KUTKOD(I),' IPVARS=',
     >     (IPVARS(K),K=1,5),' ABIRTH= ',ABIRTH(I),' DBSKODE=',
     >     DBSKODE, ' LBIRTH= ',LBIRTH(I)
      ENDIF
      IF (IDTREE(I) .GT. IDCMP1-1) WRITE(JOSTND,35)
   35 FORMAT('IN INTREE: TREE ID NUMBER IS LARGER THAN MAXIMUM',
     &       ' ALLOWED')
C----------
C IF THIS IS A SITE TREE, THEN STORE THE SITE RELATED INFORMATION.
C IF THE TREE IS ON THE PLOT, THEN CONTINUE TO PROCESS THE TREE NORMALLY.
C IF THE TREE IS OFF THE PLOT, THEN READ THE NEXT TREE RECORD.
C----------
      IHIT1=0
      IHIT2=0
      IHIT3=0
      IF(IDAMCD(1) .EQ. 28)THEN
        IHIT1=1
      ELSEIF(IDAMCD(3) .EQ. 28)THEN
        IHIT2=1
      ELSEIF(IDAMCD(5) .EQ. 28)THEN
        IHIT3=1
      ENDIF
      IF(IHIT1.GT.0 .OR. IHIT2.GT.0 .OR. IHIT3.GT.0)THEN
        NSITET = NSITET + 1
        IF(NSITET .GT. MAXSTR)GO TO 34
        CSPI=ADJUSTL(CSPI)
        DO IUP=1,8
          CALL UPCASE(CSPI(IUP:IUP))
        ENDDO
C
C  CHECK FOR VALID SPECIES CODE AND SET OUTPUT DATA BASE
C  TABLE FORMAT ARRAY JSPIN BASED ON INPUT SPECIES CODE FORMAT
C
        DO ISPI=1,MAXSP
        IF(CSPI.EQ.JSP(ISPI))THEN
          JSPIN(ISPI)=1
          IF(JSPINDEF.LE.0)JSPINDEF=1
          GO TO 33
        ELSEIF(CSPI.EQ.FIAJSP(ISPI))THEN
          JSPIN(ISPI)=2
          IF(JSPINDEF.LE.0)JSPINDEF=2
          GO TO 33
        ELSEIF(CSPI.EQ.PLNJSP(ISPI))THEN
          JSPIN(ISPI)=3
          IF(JSPINDEF.LE.0)JSPINDEF=3
          GO TO 33
        ENDIF
        ENDDO
        CALL SPCTRN (CSPI, ISPI)
   33   CONTINUE
        SITETR(NSITET,1) = ISPI
        SITETR(NSITET,2) = DBH(I)
        SITETR(NSITET,3) = HT(I)
        SITETR(NSITET,4) = ABIRTH(I)
        IAXE = 0
        IF(IHIT1 .GT. 0)THEN
          IF(IDAMCD(2).EQ.1 .OR. IDAMCD(2).EQ.3)SITETR(NSITET,5)=1.
          IF(IDAMCD(2).EQ.2 .OR. IDAMCD(2).EQ.4)SITETR(NSITET,5)=2.
          IF(IDAMCD(2).EQ.1 .OR. IDAMCD(2).EQ.2)SITETR(NSITET,6)=1.
          IF(IDAMCD(2).EQ.3 .OR. IDAMCD(2).EQ.4)THEN
            SITETR(NSITET,6)=2.
            IAXE=1
          ENDIF
        ELSEIF(IHIT2 .GT. 0)THEN
          IF(IDAMCD(4).EQ.1 .OR. IDAMCD(4).EQ.3)SITETR(NSITET,5)=1.
          IF(IDAMCD(4).EQ.2 .OR. IDAMCD(4).EQ.4)SITETR(NSITET,5)=2.
          IF(IDAMCD(4).EQ.1 .OR. IDAMCD(4).EQ.2)SITETR(NSITET,6)=1.
          IF(IDAMCD(4).EQ.3 .OR. IDAMCD(4).EQ.4)THEN
            SITETR(NSITET,6)=2.
            IAXE=1
          ENDIF
        ELSE
          IF(IDAMCD(6).EQ.1 .OR. IDAMCD(6).EQ.3)SITETR(NSITET,5)=1
          IF(IDAMCD(6).EQ.2 .OR. IDAMCD(6).EQ.4)SITETR(NSITET,5)=2
          IF(IDAMCD(6).EQ.1 .OR. IDAMCD(6).EQ.2)SITETR(NSITET,6)=1
          IF(IDAMCD(6).EQ.3 .OR. IDAMCD(6).EQ.4)THEN
            SITETR(NSITET,6)=2
            IAXE=1
          ENDIF
        ENDIF
        IF(IAXE .EQ. 1)GO TO 30
      ENDIF
   34 CONTINUE
C----------
C  CONVERT INPUT CROWN CLASS VALUES (1-9) TO PERCENT
C  CROWN RATIO (1-99) IF NEEDED
C----------
      IF(ICR(I).LE.0)GOTO 37
      IF(ICR(I).LT.10) THEN
        ICR(I)=ICR(I)*10-5
      ELSE
        IF(ICR(I).GT.99)ICR(I)=99
      ENDIF
   37 CONTINUE
C----------
C  COUNT UP THE NUMBER OF POINTS.  'IPVEC' IS A SUB-PLOT I.D. VECTOR
C  USED TO KEEP TRACK OF SUB-PLOT IDENTIFICATION CODES THAT HAVE
C  ALREADY BEEN USED.
C  ADDITIONAL TESTING AND VALIDATION OF PLOT COUNTS SPECIFIED ON DESIGN
C  KEYWORD OR NUM_PLOTS OF INPUT DATABASE STANDINIT TABLE TO ENSURE THAT
C  TREE RECORD PLOT ID CAN BE USED IN PROCESSES UTILITZING PLOT LEVEL
C  VARIABLES, SUCH AS DENSITIES, CAN BE USED AND TPA EXPANSIONS ARE CORRECT:
C    1 - IF NUM_PLOTS IS 1, PLOT ID WILL BE RETAINED WITH THE FOLLOWING
C        EXCEPTION. IN ORDER TO ACCOMMODATE CIRCUMSTANCE WHERE TREE
C        RECORDS WERE ACCUMULATED FROM MULTIPLE PLOTS AND HAVE MORE
C        THAN ONE PLOT ID EXISTING ON THE TREE RECORDS BUT THE STAND HAS
C        BEEN DEFINED AS A SINGLE PLOT, THE PLOT ID USED WILL BE 1.
C        LRD 02/04/2022 
C
C    *** NEXT 2 SCENERIOS ARE EVELUATED IN CALLING SUBROUTINE INITRE.F ***
C    2 - IF NUM_PLOTS IS >1 AND COUNTED TREE RECORD PLOT IDS IS LESS THAN
C        THAT VALUE, PRESENCE OF NONSTOCKED PLOTS IS ASSUMED.
C    3   IF NUM_PLOTS IS >1 AND COUNTED TREE RECORD PLOT IDS IS GREATER THAN
C        THAT VALUE, THE RUN WILL BE TERMINATED BECAUSE ACCURATE TPA VALUES
C        CAN NOT BE CALCULATED.
C----------
      IF( IPTKNT .LT. LSTKNT ) GO TO 50
      DO 40 IPP= LSTKNT, IPTKNT
        IF( IPVEC(IPP) .EQ. ITREI) THEN
C         TREE RECORD IS ON EXISTING PLOT
          GO TO 60
        ELSE
          IF (IPTINV .EQ. 1) THEN      ! ALL TREES ON 1 PLOT (1 ABOVE)
C           A SINGLE PLOT HAS BEEN SPECIFIED BUT NEW PLOT ID HAS BEEN
C           READ. PLOT ID WILL BE SET TO 1 SINCE MULTIPLE PLOT IDS
C           EXIST IN THE INPUT TREE RECORDS. 
            ITREI = 1
            IPVEC(IPP) = 1
            GO TO 60
          ENDIF
        ENDIF
   40 CONTINUE
   50 CONTINUE
      IPTKNT= IPTKNT + 1
      IF (IPTKNT .GT. MAXPLT) GO TO 15
      IPVEC(IPTKNT)= ITREI
      ITRE(I)=IPTKNT
C----------
C  IF POINT SPECIFIC SITE DATA ARE BEING READ AND IF THIS PLOT IS
C  A STOCKABLE PLOT (IMC1.GT.800), THEN: CALL THE ESTABLISHMENT
C  SYSTEM TO STORE THE SITE DATA.
C---------
      CALL ESPLT1 (ITREI,IMC1,NPNVRS,IPVARS(1))
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN
      GOTO 65
   60 CONTINUE
      ITRE(I)=IPP
   65 CONTINUE
C----------
C  FLAG INCOMING TREE RECORDS SO MORTS WILL BE ABLE TO APPLY CORRECT
C  MORTALITY RATES.  VECTOR IESTAT IS PART OF THE REGENERATION
C  ESTABLISHMENT SYSTEM.
C----------
      IESTAT(I)=0
C----------
C  INITIALIZE SERIAL CORRELATION.
C----------
      ZRAND(I)=-999.
C----------
C  COUNT THE NUMBER ON NON-STOCKABLE SUB-PLOTS.
C  IF IMC1 IS EQUAL TO 8 THE POINT IS NON-STOCKABLE
C----------
      IF ( IMC1 .NE. 8 ) GO TO 70
      NSTKNT = NSTKNT + 1
      GO TO 30
   70 CONTINUE
C----------
C  TRANSLATE SPECIES CODES TO 1 THROUGH MAXSP AND
C  SET SPECIES DATA BASE TABLE OUTPUT FORMAT ARRAY
C  JSPIN BASED ON INPUT SPECIES CODE FORMAT
C----------
      CSPI=ADJUSTL(CSPI)
      DO IUP=1,8
      CALL UPCASE(CSPI(IUP:IUP))
      ENDDO
      DO 71 ISPI=1,MAXSP
      IF(CSPI.EQ.JSP(ISPI))THEN
        JSPIN(ISPI)=1
        IF(JSPINDEF.LE.0)JSPINDEF=1
        GO TO 72
      ELSEIF(CSPI.EQ.FIAJSP(ISPI))THEN
        JSPIN(ISPI)=2
        IF(JSPINDEF.LE.0)JSPINDEF=2
        GO TO 72
      ELSEIF(CSPI.EQ.PLNJSP(ISPI))THEN
        JSPIN(ISPI)=3
        LFIA=.TRUE.
        IF(JSPINDEF.LE.0)JSPINDEF=3
        GO TO 72
      ENDIF
   71 CONTINUE
C----------
C  SET SPECIES CODE TO MAXSP IF CODE GIVEN IS INVALID.
C  SPECIES ARE TRANSLATED TO APPROPRIATE VALID SPECIES CODE.
C----------
      CALL SPCTRN (CSPI, ISPI)
C----------
C  WRITE SPECIES MAPPING
C----------
      IF(INOSPC.EQ.0)THEN
        WRITE(JOSTND,73)
        INOSPC=1
      ENDIF
   73 FORMAT(/)
      DO ICNTR2=1,INOSPC
        IF (CSPI.EQ.ANOSPC(ICNTR2)) GO TO 74
      ENDDO
      WRITE(JOSTND,75) CSPI,JSP(ISPI)
   75 FORMAT(T12,'NOTE: INPUT SPECIES CODE (',A8,')WAS SET TO ('
     & ,A4,') FOR THIS PROJECTION.')
      INOSPC = INOSPC+1
      IF(INOSPC.GT.1000)INOSPC=1000
      ANOSPC(INOSPC) = CSPI
   74 CONTINUE
C
   72 CONTINUE
C----------
C  SAVE SPECIES POINTERS IN ISP
C----------
      ISP(I) = ISPI
C----------
C  CHECK TO SEE IF THIS IS A PROJECTABLE TREE RECORD. TREES WITH
C  HISTORY CODES 6,7,8 AND 9 ARE DEAD TREES ACCORDING TO REGION 1
C  STANDARDS. CODES 6 AND 7 REPRESENT RECENT DEAD TREES.
C
C  SCREEN TREE OUT IF IT FALLS WITHIN THE SPECIES/DBH SCREEN. THIS WAS
C  SET UP FOR VARIANTS LIKE AK TO INSURE THAT LARGE NUMBER OF SEEDLINGS
C  DO NOT ENTER THE SYSTEM AND GIVE MISLEADING RESULTS WHEN THEY
C  GET LARGER AND CREATE 100'S OF FT SQ OF BASAL AREA.
C----------
C  SET LINCL
C----------
      LINCL = .FALSE.
      IF(ISDSP.EQ.0 .OR. ISDSP.EQ.ISP(I))THEN
        LINCL = .TRUE.
      ELSEIF(ISDSP.LT.0)THEN
        IGRP = -ISDSP
        IULIM = ISPGRP(IGRP,1)+1
        DO 705 IG=2,IULIM
        IF(ISP(I) .EQ. ISPGRP(IGRP,IG))THEN
          LINCL = .TRUE.
          GO TO 710
        ENDIF
  705   CONTINUE
      ENDIF
  710 CONTINUE

C   ADD CONDITIONAL FOR TREES WITH HT < 4.5,
C   WILL DUB DBH OF NULL ENTRIES WITH VALUE OF 0.1
      IF(HT(I) > 0 .AND. HT(I) < 4.5 .AND. DBH(I) .EQ. 0) DBH(I)=0.1
C
      LDELTR = (DBH(I) .LT. 0.0001) .OR.
     >         (LINCL .AND. (DBH(I) .LT. SDLO .OR. DBH(I) .GE. SDHI))
C----------
C   CALL DAMCDS TO PROCESS DAMAGE CODES AND OTHER TREE ATTRIBUTES FOR
C   ANY EXTENSIONS THAT MAY BE ACTIVE.
C----------
      CALL DAMCDS (I,IDAMCD)
C----------
C     NOW, IF THE TREE IS 'FLAGED' TO BE DELETED, THEN BRANCH TO
C     READ ANOTHER TREE RECORD.
C----------
      IF (LDELTR) THEN
         IF (DBH(I) .GE. 0.0001) ISCRN=ISCRN+1
         GO TO 30
      ENDIF
C----------
C  IF THE TREE WAS TOPKILLED (AS OBSERVED DURING SAMPLING), THE
C  VALUE OF HEIGHT IS FLAGGED AS NEGATIVE - THIS IS CORRECTED TO
C  A HEIGHT AS PREDICTED BY THE HEIGHT-DIAMETER CURVE IN SUBROUTINE
C  'CRATET'. REGION 1 DAMAGE CODES: 96=BROKEN TOP, 97=DEAD TOP.
C   SEARCH THROUGH THE DAMAGE ARRAY TO FIND ANY TOP DEAD OR BROKEN
C   TREES. EVEN IF DAMAGE CODE 96 OR 97 ARE NOT PRESENT, IF HEIGHT
C   TO THE BROKEN TOP IS ENTERED, FLAG THE TREE.
C   WHEN BOTH TOTAL TREE HEIGHT (HT) AND TOPKILL HEIGHT (THT) ARE
C   ENTERED, HT MUST BE GREATER THAN THT. IF NOT, HT IS SET TO ZERO
C   AND THE HEIGHT DETERMINED IN CRATET WILL BE USED.
C----------
      ITRUNC(I)=0
      NORMHT(I)=0
      DO 81 K=1,5,2
      IF (IDAMCD(K) .NE. 96 .AND. IDAMCD(K) .NE. 97) GO TO 81
      GO TO 82
   81 CONTINUE
      IF(THT .GT. 0.)GO TO 82
      GO TO 90
C
   82 CONTINUE
C     PROCESS TOPKILL TREE
C
      NORMHT(I)=-1
      IF(THT.LE.0.0) GO TO 90
      ITRUNC(I)=INT(THT*100.0+0.5)
C      write(*,*) 'at 82: I=',i,' NORMHT=',normht(i),' HT=',ht(i),
C     & ' THT=',tht,
C     & ' ITRUNC=',(itrunc(i)/100.0),' ITH=',ith,' IDAMCD=',idamcd
      IF(HT(I) .LE. THT) THEN
        HT(I)=0.0
      ENDIF
C      write(*,*) ' NORMHT=',normht(i),' HT=',ht(i),' THT=',tht,
C     & ' ITRUNC=',itrunc(i)
   90 CONTINUE
C----------
C  IF THE TREE HEIGHT IS ZERO (MISSING), THEN INSURE THAT THE HEIGHT
C  GROWTH IS ZERO AS WELL
C----------
      IF (HT(I).EQ.0.0 .AND. IHTG.EQ.3) HTG(I)=0.0
C----------
C  IF GROWTH METHODS ARE FOR REMEASUREMENT DATA, STORE THE
C  INCOMING VALUES FOR PRINTING IN **FVSSTD**
C----------
      IF(IDG.EQ.1 .OR. IDG.EQ.3) PDBH(I)=DG(I)
      IF(IHTG.EQ.1 .OR. IHTG.EQ.3) PHT(I)=HTG(I)
C----------
C  STORE ALL DEAD TREES IN THE BOTTOM OF THE ARRAYS
C  TREES WITH HISTORY CODES 6,7 ARE RECENT DEAD (GET IMC()=7)
C  TREES WITH HISTORY CODES 8,9 ARE OLDER  DEAD (GET IMC()=9)
C----------
      IF( ITH .LT. 6 .OR. ITH .GT. 9 ) GO TO  100
      IREC2= IREC2 - 1
      ITRE(IREC2)= ITRE(I)
      IDTREE(IREC2)=IDTREE(I)
C----------
C  NOTE: INFLATION OF DEAD TREE PROB'S IS IN NOTRE.  CROWN RATIOS
C        FOR TREES LESS THAN 3 INCHES ARE SET ZERO IN CRATET.
C----------
      PROB(IREC2)= PROB(I)
      DBH(IREC2)= DBH(I)
      DG(IREC2)= DG(I)
      HT(IREC2)= HT(I)
      ITRUNC(IREC2) = ITRUNC(I)
      NORMHT(IREC2) = NORMHT(I)
      ICR(IREC2)= ICR(I)
      ISP(IREC2)= ISP(I)
      ISPECL(IREC2)=ISPECL(I)
      DEFECT(IREC2)=DEFECT(I)
      IMC(IREC2)= 7
      IF(ITH.EQ.8 .OR. ITH.EQ.9) IMC(IREC2)=9
      ABIRTH(IREC2)=ABIRTH(I)
      LBIRTH(IREC2)=LBIRTH(I)
      KUTKOD(IREC2)=KUTKOD(I)
      DO I3 = 1,6
        DAMSEV(I3,IREC2) = DAMSEV(I3,I)
      END DO

C----------
C RESET ARRAY VALUES TO ZERO IN CASE THIS IS THE LAST RECORD
C IN THE INPUT DATA --- DON'T WANT THESE VALUES HANGING AROUND
C WHERE THEY AREN'T SUPPOSED TO BE.  GD 5/10/96
C----------
      PROB(I)=0.
      DBH(I)=0.
      DG(I)=0.
      HT(I)=0.
      ITRUNC(I)=0
      NORMHT(I)=0
      ICR(I)=0
      ISP(I)=0
      ISPECL(I)=0
      DEFECT(I)=0
      IDTREE(I)=0
      HTG(I)=0.
      ITRE(I)=0
      NORMHT(I)=0
      PDBH(I)=0.
      PHT(I)=0.
      ZRAND(I)=-999.
      ABIRTH(I)=0.
      LBIRTH(I)=.FALSE.
      KUTKOD(I)=0
      DO I3 = 1,6
        DAMSEV(I3,I) = 0
      END DO
C----------
      I= IREC2
      GO TO 200
  100 CONTINUE
      IF(IMC1.GT.3)IMC1=3
      IF(IMC1.LE.0)IMC1=1
      IMC(I)=IMC1
      IREC1 = I
  200 CONTINUE
C----------
C  ESTABLISH THIS TREE RECORD AS A LINK IN THE CHAIN SORT.
C----------
      CALL LNKCHN (I)
C----------
      GO TO 10
C----------
  900 CONTINUE
C----------
C  END OF TREE DATA ON THIS FILE
C----------
      LSTKNT = IPTKNT + 1
C
      IF(NSITET .GT. MAXSTR)NSITET=MAXSTR
C----------
C   CALL INTREX TO READ ANY ADDITIONAL DATA THAT MAY BE NEEDED BY
C   EXTENSIONS.
C----------
C***  CALL INTREX (IDTREE)
C
      IF (ISCRN .GT. 0) WRITE(JOSTND,901) ISCRN
  901 FORMAT(/,T12,'**** NOTE: ',I5,' TREE RECORDS HAVE BEEN',
     &       ' SCREENED OUT BY THE DIAMETER SCREEN.')
      IF((DBSKODE.EQ.-1).AND.LKECHO)WRITE (JOSTND,940) IRECRD
  940 FORMAT (T12,'NUMBER ROWS PROCESSED:',I5)
      IF(DEBUG)THEN
        WRITE(JOSTND,945) IRECRD,IPTKNT,DBSKODE
  945   FORMAT (/' LEAVING SUBROUTINE INTREE.   RECORDS READ=',I5,
     &        '; PLOTS COUNTED = ',I5,'; DBSKODE=',I4)
        IF(NSITET.GT.0)WRITE(JOSTND,950)((SITETR(I,J),J=1,6),I=1,NSITET)
  950   FORMAT(/' SITE INDEX TREES:',/,7X,'ISPC',7X,'DBH',8X,'HT',
     &  7X,'AGE',4X,'T OR B',4X,'ON OFF',20(/,1X,F10.0,2F10.1,3F10.0))
      ENDIF
C
      RETURN
      END
