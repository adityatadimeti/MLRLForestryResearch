      SUBROUTINE ALGKEY (CTOK,LEN,NUM,IRC)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C     CALLED FROM ALGEBRAIC COMPILER, MATCHES KEYWORD IN ISTRNG
C     WITH ONE OF THE KEYWORDS RECOGNIZED BY THE EVENT MONITOR
C     AND TABULATED IN THIS ROUTINE.
C
C     VARIABLES AND THEIR MEANINGS:
C
C     ISTRNG= ONE DIMENSIONAL ARRAY PASSED THAT CONTAINS THE KEYWORD
C     LEN   = THE LENGTH OF THE KEYWORD .
C     NUM   = THE ASSOCIATED NUMBER FOR THE KEYWORD THAT IS RETURNED IF
C             THE KEYWORD HAS BEEN FOUND.
C     IRC   = THE INTERNAL RETURN CODE FOR THE KEYWORD (O IF OK; 1 IF
C             NOT FOUND)
C     CTAB1 - 8 = THE TABLES THAT CONTAIN THE KEYWORDS.
C     IOPT1 - 8 = THE TABLES THAT CONTAIN THE OPCODES.
C
      INTEGER IRC,NUM,LEN,N1,I,N2,N3,N4,N5,N6,N7,N8
      PARAMETER (N1=1,N2=8,N3=26,N4=21,N5=22,N6=41,N7=29,N8=34)
      CHARACTER CTOK*20,CTAB1(N1)*1,CTAB2(N2)*2,CTAB3(N3)*3,CTAB4(N4)*4,
     >          CTAB5(N5)*5,CTAB6(N6)*6,CTAB7(N7)*7,CTAB8(N8)*8
      INTEGER IOPT1(N1),IOPT2(N2),IOPT3(N3),IOPT4(N4),IOPT5(N5),
     >          IOPT6(N6),IOPT7(N7),IOPT8(N8)
