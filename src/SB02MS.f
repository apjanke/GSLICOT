      LOGICAL FUNCTION SB02MS( REIG, IEIG )
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
C     To select the unstable eigenvalues for solving the discrete-time
C     algebraic Riccati equation.
C
C     ARGUMENTS
C
C     Input/Output Parameters
C
C     REIG    (input) DOUBLE PRECISION
C             The real part of the current eigenvalue considered.
C
C     IEIG    (input) DOUBLE PRECISION
C             The imaginary part of the current eigenvalue considered.
C
C     METHOD
C
C     The function value SB02MS is set to .TRUE. for an unstable
C     eigenvalue (i.e., with modulus greater than or equal to one) and
C     to .FALSE., otherwise.
C
C     REFERENCES
C
C     None.
C
C     NUMERICAL ASPECTS
C
C     None.
C
C     CONTRIBUTOR
C
C     V. Sima, Katholieke Univ. Leuven, Belgium, Aug. 1997.
C
C     REVISIONS
C
C     -
C
C     KEYWORDS
C
C     Algebraic Riccati equation, closed loop system, discrete-time
C     system, optimal regulator, Schur form.
C
C     ******************************************************************
C
C     .. Parameters ..
      DOUBLE PRECISION  ONE
      PARAMETER         ( ONE = 1.0D0 )
C     .. Scalar Arguments ..
      DOUBLE PRECISION  IEIG, REIG
C     .. External Functions ..
      DOUBLE PRECISION   DLAPY2
      EXTERNAL           DLAPY2
C     .. Executable Statements ..
C
      SB02MS = DLAPY2( REIG, IEIG ).GE.ONE
C
      RETURN
C *** Last line of SB02MS ***
      END
