CODE SEGMENT PPCNTL
C----------
C COMMON $Id$
C----------
      CHARACTER*4   MGMIDS(MXSTND),MGM1,MGM2,NSET,CMPID,CAUTID,CLBWID
      CHARACTER*26  STDIDS(MXSTND),SID1,SID2,NOTSET
      CHARACTER*11  CISNUM(MXSTND),CSISN,CLISN
      CHARACTER*40  SLHPLB
      CHARACTER*250 SLSETS(MXSTND),SLSPLB
      COMMON /PPCHAR/ CISNUM,STDIDS,MGMIDS,SLSETS,SID1,SID2,NOTSET,
     >                MGM1,MGM2,NSET,SLSPLB,SLHPLB,CSISN,CLISN,CLBWID,
     >                CMPID,CAUTID
      LOGICAL LIN1ST,LASTIN,LEORUN,PDEBUG,LRESTR,LAREAS,
     >        LMCYC,LSTYR,LMINT,LCMPS,LACTS,LSUM,LHIST,LBWTS,
     >        LSNDCP,LSMPT,LPAUSE(MAXCYC),LHVALL,LTMPAC,LTMPAD
      INTEGER ISNKEY(MXSTND,4),ISNSRT(MXSTND),IPMODE(MXSTND),
     >        LNSETS(MXSTND),ISDWK1(MXSTND),INEXR(NDAREC),MIY(MAXCY1),
     >        MNCYC,MICYC,MAXBUF,ISTND,NOSTND,IAVAIL,IENDFR,
     >        IDAIO(MXDAFL),NDAFL,IWTREC,IRDREC,JLBWTS,JEXOPT,
     >        JOHIST,INCYC,IDAPRT,NPTREC,NAVPRT,IASVPT,IPTELS,NMPRTD,
     >        JCPCMP,JCPSUM,JOCOPY,IPMODI,JOPPRT,LNSSPL,LNSHPL,
     >        NBYGRP,IOSTRC,NAUTID,JADFIL,IMSREC,IMSEND,
     >        NDACUM(MXDAFL),NAURPS
      REAL    BRCHWT(MXSTND),AREAS(MXSTND),SAMWTS(MXSTND),DCTOP,DCTPA
      COMMON /PPCNTL/ ISNKEY,BRCHWT,AREAS,
     >      ISNSRT,IPMODE,LNSETS,ISDWK1,
     >      SAMWTS,INEXR,LPAUSE,MIY,JEXOPT,
     >      MNCYC,MICYC,MAXBUF,LMINT,ISTND,NOSTND,LMCYC,LSTYR,IAVAIL,
     >      IENDFR,IDAIO,NDAFL,IWTREC,IRDREC,JLBWTS,LBWTS,
     >      JOHIST,INCYC,LASTIN,LEORUN,PDEBUG,LIN1ST,IDAPRT,NPTREC,
     >      NAVPRT,IASVPT,LHVALL,IPTELS,NMPRTD,LCMPS,LACTS,LSUM,
     >      JCPCMP,JCPSUM,JOCOPY,IPMODI,LHIST,LSNDCP,DCTOP,DCTPA,
     >      LSMPT,JOPPRT,LNSSPL,LNSHPL,NBYGRP,IOSTRC,NAUTID,JADFIL,
     >      LTMPAC,LTMPAD,IMSREC,IMSEND,LAREAS,LRESTR,NDACUM,
     >      NAURPS
