      SUBROUTINE EXMIST
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C  Purpose:
C     Dummy external references for dwarf mistletoe model routines. A
C  dummy version of function MISDGF is at the end of this file.
C----------
C
C  Call list definitions (for entry point routines):
C     ARRAY:  (I)  Array containing keyword entries.
C     DMFLAG: (IO) Logical flag; TRUE if theres any DM in the stand.
C     IARRAY: (IO) Array containing random integers between 1 and ISIZE.
C     ICODE:  (I)  Array of mistletoe damage codes.
C     IDMR:   (IO) Current tree dwarf mistletoe rating.
C     IPNT:   (IO) Pointer to current element in print buffer WK3.
C     ILIMIT: (I)  Size of print buffer WK3.
C     ISIZE:  (I)  Range of integers in IARRAY.
C     ITREE:  (I)  Current tree record number.
C     KEY:    (I)  Keyword number used in MISKEY call list.
C     KEYWRD: (IO) Character buffer containing keyword name.
C     LNOTBK: (O)  Logical array depicting blank keyword fields.
C     MFLAG:  (I)  Logical flag to update WK2 with mistletoe mortality.
C     MSPCNT: (O)  Array of number of DM infected records by species.
C     NFLAG:  (O)  Logical flag indicating presence of mistletoe code.
C     PRFCUT: (O)  Array of mistletoe cutting preferences by species.
C     WK3:    (IO) Work array used as a print buffer.
C
C  Local variable definitions:
C     NOMIS:  Character buffer used to tell MISKEY this is a no DM run.
C
C  Common block variables and parameters:
C     MAXSP:  From PRGPRM; maximum number species.
C     MAXTRE: From PRGPRM; maximum number tree records.
C
C----------
C----------
C  PARAMETER INCLUDE FILES.
C----------
      INCLUDE 'PRGPRM.F77'
C----------
C  VARIABLE DECLARATIONS.
C----------
      INTEGER I,ITREE,IDMR,KEY,IDMR1,ISIZE,ILIMIT,IPNT
      LOGICAL LNOTBK(7),DMFLAG,MFLAG,NFLAG,LKECHO
      REAL ARRAY(7),PRFCUT(MAXSP),WK3(MAXTRE)
      INTEGER ICODE(6),MSPCNT(MAXSP),IARRAY(MAXTRE)
      CHARACTER*8 KEYWRD,NOMIS
      CHARACTER*1 CBUFF
      REAL RDANUW
      INTEGER IDANUW
      CHARACTER*8 CDANUW
      LOGICAL LDANUW
C----------
C  DATA STATEMENTS.
C----------
      DATA NOMIS/'*NO MIST'/
C----------
C  ENTRY MISCNT
C----------
      ENTRY MISCNT(MSPCNT)
        DO 100 I=1,MAXSP
          MSPCNT(I)=0
  100   CONTINUE
      RETURN
C----------
C  ENTRY MISCPF
C----------
      ENTRY MISCPF(PRFCUT)
        DO 150 I=1,MAXSP
          PRFCUT(I)=0.0
  150   CONTINUE
      RETURN
C----------
C  ENTRY MISDAM
C----------
      ENTRY MISDAM(ITREE,ICODE)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = ITREE
        RDANUW = ICODE(1)
      RETURN
C----------
C  ENTRY MISGET
C----------
      ENTRY MISGET(ITREE,IDMR)
        IDMR=0
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = ITREE
      RETURN
C----------
C  ENTRY MISIN
C----------
      ENTRY MISIN(KEYWRD,ARRAY,LNOTBK,LKECHO)
        CALL ERRGRO(.TRUE.,11)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        CDANUW = KEYWRD
        RDANUW = ARRAY(1)
        LDANUW = LNOTBK(1)
        LDANUW = LKECHO
      RETURN
C----------
C  ENTRY MISINF
C----------
      ENTRY MISINF(DMFLAG)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        LDANUW = DMFLAG
      RETURN
