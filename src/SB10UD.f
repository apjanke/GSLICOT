      SUBROUTINE SB10UD( N, M, NP, NCON, NMEAS, B, LDB, C, LDC, D, LDD,
     $                   TU, LDTU, TY, LDTY, RCOND, TOL, DWORK, LDWORK,
     $                   INFO )
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
C     To reduce the matrices D12 and D21 of the linear time-invariant
C     system
C
C                   | A  | B1  B2  |   | A | B |
C               P = |----|---------| = |---|---|
C                   | C1 |  0  D12 |   | C | D | 
C                   | C2 | D21 D22 |
C
C     to unit diagonal form, and to transform the matrices B and C to
C     satisfy the formulas in the computation of the H2 optimal
C     controller.
C
C     ARGUMENTS
C
C     Input/Output Parameters
C
C     N       (input) INTEGER
C             The order of the system.  N >= 0.
C
C     M       (input) INTEGER
C             The column size of the matrix B.  M >= 0.
C
C     NP      (input) INTEGER
C             The row size of the matrix C.  NP >= 0.
C
C     NCON    (input) INTEGER
C             The number of control inputs (M2).  M >= NCON >= 0,
C             NP-NMEAS >= NCON.
C
C     NMEAS   (input) INTEGER
C             The number of measurements (NP2).  NP >= NMEAS >= 0,
C             M-NCON >= NMEAS.
C
C     B       (input/output) DOUBLE PRECISION array, dimension (LDB,M)
C             On entry, the leading N-by-M part of this array must
C             contain the system input matrix B.
C             On exit, the leading N-by-M part of this array contains
C             the transformed system input matrix B.
C
C     LDB     INTEGER
C             The leading dimension of the array B.  LDB >= max(1,N).
C
C     C       (input/output) DOUBLE PRECISION array, dimension (LDC,N)
C             On entry, the leading NP-by-N part of this array must
C             contain the system output matrix C.
C             On exit, the leading NP-by-N part of this array contains
C             the transformed system output matrix C.
C
C     LDC     INTEGER
C             The leading dimension of the array C.  LDC >= max(1,NP).
C
C     D       (input/output) DOUBLE PRECISION array, dimension (LDD,M)
C             On entry, the leading NP-by-M part of this array must
C             contain the system input/output matrix D.
C             The (NP-NMEAS)-by-(M-NCON) leading submatrix D11 is not
C             referenced.
C             On exit, the trailing NMEAS-by-NCON part (in the leading
C             NP-by-M part) of this array contains the transformed
C             submatrix D22.
C             The transformed submatrices D12 = [ 0  Im2 ]' and
C             D21 = [ 0  Inp2 ] are not stored. The corresponding part
C             of this array contains no useful information.
C           
C     LDD     INTEGER
C             The leading dimension of the array D.  LDD >= max(1,NP).
C
C     TU      (output) DOUBLE PRECISION array, dimension (LDTU,M2)
C             The leading M2-by-M2 part of this array contains the
C             control transformation matrix TU.
C
C     LDTU    INTEGER
C             The leading dimension of the array TU.  LDTU >= max(1,M2).
C
C     TY      (output) DOUBLE PRECISION array, dimension (LDTY,NP2)
C             The leading NP2-by-NP2 part of this array contains the
C             measurement transformation matrix TY.
C
C     LDTY    INTEGER
C             The leading dimension of the array TY.
C             LDTY >= max(1,NP2).
C  
C     RCOND   (output) DOUBLE PRECISION array, dimension (2)
C             RCOND(1) contains the reciprocal condition number of the 
C                      control transformation matrix TU;
C             RCOND(2) contains the reciprocal condition number of the 
C                      measurement transformation matrix TY.
C             RCOND is set even if INFO = 1 or INFO = 2; if INFO = 1,
C             then RCOND(2) was not computed, but it is set to 0.
C
C     Tolerances
C
C     TOL     DOUBLE PRECISION
C             Tolerance used for controlling the accuracy of the applied
C             transformations. Transformation matrices TU and TY whose
C             reciprocal condition numbers are less than TOL are not
C             allowed. If TOL <= 0, then a default value equal to
C             sqrt(EPS) is used, where EPS is the relative machine
C             precision.
C
C     Workspace
C
C     DWORK   DOUBLE PRECISION array, dimension (LDWORK)
C             On exit, if INFO = 0, DWORK(1) contains the optimal
C             LDWORK.
C
C     LDWORK  INTEGER
C             The dimension of the array DWORK.
C             LDWORK >= MAX( M2 + NP1*NP1 + MAX(NP1*N,3*M2+NP1,5*M2),
C                            NP2 + M1*M1  + MAX(M1*N,3*NP2+M1,5*NP2),
C                            N*M2, NP2*N, NP2*M2, 1 )
C             where M1 = M - M2 and NP1 = NP - NP2.
C             For good performance, LDWORK must generally be larger.
C             Denoting Q = MAX(M1,M2,NP1,NP2), an upper bound is
C             MAX(1,Q*(Q+MAX(N,5)+1)).
C
C     Error Indicator
C
C     INFO    INTEGER
C             = 0:  successful exit;
C             < 0:  if INFO = -i, the i-th argument had an illegal
C                   value;
C             = 1:  if the matrix D12 had not full column rank in
C                   respect to the tolerance TOL;
C             = 2:  if the matrix D21 had not full row rank in respect
C                   to the tolerance TOL;
C             = 3:  if the singular value decomposition (SVD) algorithm
C                   did not converge (when computing the SVD of D12 or
C                   D21).
C
C     METHOD
C
C     The routine performs the transformations described in [1], [2].
C
C     REFERENCES 
C
C     [1] Zhou, K., Doyle, J.C., and Glover, K.
C         Robust and Optimal Control.
C         Prentice-Hall, Upper Saddle River, NJ, 1996.
C
C     [2] Balas, G.J., Doyle, J.C., Glover, K., Packard, A., and
C         Smith, R.
C         mu-Analysis and Synthesis Toolbox.
C         The MathWorks Inc., Natick, Mass., 1995.
C
C     NUMERICAL ASPECTS
C
C     The precision of the transformations can be controlled by the
C     condition numbers of the matrices TU and TY as given by the
C     values of RCOND(1) and RCOND(2), respectively. An error return
C     with INFO = 1 or INFO = 2 will be obtained if the condition
C     number of TU or TY, respectively, would exceed 1/TOL.
C
C     CONTRIBUTORS
C
C     P.Hr. Petkov, D.W. Gu and M.M. Konstantinov, October 1998.
C
C     REVISIONS
C
C     V. Sima, Research Institute for Informatics, Bucharest, May 1999,
C     Feb. 2000.
C
C     KEYWORDS
C
C     Algebraic Riccati equation, H2 optimal control, LQG, LQR, optimal
C     regulator, robust control.
C
C     ******************************************************************
C 
C     .. Parameters ..
      DOUBLE PRECISION   ZERO, ONE
      PARAMETER          ( ZERO = 0.0D+0, ONE = 1.0D+0 )
