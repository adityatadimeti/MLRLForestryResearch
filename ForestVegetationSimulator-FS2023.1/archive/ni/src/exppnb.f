      SUBROUTINE EXPPNB
      IMPLICIT NONE
C----------
C NI $Id: exppnb.f 2121 2018-02-28 23:37:24Z gedixon $
C----------
C
C     VARIANT DEPENDENT EXTERNAL REFERENCES FOR THE
C     PARALLEL PROCESSING EXTENSION
C
C
C     CALLED TO COMPUTE THE DDS MODIFIER THAT ACCOUNTS FOR THE DENSITY
C     OF NEIGHBORING STANDS (CALLED FROM DGF).
C
      REAL BDBL,BBAL,BCCF,DBH,CCFO,BALO,XPPDDS,XPPMLT
      REAL RDANUW
C----------
C  ENTRY PPDGF
C----------
      ENTRY PPDGF (XPPDDS,BALO,CCFO,DBH,BCCF,BBAL,BDBL)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = XPPDDS
      RDANUW = BALO
      RDANUW = CCFO
      RDANUW = DBH
      RDANUW = BCCF
      RDANUW = BBAL
      RDANUW = BDBL
C
      RETURN
C----------
C  ENTRY PPREGT
C----------
C
C     CALLED TO COMPUTE THE REGENT MULTIPLIER THAT ACCOUNTS FOR
C     THE DENSITY OF NEIGHBORING STANDS (CALLED FROM REGENT).
C
      ENTRY PPREGT (XPPMLT,CCFO,BALO,BCCF,BBAL)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = XPPMLT
      RDANUW = CCFO
      RDANUW = BALO
      RDANUW = BCCF
      RDANUW = BBAL
C
      RETURN
      END
