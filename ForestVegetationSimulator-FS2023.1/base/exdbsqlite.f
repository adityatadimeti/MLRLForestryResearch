      SUBROUTINE EXDBSQLITE
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C  EXTERNAL REFERENCES FOR THE Q-FAMILY DATA BASE CONNECTION CODE.
C----------
      REAL TPA1,BA1,CFVOL,BFVOL,STDIST1,STDIST2,STDIST3,STDIST4
      REAL STDIST5,STDIST6,STDIST7,STDIST8,STDIST9
      REAL INGROW,TPAIN,TPASUM,HTAVE,TPATOT,PRBSTK,SUMTPA,SUMPCT,
     &     PASPCT,BESTTPA,BESTPCT,AVEHT,PASTPA
      REAL WINDSP,MOIST1,MOIST2,MOIST3,MOIST4,MOIST5,MOIST6,MOIST7
      INTEGER BURNYEAR, NUMPTS,M,NOYEAR,MECHYEAR,PCTBURN,WTHTAVE,TOT,
     &     NTALLY,IYEAR,PCTNONE,PCTMECH,TBL
      INTEGER KODE,TEMP
      CHARACTER*47 HABTYP
      CHARACTER*7 SERIES
      CHARACTER*2 SPECCD
      REAL RDANUW
      INTEGER IDANUW
      CHARACTER*1 CDANUW
      CHARACTER*16 LABEL
C----------
C  ENTRY DBSSTATS
C----------
      ENTRY  DBSSTATS(SPECCD,TPA1,BA1,CFVOL,BFVOL,STDIST1,
     & STDIST2,STDIST3,STDIST4,STDIST5,STDIST6,STDIST7,STDIST8,
     & STDIST9,LABEL,TBL,IYEAR)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        CDANUW = SPECCD(1:1)
        RDANUW = TPA1
        RDANUW = BA1
        RDANUW = CFVOL
        RDANUW = BFVOL
        RDANUW = STDIST1
        RDANUW = STDIST2
        RDANUW = STDIST3
        RDANUW = STDIST4
        RDANUW = STDIST5
        RDANUW = STDIST6
        RDANUW = STDIST7
        RDANUW = STDIST8
        RDANUW = STDIST9
        CDANUW = LABEL(1:1)
        IDANUW = TBL
        IDANUW = IYEAR
      RETURN
C----------
C  ENTRY DBSSPRT
C----------
      ENTRY  DBSSPRT(SPECCD,TPASUM,HTAVE,TPATOT,
     &  WTHTAVE,TOT,IYEAR)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        CDANUW = SPECCD(1:1)
        RDANUW = TPASUM
        RDANUW = HTAVE
        RDANUW = TPATOT
        RDANUW = WTHTAVE
        IDANUW = TOT
        IDANUW = IYEAR
      RETURN
C----------
C  ENTRY DBSSITEPREP
C----------
      ENTRY  DBSSITEPREP(NOYEAR,MECHYEAR,BURNYEAR,PCTNONE,
     & PCTMECH,PCTBURN)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IDANUW = NOYEAR
        IDANUW = MECHYEAR
        IDANUW = BURNYEAR
        IDANUW = PCTNONE
        IDANUW = PCTMECH
        IDANUW = PCTBURN
      RETURN
C----------
C  ENTRY DBSPLOTHAB
C----------
      ENTRY  DBSPLOTHAB(NUMPTS,HABTYP,SERIES,M)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IDANUW = NUMPTS
        CDANUW = HABTYP(1:1)
        CDANUW = SERIES(1:1)
        IDANUW = M
      RETURN
C----------
C  ENTRY DBSTALLY
C----------
      ENTRY  DBSTALLY(PRBSTK,NTALLY,SPECCD,SUMTPA,SUMPCT,BESTTPA,
     & BESTPCT,AVEHT,PASTPA,PASPCT,IYEAR)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        RDANUW = PRBSTK
        IDANUW = NTALLY
        CDANUW = SPECCD(1:1)
        RDANUW = SUMTPA
        RDANUW = SUMPCT
        RDANUW = BESTTPA
        RDANUW = BESTPCT
        RDANUW = AVEHT
        RDANUW = PASTPA
        RDANUW = PASPCT
        IDANUW = IYEAR
      RETURN
C----------
C  ENTRY DBSINGROW
C----------
      ENTRY  DBSINGROW(IYEAR,INGROW,SPECCD,TPAIN)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IDANUW = IYEAR
        RDANUW = INGROW
        CDANUW = SPECCD(1:1)
        RDANUW = TPAIN
      RETURN
C
      ENTRY  DBSFMPFC(WINDSP,TEMP,MOIST1,MOIST2,MOIST3,MOIST4,MOIST5,
     &           MOIST6,MOIST7,KODE)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        RDANUW = WINDSP
        IDANUW = TEMP
        RDANUW = MOIST1
        RDANUW = MOIST2
        RDANUW = MOIST3
        RDANUW = MOIST4
        RDANUW = MOIST5
        RDANUW = MOIST6
        RDANUW = MOIST7
        IDANUW = KODE
      RETURN
C
      END

