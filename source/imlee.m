function [X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(fname)

% Lee archivo de imagen <fname>
% Convierte a truecolor, si no lo es ya
% Convierte a espacio de color YCbCr
% Amplia dimensiones a multiplos de 8

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
% Salidas:
%  X: Matriz de imagen original BMP en espacio RGB y tipo truecolor
%  Xamp: Matriz de imagen en espacio YCbCr y dimensiones ampliadas
%  tipo: 0 -> indexado, 1 -> truecolor
%  m: Alto original de la imagen (nº de filas)
%  n: Ancho original de la imagen (nº de columnas)
%  mamp: Alto ampliado de la imagen (nº de filas)
%  namp: Ancho ampliadode la imagen (nº de columnas)
%  TO: Tamaño original de archivo para calcular RC

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion imlee:');
end

% Lee info de imagen
s=imfinfo(fname);
TO=s.FileSize; % Tamaño original

% Carga archivo, convierte a RGB y calcula tamaño
if strcmp(s.ColorType,'indexed') & s.BitDepth==8
    tipo=0;
    [Y,map]=imread(fname);
    X=uint8(round(ind2rgb(Y,map)*255));
elseif strcmp(s.ColorType,'truecolor') & s.BitDepth==24
    tipo=1;
    X=imread(fname);
else
    disp('Formato no reconocido. Terminado.');
    return;
end

% Convierte a espacio de color YCbCr
% Formato double para poder procesar con DCT
XYCbCr=double(rgb2ycbcr(X));

% Si tamaño no es multiplo de 8, replica ultimas filas y/o columnas
% Si no se amplia, al usar blkproc en DCT, ampliara e introducira ceros
% Los ceros provocarian mas error de borde que la replicacion
[m n plan]=size(X); % tamaño original
mpad = rem(m,8); if mpad>0, mpad = 8-mpad; end
npad = rem(n,8); if npad>0, npad = 8-npad; end
Xamp=cat(1, XYCbCr, repmat(XYCbCr(m,:,:),[mpad 1 1]));
Xamp=cat(2, Xamp, repmat(Xamp(:,n,:),[1 npad 1]));
mamp=m+mpad; % Alto ampliado de la imagen (nº de filas)
namp=n+npad; % Ancho ampliadode la imagen (nº de columnas)

if disptext
    disp(sprintf('%s %s', 'Archivo leido:', fname));
    if tipo
        disp('Formato truecolor de 24 bits');
    else
        disp('Formato indexado de 8 bits');
    end
    disp(sprintf('%s %1.0f %s %1.0f', 'Imagen original de ancho x alto:', n,'x',m));
    disp(sprintf('%s %1.0f %s %1.0f', 'Ampliada a:', namp,'x',mamp));
    disp('Imagen convertida a Espacio de Color YCbCr');
    disp('Terminado imlee');
    disp('--------------------------------------------------');
end