C----------
C DEFINITION OF CURRENTLY USED OPTION CODES
C----------
C   OPT
C  CODE  MEANING
C -----  ----------
C     0  blank
C     1  NOT
C     2  AND
C     3  OR
C     4  EQ
C     5  NE
C     6  GT
C     7  GE
C     8  LT
C     9  LE
C
C    22  SQRT
C    23  EXP
C    24  ALOG
C    25  ALOG10
C    26  FRAC
C    27  INT
C    28  SIN
C    29  COS
C    30  TAN
C    31  ARCSIN
C    32  ARCCOS
C    33  ARCTAN
C    34  ABS
C
C GROUP 1 VARIABLES, SET IN PHASE 1 AND ALWAYS KNOWN.
C
C   101  YEAR
C   102  AGE
C   103  BTPA
C   104  BTCUFT
C   105  BMCUFT
C   106  BBDFT
C   107  BBA
C   108  BCCF
C   109  BTOPHT
C   110  BADBH
C   111  YES
C                    THIS WORKS SINCE BOTH THE VARIABLE
C   112  NO   <----- NO AND THE WORD ALL EQUATE TO A 
C   112  ALL  <----- CONTANT EQUAL TO 0
C
C   113  CYCLE
C   114  NUMTREES
C   115  BSDIMAX
C   116  BSDI
C   117  BRDEN
C   118  BRDEN2
C
C   126  HABTYPE
C   127  SLOPE
C   128  ASPECT
C   129  ELEV
C   130  SAMPWT
C   131  INVYEAR
C   132  CENDYEAR
C   133  EVPHASE
C   134  SMR
C   135  SITE
C   136  CUT
C   137  LAT
C   138  LONG
C   139  STATE
C   140  COUNTY
C   141  FORTYP
C   142  SIZCLS
C   143  STKCLS
C   144  PROPSTK
C   145  MAI
C   146  AGECMP
C   147  BDBHWTBA
C   148  SILVAHFT
C   149  R5 FISHER HABITAT SUITABILITY INDEX
C   150  BSDI2
C
C GROUP 2 VARIABLES, SET IN PHASE 2, AFTER THINNING.
C
C   201  ATPA
C   202  ATCUFT
C   203  AMCUFT
C   204  ABDFT
C   205  ABA
C   206  ACCF
C   207  ATOPHT
C   208  AADBH
C   209  RTPA
C   210  RTCUFT
C   211  RMCUFT
C   212  RBDFT
C   213  ASDIMAX
C   214  ASDI
C   215  ARDEN
C   216  ADBHWTBA
C   217  ARDEN2
C   218  ASDI2
C
C GROUP 3 VARIABLES, THOSE KNOWN AFTER CYCLE 1.
C
C   301  ACC
C   302  MORT
C   303  PAI
C                vacant  spot  
C   305  DTPA
C   306  DTPA%
C   307  DBA
C   308  DBA%
C   309  DCCF
C   310  DCCF%
C   311  ORG%CC
C   312  ORGAHT
C
C
C GROUP 4 VARIABLES, THOSE KNOWN WHEN THE SETTING ROUTINE SAYS SO, 
C         AND NOT KNOWN THE REST OF THE TIME.
C
C   401  TM%STND
C   402  TM%DF
C   403  TM%GF
C   404  MPBTPAK
C   405  BW%STND
C   406  MPBPROB
C   407  vacant
C   408  vacant
C   409  vacant
C   410  vacant
C   411  vacant
C   412  vacant
C   413  vacant
C   414  vacant
C   415  vacant
C   416  BSCLASS
C   417  ASCLASS
C   418  BSTRDBH
C   419  ASTRDBH
C   420  FIRE
C   421  MINSOIL
C   422  CROWNIDX
C   423  FIREYEAR
C   424  BCANCOV
C   425  ACANCOV
C   426  CRBASEHT
C   427  TORCHIDX
C   428  CRBULKDN
C                    vacant spot?
C   430  DISCCOST
C   431  DISCREVN
C   432  FORSTVAL
C   433  HARVCOST
C   434  HARVREVN
C   435  IRR
C   436  PCTCOST
C   437  PNV
C   438  RPRODVAL
C   439  SEV
C   440  BMAXHS
C   441  AMAXHS
C   442  BMINHS
C   443  AMINHS
C   444  BNUMSS
C   445  ANUMSS
C   446  DISCRATE
C   447  UNDISCST
C   448  UNDISRVN
C   449  ECCUFT
C   450  ECBDFT
C
C   900  RANN
C
C  7001  AVBTPA
C  7002  AVBTCUFT
C  7003  AVBMCUFT
C  7004  AVBBDFT
C  7005  AVBBA
C  7006  AVACC
C  7007  AVMORT
C  7008  TOTALWT
C  7009  OLDTARG
C  7010  MSPERIOD
C
C 10100  MOD
C 10200  DECADE
C 10300  TIME
C 10400  SUMSTAT
C 10500  DBHDIST
C 10600  SPMCDBH
C 10700  PARMS
C 10800  LININT
C 10900  MIN
C 11000  MAX
C 11100  BOUND
C 11200  BCCFSP
C 11300  ACCFSP
C 11400  MININDEX
C 11500  MAXINDEX
C 11600  NORMAL
C 11700  FUELLOAD
C 11800  SNAGS
C 11900  POTFLEN
C 12000  INDEX
C 12100  POTFMORT
C 12200  FUELMODS
C 12300  SALVVOL
C 12400  POINTID
C 12500  STRSTAT
C 12600  POTFTYPE
C 12700  POTSRATE
C 12800  POTREINT
C 12900  TREEBIO
C 13000  CARBSTAT
C 13100  HTDIST
C 13200  HERBSHRB
C 13300  DWDVAL
C 13400  ACORNS
C 13500  CLSPVIAB
C----------
C
C     DEFINE THE TABLES OF KEYWORDS AND NUMS IN DATA STATEMENTS
C
C     NOTE: CURRENTLY, THERE ARE NO 1 CHAR TOKENS.
C
      DATA CTAB1 /' '/
     >     IOPT1 /  0/
C
      DATA CTAB2 /'GT','GE','LT','LE','EQ','NE','OR','NO'/,
     >     IOPT2 /006,007,008,009,004,005,003,112/
