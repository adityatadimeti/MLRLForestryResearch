      SUBROUTINE FMVINIT
      IMPLICIT NONE
C----------
C FIRE-AK $Id$
C----------
*  Purpose:
*      Initialize variant-specific variables for the Fire Model
*
*
*  Called from: INITRE
*
*  Call list definitions:
*
*  Local variable definitions:
*
***********************************************************************
COMMONS

      INCLUDE 'PRGPRM.F77'
      INCLUDE 'FMPARM.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'FMCOM.F77'
      INCLUDE 'FMFCOM.F77'

COMMONS

      INTEGER I,J

      LVWEST    = .TRUE.  ! WESTERN VARIANT

      CANCLS(1) =  5.0
      CANCLS(2) = 17.5
      CANCLS(3) = 37.5
      CANCLS(4) = 75.0

      CORFAC(1) =  0.5
      CORFAC(2) =  0.3
      CORFAC(3) =  0.2
      CORFAC(4) =  0.1

      SNPRCL(1) =  0
      SNPRCL(2) = 12
      SNPRCL(3) = 18
      SNPRCL(4) = 24
      SNPRCL(5) = 30
      SNPRCL(6) = 36

      LOWDBH(1) =  0.0
      LOWDBH(2) =  5.0
      LOWDBH(3) = 10.0
      LOWDBH(4) = 20.0
      LOWDBH(5) = 30.0
      LOWDBH(6) = 40.0
      LOWDBH(7) = 50.0
C----------
C  SET POTENTIAL FIRE TEMPERATURES AND WINDSPEEDS
C----------
      PREWND(1) = 20.0
      PREWND(2) =  6.0
      POTEMP(1) = 70.0
      POTEMP(2) = 70.0

C     DECAY RATES BASED ON PN DECAY INFO SENT BY KIM MELLEN IN R6,
C     ASSUMING COLD/WET PN HABITAT TYPE.

      DKR(1,1) = 0.052 ! < 0.25"
      DKR(2,1) = 0.052 ! 0.25 - 1"
      DKR(3,1) = 0.052 ! 1 - 3"
      DKR(4,1) = 0.012 ! 3 - 6"
      DKR(5,1) = 0.012 ! 6 - 12"
      DKR(6,1) = 0.009 ! 12 - 20"
      DKR(7,1) = 0.009 ! 20 - 35"
      DKR(8,1) = 0.009 ! 35 - 50"
      DKR(9,1) = 0.009 ! > 50"
      DKR(10,1) = 0.35  ! litter
      DKR(11,1) = 0.002 ! duff

      DKR(1,2) = 0.061 ! < 0.25"
      DKR(2,2) = 0.061 ! 0.25 - 1"
      DKR(3,2) = 0.061 ! 1 - 3"
      DKR(4,2) = 0.025 ! 3 - 6"
      DKR(5,2) = 0.025 ! 6 - 12"
      DKR(6,2) = 0.018 ! 12 - 20"
      DKR(7,2) = 0.018 ! 20 - 35"
      DKR(8,2) = 0.018 ! 35 - 50"
      DKR(9,2) = 0.018 ! > 50"
      DKR(10,2) = 0.4   ! litter
      DKR(11,2) = 0.002 ! duff

      DKR(1,3) = 0.073 ! < 0.25"
      DKR(2,3) = 0.073 ! 0.25 - 1"
      DKR(3,3) = 0.073 ! 1 - 3"
      DKR(4,3) = 0.041 ! 3 - 6"
      DKR(5,3) = 0.041 ! 6 - 12"
      DKR(6,3) = 0.031 ! 12 - 20"
      DKR(7,3) = 0.031 ! 20 - 35"
      DKR(8,3) = 0.031 ! 35 - 50"
      DKR(9,3) = 0.031 ! > 50"
      DKR(10,3) = 0.45  ! litter
      DKR(11,3) = 0.003 ! duff

      DKR(1,4) = 0.098 ! < 0.25"
      DKR(2,4) = 0.098 ! 0.25 - 1"
      DKR(3,4) = 0.098 ! 1 - 3"
      DKR(4,4) = 0.077 ! 3 - 6"
      DKR(5,4) = 0.077 ! 6 - 12"
      DKR(6,4) = 0.058 ! 12 - 20"
      DKR(7,4) = 0.058 ! 20 - 35"
      DKR(8,4) = 0.058 ! 35 - 50"
      DKR(9,4) = 0.058 ! > 50"
      DKR(10,4) = 0.5   ! litter
      DKR(11,4) = 0.003 ! duff

