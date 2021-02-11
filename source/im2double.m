function d = im2double(img, typestr)
%IM2DOUBLE Convert image to double precision.
%   IM2DOUBLE takes an image as input, and returns an image of
%   class double.  If the input image is of class double, the
%   output image is identical to it.  If the input image is of
%   class uint8 or uint16, im2double returns the equivalent 
%   image of class double, rescaling or offsetting the data 
%   as necessary.
%
%   I2 = IM2DOUBLE(I1) converts the intensity image I1 to double
%   precision, rescaling the data if necessary.
%
%   RGB2 = IM2DOUBLE(RGB1) converts the truecolor image RGB1 to
%   double precision, rescaling the data if necessary.
%
%   BW2 = IM2DOUBLE(BW1) converts the binary image BW1 to double
%   precision.
%
%   X2 = IM2DOUBLE(X1,'indexed') converts the indexed image X1 to
%   double precision, offsetting the data if necessary.
% 
%   See also DOUBLE, IM2UINT8, UINT8.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 1.13 $  $Date: 2001/01/18 15:29:17 $

if isa(img, 'double')
   d = img; 
elseif isa(img, 'uint8') | isa(img, 'uint16')
   if nargin==1
      if islogical(img)      % uint8 binary image
         d = double(img);
      else                   % uint8 or uint16 intensity image
         if isa(img, 'uint8')
            d = double(img)/255;
         else
            d = double(img)/65535;
         end
      end
   elseif nargin==2
      if ~ischar(typestr) | (typestr(1) ~= 'i')
         error('Invalid input arguments');
      else 
         d = double(img)+1;
      end
   else
      error('Invalid input arguments.');
   end
else
   error('Unsupported input class.');
end

