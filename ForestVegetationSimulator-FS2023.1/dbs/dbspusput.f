      SUBROUTINE DBSPUSPUT (CBUFF,IPNT,LNCBUF)
      IMPLICIT NONE
C----------
C DBS $Id$
C----------
C
C
COMMONS
C
C
      INCLUDE 'DBSCOM.F77'
C
C
COMMONS
C
C
      INTEGER I
      INTEGER LNCBUF, IPNT
      CHARACTER*1 CBUFF(*)

      DO I=1,LEN_TRIM(DSNOUT)
         CALL CHWRIT (CBUFF,IPNT,LNCBUF,DSNOUT(I:I),2)
      ENDDO
      CALL CHWRIT (CBUFF,IPNT,LNCBUF,CHAR(0),2)
      DO I=1,LEN_TRIM(DBMSOUT)
         CALL CHWRIT (CBUFF,IPNT,LNCBUF,DBMSOUT(I:I),2)
      ENDDO
      CALL CHWRIT (CBUFF,IPNT,LNCBUF,CHAR(0),2)
      DO I=1,LEN_TRIM(DSNIN)
         CALL CHWRIT (CBUFF,IPNT,LNCBUF,DSNIN(I:I),2)
      ENDDO
      CALL CHWRIT (CBUFF,IPNT,LNCBUF,CHAR(0),2)
      DO I=1,LEN_TRIM(DBMSIN)
         CALL CHWRIT (CBUFF,IPNT,LNCBUF,DBMSIN(I:I),2)
      ENDDO
      CALL CHWRIT (CBUFF,IPNT,LNCBUF,CHAR(0),2)
      RETURN
      END
