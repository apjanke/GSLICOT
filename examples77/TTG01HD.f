*     TG01HD EXAMPLE PROGRAM TEXT
*     RELEASE 4.5, Copyright (c) 2002-2005 NICONET Int. Society.
*
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        ( NIN = 5, NOUT = 6 )
      INTEGER          LMAX, NMAX, MMAX, PMAX
      PARAMETER        ( LMAX = 20, NMAX = 20, MMAX = 20, PMAX = 20 )
      INTEGER          LDA, LDB, LDC, LDE, LDQ, LDZ
      PARAMETER        ( LDA = LMAX, LDB = LMAX, LDC = PMAX, 
     $                   LDE = LMAX, LDQ = LMAX, LDZ = NMAX )
      INTEGER          LDWORK
      PARAMETER        ( LDWORK = ( 1 + NMAX + 2*MMAX ) )
*     .. Local Scalars ..
      CHARACTER*1      COMPQ, COMPZ, JOBCO
      INTEGER          I, INFO, J, M, N, NCONT, NIUCON, NRBLCK, P
      DOUBLE PRECISION TOL
*     .. Local Arrays ..
      INTEGER          IWORK(MMAX), RTAU(NMAX)
      DOUBLE PRECISION A(LDA,NMAX), B(LDB,MMAX), C(LDC,NMAX),
     $                 DWORK(LDWORK), E(LDE,NMAX), Q(LDQ,LMAX),
     $                 Z(LDZ,NMAX)
*     .. External Subroutines ..
      EXTERNAL         TG01HD
*     .. Executable Statements ..
*
      WRITE ( NOUT, FMT = 99999 )
*     Skip the heading in the data file and read the data.
      READ ( NIN, FMT = '()' )
      READ ( NIN, FMT = * ) N, M, P, TOL, JOBCO
      COMPQ = 'I'
      COMPZ = 'I'
      IF ( N.LT.0 .OR. N.GT.NMAX ) THEN
         WRITE ( NOUT, FMT = 99988 ) N
      ELSE
         READ ( NIN, FMT = * ) ( ( A(I,J), J = 1,N ), I = 1,N )
         READ ( NIN, FMT = * ) ( ( E(I,J), J = 1,N ), I = 1,N )
         IF ( M.LT.0 .OR. M.GT.MMAX ) THEN
            WRITE ( NOUT, FMT = 99987 ) M
         ELSE
            READ ( NIN, FMT = * ) ( ( B(I,J), J = 1,M ), I = 1,N )
            IF ( P.LT.0 .OR. P.GT.PMAX ) THEN
               WRITE ( NOUT, FMT = 99986 ) P
            ELSE
               READ ( NIN, FMT = * ) ( ( C(I,J), J = 1,N ), I = 1,P )
*              Find the transformed descriptor system (A-lambda E,B,C).
               CALL TG01HD( JOBCO, COMPQ, COMPZ, N, M, P, A, LDA,  
     $                      E, LDE, B, LDB, C, LDC, Q, LDQ, Z, LDZ, 
     $                      NCONT, NIUCON, NRBLCK, RTAU, TOL, IWORK,
     $                      DWORK, INFO )
*
               IF ( INFO.NE.0 ) THEN
                  WRITE ( NOUT, FMT = 99998 ) INFO
               ELSE
                  WRITE ( NOUT, FMT = 99994 ) NCONT, NIUCON
                  WRITE ( NOUT, FMT = 99985 )
                  WRITE ( NOUT, FMT = 99984 ) ( RTAU(I), I = 1,NRBLCK )
                  WRITE ( NOUT, FMT = 99997 )
                  DO 10 I = 1, N
                     WRITE ( NOUT, FMT = 99995 ) ( A(I,J), J = 1,N )
   10             CONTINUE
                  WRITE ( NOUT, FMT = 99996 )
                  DO 20 I = 1, N
                     WRITE ( NOUT, FMT = 99995 ) ( E(I,J), J = 1,N )
   20             CONTINUE
                  WRITE ( NOUT, FMT = 99993 )
                  DO 30 I = 1, N
                     WRITE ( NOUT, FMT = 99995 ) ( B(I,J), J = 1,M )
   30             CONTINUE
                  WRITE ( NOUT, FMT = 99992 )
                  DO 40 I = 1, P
                     WRITE ( NOUT, FMT = 99995 ) ( C(I,J), J = 1,N )
   40             CONTINUE
                  WRITE ( NOUT, FMT = 99991 )
                  DO 50 I = 1, N
                     WRITE ( NOUT, FMT = 99995 ) ( Q(I,J), J = 1,N )
   50             CONTINUE 
                  WRITE ( NOUT, FMT = 99990 )
                  DO 60 I = 1, N
                     WRITE ( NOUT, FMT = 99995 ) ( Z(I,J), J = 1,N )
   60             CONTINUE 
               END IF
            END IF
         END IF
      END IF
      STOP
*
99999 FORMAT (' TG01HD EXAMPLE PROGRAM RESULTS',/1X)
99998 FORMAT (' INFO on exit from TG01HD = ',I2)
99997 FORMAT (/' The transformed state dynamics matrix Q''*A*Z is ')
99996 FORMAT (/' The transformed descriptor matrix Q''*E*Z is ')
99995 FORMAT (20(1X,F8.4))
99994 FORMAT (' Dimension of controllable part   =', I5/
     $        ' Number of uncontrollable infinite eigenvalues =', I5)
99993 FORMAT (/' The transformed input/state matrix Q''*B is ')
99992 FORMAT (/' The transformed state/output matrix C*Z is ')
99991 FORMAT (/' The left transformation matrix Q is ')
99990 FORMAT (/' The right transformation matrix Z is ')
99989 FORMAT (/' L is out of range.',/' L = ',I5)
99988 FORMAT (/' N is out of range.',/' N = ',I5)
99987 FORMAT (/' M is out of range.',/' M = ',I5)
99986 FORMAT (/' P is out of range.',/' P = ',I5)
99985 FORMAT (/' The staircase form row dimensions are ' )
99984 FORMAT (10I5) 
      END
