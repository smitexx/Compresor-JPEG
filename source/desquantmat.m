function Xtransrec = desquantmat(Xlab, caliQ)

% Dada una matriz de etiquetas Xlab, la descuantiza en bloques de 8x8

% Entradas:
%  Xlab: Matriz de etiquetas (RGB)
%  caliQ: Factor de calidad (entero positivo > 1)
%         1: mejor calidad
%         100: usa las tablas estandar
%         1000: mala calidad
% Salidas:
%  Xtransrec: Matriz transformada reconstruida de la imagen ampliada para 8x8 (YCbCr)

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion desquantmat:');
end

% Instante inicial
t=cputime;

% Separa las matrices bidimensionales 
%  para procesar separadamente
YXlab=Xlab(:,:,1);
CbXlab=Xlab(:,:,2);
CrXlab=Xlab(:,:,3);

% Verificar caliQ: entero >1
caliQ=round(caliQ);
if caliQ <= 0, caliQ=1; end

% Matriz de cuantizacion de luminancia
% Recomendada en ITU T.81
% Aplicable a componente Y
QY = [16  11  10  16  24  40  51  61; ...
     12  12  14  19  26  58  60  55; ...
     14  13  16  24  40  57  69  56; ...
     14  17  22  29  51  87  80  62; ...
     18  22  37  56  68 109 103  77; ...
     24  35  55  64  81 104 113  92; ...
     49  64  78  87 103 121 120 101; ...
     72  92  95  98 112 100 103  99];
% Aplica factor de calidad
QY=max(round(QY*caliQ/100),ones(8,8));

% Matriz de cuantizacion de crominancia
% Recomendada en ITU T.81
% Aplicable a componentes Cb y Cr
QC = [17 18 24 47 99 99 99 99; ...
     18 21 26 66 99 99 99 99; ...
     24 26 56 99 99 99 99 99; ...
     47 66 99 99 99 99 99 99; ...
     99 99 99 99 99 99 99 99; ...
     99 99 99 99 99 99 99 99; ...
     99 99 99 99 99 99 99 99; ...
     99 99 99 99 99 99 99 99];
% Aplica factor de calidad
QC=max(round(QC*caliQ/100),ones(8,8));

% Descuantiza cada matriz de color en bloques de 8 x 8 pixeles
% Aplica tabla de cuantizacion Q
fun=@desquant88;
YXtransrec=blkproc(YXlab, [8 8], fun, QY);
CbXtransrec=blkproc(CbXlab, [8 8], fun, QC);
CrXtransrec=blkproc(CrXlab, [8 8], fun, QC);

% Recompone  matriz de etiquetas 3-D
Xtransrec=cat(3,YXtransrec,CbXtransrec,CrXtransrec);

% Tiempo de ejecucion
e=cputime-t;

if disptext
    disp('Matriz descuantizada obtenida');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado desquantmat');
end