C     ..      
C     .. Scalar Arguments ..
      INTEGER            INFO, LDB, LDC, LDD, LDTU, LDTY, LDWORK, M, N,
     $                   NCON, NMEAS, NP
      DOUBLE PRECISION   TOL
C     ..
C     .. Array Arguments ..
      DOUBLE PRECISION   B( LDB, * ), C( LDC, * ), D( LDD, * ),
     $                   DWORK( * ), RCOND( 2 ), TU( LDTU, * ),
     $                   TY( LDTY, * )
C     ..      
C     .. Local Scalars ..
      INTEGER            INFO2, IQ, IWRK, J, LWAMAX, M1, M2, MINWRK,
     $                   ND1, ND2, NP1, NP2
      DOUBLE PRECISION   TOLL
C     ..
C     .. External Functions
      DOUBLE PRECISION   DLAMCH
      EXTERNAL           DLAMCH
C     ..
C     .. External Subroutines ..
      EXTERNAL           DGEMM, DGESVD, DLACPY, DSCAL, DSWAP, XERBLA
C     ..
C     .. Intrinsic Functions ..
      INTRINSIC          DBLE, INT, MAX, SQRT
C     ..
C     .. Executable Statements ..      
C
C     Decode and Test input parameters.
C
      M1  = M - NCON
      M2  = NCON
      NP1 = NP - NMEAS
      NP2 = NMEAS
