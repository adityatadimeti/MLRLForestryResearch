CODE SEGMENT PPLLCM
C----------
C COMMON $Id$
C----------
      INTEGER LKNEX(MXLLSZ),IELEM(MXLLSZ),IFRBEG,IFREND,INULL
      COMMON /PPLLCM/ LKNEX,IELEM,IFRBEG,IFREND,INULL
C
C     LKNEX = LIST OF POINTERS TO LINK LIST
C     IELEM = LIST OF ELEMENTS STORED IN THE LINKED LIST.
C     IFRBEG= POINTER TO THE BEGINNING OF THE FREE SPACE (INITIALLY
C             SET EQUAL TO 1).
C     IFREND= POINTER TO THE END OF THE FREE SPACE (INITIALLY SET
C             EQUAL TO MXLLSZ).
C     INULL = THE VALUE OF A NULL POINTER (ZERO, IN THIS APPLICATION).
C     MXLLSZ= DIMENSION OF LKNEX AND IELEM...DEFINED IN PPEPRM.
C
C-----END SEGMENT
