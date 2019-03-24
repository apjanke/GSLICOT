*     SB08ED EXAMPLE PROGRAM TEXT
*     RELEASE 4.5, Copyright (c) 2002-2005 NICONET Int. Society.
*
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        ( NIN = 5, NOUT = 6 )
      INTEGER          NMAX, MMAX, PMAX
      PARAMETER        ( NMAX = 20, MMAX = 20, PMAX = 20 )
      INTEGER          MPMAX
      PARAMETER        ( MPMAX = MAX( MMAX, PMAX ) )
      INTEGER          LDA, LDB, LDBR, LDC, LDD, LDDR
      PARAMETER        ( LDA = NMAX, LDB = NMAX, LDC = MPMAX,
     $                   LDD = MPMAX, LDBR = NMAX, LDDR = PMAX )
      INTEGER          LDWORK
      PARAMETER        ( LDWORK = NMAX*PMAX + MAX( NMAX*( NMAX + 5 ),
     $                                             5*PMAX, 4*MMAX ) )
*     .. Local Scalars ..
      DOUBLE PRECISION ALPHA, TOL
      INTEGER          I, INFO, IWARN, J, M, N, NQ, NR, P
      CHARACTER*1      DICO
*     .. Local Arrays ..
      DOUBLE PRECISION A(LDA,NMAX), B(LDB,MPMAX), BR(LDBR,PMAX),
     $                 C(LDC,NMAX), D(LDD,MPMAX), DR(LDDR,PMAX),
     $                 DWORK(LDWORK)
*     .. External Subroutines ..
      EXTERNAL         SB08ED
*     .. Intrinsic Functions ..
      INTRINSIC        MAX
*     .. Executable Statements ..
*
      WRITE ( NOUT, FMT = 99999 )
*     Skip the heading in the data file and read the data.
      READ ( NIN, FMT = '()' )
      READ ( NIN, FMT = * ) N, M, P, ALPHA, TOL, DICO
      IF ( N.LT.0 .OR. N.GT.NMAX ) THEN
         WRITE ( NOUT, FMT = 99990 ) N
      ELSE
         READ ( NIN, FMT = * ) ( ( A(I,J), J = 1, N ), I = 1, N )
         IF ( M.LT.0 .OR. M.GT.MMAX ) THEN
            WRITE ( NOUT, FMT = 99989 ) M
         ELSE
            READ ( NIN, FMT = * ) ( ( B(I,J), J = 1, M ), I = 1, N )
            IF ( P.LT.0 .OR. P.GT.PMAX ) THEN
               WRITE ( NOUT, FMT = 99988 ) P
            ELSE
               READ ( NIN, FMT = * ) ( ( C(I,J), J = 1, N ), I = 1, P )
               READ ( NIN, FMT = * ) ( ( D(I,J), J = 1, M ), I = 1, P )
*              Find a LCF for (A,B,C,D).
               CALL SB08ED( DICO, N, M, P, ALPHA, A, LDA, B, LDB, C,
     $                      LDC, D, LDD, NQ, NR, BR, LDBR, DR, LDDR,
     $                      TOL, DWORK, LDWORK, IWARN, INFO )
*
               IF ( INFO.NE.0 ) THEN
                  WRITE ( NOUT, FMT = 99998 ) INFO
               ELSE
                  IF( NQ.GT.0 ) WRITE ( NOUT, FMT = 99996 )
                  DO 20 I = 1, NQ
                     WRITE ( NOUT, FMT = 99995 ) ( A(I,J), J = 1, NQ )
   20             CONTINUE
                  IF( NQ.GT.0 ) WRITE ( NOUT, FMT = 99993 )
                  DO 40 I = 1, NQ
                     WRITE ( NOUT, FMT = 99995 ) ( B(I,J), J = 1, M )
   40             CONTINUE
                  IF( NQ.GT.0 ) WRITE ( NOUT, FMT = 99992 )
                  DO 60 I = 1, P
                     WRITE ( NOUT, FMT = 99995 ) ( C(I,J), J = 1, NQ )
   60             CONTINUE
                  WRITE ( NOUT, FMT = 99991 )
                  DO 70 I = 1, P
                     WRITE ( NOUT, FMT = 99995 ) ( D(I,J), J = 1, M )
   70             CONTINUE
                  IF( NR.GT.0 ) WRITE ( NOUT, FMT = 99986 )
                  DO 80 I = 1, NR
                     WRITE ( NOUT, FMT = 99995 ) 
     $                     ( A(I,J), J = 1, NR )
   80             CONTINUE
                  IF( NR.GT.0 ) WRITE ( NOUT, FMT = 99985 )
                  DO 90 I = 1, NR
                     WRITE ( NOUT, FMT = 99995 ) ( BR(I,J), J = 1, P )
   90             CONTINUE
                  IF( NR.GT.0 ) WRITE ( NOUT, FMT = 99984 )
                  DO 100 I = 1, P
                     WRITE ( NOUT, FMT = 99995 ) 
     $                     ( C(I,J), J = 1, NR )
  100             CONTINUE
                  WRITE ( NOUT, FMT = 99983 )
                  DO 110 I = 1, P
                     WRITE ( NOUT, FMT = 99995 ) ( DR(I,J), J = 1, P )
  110             CONTINUE
               END IF
            END IF
         END IF
      END IF
      STOP
*
99999 FORMAT (' SB08ED EXAMPLE PROGRAM RESULTS',/1X)
99998 FORMAT (' INFO on exit from SB08ED = ',I2)
99996 FORMAT (/' The numerator state dynamics matrix AQ is ')
99995 FORMAT (20(1X,F8.4))
99993 FORMAT (/' The numerator input/state matrix BQ is ')
99992 FORMAT (/' The numerator state/output matrix CQ is ')
99991 FORMAT (/' The numerator input/output matrix DQ is ')
99990 FORMAT (/' N is out of range.',/' N = ',I5)
99989 FORMAT (/' M is out of range.',/' M = ',I5)
99988 FORMAT (/' P is out of range.',/' P = ',I5)
99986 FORMAT (/' The denominator state dynamics matrix AR is ')
99985 FORMAT (/' The denominator input/state matrix BR is ')
99984 FORMAT (/' The denominator state/output matrix CR is ')
99983 FORMAT (/' The denominator input/output matrix DR is ')
      END