C
      INFO = 0
      IF( N.LT.0 ) THEN
         INFO = -1
      ELSE IF( M.LT.0 ) THEN
         INFO = -2
      ELSE IF( NP.LT.0 ) THEN
         INFO = -3
      ELSE IF( NCON.LT.0 .OR. M1.LT.0 .OR. M2.GT.NP1 ) THEN
         INFO = -4
      ELSE IF( NMEAS.LT.0 .OR. NP1.LT.0 .OR. NP2.GT.M1 ) THEN
         INFO = -5
      ELSE IF( LDB.LT.MAX( 1, N ) ) THEN
         INFO = -7  
      ELSE IF( LDC.LT.MAX( 1, NP ) ) THEN
         INFO = -9
      ELSE IF( LDD.LT.MAX( 1, NP ) ) THEN
         INFO = -11
      ELSE IF( LDTU.LT.MAX( 1, M2 ) ) THEN
         INFO = -13
      ELSE IF( LDTY.LT.MAX( 1, NP2 ) ) THEN
         INFO = -15
      ELSE
C
C        Compute workspace.
C
         MINWRK = MAX( 1, M2  + NP1*NP1 + MAX( NP1*N, 3*M2 + NP1,
     $                                         5*M2 ),
     $                    NP2 + M1*M1 + MAX( M1*N, 3*NP2 + M1, 5*NP2 ),
     $                    N*M2, NP2*N, NP2*M2 )
         IF( LDWORK.LT.MINWRK )
     $      INFO = -19
      END IF       
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'SB10UD', -INFO )
         RETURN
      END IF
C
C     Quick return if possible.
C
      IF( N.EQ.0 .OR. M.EQ.0 .OR. NP.EQ.0 .OR. M1.EQ.0 .OR. M2.EQ.0
     $    .OR. NP1.EQ.0 .OR. NP2.EQ.0 ) THEN
         RCOND( 1 ) = ONE
         RCOND( 2 ) = ONE
         DWORK( 1 ) = ONE
         RETURN
      END IF
C
      ND1  = NP1 - M2
      ND2  = M1 - NP2
      TOLL = TOL
      IF( TOLL.LE.ZERO ) THEN
C
C        Set the default value of the tolerance for condition tests.
C
         TOLL = SQRT( DLAMCH( 'Epsilon' ) )
      END IF      
C
C     Determine SVD of D12, D12 = U12 S12 V12', and check if D12 has
C     full column rank. V12' is stored in TU.
C     Workspace:  need   M2 + NP1*NP1 + max(3*M2+NP1,5*M2);
C                 prefer larger.
C
      IQ   = M2 + 1
      IWRK = IQ + NP1*NP1
C
      CALL DGESVD( 'A', 'A', NP1, M2, D( 1, M1+1 ), LDD, DWORK,
     $             DWORK( IQ ), NP1, TU, LDTU, DWORK( IWRK ),
     $             LDWORK-IWRK+1, INFO2 )
      IF( INFO2.NE.0 ) THEN
          INFO = 3
          RETURN
      END IF
C
      RCOND( 1 ) = DWORK( M2 )/DWORK( 1 )
      IF( RCOND( 1 ).LE.TOLL ) THEN
          RCOND( 2 ) = ZERO
          INFO = 1
          RETURN
      END IF
      LWAMAX = INT( DWORK( IWRK ) ) + IWRK - 1
C
C     Determine Q12.
C
      IF( ND1.GT.0 ) THEN
         CALL DLACPY( 'Full', NP1, M2, DWORK( IQ ), NP1, D( 1, M1+1 ),
     $                LDD )
         CALL DLACPY( 'Full', NP1, ND1, DWORK( IQ+NP1*M2 ), NP1,
     $                DWORK( IQ ), NP1 )
         CALL DLACPY( 'Full', NP1, M2, D( 1, M1+1 ), LDD,
     $                DWORK( IQ+NP1*ND1 ), NP1 )
      END IF
C
C     Determine Tu by transposing in-situ and scaling.
C
      DO 10 J = 1, M2 - 1
         CALL DSWAP( J, TU( J+1, 1 ), LDTU, TU( 1, J+1 ), 1 )
   10 CONTINUE
C
      DO 20 J = 1, M2
         CALL DSCAL( M2, ONE/DWORK( J ), TU( 1, J ), 1 )
   20 CONTINUE