C----------
C  ENTRY MISIN0
C----------
      ENTRY MISIN0
      RETURN
C----------
C  ENTRY MISINT
C----------
      ENTRY MISINT
      RETURN
C----------
C  ENTRY MISKEY (ENTRY POINT IN MISIN)
C----------
      ENTRY MISKEY(KEY,KEYWRD)
        KEYWRD=NOMIS
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = KEY
      RETURN
C----------
C  ENTRY MISMRT
C----------
      ENTRY MISMRT(MFLAG)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        LDANUW = MFLAG
      RETURN
C----------
C  ENTRY MISPRT
C----------
      ENTRY MISPRT
      RETURN
C----------
C  ENTRY MISPUT
C----------
      ENTRY MISPUT(ITREE,IDMR)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = ITREE
        IDANUW = IDMR
      RETURN
C----------
C  ENTRY MISPUTZ
C----------
      ENTRY MISPUTZ(ITREE,IDMR1)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = ITREE
        IDANUW = IDMR1
      RETURN
C----------
C  ENTRY MISRAN
C----------
      ENTRY MISRAN(IARRAY,ISIZE)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = ISIZE
        IDANUW = IARRAY(1)
      RETURN
C----------
C  ENTRY MISTOE
C----------
      ENTRY MISTOE
      RETURN
C----------
C  ENTRY MSPPPT - PPE -
C----------
      ENTRY MSPPPT (WK3,IPNT,ILIMIT)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        RDANUW = WK3(1)
        IDANUW = IPNT
        IDANUW = ILIMIT
      RETURN
C----------
C  ENTRY MSCHPUT
C----------
      ENTRY MSCHPUT (CBUFF, IPNT, ILIMIT)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        CDANUW(1:1) = CBUFF(1)
        IDANUW = IPNT
        IDANUW = ILIMIT
      RETURN
C----------
C  ENTRY MSPPGT - PPE -
C----------
      ENTRY MSPPGT (WK3,IPNT,ILIMIT)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        RDANUW = WK3(1)
        IDANUW = IPNT
        IDANUW = ILIMIT
      RETURN
C----------
C  ENTRY MSCHGET
C----------
      ENTRY MSCHGET (CBUFF, IPNT, ILIMIT)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        CDANUW(1:1) = CBUFF(1)
        IDANUW = IPNT
        IDANUW = ILIMIT
      RETURN
C----------
C  ENTRY MISACT
C----------
      ENTRY MISACT (NFLAG)
        NFLAG=.FALSE.
      RETURN
C
      END

      REAL FUNCTION MISDGF(ITREE,ISPC)
C----------
C  **MISDGF--MS  Date of last revision:  04/09/91
C----------
C  Purpose:
C     This is a dummy version of the mistletoe infection diameter
C  growth function. It returns MISDGF as 1.0 always (i.e. 100 percent
C  potential diameter growth).
C----------
C
C  Call list definitions:
C     ISPC:   (I) Current tree species.
C     ITREE:  (I) Current tree record number.
C     MISDGF: (O) Returns the 10 year proportion of potential diameter
C                growth due to mistletoe infection.
C
C----------
      MISDGF=1.0
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      IF(.TRUE.)RETURN
      IDANUW = ITREE
      IDANUW = ISPC
      RETURN
C
      END

      REAL FUNCTION MISHGF(ITREE,ISPC)
C----------
C  **MISHGF--MS  Date of last revision:  04/01/11
C----------
C  Purpose:
C     This is a dummy version of the mistletoe infection height
C  growth function. It returns MISHGF as 1.0 always (i.e. 100 percent
C  potential height growth).
C----------
C
C  Call list definitions:
C     ISPC:   (I) Current tree species.
C     ITREE:  (I) Current tree record number.
C     MISHGF: (O) Returns the 10 year proportion of potential height
C                growth due to mistletoe infection.
C
C----------
      MISHGF=1.0
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      IF(.TRUE.)RETURN
      IDANUW = ITREE
      IDANUW = ISPC
      RETURN
C
      END
