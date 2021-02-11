function XScan=scan(Xlab)

% Genera un scan por cada componente de color
%  Cada scan es una matriz mamp x namp
%  Cada bloque se reordena en zigzag

% Entradas:
%  Xlab: Matriz de etiquetas a procesar: mamp x namp x 3
% Salidas:
%  XScan: Scans de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3
%  compuesta de:
%   YScan: Scan de luminancia Y: Matriz mamp x namp
%   CbScan: Scan de crominancia Cb: Matriz mamp x namp
%   CrScan: Scan de crominancia Cr: Matriz mamp x namp

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion scan:');
end

% Instante inicial
t=cputime;

% Separa las matrices bidimensionales 
%  para procesar separadamente
YXlab=Xlab(:,:,1);
CbXlab=Xlab(:,:,2);
Crlab=Xlab(:,:,3);

% Reordena etiquetas en zig-zag
fun=@zigzag64;
YScan=blkproc(YXlab, [8 8], fun);
CbScan=blkproc(CbXlab, [8 8], fun);
CrScan=blkproc(Crlab, [8 8], fun);

% Recompone  matriz  3-D
XScan=cat(3,YScan,CbScan,CrScan);

% Tiempo de ejecucion
e=cputime-t;

if disptext
    disp('Scans de color en zigzag obtenidos');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado scan');
end