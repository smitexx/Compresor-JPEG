function [RC, mse] = jdes_dflt(fname)

%Funcion que descomprime un archivo .hud

disptext = 1;
%Abrimos el archivo .hud y recuperamos los datos en el orden de compresión.
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

fclose(fid);

% Convierte CodedX a string binario codificado
CodedY = bytes2bits(sCodedY, ultlCodedY);
CodedCb = bytes2bits(sCodedCb, ultlCodedCb);
CodedCr = bytes2bits(sCodedCr, ultlCodedCr);

% Decodifica los tres Scans a partir de strings binarios
XScanrec=DecodeScans_dflt(CodedY,CodedCb,CodedCr,[mamp namp]);

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

%Creamos el archivo bmp recuperado
[pathstr,name,ext] = fileparts(fname);

nombrecomp=strcat(name,'_des_dflt_',int2str(caliQ),'.bmp');
nombreoriginal = strcat(name,'','.bmp');

%Volcamos los datos recuperados en el archivo bmp
imwrite(Xrec, nombrecomp, 'bmp');

%Abre el Archivo Original sin comprimir para ver el tamaño original y
%calcular medidas de error
[X, Xamp, tipo, m, n, mamp, namp, TO] = imlee(nombreoriginal);

%Tamaño del fichero comprimido
TC = dir(fname);
TC = TC.bytes;

%Obtenemos medidas de error a partir de la imagen original y datos de
%archivo comprimido
RC = 100*(TO-TC)/TO;
mse=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3);
% Test visual
if disptext
      [m,n,p] = size(X);
      figure('Units','pixels','Position',[100 100 n m]);
      set(gca,'Position',[0 0 1 1]);
      image(X); 
      set(gcf,'Name','Imagen original X');
      figure('Units','pixels','Position',[100 100 n m]);
      set(gca,'Position',[0 0 1 1]);
      image(Xrec);;
      set(gcf,'Name','Imagen reconstruida Xrec');
    
end