C
C     Determine C1 =: Q12'*C1.
C     Workspace:  M2 + NP1*NP1 + NP1*N.
C  
      CALL DGEMM( 'T', 'N', NP1, N, NP1, ONE, DWORK( IQ ), NP1, C, LDC,
     $            ZERO, DWORK( IWRK ), NP1 )
      CALL DLACPY( 'Full', NP1, N, DWORK( IWRK ), NP1, C, LDC )
      LWAMAX = MAX( IWRK + NP1*N - 1, LWAMAX )
C
C     Determine SVD of D21, D21 = U21 S21 V21', and check if D21 has
C     full row rank. U21 is stored in TY.
C     Workspace:  need   NP2 + M1*M1 + max(3*NP2+M1,5*NP2);
C                 prefer larger.
C
      IQ   = NP2 + 1
      IWRK = IQ + M1*M1
C
      CALL DGESVD( 'A', 'A', NP2, M1, D( NP1+1, 1 ), LDD, DWORK, TY,
     $             LDTY, DWORK( IQ ), M1, DWORK( IWRK ), LDWORK-IWRK+1,
     $             INFO2 )
      IF( INFO2.NE.0 ) THEN
          INFO = 3
          RETURN
      END IF
C
      RCOND( 2 ) = DWORK( NP2 )/DWORK( 1 )
      IF( RCOND( 2 ).LE.TOLL ) THEN
          INFO = 2
          RETURN
      END IF
      LWAMAX = MAX( INT( DWORK( IWRK ) ) + IWRK - 1, LWAMAX )
C
C     Determine Q21.
C
      IF( ND2.GT.0 ) THEN
         CALL DLACPY( 'Full', NP2, M1, DWORK( IQ ), M1, D( NP1+1, 1 ),
     $                LDD )
         CALL DLACPY( 'Full', ND2, M1, DWORK( IQ+NP2 ), M1, DWORK( IQ ),
     $                M1 )
         CALL DLACPY( 'Full', NP2, M1, D( NP1+1, 1 ), LDD,
     $                DWORK( IQ+ND2 ), M1 )
      END IF
C
C     Determine Ty by scaling and transposing in-situ.
C
      DO 30 J = 1, NP2
         CALL DSCAL( NP2, ONE/DWORK( J ), TY( 1, J ), 1 )
   30 CONTINUE
C
      DO 40 J = 1, NP2 - 1
         CALL DSWAP( J, TY( J+1, 1 ), LDTY, TY( 1, J+1 ), 1 )
   40 CONTINUE
C
C     Determine B1 =: B1*Q21'.
C     Workspace:  NP2 + M1*M1 + N*M1.
C
      CALL DGEMM( 'N', 'T', N, M1, M1, ONE, B, LDB, DWORK( IQ ), M1,
     $            ZERO, DWORK( IWRK ), N )
      CALL DLACPY( 'Full', N, M1, DWORK( IWRK ), N, B, LDB )
      LWAMAX = MAX( IWRK + N*M1 - 1, LWAMAX )
C
C     Determine B2 =: B2*Tu.
C     Workspace:  N*M2.
C
      CALL DGEMM( 'N', 'N', N, M2, M2, ONE, B( 1, M1+1 ), LDB, TU, LDTU,
     $            ZERO, DWORK, N )
      CALL DLACPY( 'Full', N, M2, DWORK, N, B( 1, M1+1 ), LDB )
C
C     Determine C2 =: Ty*C2.
C     Workspace:  NP2*N.
C
      CALL DGEMM( 'N', 'N', NP2, N, NP2, ONE, TY, LDTY,
     $            C( NP1+1, 1 ), LDC, ZERO, DWORK, NP2 )
      CALL DLACPY( 'Full', NP2, N, DWORK, NP2, C( NP1+1, 1 ), LDC )
C
C     Determine D22 =: Ty*D22*Tu.
C     Workspace:  NP2*M2.
C
      CALL DGEMM( 'N', 'N', NP2, M2, NP2, ONE, TY, LDTY,
     $            D( NP1+1, M1+1 ), LDD, ZERO, DWORK, NP2 )
      CALL DGEMM( 'N', 'N', NP2, M2, M2, ONE, DWORK, NP2, TU, LDTU,
     $            ZERO, D( NP1+1, M1+1 ), LDD )
C
      LWAMAX = MAX( N*MAX( M2, NP2 ), NP2*M2, LWAMAX )
      DWORK( 1 ) = DBLE( LWAMAX )
      RETURN
C *** Last line of SB10UD ***
      END
