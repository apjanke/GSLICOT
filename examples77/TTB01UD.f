*     TB01UD EXAMPLE PROGRAM TEXT
*     RELEASE 4.5, Copyright (c) 2002-2005 NICONET Int. Society.
*
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        ( NIN = 5, NOUT = 6 )
      INTEGER          NMAX, MMAX, PMAX
      PARAMETER        ( NMAX = 20, MMAX = 20, PMAX = 20 )
      INTEGER          LDA, LDB, LDC, LDZ
      PARAMETER        ( LDA = NMAX, LDB = NMAX, LDC = PMAX, 
     $                   LDZ = NMAX )
      INTEGER          LIWORK
      PARAMETER        ( LIWORK = MMAX )
      INTEGER          LDWORK
      PARAMETER        ( LDWORK = ( NMAX + 3*MMAX + PMAX ) )
*     .. Local Scalars ..
      DOUBLE PRECISION TOL
      INTEGER          I, INFO, INDCON, J, M, N, NCONT, P
      CHARACTER*1      JOBZ
*     .. Local Arrays ..
      DOUBLE PRECISION A(LDA,NMAX), B(LDB,MMAX), C(LDC,NMAX),
     $                 DWORK(LDWORK), TAU(NMAX), Z(LDZ,NMAX)
      INTEGER          IWORK(LIWORK), NBLK(NMAX)
*     .. External Functions ..
      LOGICAL          LSAME
      EXTERNAL         LSAME
*     .. External Subroutines ..
      EXTERNAL         TB01UD, DORGQR
*     .. Executable Statements ..
*
      WRITE ( NOUT, FMT = 99999 )
*     Skip the heading in the data file and read the data.
      READ ( NIN, FMT = '()' )
      READ ( NIN, FMT = * ) N, M, P, TOL, JOBZ
      IF ( N.LE.0 .OR. N.GT.NMAX ) THEN
         WRITE ( NOUT, FMT = 99990 ) N
      ELSE
         READ ( NIN, FMT = * ) ( ( A(I,J), J = 1,N ), I = 1,N )
         IF ( M.LE.0 .OR. M.GT.MMAX ) THEN
            WRITE ( NOUT, FMT = 99989 ) M
         ELSE
            READ ( NIN, FMT = * ) ( ( B(I,J), I = 1,N ), J = 1,M )
            IF ( P.LE.0 .OR. P.GT.PMAX ) THEN
               WRITE ( NOUT, FMT = 99988 ) P
            ELSE
               READ ( NIN, FMT = * ) ( ( C(I,J), J = 1,N ), I = 1,P )
*              Find a controllable ssr for the given system.
               CALL TB01UD( JOBZ, N, M, P, A, LDA, B, LDB, C, LDC,
     $                      NCONT, INDCON, NBLK, Z, LDZ, TAU, TOL, 
     $                      IWORK, DWORK, LDWORK, INFO )
*           
               IF ( INFO.NE.0 ) THEN
                  WRITE ( NOUT, FMT = 99998 ) INFO
               ELSE
                  WRITE ( NOUT, FMT = 99997 ) NCONT
                  WRITE ( NOUT, FMT = 99996 )
                  DO 20 I = 1, NCONT
                     WRITE ( NOUT, FMT = 99995 ) ( A(I,J), J = 1,NCONT )
   20             CONTINUE
                  WRITE ( NOUT, FMT = 99994 ) ( NBLK(I), I = 1,INDCON )
                  WRITE ( NOUT, FMT = 99993 )
                  DO 40 I = 1, NCONT
                     WRITE ( NOUT, FMT = 99995 ) ( B(I,J), J = 1,M )
   40             CONTINUE
                  WRITE ( NOUT, FMT = 99987 )
                  DO 60 I = 1, P
                     WRITE ( NOUT, FMT = 99995 ) ( C(I,J), J = 1,NCONT )
   60             CONTINUE
                  WRITE ( NOUT, FMT = 99992 ) INDCON
                  IF ( LSAME( JOBZ, 'F' ) ) 
     $               CALL DORGQR( N, N, N, Z, LDZ, TAU, DWORK, LDWORK,
     $                            INFO )
                  IF ( LSAME( JOBZ, 'F' ).OR.LSAME( JOBZ, 'I' ) ) THEN
                     WRITE ( NOUT, FMT = 99991 )
                     DO 80 I = 1, N
                        WRITE ( NOUT, FMT = 99995 ) ( Z(I,J), J = 1,N )
   80                CONTINUE
                  END IF
               END IF
            END IF
         END IF
      END IF
      STOP
*
99999 FORMAT (' TB01UD EXAMPLE PROGRAM RESULTS',/1X)
99998 FORMAT (' INFO on exit from TB01UD = ',I2)
99997 FORMAT (' The order of the controllable state-space representati',
     $       'on = ',I2)
99996 FORMAT (/' The transformed state dynamics matrix of a controllab',
     $       'le realization is ')
99995 FORMAT (20(1X,F8.4))
99994 FORMAT (/' and the dimensions of its diagonal blocks are ',
     $       /20(1X,I2))
99993 FORMAT (/' The transformed input/state matrix B of a controllabl',
     $       'e realization is ')
99992 FORMAT (/' The controllability index of the transformed system r',
     $       'epresentation = ',I2)
99991 FORMAT (/' The similarity transformation matrix Z is ')
99990 FORMAT (/' N is out of range.',/' N = ',I5)
99989 FORMAT (/' M is out of range.',/' M = ',I5)
99988 FORMAT (/' P is out of range.',/' P = ',I5)
99987 FORMAT (/' The transformed output/state matrix C of a controlla',
     $       'ble realization is ')
      END