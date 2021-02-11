function Xlabrec=invscan(XScan)

% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag

% Entradas:
%  YScan: Scan de luminancia Y: Matriz mamp x namp
%  CbScan: Scan de crominancia Cb: Matriz mamp x namp
%  CrScan: Scan de crominancia Cr: Matriz mamp x namp
% Salidas:
%  Xlabrec: Matriz de etiquetas 3-D de 3 x mamp x namp

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion invscan:');
end

% Instante inicial
t=cputime;

% Separa las matrices bidimensionales 
%  para procesar separadamente
YScan=XScan(:,:,1);
CbScan=XScan(:,:,2);
CrScan=XScan(:,:,3);

% Reordena etiquetas zig-zag en orden natural
fun=@invzigzag64;
YXlab=blkproc(YScan, [8 8], fun);
CbXlab=blkproc(CbScan, [8 8], fun);
CrXlab=blkproc(CrScan, [8 8], fun);

% Recompone  matriz 3-D
Xlabrec=cat(3,YXlab,CbXlab,CrXlab);

% Tiempo de ejecucion
e=cputime-t;

if disptext
    disp('Matriz de etiquetas recuperada a partir de scans');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado invscan');
end