function XScanrec=DecodeScans_dflt(CodedY,CodedCb,CodedCr,tam)

% DecodeScans_dflt: Decodifica los tres scans binarios usando Huffman por defecto
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Nick Kingsbury, University of Cambridge
% Adaptado por Roque Marin

% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   tam: Tamaño del scan a devolver [mamp namp]
% Salidas:
%  XScanrec: Scans reconstruidos de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion DecodeScans_dflt:');
end

% Instante inicial
tc=cputime;

% Construir tablas Huffman para Luminancia y Crominancia
% Tablas Huffman, formato ITU T.81, Anexo C y Anexo K
% Genera Tablas Huffman por defecto, que no se archivaran
% Tablas de luminancia
% Tabla Y_DC
[mincode_Y_DC,maxcode_Y_DC,valptr_Y_DC,huffval_Y_DC] = HufDecodTables_dflt(1);
% Tabla Y_AC
[mincode_Y_AC,maxcode_Y_AC,valptr_Y_AC,huffval_Y_AC] = HufDecodTables_dflt(3);
% Tablas de crominancia
% Tabla C_DC
[mincode_C_DC,maxcode_C_DC,valptr_C_DC,huffval_C_DC] = HufDecodTables_dflt(2);
% Tabla C_AC
[mincode_C_AC,maxcode_C_AC,valptr_C_AC,huffval_C_AC] = HufDecodTables_dflt(4);

% Decodifica en binario cada Scan
% Las tablas de crominancia se aplican, tanto a Cb, como a Cr
YScanrec=DecodeSingleScan(CodedY,mincode_Y_DC,maxcode_Y_DC,valptr_Y_DC,huffval_Y_DC,mincode_Y_AC,maxcode_Y_AC,valptr_Y_AC,huffval_Y_AC,tam);
CbScanrec=DecodeSingleScan(CodedCb,mincode_C_DC,maxcode_C_DC,valptr_C_DC,huffval_C_DC,mincode_C_AC,maxcode_C_AC,valptr_C_AC,huffval_C_AC,tam);
CrScanrec=DecodeSingleScan(CodedCr,mincode_C_DC,maxcode_C_DC,valptr_C_DC,huffval_C_DC,mincode_C_AC,maxcode_C_AC,valptr_C_AC,huffval_C_AC,tam);

% Reconstruye matriz 3-D
XScanrec=cat(3,YScanrec,CbScanrec,CrScanrec);

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Scans decodificados');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado DecodeScans_dflt');
end