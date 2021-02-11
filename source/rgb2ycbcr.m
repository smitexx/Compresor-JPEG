function out = rgb2ycbcr(in)
%RGB2YCBCR Convert RGB values to YCBCR color space.
%   YCBCRMAP = RGB2YCBCR(RGBMAP) converts the RGB values in RGBMAP to
%   the YCBCR color space.  YCBCRMAP is a M-by-3 matrix that contains
%   the YCBCR luminance (Y) and chrominance (Cb and Cr) color values as
%   columns.  Each row represents the equivalent color to the
%   corresponding row in the RGB colormap.
%
%   YCBCR = RGB2YCBCR(RGB) converts the truecolor image RGB to the
%   equivalent image in the YCBCR color space.
%
%   Class Support
%   -------------
%   If the input is an RGB image, it can be of class uint8, uint16,
%   or double; the output image is of the same class as the input 
%   image.  If the input is a colormap, the input and output colormaps 
%   are both of class double.
%
%   See also NTSC2RGB, RGB2NTSC, YCBCR2RGB.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 1.12 $  $Date: 2001/01/18 15:30:32 $

%   Reference: 
%     Charles A. Poynton, "A Technical Introduction to Digital Video", John Wiley
%     & Sons, Inc., 1996

if ndims(in)~=3 | size(in,3)~=3
   if ndims(in)==2 & size(in,2)==3 % a colormap
      iscolormap=1;
      colors = size(in,1);
      in = reshape(in, [colors 1 3]);
   else
      error('Invalid RGB input image');
   end
else
   iscolormap=0;
end

classin = class(in);
rgb = im2double(in);

% These equations transform RGB in [0,1] to YCBCR in [0, 255]
out(:,:,1) = 16 + 65.481 * rgb(:,:,1) + 128.553 * rgb(:,:,2) + 24.966 * rgb(:,:,3);
out(:,:,2) = 128 - 37.797 * rgb(:,:,1) - 74.203 * rgb(:,:,2) + 112 * rgb(:,:,3);
out(:,:,3) = 128 + 112 * rgb(:,:,1) - 93.786 * rgb(:,:,2) -18.214 * rgb(:,:,3);

switch classin
case 'uint8'
   out = uint8(round(out));
case 'uint16'
   out = uint16(round(out*257));
case 'double'
   out = out / 255;
end

if iscolormap
   out = reshape(out, [colors 3 1]);
end