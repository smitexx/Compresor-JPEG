function c = dctmtx2(n)
%DCTMTX2 Discrete cosine transform matrix.
%
%   Note: This function is obsolete and may be removed in future
%   versions. Use DCTMTX instead.
%
%   D = DCTMTX(N) returns the N-by-N unitary 2-D DCT transform
%   matrix.  D*A is the DCT of A and D'*A is the inverse DCT
%   of A (when A is N-by-N).
%
%   See also DCTMTX, DCT.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 5.16 $  $Date: 2001/01/18 15:28:53 $

%   References:
%   Jain, Fundamentals of Digital Image Processing, p. 150.
warning(['This function is obsolete and may be removed ',...
  'in future versions. Use DCTMTX instead.']);

c = dctmtx(n);
