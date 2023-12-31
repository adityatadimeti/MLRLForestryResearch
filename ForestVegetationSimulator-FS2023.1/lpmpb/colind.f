      SUBROUTINE COLIND (DBH,INDEX)
      IMPLICIT NONE
C----------
C LPMPB $Id$
C----------
C
C     PART OF THE MOUNTAIN PINE BEETLE EXTENSION OF PROGNOSIS.
C     P.W. THOMAS -- FORESTRY SCIENCES LAB -- MOSCOW
C
C     THIS ROUTINE ASSIGNS A SIZE CLASS BETWEEN ONE AND TEN
C     TO A TREE DIAMETER BETWEEN 1.0 INCHES AND 20.0 INCHES.
C     IF THE TREE'S DBH IS LESS THAN 1.0 INCHES, THE TREE IS
C     ASSIGNED TO SIZE CLASS ONE.  IF THE TREES DBH IS GREATER
C     THAN 20.0 INCHES, THEN THE TREE IS ASSIGNED TO SIZE CLASS
C     TEN.
C
C     PARAMETERS:
C
C        DBH - FOUR BYTE REAL DBH OF TREE.
C        INDEX - FOUR BYTE INTEGER SIZE CLASS.
C
C Revision History
C   02/08/88 Last noted revision date.
C   07/02/10 Lance R. David (FMSC)
C     Added IMPLICIT NONE.
C----------
C
      INTEGER IVAL,INDEX
      REAL DBH

      IVAL=IFIX(DBH)
      INDEX=IVAL/2+MOD(IVAL,2)
C
C     TAKE INTO ACCOUNT EXTREME VALUES LESS THAN 1 OR
C     GREATER THAN 20 INCHES.
C
      IF (INDEX.GT.10) INDEX=10
      IF (INDEX.LT.1) INDEX=1
      RETURN
      END
