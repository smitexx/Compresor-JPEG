function [CodedY,CodedCb,CodedCr]=EncodeScans_dflt(XScan)

% EncodeScans_dflt: Codifica en binario los tres scan usando Huffman por defecto
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge
% Adaptado por Roque Marin

% Entradas:
%  XScan: Scans de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3
%  compuesta de:
%   YScan: Scan de luminancia Y: Matriz mamp x namp
%   CbScan: Scan de crominancia Cb: Matriz mamp x namp
%   CrScan: Scan de crominancia Cr: Matriz mamp x namp
% Salidas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion EncodeScans_dflt:');
end

% Instante inicial
tc=cputime;

% Separa las matrices bidimensionales 
%  para procesar separadamente
YScan=XScan(:,:,1);
CbScan=XScan(:,:,2);
CrScan=XScan(:,:,3);

% Recolectar valores a codificar
[Y_DC_CP, Y_AC_ZCP]=CollectScan(YScan);
[Cb_DC_CP, Cb_AC_ZCP]=CollectScan(CbScan);
[Cr_DC_CP, Cr_AC_ZCP]=CollectScan(CrScan);

% Construir tablas Huffman para Luminancia y Crominancia
% Tablas Huffman, formato ITU T.81, Anexo C y Anexo K
% Genera Tablas Huffman por defecto, que no se archivaran
% La variable ehuf_X_X es la concatenacion [EHUFCO EHUFSI]
% Tablas de luminancia
% Tabla Y_DC
ehuf_Y_DC = HufCodTables_dflt(1);
% Tabla Y_AC
ehuf_Y_AC = HufCodTables_dflt(3);
% Tablas de crominancia
% Tabla C_DC
ehuf_C_DC = HufCodTables_dflt(2);
% Tabla C_AC
ehuf_C_AC = HufCodTables_dflt(4);

% Codifica en binario cada Scan
% Las tablas de crominancia, ehuf_C_DC y ehuf_C_AC, se aplican, tanto a Cb, como a Cr
CodedY=EncodeSingleScan(YScan, Y_DC_CP, Y_AC_ZCP, ehuf_Y_DC, ehuf_Y_AC);
CodedCb=EncodeSingleScan(CbScan, Cb_DC_CP, Cb_AC_ZCP, ehuf_C_DC, ehuf_C_AC);
CodedCr=EncodeSingleScan(CrScan, Cr_DC_CP, Cr_AC_ZCP, ehuf_C_DC, ehuf_C_AC);

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Componentes codificadas en binario');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado EncodeScans_dflt');
end