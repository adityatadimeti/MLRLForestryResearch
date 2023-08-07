      SUBROUTINE CHPUT
      IMPLICIT NONE
C----------
C PG $Id$
C----------
C
C     WRITE THE ALL-DATA CHARACTER DATA TO THE DA FILE.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
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
      INCLUDE 'CALDEN.F77'
C
C
      INCLUDE 'OPCOM.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'DBSTK.F77'
C
C
      INCLUDE 'GGCOM.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C
C
      INTEGER LNCBUF,IRECLN
      PARAMETER (IRECLN=1024)      
      PARAMETER (LNCBUF=IRECLN*4)
      CHARACTER CBUFF(LNCBUF),CDMB*1
      INTEGER K,J,I,IPNT
C
C     PUT THE CHARACTERS.
C
      K=1
      DO 5 J=1,4
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,MGMID(J:J),K)
      K=2
    5 CONTINUE
      DO 10 J=1,26
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,NPLT(J:J),2)
   10 CONTINUE
      DO J=1,LEN(DBCN)
        CALL CHWRIT(CBUFF,IPNT,LNCBUF,DBCN(J:J),2)
      ENDDO
C
      IF (LBSETS) THEN
         IF (LENSLS.GT.0) THEN
            DO 20 K=1,LENSLS
            CALL CHWRIT (CBUFF,IPNT,LNCBUF,SLSET(K:K),2)
   20       CONTINUE
         ENDIF
         IF (IEVA.GT.1) THEN
            DO 40 I=1,IEVA-1
            J=LENAGL(I)
            IF (J.GE.1) THEN
               DO 30 K=1,J
               CALL CHWRIT (CBUFF,IPNT,LNCBUF,AGLSET(I)(K:K),2)
   30          CONTINUE
            ENDIF
   40       CONTINUE
         ENDIF
      ENDIF
C
      DO 60 J=1,4
      DO 50 I=1,3
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPTT(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPBR(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPTV(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPMR(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPAC(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPCT(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPCV(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPMC(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPBV(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPRT(J)(I:I),2)
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IOSPMO(J)(I:I),2)
   50 CONTINUE
   60 CONTINUE
C
      DO 80 J=1,6
      DO 70 I=1,3
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,IONSP(J)(I:I),2)
   70 CONTINUE
   80 CONTINUE
C
      DO 85 I=1,6
         CALL CHWRIT (CBUFF,IPNT,LNCBUF,ALLSUB(I:I),2)
   85 CONTINUE
C
      IF (ITOP.GT.0) THEN
         DO 90 I=1,ITOP
         CALL CHWRIT (CBUFF,IPNT,LNCBUF,SUBNAM(I:I),2)
   90    CONTINUE
      ENDIF
C
      IF (ITST5.GT.0) THEN
         DO J=1,ITST5
           DO I=1,8
             CALL CHWRIT (CBUFF,IPNT,LNCBUF,CTSTV5(J)(I:I),2)
           ENDDO
         ENDDO
      ENDIF
      IF (ICACT.GT.0) THEN
         DO I=1,ICACT
            CALL CHWRIT (CBUFF,IPNT,LNCBUF,CACT(I),2)
         ENDDO
      ENDIF
C
      DO 102 J=1,30
      DO 101 I=1,10
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,NAMGRP(J)(I:I),2)
  101 CONTINUE
  102 CONTINUE
C
      DO 104 J=1,MAXSP
      DO 103 I=1,10
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,VEQNNB(J)(I:I),2)
  103 CONTINUE
  104 CONTINUE
C
      DO 106 J=1,MAXSP
      DO 105 I=1,10
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,VEQNNC(J)(I:I),2)
  105 CONTINUE
  106 CONTINUE
C
      DO 108 I=1,10
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,CPVREF(I:I),2)
  108 CONTINUE
C
      DO 110 I=1,72
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,ITITLE(I:I),2)
  110 CONTINUE
C
      DO 112 J=1,30
      DO 111 I=1,10
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,PTGNAME(J)(I:I),2)
  111 CONTINUE
  112 CONTINUE
C
      DO 114 I=1,2
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,VARACD(I:I),2)
  114 CONTINUE
C
      DO 115 I=1,7
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,CALCSDI(I:I),2)
  115 CONTINUE
C
      CALL DBSCHPUT(CBUFF,IPNT,LNCBUF)
      CALL VARCHPUT(CBUFF,IPNT,LNCBUF)
      CALL MSCHPUT(CBUFF,IPNT,LNCBUF)
C
C     Store dummy character as last write and finalize character 
C     variable storage, last parameter is 3 to specify.
C
      CDMB='X'
      CALL CHWRIT(CBUFF,IPNT,LNCBUF,CDMB,3)
C
      RETURN
      END
