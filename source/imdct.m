function Xtrans = imdct(X)

% Calcula DCT bidimensional en bloques de 8 x 8 pixeles

% Entradas:
%  X: Matriz de imagen original en formato truecolor YCbCr
%     Dimensiones deben ser multiplo de 8 para que no rellene con ceros
% Salidas:
%  Xtrans: Matriz transformada de X

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion imdct:');
end

% Instante inicial
t=cputime;


% Resta offset 128
Xoff=X-128; % Rango [-128, 127]

% Separa las matrices bidimensionales de color
%  para procesar separadamente
Y=Xoff(:,:,1);
Cb=Xoff(:,:,2);
Cr=Xoff(:,:,3);

% Calcula DCT bidimensional de cada matriz de color en bloques de 8 x 8 pixeles
% Como tamaño ya es multiplo de 8, blkproc no rellena con 0
T = dctmtx(8); % Construye matriz DCT de 8x8
XYtrans=blkproc(Y, [8 8], 'P1*x*P2',T,T');
XCbtrans=blkproc(Cb, [8 8], 'P1*x*P2',T,T');
XCrtrans=blkproc(Cr, [8 8], 'P1*x*P2',T,T');

% Recompone  matriz transformada 3-D
Xtrans=cat(3,XYtrans,XCbtrans,XCrtrans);

% Tiempo de ejecucion
e=cputime-t;

if disptext
    disp('Imagen transformada obtenida');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado imdct');
end