C
C     STDIDS= STAND IDENTS
C     MGMIDS= MANAGEMENT IDENTS
C     SLSETS= STAND LABEL SETS FOR ALL STANDS
C     LNSETS= LENGHT OF EACH STAND LABEL SET
C     CISNUM= INTERNAL STAND NUMBER IN FIRST 4 COLS, BRANCHING IN REST
C     ISNKEY= (I,1) ALL-DATA VERSION WHERE:
C                   UNITS PLACE
C                   1= BASE MODEL ALL-DATA
C                   2= BASE MODEL SUMMARY ARRAYS ONLY
C                   3= BASE MODEL ALL-DATA ON TEMPORARY SPACE
C                   TENS PLACE
C                   0= ESTABLISHMENT SUBSYSTEM NOT ACTIVE
C                   1= ESTABLISHMENT SUBSYSTEM ACTIVE
C                   HUNDREDS
C                   0= COVER/BROWSE SUBSYSTEM NOT ACTIVE
C                   1= COVER/BROWSE SUBSYSTEM ACTIVE
C             (I,2) DA RECORD MARKING START OF ALL-DATA LIST.
C             (I,3) DA RECORD MARKING END OF ALL DATA LIST.
C             (I,4) PROCESSING PHASE WHEN BRANCH NODE WAS CREATED.
C     BRCHWT= WEIGHTING FACTOR ASSOCIATED WITH THE STAND.
C     AREAS = STAND AREAS AS READ BY THE AREALOCS KEYWORD, OR 1.0
C     SAMWTS= STAND SAMWT FROM THE DESIGN RECORDS.
C     LAREAS= TRUE IF AREAS IS DEFINED, FALSE IF NOT OR WHEN AREALOCS
C             KEYWORD HAS BEEN SPECIFIED.
C     LRESTR= TRUE WHEN PAUSE WAS EXECUTED AFTER PROJECTION HAS
C             STARTED (ALL STANDS HAVE BEEN ENTERED), AND FALSE
C             OTHER TIMES (WHEN PAUSE WAS EXECUTED DURING THE ENTERING
C             OF STANDS).
C     NAUTID= CONTROLS AUTOMATIC GENERATION OF MGMTID'S FOR OUTPUT.
C             0=OPTION OFF, 1=OPTION ON AND PPAUID USES THE VALUE
C             OF CAUTID FOR THE FIRST AUTOID, 2=OPTION ON AND PPAUID
C             INCREMENTS CAUTID FOR THE AUTOID (PPAUID CHANGES NAUTID
C             FROM 1 TO 2 ON THE FIRST CALL).
C     CAUTID= THE FIRST AUUTID IN THE SEQUENCE (CAN BE SET BY KEYWORD)
C     IOSTRC= A ALL-DATA RECORD POINTER TO THE LAST RECORD USED TO
C             HOLD DATA FOR THE CURRENT STAND.
C     LPAUSE= TRUE IF A PROCESSING PAUSE IS SCHEDULED (INDEXED
C             BY MASTER CYCLE NUMBER).
C     ISNSRT= AN INDEXING ARRAY USED TO SORT ISNKEY.
C     ISTND = SUBSCRIPT TO ISNKEY OF CURRENT STAND.
C     NOSTND= NUMBER OF ENTERIES IN ISNKEY
C     LMCYC = TRUE IF MNCYC HAS BEEN DEFINED
C     LSTYR = TRUE IF MASTER STARTING YEAR (MIY(1)) HAS BEEN
C             DEFINED.
C     LMINT = TRUE IF MASTER TIME INTERIVALS HAVE BEEN DEFINED.
C     MIY   = MASTER VERSION OF SPS ARRAY IY
C     MNCYC = MASTER VERSION OF SPS VARIABLE NCYC
C     MICYC = MASTER VERSION OF SPS VARIABLE ICYC
C     IDAIO = ALL-DATA DA DATA SET REFERENCE NUMBERS.
C     NDAFL = NUMBER OF ALL-DATA DA FILES.
C     IWTREC= RECORD NUMBER TO BEGIN WRITING ALL-DATA.
C     IRDREC= RECORD NUMBER TO BEGIN READING ALL-DATA.
C     JOHIST= PROJECTION HISTORY DATA SET REF. NUM.
C     INCYC = THE CYCLE NUMBER OF THE CURRENT STAND WHICH
C             POINTS TO THE YEAR THE CURRENT MASTER CYCLE ENDS.
C     LASTIN= TRUE IF THE LAST STAND HAS BEEN INITIATED.
C     LEORUN= TRUE WHEN THE MASTER CLOCK SIGNALS THE LAST CYCLE.
C     PDEBUG= TRUE WHEN DEBUGGING THE PARALLEL PROCESSOR.
C     LIN1ST= TRUE FOR FIRST CALL TO PPIN FOR PROJECTION.
C     IDAPRT= DA PRINT-DATA DATA SET REFERENCE NUMBER.
C     NPTREC= NUMBER OF PRINT-DATA DA RECORDS AVAILABLE IN THE FILE.
C     NAVPRT= NEXT AVAILABLE RECORD TO WRITE PRINT-DATA ON DA FILE.
C     IASVPT= POINTS TO PRINT-DATA RECORD BEING WRITTEN.
C     LHVALL= TRUE IF MULTISTAND TREATMENT SCHEDULING IS ACTIVE.
C             (FORMALLY CALLED HARVEST SIMULATION).
C     IPTELS= PRINT-DATA DATA ELEMENT DISCRIPTION WORD WHERE:
C             UNITS PLACE
C             0= INITIAL CYCLE
C             1= NORMAL CYCLE
C             2= NORMAL CYCLE WITH REMOVAL
C             3= LAST CYCLE FOR STAND
C             TENS PLACE
C             0= NO CHEAPO OUTPUT
C             1= WITH CHEAPO OUTPUT
C             IPTELS DISCRIBES THE DATA ELEMENTS THAT ARE WRITTEN
C             ON THE PRINT-DATA DA FILE FOR A GIVEN STAND AND CYCLE.
C     MXPRTD= THE MAXIMUM NUMBER OF HISTORY RECORDS THAT CAN BE
C             READ AT ONE TIME...IN OTHER WORDS THE MAX NUMBER OF
C             CYCLES*STANDS WHICH CAN BE RETREIVED AT ONCE FOR
C             PRINT-DATA PROCESSING.
C     NMPRTD= THE NUMBER OF TYPE 2 HISTORY RECORDS READ AND STORED.
C     JOPPRT= PRINTER DSRN FOR PARALLEL PROCESSOR OUTPUT.
C     JADFIL= USED IN CONJUNCTION WITH ICL6 TO SUPPORT ADDFILE.
C     LCMPS = TRUE IF COMPOSITE YIELD TABLES ARE REQUESTED
C     LACTS = TRUE IF ACTIVITY SUMMARY WILL BE PRINTED.
C     LSUM  = TRUE IF SUMMARY DATA ARE TO BE PROCESSED FOR OUTPUT.
C     LSCOPY= TRUE IF SUMMARY DATA WHICH IS SELECTED FOR PROCESSING
C             IS ALSO COPIED TO FILE JOCOPY.
C     JOCOPY= DSRN FOR SUMMARY DATA OUTPUT FILE, WRITTEN WITHOUT
C             HEADINGS.
C     IPMODE= THE PROCESSING MODE FOR EACH STAND IN THE CURRENT CYCLE:
C             1 IF THE STAND WILL BE INDEPENTENTLY PROCESSED UP TO
C             THE END OF THE MASTER CYCLE.
C             2 IF THE STAND WILL BE ALLOWED TO INTERACT ON A ANNUAL
C             OR MORE FREQUENT BASIS.  NOTE THAT STANDS WITH A
C             PROCESSING MODE OF 2 CYCLE ONLY ONCE DURING
C             THE MASTER CYCLE.
C     IPMODI= THE PROCESSING MODE FOR THE CURRENT STAND.
C     LHIST = TRUE IF HISTORY FILE IS OPEN FOR INPUT, AND FALSE IF IS
C             OPEN FOR OUTPUT.
C     LTMPAD= CONTROLS STAND TEMPLATING
C     IMSREC= THE FIRST RECORD WHERE THE TEMPLATE IS STORED.
C     IMSEND= THE LAST RECORD WHERE THE TEMPLATE IS STORED.
C     LSNDCP= TRUE IF STAND COMPOSTION TABLE WILL BE PRINTED.
C     LSMPT = TRUE IF SAMPLE TREE AND STAND ATTRIBUTE TABLES WILL BE
C             PRINTED.
C     MGM1  = THE MANAGEMENT ID IN THE FIRST FIELD OF SELMGMID OPTION.
C     MGM2  = THE MANAGEMENT ID IN THE SELCOND FIELD OF SELMGMID.
C     SID1  = THE STAND IDENT. IN THE FIRST FIELD OF SELSTAND OPTION.
C     SID2  = THE STAND IDENT. IN THE FIRST FIELD OF SELSTAND OPTION.
C     LNSSPL= LENGTH OF STAND POLICY LABEL IN THE SELSPLAB OPTION.
C     SLSPLB= THE STAND POLICY LABEL IN THE SELSPLAB OPTION.
C     LNSHPL= LENGTH OF POLICY LABEL IN THE SELMSPLB OPTION.
C     SLHPLB= THE POLICY LABEL IN THE SELMSPLB OPTION.
C     CMPID = THE MANAGEMENT ID OF THE COMPOSITE YIELD TABLE.
C     CSISN = THE INTERNAL STAND NUMBER IN THE FIRST FIELD OF
C             THE SELISN OPTION.
C     CLISN = THE ISN IN THE SECOND FIELD OF THE SELISN OPTION.
C     IBRPH = THE PHASE WITHIN TREGRO WHEN THE BRANCH OCCURRED.
C     DCTOP = DEFINE CLEAR CUT: TOP HEIGHT
C     DCTPA = DEFINE CLEAR CUT: TREES PER ACRE
C     ISDWK1= A WORK ARRAY USED TO PROCESS LISTS OF STAND POINTERS.
C     NBYGRP= THE SWITCH SETTING FOR THE BYGRPS KEYWORDS:
C             0=NOBYGRPS, 1=BYSTAND, 2=BYMGMTID, 3=BYSPLAB, 4=BYHPLAB.
C     JLBWTS= DATA SET REF NUMBER FOR LABEL & WEIGHTS OUTPUT FILE.
C     LBWTS = TRUE IF LABWTS OPTION IS ON, FALSE OTHERWISE.
C     CLBWID= THE IDENT USED TO IN THE FIRST 4 COLS OF THE LABWTS FILE.
C     NDACUM= VECTOR LISTING THE CUM NUMBER OF RECORDS PER ALL-DATA
C             FILE. NDACUM(1)=0, (2)=NUMBER IN FILE 1, (3)=NUMBER IN
C             FILE 1 PLUS THOSE IN FILE 2... ETC.
C     NAURPS= THE NUMBER OF INITIAL REPS FOR EACH ADDSTAND, USUALLY 1,
C             BUT CAN BE UP TO 9*9*9=729
C     JEXOPT= DATA SET REFERENCE NUMBER USED TO READ THE "MORE ACTIVITES" 
C             FILE.
C
C-----END SEGMENT
