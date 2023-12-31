CODE SEGMENT MPBCOM
C----------
C LPMPB $Id$
C----------
C
C Revision History
C   06/05/00 Last noted revision date.
C   07/02/10 Lance R. David (FMSC)
C     Declared variables for Addition of IMPLICIT NONE to subroutines.
C   08/22/14 Lance R. David (FMSC)
C     Function name was used as variable name.
C     changed variable INT to INCRS
C----------
      INTEGER IBACK, IBOUSE, IDXDF, IDXLP, IDXPP, IDXWL, IDXWP, ILP,
     &        IMPROB, INCRS, IPLTNO, IPT(MAXTRE), ISTDT, JOMPB, JOMPBX,
     &        KEYMPB(9), MPBON, MPBSPM(MAXSP), MPBYR, MPISC(30,2),
     &        MPMXYR, MPRBMT, NACLAS, NATR, NCLASS, NDAMS, NEPIYR,
     &        NG, NPGR, NPYR

      REAL A45DBH, ACTSRF(30), AGGPH(30), AMP1, AMP2, BALPP, BANEW,
     &     BAOLD, BETTER(8), CE, CF1, CF2, CF3, CLASS(30,6), CNTLP,
     &     CRITAD, DCPF(30), DCPK(30), DST(3), EFELEV, EFLAT,
     &     EFPHLM(30), EPIPRB, EXCON, FORLAT, HS, PBALPP, PCTCO, PGR,
     &     PRBMPB(40), PRBSCL, PSDL(30), PSPF(30), PSPK(30), PWR,
     &     REPL(30), SADLPP, SNOHST, STRBUG, STRP, SURF(30),
     &     SURVIV(30), TAFAC, TAMAX, TAMID, TAMIN, TATOL, TLP45,
     &     XPT(MAXTRE)

      LOGICAL DEBUIN, LAGG, LBET, LCRES, LDC, LEPI, LINVMR, LMPB1,
     &        LPOPDY, LPS, LRANST, LREP, LSADLP, LXNOTE, MPBGRF,
     &        SAVGRF, WORKIN(40)

      COMMON / MPBCOM / A45DBH, ACTSRF, AGGPH, AMP1, AMP2, BALPP,
     &       BANEW, BAOLD, BETTER, CE, CF1, CF2, CF3, CLASS, CNTLP,
     &       CRITAD, DCPF, DCPK, DEBUIN, DST, EFELEV, EFLAT, EFPHLM,
     &       EPIPRB, EXCON, FORLAT, HS, IBACK, IBOUSE, IDXDF, IDXLP,
     &       IDXPP, IDXWL, IDXWP, ILP, IMPROB, INCRS, IPLTNO, IPT,
     &       ISTDT, JOMPB, JOMPBX, KEYMPB, LAGG, LBET, LCRES, LDC,
     &       LEPI, LINVMR, LMPB1, LPOPDY, LPS, LRANST, LREP, LSADLP,
     &       LXNOTE, MPBGRF, MPBON, MPBSPM, MPBYR, MPISC, MPMXYR,
     &       MPRBMT, NACLAS, NATR, NCLASS, NDAMS, NEPIYR, NG, NPGR,
     &       NPYR, PBALPP, PCTCO, PGR, PRBMPB, PRBSCL, PSDL, PSPF,
     &       PSPK, PWR, REPL, SADLPP, SAVGRF, SNOHST, STRBUG, STRP,
     &       SURF, SURVIV, TAFAC, TAMAX, TAMID, TAMIN, TATOL, TLP45,
     &       WORKIN, XPT
C
C-----END SEGMENT
