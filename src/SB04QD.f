      SUBROUTINE SB04QD( N, M, A, LDA, B, LDB, C, LDC, Z, LDZ, IWORK,
     $                   DWORK, LDWORK, INFO )
C
C     SLICOT RELEASE 4.5.
C
C     Copyright (c) 2002-2005 NICONET International Society.
C
C     This program is free software: you can redistribute it and/or
C     modify it under the terms of the GNU General Public License as
C     published by the Free Software Foundation, either version 2 of
C     the License, or (at your option) any later version.
C
C     This program is distributed in the hope that it will be useful,
C     but WITHOUT ANY WARRANTY; without even the implied warranty of
C     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C     GNU General Public License for more details.
C
C     You should have received a copy of the GNU General Public License
C     along with this program.  If not, see
C     <http://www.gnu.org/licenses/>.
C     PURPOSE
C
C     To solve for X the discrete-time Sylvester equation
C
C        X + AXB = C,
C
C     where A, B, C and X are general N-by-N, M-by-M, N-by-M and
C     N-by-M matrices respectively. A Hessenberg-Schur method, which
C     reduces A to upper Hessenberg form, H = U'AU, and B' to real
C     Schur form, S = Z'B'Z (with U, Z orthogonal matrices), is used.
C
C     ARGUMENTS
C
C     Input/Output Parameters
C
C     N       (input) INTEGER
C             The order of the matrix A.  N >= 0.
C
C     M       (input) INTEGER
C             The order of the matrix B.  M >= 0.
C
C     A       (input/output) DOUBLE PRECISION array, dimension (LDA,N)
C             On entry, the leading N-by-N part of this array must
C             contain the coefficient matrix A of the equation.
C             On exit, the leading N-by-N upper Hessenberg part of this
C             array contains the matrix H, and the remainder of the
C             leading N-by-N part, together with the elements 2,3,...,N
C             of array DWORK, contain the orthogonal transformation
C             matrix U (stored in factored form).
C
C     LDA     INTEGER
C             The leading dimension of array A.  LDA >= MAX(1,N).
C
C     B       (input/output) DOUBLE PRECISION array, dimension (LDB,M)
C             On entry, the leading M-by-M part of this array must
C             contain the coefficient matrix B of the equation.
C             On exit, the leading M-by-M part of this array contains
C             the quasi-triangular Schur factor S of the matrix B'.
C
C     LDB     INTEGER
C             The leading dimension of array B.  LDB >= MAX(1,M).
C
C     C       (input/output) DOUBLE PRECISION array, dimension (LDC,M)
C             On entry, the leading N-by-M part of this array must
C             contain the coefficient matrix C of the equation.
C             On exit, the leading N-by-M part of this array contains
C             the solution matrix X of the problem.
C
C     LDC     INTEGER
C             The leading dimension of array C.  LDC >= MAX(1,N).
C
C     Z       (output) DOUBLE PRECISION array, dimension (LDZ,M)
C             The leading M-by-M part of this array contains the
C             orthogonal matrix Z used to transform B' to real upper
C             Schur form.
C
C     LDZ     INTEGER
C             The leading dimension of array Z.  LDZ >= MAX(1,M).
C
C     Workspace
C
C     IWORK   INTEGER array, dimension (4*N)
C
C     DWORK   DOUBLE PRECISION array, dimension (LDWORK)
C             On exit, if INFO = 0, DWORK(1) returns the optimal value
C             of LDWORK, and DWORK(2), DWORK(3),..., DWORK(N) contain
C             the scalar factors of the elementary reflectors used to
C             reduce A to upper Hessenberg form, as returned by LAPACK 
C             Library routine DGEHRD. 
C
C     LDWORK  INTEGER
C             The length of the array DWORK.
C             LDWORK = MAX(1, 2*N*N + 9*N, 5*M, N + M).
C             For optimum performance LDWORK should be larger.
C
C     Error Indicator
C
C     INFO    INTEGER
C             = 0:  successful exit;
C             < 0:  if INFO = -i, the i-th argument had an illegal
C                   value;
C             > 0:  if INFO = i, 1 <= i <= M, the QR algorithm failed to
C                   compute all the eigenvalues of B (see LAPACK Library
C                   routine DGEES);
C             > M:  if a singular matrix was encountered whilst solving
C                   for the (INFO-M)-th column of matrix X.
C
C     METHOD
C
C     The matrix A is transformed to upper Hessenberg form H = U'AU by
C     the orthogonal transformation matrix U; matrix B' is transformed
C     to real upper Schur form S = Z'B'Z using the orthogonal
C     transformation matrix Z. The matrix C is also multiplied by the
C     transformations, F = U'CZ, and the solution matrix Y of the
C     transformed system
C
C        Y + HYS' = F
C
C     is computed by back substitution. Finally, the matrix Y is then
C     multiplied by the orthogonal transformation matrices, X = UYZ', in
C     order to obtain the solution matrix X to the original problem.
C
C     REFERENCES
C
C     [1] Golub, G.H., Nash, S. and Van Loan, C.F.
C         A Hessenberg-Schur method for the problem AX + XB = C.
C         IEEE Trans. Auto. Contr., AC-24, pp. 909-913, 1979.
C
C     [2] Sima, V.
C         Algorithms for Linear-quadratic Optimization.
C         Marcel Dekker, Inc., New York, 1996.
C
C     NUMERICAL ASPECTS
C                                         3       3      2         2
C     The algorithm requires about (5/3) N  + 10 M  + 5 N M + 2.5 M N
C     operations and is backward stable.
C
C     CONTRIBUTORS
C
C     D. Sima, University of Bucharest, May 2000, Aug. 2000.
C
C     REVISIONS
C
C     V. Sima, Research Institute for Informatics, Bucharest, May 2000.
C
C     KEYWORDS
C
C     Hessenberg form, orthogonal transformation, real Schur form,
C     Sylvester equation.
C
C     ******************************************************************
C
C     .. Parameters ..
      DOUBLE PRECISION  ONE, ZERO
      PARAMETER         ( ONE = 1.0D0, ZERO = 0.0D0 )