C
      DATA CTAB3 /'AGE','BBA','ABA','ACC','PAI','MAI',
     >            'DBA','AND','NOT','YES','EXP','INT',
     >            'SIN','COS','TAN','MOD','SMR','CUT',
     >            'MIN','MAX','ABS','ALL','LAT','IRR',
     >            'PNV','SEV'/
     >     IOPT3 /102,107,205,301,303,145,307,002,001,111,023,027,
     >            028,029,030,10100,134,136,10900,11000,034,112,137,
     >            435,437,439/
C
      DATA CTAB4 /'YEAR','BTPA','BCCF','ATPA','RTPA','MORT',
     >            'DTPA','DBA%','DCCF','ACCF','RANN','SQRT',
     >            'ALOG','FRAC','TIME','ELEV','SITE','BSDI',
     >            'ASDI','FIRE','LONG'/,
     >     IOPT4 /101,103,108,201,209,302,305,308,309,206,900,022,
     >            024,026,10300,129,135,116,214,420,138/
C
      DATA CTAB5 /'BBDFT','BADBH','ABDFT','AADBH','RBDFT','DTPA%',
     >            'DCCF%','TM%DF','TM%GF','CYCLE','SLOPE','AVACC',
     >            'PARMS','BOUND','AVBBA','SNAGS','STATE',
     >            'INDEX','BRDEN','ARDEN','ASDI2','BSDI2'/,
     >     IOPT5 /106,110,204,208,212,306,310,402,403,113,127,7006,
     >            10700,11100,7005,11800,139,12000,117,215,218,150/
C
      DATA CTAB6 /'BTCUFT','BMCUFT','BTOPHT','ATCUFT','AMCUFT','ATOPHT',
     >            'RTCUFT','RMCUFT','ALOG10','ARCSIN','ARCCOS','ARCTAN',
     >            'DECADE','ASPECT','SAMPWT','AVBTPA','AVMORT',
     >            'LININT','BCCFSP','ACCFSP','NORMAL','COUNTY','FORTYP',
     >            'SIZCLS','STKCLS','BMAXHS','AMAXHS','BMINHS','AMINHS',
     >            'BNUMSS','ANUMSS','AGECMP','BRDEN2','ARDEN2','HTDIST',
     >            'DWDVAL','ECCUFT','ECBDFT','ACORNS','ORG%CC','ORGAHT'
     >            /,
     >     IOPT6 /104,105,109,202,203,207,210,211,25,31,32,33,10200,
     >            128,130,7001,7007,10800,11200,11300,11600,140,
     >            141,142,143,440,441,442,443,444,445,146,118,217,
     >            13100,13300,449,450,13400,311,312/
C
      DATA CTAB7 /'TM%STND','MPBTPAK','BW%STND','SUMSTAT','HABTYPE',
     >            'INVYEAR','TOTALWT','AVBBDFT','DBHDIST',
     >            'SPMCDBH','EVPHASE','MPBPROB','OLDTARG',
     >            'BSDIMAX','ASDIMAX','BSCLASS','ASCLASS','BSTRDBH',
     >            'ASTRDBH','MINSOIL','BCANCOV','ACANCOV','POTFLEN',
     >            'PCTCOST','PROPSTK','SALVVOL','POINTID','STRSTAT',
     >            'TREEBIO'/,
     >     IOPT7 /401,404,405,10400,126,131,7008,7004,10500,
     >            10600,133,406,7009,115,213,416,417,418,
     >            419,421,424,425,11900,436,144,12300,12400,12500,
     >            12900/
