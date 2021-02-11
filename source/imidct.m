function Xamprec = imidct(Xtrans, m, n)

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Reconstruye una imagen YCbCr con tamaño ampliado

% Entradas:
%  Xtrans: Matriz transformada de X, ampliada a dimensiones multiplo de 8 
%  m: Alto de la imagen original (nº de filas)
%  n: Ancho de la imagen original (nº de columnas)
% Salidas:
%  Xrec: Imagen reconstruida por iDCT, de tamaño original m x n

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion imidct:');
end

% Instante inicial
t=cputime;

% Separa las matrices bidimensionales transformadas por color
%  para procesar separadamente
Ytrans=Xtrans(:,:,1);
Cbtrans=Xtrans(:,:,2);
Crtrans=Xtrans(:,:,3);

% Calcula iDCT bidimensional de cada matriz de color en bloques de 8 x 8 pixeles
% Como tamaño ya es multiplo de 8, blkproc no rellena con 0
T = dctmtx(8); % Construye matriz DCT de 8x8
XYtrans=blkproc(Ytrans, [8 8], 'P1*x*P2',T',T);
XCbtrans=blkproc(Cbtrans, [8 8], 'P1*x*P2',T',T);
XCrtrans=blkproc(Crtrans, [8 8], 'P1*x*P2',T',T);

% Reconstruye la matriz RGB
Xamprec=cat(3,XYtrans,XCbtrans,XCrtrans);

% Suma 128
Xamprec=Xamprec+128;

% Tiempo de ejecucion
e=cputime-t;

if disptext
    disp(sprintf('%s %1.0f %s %1.0f', 'Imagen reconstruida de de ancho x alto:', n,'x',m));
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado imidct');
end
