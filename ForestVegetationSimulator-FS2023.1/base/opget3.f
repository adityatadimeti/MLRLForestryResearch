      SUBROUTINE OPGET3 (IACTK,IDT,IYR1,IYR2,ISQNUM,MXPM,NPRMS,
     >                   PRMS,KODE)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     OPTION PROCESSING ROUTINE - NL CROOKSTON - JUNE 1981 - MOSCOW
C
C     OPGET3 IS MUCH LIKE OPGET2 EXCEPT THAT THIS ROUTINE RETURNS
C     INFORMATION ABOUT ACTIVITIES WHICH HAVE ALREADY BEEN ACOMPLISHED.
C
C     IACTK = THE ACTIVITY CODE
C     IDT   = THE DATE THE ACTIVITY IS ACTUALLY SCHEDULED.
C     IYR1  = THE EARLYEST DATE IN THE SEARCH.
C     IYR2  = THE LATEST DATE IN THE SEARCH. IYR1 AND IYR2 DEMARK THE
C             RANGE OF DATES OF INTEREST.
C     ISQNUM= THE OCCURANCE NUMBER OF INTEREST.  IF ISQNUM IS PASSED
C             AS A ZERO, THE LAST OCCURANCE OF THE ACTIVITY WHICH IS
C             SCHEDULED BETWEEN IYR1 AND IYR2 IS PROCESSED, OTHERWISE
C             THE ISQNUM TH OCCURANCE OF THE ACTIVITY IS PROCESSED.
C     MXPM  = THE MAXIMUM NUMBER OF PARAMETERS THE CALLING ROUTINE
C             CAN ACCEPT; DIMENSION OF PRMS.
C     NPRMS = THE NUMBER OF PARAMETERS RETURNED, OR -NPRMS IF THE
C             NUMBER OF PARAMETERS PRESENT FOR THE ACTIVITY IS
C             GREATER THAN THE VALUE OF MXPM.
C     PRMS  = THE PARAMETER ARRAY.
C     KODE  = RETURN CODE, WHERE:
C             0 IMPLIES NO ERRORS.
C             1 IMPLIES THE ACTIVITY REFERENCED COULD NOT BE FOUND.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'OPCOM.F77'
C
C
COMMONS
C
      INTEGER KODE,NPRMS,ISQNUM,IYR1,IYR2,IDT,IACTK,MXPM,IFIND,NTIMES
      INTEGER I2,II,I,ID,J1,IRC,J2,J
      REAL PRMS(MXPM)
C
C     PREFORM THE SEARCH FOR THE ACTIVITY IN ASSENDING DATE ORDER.
C
   10 CONTINUE
      KODE=0
      IFIND=0
      NTIMES=0
      I2=IMGL-1
      DO 40 II=1,I2
      I=IOPSRT(II)
      ID=IDATE(I)
      IF (ID.LT.IYR1 .OR. ID.GT.IYR2 .OR. IACTK.NE.IACT(I,1)) GOTO 40
C-------
C   WE ARE INTERESTED IN THE ACTIVITIES WHICH HAVE BEEN COMPLETED.
C-------
      IF (IACT(I,4).EQ.0) GOTO 40
      NTIMES=NTIMES+1
      IF (ISQNUM.GT.0) GOTO 30
      IFIND=I
      GOTO 40
   30 CONTINUE
      IF (ISQNUM.NE.NTIMES) GOTO 40
      IFIND=I
      GOTO 50
   40 CONTINUE
   50 CONTINUE
      IF (IFIND.GT.0) GOTO 60
      KODE=1
      RETURN
C
C     THE SEARCH IS COMPLETE - PROCEED WITH THE OPERATION.
C
   60 CONTINUE
      J1=IACT(IFIND,2)
C
C     IF J1 IS LESS THAN ZERO, THE OPTION WAS SPECIFIED WITH THE PARMS
C     OPTION.  CALL OPEVAL TO EVALUATE THE PARAMETERS.  IF THE RETURN
C     CODE FROM OPEVAL IS GT THAN ZERO, ONE OR MORE PARAMETER IS
C     UNDEFINED AND THE ACTIVITY IS 'DELETED'; SO GO LOOK FOR ANOTHER.
C
      IF (J1.LT.0) THEN
         CALL OPEVAL (IFIND,IRC)
         IF (IRC.GT.0) GOTO 10
         J1=IACT(IFIND,2)
      ENDIF
      IDT=IDATE(IFIND)
      NPRMS=0
      IF (J1.EQ.0) RETURN
      J2=IACT(IFIND,3)
      NPRMS=J2-J1+1
      IF (NPRMS.LE.MXPM) GOTO 90
      J2=J2-(NPRMS-MXPM)
      NPRMS=-NPRMS
   90 CONTINUE
      DO 100 J=J1,J2
      PRMS(J-J1+1)=PARMS(J)
  100 CONTINUE
      RETURN
      END



