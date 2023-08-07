      SUBROUTINE SVMORT (ICALLER, CUMMORT, ICURYEAR)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     STAND VISUALIZATION GENERATION
C     N.L.CROOKSTON -- RMRS MOSCOW -- NOVEMBER 1998
C     J.J.MARCHINEK -- RMRS MOSCOW -- JANUARY 1999
C     A.H.DALLMANN  -- RMRS MOSCOW -- JANUARY 2000
C     L.R.DAVID     -- FHTET FORT COLLINS -- JULY 2005
C
C     INPUT:
C     ICALLER = IDENTIFICATION OF THE CALLER.
C               0 - CALLED FROM GRINIT FOR FINAL MORTALITY...MORTALITY
C                   COMES FROM WK2...AND THIS IS THE LAST CALL FOR
C                   THE CYCLE (IMORTCNT IS RESET TO ZERO).
C               1 - CALLED FROM ELSEWHERE FOR INCREMENTAL MORTALITY
C                   AS STORED IN CUMMORT (THESE CALLS MUST COME PRIOR
C                   TO ANY CALLS WHERE ICALLER IS 0).
C               2 - CALLED FROM WESTWIDE PINE BEETLE FOR INCREMENTAL
C     CUMMORT = VECTOR OF CUMMULATIVE TREE MORTIALITY WHEN ICALLER
C               IS 1 OR 2, AND IS IGNORED WHEN ICALLER IS 0. ONLY THE 
C               ADDITIONAL MORTALITY FROM THE LAST CALL IS PROCESSED.
C               
C
C     UPDATES THE VISUALIZATION FOR MORTALITY. THIS CALL
C     ASSUMES THAT ALL THE TREES THAT "DIE" ARE STANDING 
C     SNAGS.  
C
C     CALLED FROM GRADD JUST BEFORE UPDATE.
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
      INCLUDE 'SVDATA.F77'
C
C
COMMONS
C
C     SUM= TOTAL CHANGE IN MORT THIS CALL
C     CREATE DUMMY VERSIONS OF SSNG,DSNG,CTCRWN
C
      REAL SUM,TEMP
      INTEGER ICURYEAR,ICALLER,I
      REAL SSNG(1),DSNG(1),CTCRWN(1)
      REAL CUMMORT(*)
      SUM = 0.

C     CHECK TO SEE IF MORT HAS NOT BEEN DONE YET THIS CYCLE.  
C     IF IT HAS NOT, PROCESS ALL CHANGES.

      IF (ICALLER .EQ. 0) THEN
         IF (IMORTCNT .EQ. 0) THEN

C           INITIALIZE SVMSAVE WITH WK2'S VALUES, AND FIND THE SUM
C           OF ALL THE VALUES IN WK2.

            DO I=1, ITRN
               SVMSAVE(I) = WK2(I)
               SUM = SUM + WK2(I)
            ENDDO
         ELSE

C           MODIFY WK2, REMOVING MORTALITY THAT HAS ALREADY BEEN DONE
C           DURING THIS CYCLE.  THIS NEW VALUE WILL BE PASSED INTO
C           SVRMOV, AND THEN WK2 WILL HAVE THE OLD VALUE ADDED BACK IN.

            DO I=1, ITRN
               TEMP = WK2(I)
               WK2(I) = WK2(I) - SVMSAVE(I)
               IF (WK2(I).LT. 0.0) WK2(I)=0.0
               SUM = SUM + WK2(I)
               SVMSAVE(I) = TEMP
            ENDDO

         ENDIF
      ELSE
     
C        IF MORT HAS ALREADY BEEN DONE DURING THIS CYCLE, THEN ONLY 
C        PROCESS THE NEW MORTALITY.
    
         IF (IMORTCNT .EQ. 0) THEN

C           INITIALIZE SVMSAVE WITH CUMMORT'S VALUES, AND FIND THE
C           SUM OF ALL THE VALUES IN CUMMORT.

            DO I=1, ITRN
               SVMSAVE(I) = CUMMORT(I)
               SUM = SUM + CUMMORT(I)
            ENDDO
         ELSE

C           MODIFY CUMMORT, REMOVING MORTALITY THAT HAS ALREADY BEEN DONE
C           DURING THIS CYCLE.  THIS NEW CUMMORT WILL BE PASSED INTO
C           SVRMOV, AND THEN CUMMORT WILL HAVE THE OLD VALUE ADDED BACK IN.

            DO I=1, ITRN
               TEMP = CUMMORT(I)
               CUMMORT(I) = CUMMORT(I) - SVMSAVE(I)
               IF (CUMMORT(I).LT.0.0) CUMMORT(I)=0.0
               SUM = SUM + CUMMORT(I)
               SVMSAVE(I) = TEMP
            ENDDO
         ENDIF

C        INCREMENT IMORTCNT TO SHOW THAT THE NUMBER OF TIMES SVMORT
C        HAS BEEN CALLED HAS INCREASED.

         IMORTCNT = IMORTCNT + 1

      ENDIF

C     THIS ROUTINE WILL ONLY CALL SVRMOV WHEN THERE IS SOME AMOUNT OF CHANGE.

      IF (SUM .GT. 0.) THEN
         IF (ICALLER .EQ. 0) THEN
            CALL SVRMOV (WK2,2,SSNG,DSNG,CTCRWN,ICURYEAR)
         ELSE
            IF (ICALLER .EQ. 1) THEN
               I = 1
            ELSEIF (ICALLER .EQ. 2) THEN
               I = 3
            ENDIF
            CALL SVRMOV (CUMMORT,I,SSNG,DSNG,CTCRWN,ICURYEAR)
         ENDIF
      ENDIF

C     RESTORE THE VALUES STORED IN THE CUMMORT/WK2 ARRAY.

      IF (ICALLER .EQ. 0) THEN
         DO I=1, ITRN
            WK2(I) = SVMSAVE(I)
         ENDDO

C        RESET THE MORTALITY CALL COUNTER TO 0...

         IMORTCNT = 0

      ELSE
         DO I=1, ITRN
            CUMMORT(I) = SVMSAVE(I)
         ENDDO
      ENDIF

      RETURN
      END