C     .. Scalar Arguments ..
      INTEGER           INFO, LDA, LDB, LDC, LDWORK, LDZ, M, N
C     .. Array Arguments ..
      INTEGER           IWORK(*)
      DOUBLE PRECISION  A(LDA,*), B(LDB,*), C(LDC,*), DWORK(*), Z(LDZ,*)
C     .. Local Scalars ..
      INTEGER           BL, CHUNK, I, IEIG, IFAIL, IHI, ILO, IND, ITAU,
     $                  JWORK, SDIM, WRKOPT
C     .. Local Scalars ..
      LOGICAL           BLAS3, BLOCK
C     .. Local Arrays ..
      LOGICAL           BWORK(1)
C     .. External Functions ..
      LOGICAL           SELECT
C     .. External Subroutines ..
      EXTERNAL          DCOPY, DGEES, DGEHRD, DGEMM, DGEMV, DLACPY,
     $                  DORMHR, DSWAP, SB04QU, SB04QY, XERBLA
C     .. Intrinsic Functions ..
      INTRINSIC         INT, MAX, MIN
C     .. Executable Statements ..
C
      INFO = 0
C
C     Test the input scalar arguments.
C
      IF( N.LT.0 ) THEN
         INFO = -1
      ELSE IF( M.LT.0 ) THEN
         INFO = -2
      ELSE IF( LDA.LT.MAX( 1, N ) ) THEN
         INFO = -4
      ELSE IF( LDB.LT.MAX( 1, M ) ) THEN
         INFO = -6
      ELSE IF( LDC.LT.MAX( 1, N ) ) THEN
         INFO = -8
      ELSE IF( LDZ.LT.MAX( 1, M ) ) THEN
         INFO = -10
      ELSE IF( LDWORK.LT.MAX( 1, 2*N*N + 9*N, 5*M, N + M ) ) THEN
         INFO = -13
      END IF
