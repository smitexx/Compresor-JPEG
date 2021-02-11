function rgb = ycbcr2rgb(in)
%YCBCR2RGB Convert YCbCr values to RGB color space.
%   RGBMAP = YCBCR2RGB(YCBCRMAP) converts the YCbCr values in the
%   colormap YCBCRMAP to the RGB color space. If YCBCRMAP is M-by-3 and
%   contains the YCbCr luminance (Y) and chrominance (Cb and Cr) color
%   values as columns, then RGBMAP is an M-by-3 matrix that contains
%   the red, green, and blue values equivalent to those colors.
%
%   RGB = YCBCR2RGB(YCBCR) converts the YCbCr image to the equivalent
%   truecolor image RGB.
%
%   Class Support
%   -------------
%   If the input is a YCbCr image, it can be of class uint8, uint16,
%   or double; the output image is of the same class as the input 
%   image.  If the input is a colormap, the input and output 
%   colormaps are both of class double.
%
%   See also NTSC2RGB, RGB2NTSC, RGB2YCBCR.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 1.14 $  $Date: 2001/01/23 16:49:01 $

%   Reference:
%     Charles A. Poynton, "A Technical Introduction to Digital Video",
%     John Wiley & Sons, Inc., 1996

if ndims(in)~=3 | size(in,3)~=3
   if ndims(in)==2 & size(in,2)==3 % a colormap
      iscolormap=1;
      colors = size(in,1);
      in = reshape(in, [colors 1 3]);
   else
      error('Invalid YCbCr input image');
   end
else
   iscolormap=0;
end

classin = class(in);
switch classin
case 'uint8'
   in = double(in);
case 'double'
   in = in*255;
case 'uint16'
   in = double(in)/257;
otherwise
   error('Unsupported input class');
end

% These equations transform YCBCR in [0, 255] to RGB in [0,1].
in(:,:,1) = in(:,:,1)-16;
in(:,:,2) = in(:,:,2)-128;
in(:,:,3) = in(:,:,3)-128;

rgb(:,:,1) = .00456621 * in(:,:,1) + .00625893 * in(:,:,3);
rgb(:,:,2) = .00456621 * in(:,:,1) - .00153632 * in(:,:,2) - .00318811 * in(:,:,3);
rgb(:,:,3) = .00456621 * in(:,:,1) + .00791071 * in(:,:,2);

rgb = changeclass(classin, rgb);

if iscolormap
   rgb = reshape(rgb, [colors 3 1]);
end

if isa(rgb,'double')
    rgb = min(max(rgb,0.0),1.0);
end

