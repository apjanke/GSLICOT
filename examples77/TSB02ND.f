*     SB02ND EXAMPLE PROGRAM TEXT
*     RELEASE 4.5, Copyright (c) 2002-2005 NICONET Int. Society.
*
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        ( NIN = 5, NOUT = 6 )
      INTEGER          NMAX, MMAX, PMAX
      PARAMETER        ( NMAX = 20, MMAX = 20, PMAX = 20 )
      INTEGER          NMAX2
      PARAMETER        ( NMAX2 = 2*NMAX )
      INTEGER          LDA, LDB, LDC, LDL, LDR, LDS, LDT, LDU, LDX, LDF
      PARAMETER        ( LDA = NMAX, LDB = NMAX, LDC = PMAX, LDL = NMAX,
     $                   LDR = (MMAX+PMAX), LDS = NMAX2+MMAX, 
     $                   LDT = NMAX2+MMAX, LDU = NMAX2, LDX = NMAX, 
     $                   LDF = MMAX )
      INTEGER          LIWORK
      PARAMETER        ( LIWORK = ( NMAX2+MMAX ) )
      INTEGER          LDWORK
      PARAMETER        ( LDWORK = ( NMAX+3*MMAX+2 + 14*NMAX+23 +
     $                   16*NMAX ) )
*     .. Local Scalars ..
      DOUBLE PRECISION TOL, RCOND, RNORM
      INTEGER          I, INFO1, INFO2, J, M, N, P
      CHARACTER*1      DICO, FACT, JOBB, JOBL, SORT, UPLO
*     .. Local Arrays ..
      DOUBLE PRECISION A(LDA,NMAX), ALFAI(2*NMAX), ALFAR(2*NMAX),
     $                 B(LDB,MMAX), BETA(2*NMAX), C(LDC,NMAX),
     $                 DWORK(LDWORK), F(LDF,NMAX), L(LDL,MMAX),
     $                 R(LDR,MMAX), S(LDS,NMAX2+MMAX), T(LDT,NMAX2), 
     $                 U(LDU,NMAX2), X(LDX,NMAX)
      INTEGER          IPIV(LIWORK), IWORK(LIWORK), OUFACT(2)
      LOGICAL          BWORK(NMAX2)
*     .. External Functions ..
      LOGICAL          LSAME
      EXTERNAL         LSAME
*     .. External Subroutines ..
      EXTERNAL         SB02ND, SB02OD
*     .. Executable Statements ..
*
      WRITE ( NOUT, FMT = 99999 )
*     Skip the heading in the data file and read the data.
      READ ( NIN, FMT = '()' )
      READ ( NIN, FMT = * ) N, M, P, TOL, DICO, FACT, JOBL, UPLO
      IF ( N.LT.0 .OR. N.GT.NMAX ) THEN
         WRITE ( NOUT, FMT = 99993 ) N
      ELSE
         READ ( NIN, FMT = * ) ( ( A(I,J), J = 1,N ), I = 1,N )
         IF ( M.LT.0 .OR. M.GT.MMAX ) THEN
            WRITE ( NOUT, FMT = 99992 ) M
         ELSE
            READ ( NIN, FMT = * ) ( ( B(I,J), J = 1,M ), I = 1,N )
            IF ( P.LT.0 .OR. P.GT.PMAX ) THEN
               WRITE ( NOUT, FMT = 99991 ) P
            ELSE
               READ ( NIN, FMT = * ) ( ( C(I,J), J = 1,N ), I = 1,P )
               IF ( LSAME( FACT, 'D' ) ) THEN
                  READ ( NIN, FMT = * ) ( ( R(I,J), J = 1,M ), I = 1,P )
               ELSE
                  READ ( NIN, FMT = * ) ( ( R(I,J), J = 1,M ), I = 1,M )
               END IF 
*              Find the solution matrix X.
               JOBB = 'B'
               SORT = 'S'
               CALL SB02OD( DICO, JOBB, 'Both', UPLO, JOBL, SORT, N, M,
     $                      P, A, LDA, B, LDB, C, LDC, R, LDR, L, LDL, 
     $                      RCOND, X, LDX, ALFAR, ALFAI, BETA, S, LDS,
     $                      T, LDT, U, LDU, TOL, IWORK, DWORK, LDWORK, 
     $                      BWORK, INFO1 )
*
               IF ( INFO1.NE.0 ) THEN
                  WRITE ( NOUT, FMT = 99998 ) INFO1
               ELSE
                  WRITE ( NOUT, FMT = 99996 )
                  DO 20 I = 1, N
                     WRITE ( NOUT, FMT = 99994 ) ( X(I,J), J = 1,N )
   20             CONTINUE
*                 Compute the optimal feedback matrix F.
                  CALL SB02ND( DICO, FACT, UPLO, JOBL, N, M, P, A, LDA,
     $                         B, LDB, R, LDR, IPIV, L, LDL, X, LDX,
     $                         RNORM, F, LDF, OUFACT, IWORK, DWORK,
     $                         LDWORK, INFO2 )
*
                  IF ( INFO2.NE.0 ) THEN
                     WRITE ( NOUT, FMT = 99997 ) INFO2
                  ELSE
                     WRITE ( NOUT, FMT = 99995 )
                     DO 40 I = 1, M
                        WRITE ( NOUT, FMT = 99994 ) ( F(I,J), J = 1,N )
   40                CONTINUE
                  END IF
               END IF
            END IF
         END IF
      END IF
      STOP
*
99999 FORMAT (' SB02ND EXAMPLE PROGRAM RESULTS',/1X)
99998 FORMAT (' INFO on exit from SB02OD = ',I2)
99997 FORMAT (' INFO on exit from SB02ND = ',I2)
99996 FORMAT (' The solution matrix X is ')
99995 FORMAT (/' The optimal feedback matrix F is ')
99994 FORMAT (20(1X,F8.4))
99993 FORMAT (/' N is out of range.',/' N = ',I5)
99992 FORMAT (/' M is out of range.',/' M = ',I5)
99991 FORMAT (/' P is out of range.',/' P = ',I5)
      END