C
      IF ( INFO.NE.0 ) THEN
C
C        Error return.
C
         CALL XERBLA( 'SB04QD', -INFO )
         RETURN
      END IF
C
C     Quick return if possible.
C
      IF ( N.EQ.0 .OR. M.EQ.0 ) THEN
         DWORK(1) = ONE
         RETURN
      END IF
C
      ILO = 1
      IHI = N
      WRKOPT = 2*N*N + 9*N
C
C     Step 1 : Reduce A to upper Hessenberg and B' to quasi-upper
C              triangular. That is, H = U' * A * U (store U in factored
C              form) and S = Z' * B' * Z (save Z).
C
C     (Note: Comments in the code beginning "Workspace:" describe the
C     minimal amount of real workspace needed at that point in the
C     code, as well as the preferred amount for good performance.
C     NB refers to the optimal block size for the immediately
C     following subroutine, as returned by ILAENV.)
C     
      DO 20 I = 2, M
         CALL DSWAP( I-1, B(1,I), 1, B(I,1), LDB )
   20 CONTINUE
C
C     Workspace:  need   5*M;
C                 prefer larger.
C
      IEIG  = M + 1
      JWORK = IEIG + M
      CALL DGEES( 'Vectors', 'Not ordered', SELECT, M, B, LDB,
     $            SDIM, DWORK, DWORK(IEIG), Z, LDZ, DWORK(JWORK),
     $            LDWORK-JWORK+1, BWORK, INFO )
      IF ( INFO.NE.0 )
     $   RETURN
      WRKOPT = MAX( WRKOPT, INT( DWORK(JWORK) )+JWORK-1 )
C
C     Workspace:  need   2*N;
C                 prefer N + N*NB.
C
      ITAU  = 2
      JWORK = ITAU + N - 1
      CALL DGEHRD( N, ILO, IHI, A, LDA, DWORK(ITAU), DWORK(JWORK),
     $             LDWORK-JWORK+1, IFAIL )
      WRKOPT = MAX( WRKOPT, INT( DWORK(JWORK) )+JWORK-1 )
