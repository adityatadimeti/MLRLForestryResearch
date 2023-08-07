      BLOCK DATA CUBRDS
      IMPLICIT NONE
C----------
C  **CUBRDS--NI DATE OF LAST REVISION:  04/09/08
C----------
C  DEFAULT PARAMETERS FOR THE CUBIC AND BOARD FOOT VOLUME EQUATIONS.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C----------
C  COEFFICIENTS FOR CUBIC FOOT VOLUME FOR TREES THAT ARE SMALLER THAN 
C  THE TRANSITION SIZE
C----------
      DATA CFVEQS/
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     & 0.030288,      0.0,     0.0,0.002213,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0/
C----------
C  COEFFICIENTS FOR CUBIC FOOT VOLUME FOR TREES THAT ARE LARGER THAN 
C  THE TRANSITION SIZE
C----------
      DATA CFVEQL/
     &      0.0,      0.0,     0.0, 0.00233,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0, 0.00184,     0.0,     0.0,    0.0,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0, 0.00234,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0, 0.00219,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0, 0.00205,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &-1.557103,      0.0,     0.0,0.002474,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0, 0.00219,     0.0,     0.0,    0.0/
C----------
C  FLAG IDENTIFYING THE SIZE TRANSITION VARIABLE; 0=D, 1=D2H
C----------
      DATA ICTRAN/0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0/
C----------
C  TRANSITION SIZE.  TREES OF LARGER SIZE (D OR D2H) WILL COEFFICIENTS 
C  FOR LARGER SIZE TREES.
C---------- 
      DATA CTRAN/
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,  6000.0,     0.0/
C----------
C  COEFFICIENTS FOR BOARD FOOT VOLUME FOR TREES THAT ARE SMALLER THAN 
C  THE TRANSITION SIZE
C----------
      DATA BFVEQS/
     &  -26.729,      0.0,     0.0, 0.01189,     0.0,     0.0,    0.0,
     &  -29.790,      0.0,     0.0, 0.00997,     0.0,     0.0,    0.0,
     &  -25.332,      0.0,     0.0, 0.01003,     0.0,     0.0,    0.0,
     &  -34.127,      0.0,     0.0, 0.01293,     0.0,     0.0,    0.0,
     &  -37.314,      0.0,     0.0, 0.01203,     0.0,     0.0,    0.0,
     &  -10.742,      0.0,     0.0, 0.00878,     0.0,     0.0,    0.0,
     &   -8.085,      0.0,     0.0, 0.01208,     0.0,     0.0,    0.0,
     &  -11.851,      0.0,     0.0, 0.01149,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -50.340,      0.0,     0.0, 0.01201,     0.0,     0.0,    0.0,
     &  -37.314,      0.0,     0.0, 0.01203,     0.0,     0.0,    0.0/
C----------
C  COEFFICIENTS FOR BOARD FOOT VOLUME FOR TREES THAT ARE LARGER THAN 
C  THE TRANSITION SIZE
C----------
      DATA BFVEQL/
     &  -32.516,      0.0,     0.0, 0.01181,     0.0,     0.0,    0.0,
     &   85.150,      0.0,     0.0, 0.00841,     0.0,     0.0,    0.0,
     &   -9.522,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &   10.603,      0.0,     0.0, 0.01218,     0.0,     0.0,    0.0,
     &  -50.680,      0.0,     0.0, 0.01306,     0.0,     0.0,    0.0,
     &   -4.064,      0.0,     0.0, 0.00799,     0.0,     0.0,    0.0,
     &   14.111,      0.0,     0.0, 0.01103,     0.0,     0.0,    0.0,
     &    1.620,      0.0,     0.0, 0.01158,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     & -298.784,      0.0,     0.0, 0.01595,     0.0,     0.0,    0.0,
     &  -50.680,      0.0,     0.0, 0.01306,     0.0,     0.0,    0.0/
C----------
C  FLAG IDENTIFYING THE SIZE TRANSITION VARIABLE; 0=D, 1=D2H
C----------
      DATA IBTRAN/0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/
C----------
C  TRANSITION SIZE.  TREES OF LARGER SIZE (D OR D2H) WILL USE COEFFICIENTS 
C  FOR LARGER SIZE TREES.
C---------- 
      DATA BTRAN/
     &     20.5,     20.5,    20.5,    20.5,    20.5,    20.5,   20.5,
     &     20.5,     20.5,    20.5,    20.5/
      END
