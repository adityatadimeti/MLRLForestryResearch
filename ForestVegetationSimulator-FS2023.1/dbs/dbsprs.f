      SUBROUTINE DBSPRS(TOKEN,SOURCE,DELIMSTR)
      IMPLICIT NONE
C
C DBS $Id$
C
C     PURPOSE: TO SIMPLY RETURN THE FIRST TOKEN FROM THE SOURCE PASSED
C     IN USING THE DELIMSTR AS THE DELIMITER
C
C     THE ROUTINE ALSO CHANGES SOURCE, SO THAT SUBSEQUENT CALLS SKIP
C     THE TOKEN.
C
C     OUTPUT: TOKEN    - THE TOKENIZED VALUE
C             SOURCE   - THE SOURCE STRING WHICH IS TOKENIZED
C             DELIMSTR - THE DELIMITER THAT THE STRING IS TOKENIZED ON
C

      CHARACTER(LEN=*) SOURCE,TOKEN,DELIMSTR
      CHARACTER*1000 SAVESTR
      INTEGER ISTART,ILEN,IDLEN,IBEGPOS,IENDPOS

      TOKEN=' '
      ISTART = 1
      SAVESTR = SOURCE

      IBEGPOS = ISTART
      ILEN = LEN(SAVESTR)
      IDLEN = LEN(DELIMSTR)
5     CONTINUE
      IF (IBEGPOS .LT. ILEN) THEN
        IF (INDEX(DELIMSTR,SAVESTR(IBEGPOS:IBEGPOS+IDLEN-1)).NE.0) THEN
          IBEGPOS = IBEGPOS + 1
          GOTO 5
        ENDIF
      ENDIF
      IENDPOS = IBEGPOS
10    CONTINUE
      IF ((IENDPOS .LE. ILEN)) THEN
        IF (INDEX(DELIMSTR,SAVESTR(IENDPOS:IENDPOS+IDLEN-1)).EQ.0) THEN
          IENDPOS = IENDPOS + 1
          GOTO 10
        ENDIF
      ENDIF
      TOKEN = SAVESTR(IBEGPOS:IENDPOS-1)
      SOURCE = SAVESTR(IENDPOS+IDLEN:)
      ISTART = IENDPOS

      END
