      SUBROUTINE EXFERT
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     EXTRA EXTERNAL REFERENCES FOR FERTILIZER CALLS
C----------
      LOGICAL LNOTBK(7),LKECHO
      REAL ARRAY(7)
      INTEGER IRECNT,JOSTND
      CHARACTER*8 KEYWRD
      CHARACTER*10 KARD(7)
      REAL RDANUW
      INTEGER IDANUW
      CHARACTER*1 CDANUW
      LOGICAL LDANUW
C----------
C ENTRY FFIN
C----------
      ENTRY FFIN (JOSTND,IRECNT,KEYWRD,ARRAY,LNOTBK,KARD,LKECHO)
        CALL ERRGRO (.TRUE.,11)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = JOSTND
        IDANUW = IRECNT
        CDANUW = KEYWRD(1:1)
        RDANUW = ARRAY(1)
        LDANUW = LNOTBK(1)
        CDANUW = KARD(1)(1:1)
        LDANUW = LKECHO
      RETURN
C----------
C ENTRY FFIN
C----------
      ENTRY FFERT
      RETURN
C
      END
