      SUBROUTINE BWEOB 
      IMPLICIT NONE
C ------------
C WSBWE $Id$
C ------------
C
C  CALCULATE THE YEAR THE NEXT REGIONAL OUTBREAK STARTS & ENDS
C
C  PART OF THE BUDWORM DEFOLIATION MODEL (BUDLITE)
C
C  K.A. SHEEHAN, USDA-FS, R6 NATURAL RESOURCES, PORTLAND, OR
C
C  CALLED FROM:  BWEIN (FIRST OUTBREAK)
C                BWEGO (SUBSEQUENT OUTBREAKS)
C
C  PARAMETERS: 
C   IYROBL - YEAR THAT LAST REGIONAL OUTBREAK STARTED [BWECM2]
C   IOBLOC - GEOGRAPHIC LOCATION INDEX  [BWECM2]
C                1 = SOUTHWEST, 2 = NORTHWEST, 3 = MONTANA
C   IYRST - YEAR THAT NEXT REGIONAL OUTBREAK STARTS  [BWECM2]
C   IYREND - YEAR THAT NEXT REGIONAL OUTBREAK ENDS [BWECM2]
C   IYRECV - YEAR THAT TREES WILL BE COMPLETELY RECOVERED [BWECM2]
C                 FROM NEXT OUTBREAK
C   IYRSRC - NUMBER OF YEARS AFTER END OF OUTBREAK THAT TREES [BWECM2]
C                 WILL BE COMPLETELY RECOVERED
C   OBTABL(8,3) - OUTBREAK PARAMETER TABLE (PARAMETER=IOBLOC) [BWECM2]
C       PARAMETERS:
C          1=MEAN OUTBREAK INTERVAL, 2=INT. DEVIATION,
C          3=INT.LOW RANGE, 4=INT.HIGH RANGE, 5=MEAN
C          OUTBREAK DURATION, 6=DUR. DEVIATION, 7=DUR.
C          LOW RANGE, 8=DUR.HIGH RANGE
C   NEVENT - NO. OF BW SPECIAL EVENTS TO DATE                                   [BWEBOX]
C   IEVENT(250,5) - BW SPECIAL EVENTS SUMMARY TABLE [BWEBOX]
C   IOBOPT - 1 = ONLY OB STARTS SCHEDULED, 2=STARTS & ENDS SCHEDULED
C            3=USER SPECIFIES OB STARTS AND ENDS
C
C
C Revision History:
C   30-AUG-2006 Lance R. David (FHTET)
C      Changed array orientation of IEVENT from (4,250) to (250,4).
C   11-OCT-2006 Lance R. David (FHTET)
C      Change variable name RANGE to OBRANG. Added debug.
C   02-JUN-2009 Lance R. David (FMSC)
C      Added Stand ID and comma delimiter to output tables, some header
C      and column labels modified.
C   14-JUL-2010 Lance R. David (FMSC)
C      Added IMPLICIT NONE and declared variables as needed.
C   28-AUG-2013 Lance R. David (FMSC)
C      Added weather year (if using RAWS) to special events table.
C
C----------------------------------------------------------------------
C
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'BWECM2.F77'
      INCLUDE 'BWEBOX.F77'

      INTEGER I, IH
      REAL OBINT, OBDUR, OBRANG, X
      LOGICAL DEBUG

C
C.... Check for DEBUG
C
      CALL DBCHK(DEBUG,'BWEOB',5,ICYC)

      IF (DEBUG) WRITE (JOSTND,*) 'ENTER BWEOB: NPLT=',NPLT(1:8),
     & ' ICYC=',ICYC,' IOBOPT=',IOBOPT,' NOBDON,NOBSCH=',NOBDON,NOBSCH
C
C SEE IF THE USER HAS SCHEDULED SPECIFIC YEARS FOR OUTBREAKS
C
      IF (IOBOPT.EQ.3) THEN
         IF (NOBDON.LT.NOBSCH) THEN
            NOBDON=NOBDON+1
            IYRST=IOBSCH(NOBDON,1)
            IYREND=IOBSCH(NOBDON,2)
         ELSE
            IYRST=0
            IYREND=0
            IYRECV=0
         ENDIF
         IF (DEBUG) WRITE (JOSTND,*) 'IN BWEOB: IYRST,IYREND,IYRECV=',
     &      IYRST,IYREND,IYRECV
C
C OTHERWISE, FIRST CALC. THE NEXT INTERVAL
C   ALWAYS MAKE 2 CALLS TO BWERAN (EVEN IF ONLY THE FIRST CALL
C   WILL BE USED) TO ALLOW COMPARISONS BETWEEN OUTBREAK SCHEDULING
C   OPTIONS.
C
      ELSEIF (IOBOPT.NE.3) THEN
         OBRANG = OBTABL(4,IOBLOC)-OBTABL(3,IOBLOC)
         X=0.0
         IF (DEBUG) WRITE (JOSTND,*) 'IN BWEOB: OBRANG=',OBRANG 