C     Duff production rates 'PRDUFF' are a proportion of the overall
C     decay rate: 'DKR'.

      DO I = 1,MXFLCL
        DO J = 1,4
          PRDUFF(I,J) = 0.02
          TODUFF(I,J) = DKR(I,J) * PRDUFF(I,J)
        ENDDO
      ENDDO

C     SET ALL THE SNAG PARAMETERS HERE (THOSE WHICH ARE UNDER USER CONTROL).
C     ALSO SET LIMBRK.  NZERO COULD BE UNDER USER-CONTROL ONE DAY.

      NZERO  =  0.01
      LIMBRK =  0.01
      HTXSFT =  2.0
      DO I= 1,MAXSP
        PSOFT(I)  =  0.0
      ENDDO

C     HTR1 and HTR2 are set below, and used for most species (where htx = 1)
C     for cedar, htx = 0, so no snag height loss is modelled.
C     2% a year height loss is based on Hennon and Loopstra (1991) who found that
C     WH snags (ave dbh 23") were 30 ft or shorter after 38 years.

      HTR1   =  0.02
      HTR2   =  0.02

C     ** SPECIES-LEVEL VARIABLE ASSIGNMENT **

C     V2T() - UNITS ARE LB/CUFT BY SPECIES - FROM THE
C      'WOOD HANDBOOK' USDA FOREST PRODUCTS LAB. 1999.  FPL-GTR-113.

C     [TO CONVERT G/CM**3 TO LB/FT**3, MULTIPLY 'X' G/CM**3 * 62.372]

C     LEAFLF() - LIFETIME (YRS) OF LEAVES/NEEDLES

C     TFALL() - TIME TO FALL FOR DEAD CROWN COMPONENTS. THIS VARIABLE
C     IS NOT UNDER USER-CONTROL BUT MIGHT BE SOMEDAY.
C     TFALL INDEXING USES CROWNW() DIMENSIONS, I.E.

C     0 :  FOLIAGE
C     1 : <0.25"
C     2 :  0.25" -   1"
C     3 :  1"    -   3"
C     4 :  3"    -   6"
C     5 :  6"    -  12"

C     IF THE VALUE OF TFALL(I,-) IS LARGER THAN 20, PARAMETER TFMAX IN
C     **FMPARM.F77** MUST BE ADJUSTED TO EQUAL THE NEW VALUE, AND LOOPS
C     INVOLVING THE VALUE (SEE FMSCRO) MUST BE RE-EXAMINED TO INSURE
C     THAT THEY BEHAVE PROPERLY.

C     ALLDWN() - YEARS DEAD AT WHICH ALL SNAGS WILL BE FALLEN (NOT USED IN AK-FFE)
C     DECAYX() - DECAY RATE MULTIPLIER
C     FALLX()  - FALL RATE MULTIPLIER
C     HTX()    - HEIGHT-LOSS RATE MULTIPLIER

C     DKRCLS() - DECAY RATE CLASS 1 (V.SLOW) TO 4 (FAST). MODEL USERS
C     CAN USE THE FUELDCAY KEYWORD TO REASSIGN RATES WITHIN THE 4
C     CLASSES, AND THE FUELPOOL KEYWORD TO REASSIGN CLASS
C
C     ORIGINAL MEMBERS OF GROUPS PRIOR TO AK 23-SPECIES EXPANSION IS
C     IS MARKED WITH (ORIGINAL) IN THE FOLLOWING 2 CASE STATMENTS.
C
      DO I = 1,MAXSP

         SELECT CASE (I)

C         pacific silver fir (ORIGINAL)
          CASE (1)
            V2T(I)     = 24.9
            LEAFLF(I)  = 7.0
            ALLDWN(I)  = 30.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 3
            LSW(I)     = .TRUE.

C         subalpine fir (ORIGINAL)
          CASE (2)
            V2T(I)     = 19.3
            LEAFLF(I)  = 7.0
            ALLDWN(I)  = 90.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 3
            LSW(I)     = .TRUE.

C         Alaska-cedar (ORIGINAL)
          CASE (3)
            V2T(I)     =  26.2
            LEAFLF(I)  =  5.0
            ALLDWN(I)  =  300.0
            DECAYX(I)  =  1.0
            FALLX(I)   =  1.0
            DO J= 1,4
              HTX(I,J) =  0.0
            ENDDO
            DKRCLS(I)  =  1
            LSW(I)     =  .TRUE.

C         tamarack (subalpine larch in PN)
          CASE (4)
            V2T(I)     =  29.9
            LEAFLF(I)  =  1.0
            ALLDWN(I)  =  150.0 
            DECAYX(I)  =  1.0
            FALLX(I)   =  1.0
            DO J= 1,4
              HTX(I,J) =  1.0
            ENDDO
            DKRCLS(I)  =  1
            LSW(I)     =  .TRUE.

C         white spruce (ORIGINAL)
C         Lutz's spruce
C         black spruce 
C         other softwoods (ORIGINAL)
          CASE (5,6,7,13)
            V2T(I)     =  23.1
            LEAFLF(I)  =  6.0
            ALLDWN(I)  =  90.0 !pn engelmann spruce
            DECAYX(I)  =  1.0
            FALLX(I)   =  1.0
            DO J= 1,4
              HTX(I,J) =  1.0
            ENDDO
            DKRCLS(I)  =  2
            LSW(I)     =  .TRUE.
            
C         sitka spruce (ORIGINAL)
          CASE (8)
            V2T(I)     = 20.6
            LEAFLF(I)  = 5.0
            ALLDWN(I)  = 110.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 2
            LSW(I)     = .TRUE.

C         lodgepole pine (ORIGINAL)
          CASE (9)
            V2T(I)     = 23.7
            LEAFLF(I)  = 3.0
            ALLDWN(I)  = 90.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 2
            LSW(I)     = .TRUE.

C         western redcedar (ORIGINAL)
          CASE (10)
            V2T(I)     =  19.3
            LEAFLF(I)  =  5.0
            ALLDWN(I)  =  300.0
            DECAYX(I)  =  1.0
            FALLX(I)   =  1.0
            DO J= 1,4
              HTX(I,J) =  0.0
            ENDDO
            DKRCLS(I)  =  1
            LSW(I)     =  .TRUE.

C         western hemlock (ORIGINAL)
          CASE (11)
            V2T(I)     =  26.2
            LEAFLF(I)  =  5.0
            ALLDWN(I)  =  100.0
            DECAYX(I)  =  1.0
            FALLX(I)   =  1.0
            DO J= 1,4
              HTX(I,J) =  1.0
            ENDDO
            DKRCLS(I)  =  2
            LSW(I)     =  .TRUE.

C         mountain hemlock (ORIGINAL)
          CASE (12)
            V2T(I)     = 26.2
            LEAFLF(I)  = 4.0
            ALLDWN(I)  = 90.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 2
            LSW(I)     = .TRUE.

C         alder species 
C         red alder (ORIGINAL)
          CASE (14,15)
            V2T(I)     = 23.1
            LEAFLF(I)  = 1.0
            ALLDWN(I)  = 50.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 4
            LSW(I)     = .FALSE.

C         paper birch (paper birch in PN)
C         Alaska birch 
          CASE (16,17)
            V2T(I)     = 29.9
            LEAFLF(I)  = 1.0
            ALLDWN(I)  = 50.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 4
            LSW(I)     = .FALSE.
            
C         balsam poplar
C         black cottonwood (ORIGINAL)
C         other hardwoods (ORIGINAL)
          CASE (18,20,23)
            V2T(I)     = 19.3
            LEAFLF(I)  = 1.0
            ALLDWN(I)  = 50.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 4
            LSW(I)     = .FALSE.

C         quaking aspen (quaking aspen in PN) 
          CASE (19)
            V2T(I)     = 21.8
            LEAFLF(I)  = 1.0
            ALLDWN(I)  = 50.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 4
            LSW(I)     = .FALSE.
            
C         willow species (willow in PN)
C         Scouler's willow 
          CASE (21,22)
            V2T(I)     = 22.5
            LEAFLF(I)  = 1.0
            ALLDWN(I)  = 50.0
            DECAYX(I)  = 1.0
            FALLX(I)   = 1.0
            DO J= 1,4
              HTX(I,J) = 1.0
            ENDDO
            DKRCLS(I)  = 4
            LSW(I)     = .FALSE.

        END SELECT

C       TIME-TO-FALL VALUES

        SELECT CASE (I)

C       white spruce (ORIGINAL)
C       Lutz's spruce
C       black spruce
C       other softwood (ORIGINAL)
        CASE (5,6,7,13)
          TFALL(I,0) = 2
          TFALL(I,1) = 5
          TFALL(I,2) = 5
          TFALL(I,3) = 10
          TFALL(I,4) = 50

C       Alaska-cedar (ORIGINAL)
C       western redcedar (ORIGINAL)
        CASE (3,10)
          TFALL(I,0) = 5
          TFALL(I,1) = 15
          TFALL(I,2) = 15
          TFALL(I,3) = 30
          TFALL(I,4) = 55

C       western hemlock (ORIGINAL)
C       mountain hemlock (ORIGINAL)
C       tamarack
        CASE (4,11,12)
          TFALL(I,0) = 1
          TFALL(I,1) = 5
          TFALL(I,2) = 5
          TFALL(I,3) = 15
          TFALL(I,4) = 50

C       pacific silver fir (ORIGINAL)
C       subalpine fir (ORIGINAL)
C       sitka spriuce (ORIGINAL)
C       lodgpole pine (ORIGINAL)
        CASE (1,2,8,9)
          TFALL(I,0) = 2
          TFALL(I,1) = 5
          TFALL(I,2) = 5
          TFALL(I,3) = 15
          TFALL(I,4) = 50

C       alder species
C       red alder (ORIGINAL)
C       paper birch
C       Alaska birch
C       balsam poplar
C       quaking aspen
C       black cottonwood (ORIGINAL)
C       willow species
C       Scouler's willow
C       other hardwoods (ORIGINAL)
        CASE (14:23)
          TFALL(I,0) = 1
          TFALL(I,1) = 10
          TFALL(I,2) = 15
          TFALL(I,3) = 15
          TFALL(I,4) = 50
        END SELECT

        TFALL(I,5) = TFALL(I,4)

C       DEAD LEAF FALL CANNOT BE > LIVE

        TFALL(I,0) = MIN(TFALL(I,0), LEAFLF(I))

C       TFALL(I,3) CANNOT BE < TFALL(I,2)

        IF (TFALL(I,2) .GT. TFALL(I,3)) THEN
          TFALL(I,2) = TFALL(I,3)
        ENDIF

C       CONVERT LB/FT**3 TO TONS/FT**3

        V2T(I) = V2T(I) / 2000.0

      ENDDO

C     parameters for post-burn snag fall rates:

      PBSCOR =  0.0
      PBSOFT =  0.0
      PBSMAL =  0.0
      PBSIZE = 12.0
      PBTIME =  7.0

C     PARAMETERS FOR FUEL MODEL SELECTION

C     THE DEFAULT COVER GROUP **FMCFMD** (not used in AK-FFE)
      OLDICT  = 3
      OLDICT2 = 0
      OLDICTWT(1) = 1.0
      OLDICTWT(2) = 0.0

C     DROUGHT START AND END YEARS (not used in AK-FFE)
      IDRYB  = 0
      IDRYE  = 0

C     CRITICAL % CHANGE REQUIRED TO TRIGGER ACTIVITY FUELS
      SLCRIT = 10.0

C     CRITICAL % CHANGE IN %CC REQUIRED TO TRIGGER SHRUB MODEL DELAY (not used in AK-FFE)
      CCCRIT = 10.0

      RETURN
      END
