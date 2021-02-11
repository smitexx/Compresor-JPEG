function RCfil = jcom_dflt(fname,caliQ)

%Recibe como parámetro el nombre del fichero a comprimir y el factor de calidad elegido para la compresión de la imagen.
%El fichero de compresión con su calidad de compresión JPEG

[pathstr,name,ext] = fileparts(fname);
nombrecomp = strcat(name,'.hud');

% Lee archivo de imagen
% Convierte a espacio de color YCbCr
% Amplia dimensiones a multiplos de 8
%  X: Matriz original de la imagen en espacio RGB
%  Xamp: Matriz ampliada de la imagen en espacio YCbCr
[X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(fname);

% Calcula DCT bidimensional en bloques de 8 x 8 pixeles
Xtrans = imdct(Xamp);

% Cuantizacion de coeficientes
Xlab=quantmat(Xtrans, caliQ);

% Genera un scan por cada componente de color
%  Cada scan es una matriz mamp x namp
%  Cada bloque se reordena en zigzag
XScan=scan(Xlab);

% Codifica los tres scans, usando Huffman por defecto y recibimos el bitstream para
%cada dimensión
[CodedY,CodedCb,CodedCr]=EncodeScans_dflt(XScan);

%Convertimos CodedY a bytes
[sbytesCodedY, ultlCodedY]=bits2bytes(CodedY);

%Convertimos CodedCb a bytes
[sbytesCodedCb, ultlCodedCb]=bits2bytes(CodedCb);

%Convertimos CodedCr a bytes
[sbytesCodedCr, ultlCodedCr]=bits2bytes(CodedCr);


%Obtenemos los datos que queremos escribir en el archivo en formato uint8 y
%uint32 como hacíamos en TxCompressor.m de la práctica 2
umamp = uint32(mamp);
unamp = uint32(namp);
ucaliQ = uint32(caliQ);
um = uint32(m);
un = uint32(n);

uCodedY = sbytesCodedY;
uCodedCb = sbytesCodedCb;
uCodedCr = sbytesCodedCr;

ulenCodedY = uint32(length(sbytesCodedY));
ulenCodedCb = uint32(length(sbytesCodedCb));
ulenCodedCr = uint32(length(sbytesCodedCr));

uultCodedY = uint8(ultlCodedY);
uultCodedCb = uint8(ultlCodedCb);
uultCodedCr = uint8(ultlCodedCr);

%Escribimos todos los datos en el archivo .hud creado al principio
fid = fopen(nombrecomp,'w');
fwrite(fid,ucaliQ,'uint32');
fwrite(fid,um,'uint32');
fwrite(fid,un,'uint32');
fwrite(fid,umamp,'uint32');
fwrite(fid,unamp,'uint32');

fwrite(fid,ulenCodedY,'uint32');
fwrite(fid,uultCodedY,'uint8');
fwrite(fid,uCodedY,'uint8');

fwrite(fid,ulenCodedCb,'uint32');
fwrite(fid,uultCodedCb,'uint8');
fwrite(fid,uCodedCb,'uint8');

fwrite(fid,ulenCodedCr,'uint32');
fwrite(fid,uultCodedCr,'uint8');
fwrite(fid,uCodedCr,'uint8');

fclose(fid);


% Los datos de cabecera incluyen caliQ,umamp,unamp,un,um:
TCabecera=4+4+4+4+4;
% Los datos del cuerpo incluyen ulenCodedY,ulenCodedCb,ulenCodedCr,
% uultCodedY,uultCodedCb,uultCodedCr, uCodedY,uCodedCb,uCodedCr

TDatos = 4 + 1 + length(uCodedY) + 4 + 1 + length(uCodedCb) + 4 + 1 + length(uCodedCr);

% Tamaño total del fichero comprimido
TC=TCabecera+TDatos; 
% Razón de compresión del fichero 
RCfil = 100*(TO-TC)/TO;

disp('-----------------');
disp(sprintf('%s %s', 'Archivo comprimido:', nombrecomp));
disp(sprintf('%s %d %s %d', 'Tamaño original =', TO, 'Tamaño comprimido =', TC));
disp(sprintf('%s %d %s %d', 'Tamaño cabecera y codigo =', TCabecera, 'Tamaño datos=', TDatos));
disp(sprintf('%s %2.2f %s', 'RC archivo =', RCfil, '%.'));
if RCfil<0
 disp('El archivo original es demasiado pequeño. No se comprime.');
 disp(sprintf('%s %2.2f %s','La cabecera provoca un aumento de tamaño de un ',abs(RCfil), '%.'));
 end