C        PUT SEED VALUE FOR OUTBREAK RANDOM NUMBER SERIES.
         CALL BWERPT(OBSEED)
         CALL BWERAN(X)
         IF (OBRANG.LT.1.0) THEN
           OBINT=OBTABL(1,IOBLOC)
           IF (OBINT.LT.1.0) OBINT = 27.3
         ELSE
            OBINT=OBTABL(3,IOBLOC)+ (OBRANG * X)
         ENDIF
         IYRST=IYROBL + IFIX(OBINT)
         IF (DEBUG) WRITE (JOSTND,*)
     &    'IN BWEOB: IYRST,IYROBL,OBINT=',IYRST,IYROBL,OBINT
      ENDIF
C      
C NEXT CALC. THE NEXT DURATION
C
      IF (IOBOPT.NE.3) THEN
         IF (IOBOPT.EQ.1) IYREND=-1
         IF (IOBOPT.EQ.4) IYREND=-2
         X=0.0
         CALL BWERAN(X)
C        GET SEED VALUE FOR OUTBREAK RANDOM NUMBER SERIES.
         CALL BWERGT(OBSEED)
         IF (IOBOPT.EQ.2) THEN
            OBRANG = OBTABL(8,IOBLOC)-OBTABL(7,IOBLOC)
            IF (OBRANG.LT.1.0) THEN
               OBDUR=OBTABL(5,IOBLOC)
               IF (OBDUR.LT.1.0) OBINT = 14.0
            ELSE
               OBDUR=OBTABL(7,IOBLOC) + (OBRANG * X)
            ENDIF
            IYREND=IYRST  + IFIX(OBDUR) - 1
            IF (DEBUG) WRITE (JOSTND,*)'IN BWEOB: OBRANG=',OBRANG,
     &      ' OBDUR,IYREND=',OBDUR,IYREND
         ENDIF
      ENDIF

      IYROBL=IYRST
      IF (IOBOPT.EQ.1) THEN
        IYRECV=-1
      ELSEIF (IOBOPT.EQ.4) THEN
        IYRECV=-2
      ELSE
        IYRECV=IYREND+IYRSRC
      ENDIF

      NEVENT=NEVENT+1

      IF (DEBUG) WRITE (JOSTND,*)
     &  'IN BWEOB: IYROBL,IYRSRC,IYRECV=',IYROBL,IYRSRC,IYRECV,
     &  ' NEVENT=',NEVENT

      IF (NEVENT.GT.250) THEN
         WRITE (JOBWP4,8250)
 8250    FORMAT ('********   ERROR - WSBW: MORE THAN 250 ENTRIES!')
         LP4=.FALSE.
      ELSE
         IEVENT(NEVENT,1)=IYRST
         IEVENT(NEVENT,2)=7
         IEVENT(NEVENT,3)=0
         IEVENT(NEVENT,4)=1
C        weather year is reported only if RAWS data is in use.
C        If cycle is zero, weather data year is unknown.
         IF (IWSRC .EQ. 3 .AND. ICYC .NE. 0) THEN
           IEVENT(NEVENT,5)=BWPRMS(11,IWYR)
         ELSE
           IEVENT(NEVENT,5)=0
         ENDIF
         I=IYRST-1
         IF (LP6 .AND. NEVENT.GT.2) WRITE (JOBWP6,8600) NPLT,I,I
 8600    FORMAT (A26,', ',I5,',',7X,'0,',7X,'0,',3(5X,'   ,'),
     &           1X,I5,',',6(7X,'0,'))
        ENDIF
C
C  SET LFIRST TO TRUE TO INDICATE THAT THE NEXT CALL TO BUDLITE
C  WILL BE THE START OF A NEW OUTBREAK.  ALSO SET THE INSECTICIDE
C  APPLICATION COUNTER (NO. OF APPLICATIONS MADE DURING THE CURRENT
C  OUTBREAK), THE NO. OF YEARS OF DEFOLIATION, THE NO. OF CONSECUTIVE
C  YEARS OF LOW DEFOLIATION, AND THE DURATION OF THE CURRENT OUTBREAK
C  TO ZERO.
C
      LFIRST=.TRUE.
      NUMAPP=0
      DO 50 IH=1,6
         DEFYRS(IH)=0.0
   50 CONTINUE
      LOWYRS=0
      IOBDUR=0

      IF (DEBUG) WRITE (JOSTND,*) 'EXIT BWEOB: ICYC=',ICYC
      RETURN
      END
