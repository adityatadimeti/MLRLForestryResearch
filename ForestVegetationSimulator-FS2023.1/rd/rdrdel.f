      SUBROUTINE RDRDEL
      IMPLICIT NONE
C----------
C RD $Id$
C----------
C
C  THIS SUBROUTINE LOOPS THRU THE TREELIST TO DETERMINE IF
C  ANY TREES HAVE BEEN ZEROED OUT FOR ALL THE ROOT ROT PROB VARIABLES.
C  THIS CAN HAPPEN IN THE FIRST CYCLE IF AN INFECTED TREE IS KILLED
C  TOTALLY, IE THE ENTIRE VALUE FOR PROBI IS ASSIGNED TO STUMPS AND
C  SET TO ZERO. THIS TREE SHOULD BE DELETED FROM THE TREELIST TO
C  PREVENT ERRORS IN RRGROW AS A RESULT OF PROBI,PROBIU,PROBIT
C  AND FPROB ALL BEING ZERO.
C
C  CALLED BY :
C     RDTREG  [ROOT DISEASE]
C
C  CALLS     :
C     TREDEL  (SUBROUTINE)   [PROGNOSIS]
C     SPESRT  (SUBROUTINE)   [PROGNOSIS]
C     RDPSRT  (SUBROUTINE)   [PROGNOSIS]
C     PCTILE  (SUBROUTINE)   [PROGNOSIS]
C     DIST    (SUBROUTINE)   [PROGNOSIS]
C     COMP    (SUBROUTINE)   [PROGNOSIS]
C
C  Revision History
C    21-MAR-00 Lance David (FHTET)
C      Added Debug code.
C   09/02/14 Lance R. David (FMSC)
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
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'ARRAYS.F77'
      INCLUDE 'OUTCOM.F77'
      INCLUDE 'RDCOM.F77'
      INCLUDE 'RDARRY.F77'
      INCLUDE 'RDADD.F77'
C

      LOGICAL DEBUG
      INTEGER I, I1, I2, IM, IS, IT, IVAC, J, KSP
      REAL    SPCNT(MAXSP,3), TOAKL

C.... SEE IF WE NEED TO DO SOME DEBUG.

      CALL DBCHK (DEBUG,'RDRDEL',6,ICYC)
      IF (DEBUG)
     &  WRITE (JOSTND,*) 'ENTER RDRDEL:  ICYC=',ICYC,' ITRN=',ITRN

      DO 444 I = 1,MAXSP
         SPCNT(I,1) = 0.0
         SPCNT(I,2) = 0.0
         SPCNT(I,3) = 0.0
  444 CONTINUE

C
C     DEBUG CODE
C
      IF (DEBUG) THEN
        DO 884 I=1,ITRN
          WRITE(JOSTND,889) I,PROBI(I,1,1),PROBIU(I),FPROB(I)
  889     FORMAT(' IN RDRDEL :   I,PROBI,PROBIU,FPROB',I4,3F8.2)
  884   CONTINUE
      ENDIF

      IVAC = 0
      DO 555 KSP = 1,MAXSP
         I1 = ISCT(KSP,1)
         I2 = ISCT(KSP,2)
         IF (ISCT(KSP,1) .EQ. 0) GOTO 555

         DO 556 J = I1,I2
            IT = IND1(J)
            IF (PROBIU(IT) .EQ. 0.0 .AND. PROBIT(IT) .EQ. 0.0
     &        .AND. FPROB(IT) .EQ. 0.0) THEN
              
              TOAKL = OAKL(1,IT) + OAKL(2,IT) + OAKL(3,IT)
              
              IF (RDKILL(IT) .LE. 0.0 .AND. TOAKL .LE. 0.0) THEN

C                WE ONLY WANT TO DELETE TREE RECORD IF NOTHING IS USING IT
C                (FOR PRINTING, WE NEED TO ACCESS CFV(IT) AND FOR BEETLES,
C                WE NEED THE DBH AND PROPI OF THESE RECORDS). CORRECTIONS 
C                WILL BE ADDED TO RDGROW TO COMPENSATE FOR NOT DELETING THESE
C                RECORDS.              

                 PROB(IT) = 0.0
                 IVAC = IVAC + 1
                 IND1(J) = -IT
              
              ENDIF
            ENDIF
  556    CONTINUE
  555 CONTINUE

C
C     IF ANY TREES TO BE DELETED CALL TREDEL AND RRTDEL, SPESRT TO
C     REALIGN SPECIES SORT AND RDPSRT TO RESORT BY DBH.
C
      IF (DEBUG) WRITE (JOSTND,999) IVAC,(I,IND1(I),I=1,ITRN)
  999 FORMAT (' IN RDRDEL BEFORE DELETE: IVAC = ',I4/
     >        ((' ITREE = ',I4,'; IND1(ITREE) = ',I4)))

      IF (IVAC .LE. 0) GOTO 566
      CALL TREDEL (IVAC,IND1)
      CALL SPESRT
      IF (ITRN .LE. 0) GOTO 565
      CALL RDPSRT (ITRN,DBH,IND,.TRUE.)

C
C     RE-COMPUTE THE SPECIES COMPOSITION
C
  565 CONTINUE
      DO 60 I = 1,ITRN
         IS = ISP(I)
         IM = IMC(I)
         SPCNT(IS,IM) = SPCNT(IS,IM) + PROB(I)
   60 CONTINUE

C
C     RE-COMPUTE THE DISTRIBUTION OF TREES PER ACRE AND SPECIES-
C     TREE CLASS COMPOSITON BY TREES PER ACRE.
C
C     (MAKE SURE IFST=1, TO GET A NEW SET OF POINTERS TO THE
C      DISTRIBUTIONS).
C
      IFST = 1
      CALL PCTILE (ITRN,IND,PROB,WK3,ONTCUR(7))
      CALL DIST (ITRN,ONTCUR,WK3)
      CALL COMP (OSPCT,IOSPCT,SPCNT)
C
      IF (DEBUG) 
     &  WRITE(JOSTND,619) (I, PROBI(I,1,1),PROBIU(I),FPROB(I),I=1,ITRN)
  619 FORMAT(' IN RDRDEL AFT: I PROBI,PROBIU,FPROB',I4,3F8.2)

  566 CONTINUE
C
C     DEBUG CODE
C
      IF (DEBUG) THEN
        DO 484 I = 1,ITRN
          WRITE (JOSTND,489) I,PROB(I),WK2(I)
 489      FORMAT (' IN RDRDEL, I,PROB ,WK2 ',I4,2F8.2)
 484    CONTINUE
      ENDIF

      IF (DEBUG) WRITE (JOSTND,*) 'EXIT RDRDEL'
      RETURN
      END