C
      DATA CTAB8 /'NUMTREES',
     >            'AVBTCUFT','AVBMCUFT','MSPERIOD','CENDYEAR',
     >            'MININDEX','MAXINDEX','FUELLOAD','FIREYEAR',
     >            'CROWNIDX','CRBASEHT','TORCHIDX','CRBULKDN',
     >            'DISCCOST','DISCREVN','FORSTVAL','HARVCOST',
     >            'HARVREVN','RPRODVAL','POTFMORT','FUELMODS',
     >            'DISCRATE','UNDISCST','UNDISRVN','BDBHWTBA',
     >            'ADBHWTBA','POTFTYPE','POTSRATE','POTREINT',
     >            'CARBSTAT','SILVAHFT','FISHERIN','HERBSHRB',
     >            'CLSPVIAB'/,
     >     IOPT8 /114,7002,7003,7010,132,11400,11500,
     >            11700,423,422,426,427,428,430,431,432,433,434,
     >            438,12100,12200,446,447,448,147,216,12600,12700,12800,
     >            13000,148,149,13200,13500/
C
      NUM=0
C
C     DECIDE WHICH TABLE TO LOOK IN FOR THE ISTRNG KEYWORD
C
      IF (LEN.GE.1.AND.LEN.LE.20) GOTO 5
      IRC=1
      RETURN
    5 CONTINUE
C
      GO TO (100,200,300,400,500,600,700,800,950),MIN(LEN,20)
  100 CONTINUE
C
C     THE CTAB1 TABLE IS CHECKED.
C
      DO 150 I=1,N1
      IF (CTOK.NE.CTAB1(I)) GOTO 150
      NUM=IOPT1(I)
      GOTO 1000
  150 CONTINUE
      GOTO 950
  200 CONTINUE
C
C     THE CTAB2 TABLE IS CHECKED.
C
      DO 250 I=1,N2
      IF (CTOK.NE.CTAB2(I)) GOTO 250
      NUM=IOPT2(I)
      GOTO 1000
  250 CONTINUE
      GOTO 950
  300 CONTINUE
C
C     THE CTAB3 TABLE IS CHECKED.
C
      DO 350 I=1,N3
      IF (CTOK.NE.CTAB3(I)) GOTO 350
      NUM=IOPT3(I)
      GOTO 1000
  350 CONTINUE
      GOTO 950
  400 CONTINUE
C
C     THE CTAB4 TABLE IS CHECKED.
C
      DO 450 I=1,N4
      IF (CTOK.NE.CTAB4(I)) GOTO 450
      NUM=IOPT4(I)
      GOTO 1000
  450 CONTINUE
      GOTO 950
  500 CONTINUE
C
C     THE CTAB5 TABLE IS CHECKED.
C
      DO 550 I=1,N5
      IF (CTOK.NE.CTAB5(I)) GOTO 550
      NUM=IOPT5(I)
      GOTO 1000
  550 CONTINUE
      GOTO 950
  600 CONTINUE
C
C     THE CTAB6 TABLE IS CHECKED.
C
      DO 650 I=1,N6
      IF (CTOK.NE.CTAB6(I)) GOTO 650
      NUM=IOPT6(I)
      GOTO 1000
  650 CONTINUE
      GOTO 950
  700 CONTINUE
C
C     THE CTAB7 TABLE IS CHECKED.
C
      DO 750 I=1,N7
      IF (CTOK.NE.CTAB7(I)) GOTO 750
      NUM=IOPT7(I)
      GOTO 1000
  750 CONTINUE
      GOTO 950
  800 CONTINUE
C
C     THE CTAB8 TABLE IS CHECKED.
C
      DO 850 I=1,N8
      IF (CTOK.NE.CTAB8(I)) GOTO 850
      NUM=IOPT8(I)
      GOTO 1000
  850 CONTINUE
  950 CONTINUE
C
C     CHECK SPECIES CODES.
C
      CALL ALGSPP (CTOK,LEN,NUM,IRC)
      IF (IRC.EQ.0) GOTO 1000
C
C     CHECK POINT GROUP NAMES
C
      CALL ALGPTG (CTOK,LEN,NUM,IRC)
      IF (IRC.EQ.0) GOTO 1000
C
C     CHECK USER DEFINED VARIABLE TABLES.
C
      CALL EVKEY (CTOK(1:8),NUM,IRC)
      IF (IRC.EQ.0) GOTO 1000
      IRC=1
      RETURN
 1000 CONTINUE
      IRC=0
      RETURN
      END