C
C     Step 2 : Form  F = ( U' * C ) * Z.  Use BLAS 3, if enough space.
C
C     Workspace:  need   N + M;
C                 prefer N + M*NB.
C
      CALL DORMHR( 'Left', 'Transpose', N, M, ILO, IHI, A, LDA,
     $             DWORK(ITAU), C, LDC, DWORK(JWORK), LDWORK-JWORK+1,
     $             IFAIL )
      WRKOPT = MAX( WRKOPT, MAX( INT( DWORK(JWORK) ), N*M )+JWORK-1 )
C
      CHUNK = ( LDWORK - JWORK + 1 ) / M
      BLOCK = MIN( CHUNK, N ).GT.1
      BLAS3 = CHUNK.GE.N .AND. BLOCK
C     
      IF ( BLAS3 ) THEN
         CALL DGEMM( 'No transpose', 'No transpose', N, M, M, ONE, C,
     $               LDC, Z, LDZ, ZERO, DWORK(JWORK), N )
         CALL DLACPY( 'Full', N, M, DWORK(JWORK), N, C, LDC )
C
      ELSE IF ( BLOCK ) THEN
C     
C        Use as many rows of C as possible.
C     
         DO 40 I = 1, N, CHUNK
            BL = MIN( N-I+1, CHUNK )
            CALL DGEMM( 'NoTranspose', 'NoTranspose', BL, M, M, ONE,
     $                  C(I,1), LDC, Z, LDZ, ZERO, DWORK(JWORK), BL )
            CALL DLACPY( 'Full', BL, M, DWORK(JWORK), BL, C(I,1), LDC )
   40    CONTINUE
C
      ELSE
C
         DO 60 I = 1, N
            CALL DGEMV( 'Transpose', M, M, ONE, Z, LDZ, C(I,1), LDC,
     $                  ZERO, DWORK(JWORK), 1 )
            CALL DCOPY( M, DWORK(JWORK), 1, C(I,1), LDC )
   60    CONTINUE
C
      END IF
C
C     Step 3 : Solve  Y + H * Y * S' = F  for  Y.
C
      IND = M
   80 CONTINUE
C
      IF ( IND.GT.1 ) THEN
         IF ( B(IND,IND-1).EQ.ZERO ) THEN
C
C           Solve a special linear algebraic system of order N.
C           Workspace:  N*(N+1)/2 + 3*N.
C
            CALL SB04QY( M, N, IND, A, LDA, B, LDB, C, LDC,
     $                   DWORK(JWORK), IWORK, INFO )
C
            IF ( INFO.NE.0 ) THEN
               INFO = INFO + M
               RETURN
            END IF
            IND = IND - 1 
         ELSE
C
C           Solve a special linear algebraic system of order 2*N.
C           Workspace:  2*N*N + 9*N;
C
            CALL SB04QU( M, N, IND, A, LDA, B, LDB, C, LDC,
     $                   DWORK(JWORK), IWORK, INFO )
C
            IF ( INFO.NE.0 ) THEN
               INFO = INFO + M
               RETURN
            END IF
            IND = IND - 2 
         END IF
         GO TO 80
      ELSE IF ( IND.EQ.1 ) THEN
C
C        Solve a special linear algebraic system of order N.
C        Workspace:  N*(N+1)/2 + 3*N;
C
         CALL SB04QY( M, N, IND, A, LDA, B, LDB, C, LDC,
     $                DWORK(JWORK), IWORK, INFO )
         IF ( INFO.NE.0 ) THEN
            INFO = INFO + M
            RETURN
         END IF
      END IF
C
C     Step 4 : Form  C = ( U * Y ) * Z'.  Use BLAS 3, if enough space.
C
C     Workspace:  need   N + M;
C                 prefer N + M*NB.
C
      CALL DORMHR( 'Left', 'No transpose', N, M, ILO, IHI, A, LDA,
     $             DWORK(ITAU), C, LDC, DWORK(JWORK), LDWORK-JWORK+1,
     $             IFAIL )
      WRKOPT = MAX( WRKOPT, INT( DWORK(JWORK) )+JWORK-1 )
C
      IF ( BLAS3 ) THEN
         CALL DGEMM( 'No transpose', 'Transpose', N, M, M, ONE, C, LDC,
     $               Z, LDZ, ZERO, DWORK(JWORK), N )
         CALL DLACPY( 'Full', N, M, DWORK(JWORK), N, C, LDC )
C
      ELSE IF ( BLOCK ) THEN
C     
C        Use as many rows of C as possible.
C     
         DO 100 I = 1, N, CHUNK
            BL = MIN( N-I+1, CHUNK )
            CALL DGEMM( 'NoTranspose', 'Transpose', BL, M, M, ONE,
     $                  C(I,1), LDC, Z, LDZ, ZERO, DWORK(JWORK), BL )
            CALL DLACPY( 'Full', BL, M, DWORK(JWORK), BL, C(I,1), LDC )
  100    CONTINUE
C
      ELSE
C
         DO 120 I = 1, N
            CALL DGEMV( 'No transpose', M, M, ONE, Z, LDZ, C(I,1), LDC,
     $                  ZERO, DWORK(JWORK), 1 )
            CALL DCOPY( M, DWORK(JWORK), 1, C(I,1), LDC )
  120    CONTINUE
      END IF
C
      RETURN
C *** Last line of SB04QD ***
      END
