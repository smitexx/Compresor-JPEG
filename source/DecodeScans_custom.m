function XScanrec = DecodeScans_custom(CodedY, CodedCb, CodedCr, size , BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC,HUFFVAL_Y_AC, BITS_C_DC, HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC)

% DecodeScans_dflt: Decodifica los tres scans binarios usando Huffman a
% medida

% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   size: Tamaño del scan a devolver [mamp namp]
%   BITS_Y_XC: Tabla BITS de Luminancia
%   HUFFVAL_Y_XC: Tabla de palabras de Luminancia
%   BITS_C_XC: Tabla BITS de Crominancia
%   HUFFVAL_C_XC: Tabla de palabras de Crominancia
% Salidas:
%  XScanrec: Scans reconstruidos de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3

% Construir tablas Huffman para Luminancia y Crominancia
% Genera Tablas Huffman a medida, que no se archivaran
% Tablas de luminancia
% Tabla Y_DC
[MINCODE_Y_DC,MAXCODE_Y_DC,VALPTR_Y_DC] = HufDecodTables_custom(BITS_Y_DC, HUFFVAL_Y_DC);
% Tabla Y_AC
[MINCODE_Y_AC,MAXCODE_Y_AC,VALPTR_Y_AC] = HufDecodTables_custom(BITS_Y_AC, HUFFVAL_Y_AC);
% Tablas de crominancia
% Tabla C_DC
[MINCODE_C_DC,MAXCODE_C_DC,VALPTR_C_DC] = HufDecodTables_custom(BITS_C_DC, HUFFVAL_C_DC);
% Tabla C_AC
[MINCODE_C_AC,MAXCODE_C_AC,VALPTR_C_AC] = HufDecodTables_custom(BITS_C_AC, HUFFVAL_C_AC);

% Decodifica en binario cada Scan
% Las tablas de crominancia se aplican, tanto a Cb, como a Cr
YScanrec=DecodeSingleScan(CodedY, MINCODE_Y_DC,MAXCODE_Y_DC,VALPTR_Y_DC,HUFFVAL_Y_DC,MINCODE_Y_AC,MAXCODE_Y_AC,VALPTR_Y_AC,HUFFVAL_Y_AC,size);
CbScanrec=DecodeSingleScan(CodedCb, MINCODE_C_DC,MAXCODE_C_DC,VALPTR_C_DC,HUFFVAL_C_DC,MINCODE_C_AC,MAXCODE_C_AC,VALPTR_C_AC,HUFFVAL_C_AC,size);
CrScanrec=DecodeSingleScan(CodedCr, MINCODE_C_DC,MAXCODE_C_DC,VALPTR_C_DC,HUFFVAL_C_DC,MINCODE_C_AC,MAXCODE_C_AC,VALPTR_C_AC,HUFFVAL_C_AC,size);

% Reconstruye matriz 3-D
XScanrec=cat(3,YScanrec,CbScanrec,CrScanrec);
