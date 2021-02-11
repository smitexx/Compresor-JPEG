function image = changeclass(class, varargin)
%CHANGECLASS will change the storage class of an image.
%   I2 = CHANGECLASS(CLASS, I);
%   RGB2 = CHANGECLASS(CLASS, RGB);
%   BW2 = CHANGECLASS(CLASS, BW);
%   X2 = CHANGECLASS(CLASS, X, 'indexed');

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 1.7 $  $Date: 2001/01/18 15:51:13 $

switch class
case 'uint8'
    image = im2uint8(varargin{:});
case 'uint16'
    image = im2uint16(varargin{:});
case 'double'
    image = im2double(varargin{:});
otherwise
    error('Unsupported IPT data class.');
end
