function [RC, mse] = jdes_custom(fname)

%Función que descomprime un archivo .hud

%Variable para que se muestre la gráfica
disptext = 1;

%Abre archivo <fname>.hud y recupera los datos en el orden de compresión
fid = fopen(fname,'r');

caliQ = double(fread(fid,1,'uint32'));
m = double(fread(fid, 1, 'uint32'));
n = double(fread(fid, 1, 'uint32'));
mamp = double(fread(fid, 1, 'uint32'));
namp = double(fread(fid, 1, 'uint32'));

lenCodedY = double(fread(fid, 1, 'uint32'));
ultlCodedY = double(fread(fid, 1, 'uint8'));
sCodedY = double(fread(fid,lenCodedY, 'uint8'));

lenCodedCb = double(fread(fid, 1, 'uint32'));
ultlCodedCb = double(fread(fid, 1, 'uint8'));
sCodedCb = double(fread(fid,lenCodedCb, 'uint8'));

lenCodedCr = double(fread(fid, 1, 'uint32'));
ultlCodedCr = double(fread(fid, 1, 'uint8'));
sCodedCr = double(fread(fid,lenCodedCr, 'uint8'));

len_bits_ydc = double(fread(fid, 1, 'uint8'));
BITS_Y_DC = double(fread(fid, len_bits_ydc,'uint8'));
len_huffval_ydc = double(fread(fid, 1, 'uint8'));
HUFFVAL_Y_DC = double(fread(fid, len_huffval_ydc,'uint8'));

len_bits_yac = double(fread(fid, 1, 'uint8'));
BITS_Y_AC = double(fread(fid, len_bits_yac,'uint8'));
len_huffval_yac = double(fread(fid, 1, 'uint8'));
HUFFVAL_Y_AC = double(fread(fid, len_huffval_yac,'uint8'));

len_bits_cdc = double(fread(fid, 1, 'uint8'));
BITS_C_DC = double(fread(fid, len_bits_cdc,'uint8'));
len_huffval_cdc = double(fread(fid, 1, 'uint8'));
HUFFVAL_C_DC = double(fread(fid, len_huffval_cdc,'uint8'));

len_bits_cac = double(fread(fid, 1, 'uint8'));
BITS_C_AC = double(fread(fid, len_bits_cac,'uint8'));
len_huffval_cac = double(fread(fid, 1, 'uint8'));
HUFFVAL_C_AC = double(fread(fid, len_huffval_cac,'uint8'));

fclose(fid);

% Convierte CodedX a string binario codificado
CodedY = bytes2bits(sCodedY, ultlCodedY);
CodedCb = bytes2bits(sCodedCb, ultlCodedCb);
CodedCr = bytes2bits(sCodedCr, ultlCodedCr);


% Decodifica los tres Scans a partir de strings binarios
XScanrec = DecodeScans_custom(CodedY, CodedCb, CodedCr, [mamp namp], BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC,HUFFVAL_Y_AC, BITS_C_DC, HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC);


% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag
Xlabrec=invscan(XScanrec);

% Descuantizacion de etiquetas
Xtransrec=desquantmat(Xlabrec, caliQ);

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec,m, n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd=round(ycbcr2rgb(Xamprec/255)*255);
Xrec=uint8(Xrecrd);

% Repone el tamaño original
Xrec=Xrec(1:m,1:n, 1:3);

% Genera nombre archivo descomprimido <nombre>_des_custom<factorCalidad>.bmp
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'_des_custom',int2str(caliQ),'.bmp');

%Obtiene el nombre del archivo original
nombreoriginal = strcat(name,'','.bmp');
%Crea el archivo
imwrite(Xrec, nombrecomp, 'bmp');

%Abre el Archivo Original y el archivo .huc comprimido
[X, Xamp, tipo, m, n, mamp, namp, TO] = imlee(nombreoriginal);

TC = dir(fname);
TC = TC.bytes;

%Obtenemos medidas de error a partir de la imagen original y datos de
%archivo comprimido
RC = 100*(TO-TC)/TO;
mse=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3);

% % Test visual
if disptext
      [m,n,p] = size(X);
      figure('Units','pixels','Position',[100 100 n m]);
      set(gca,'Position',[0 0 1 1]);
      image(X); 
      set(gcf,'Name','Imagen original X');
      figure('Units','pixels','Position',[100 100 n m]);
      set(gca,'Position',[0 0 1 1]);
      image(Xrec);
      set(gcf,'Name','Imagen reconstruida Xrec');
end

