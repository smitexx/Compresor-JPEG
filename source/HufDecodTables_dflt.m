function [MINCODE,MAXCODE,VALPTR,HUFFVAL] = HufDecodTables_dflt(tipo)


% Genera tablas de decodificacion por defecto
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge

% Entradas:
%   tipo:
%       If tipo = 1, the default luminance DC coefficient table is generated (Y_DC)
%       If tipo = 2, the default chrominance DC coefficient table is generated (C_DC)
%       If tipo = 3, the default luminance AC coefficient table is generated (Y_AC)
%       If tipo = 4, the default chrominance AC coefficient table is generated (C_AC)
%       Las tablas de crominancia C_DC y C_AC se aplican, tanto a Cb, como a Cr
% Salidas:
%   MINCODE: Codigo mas pequeño de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255

% Carga tablas de especificacion Huffman por defecto
[BITS,HUFFVAL] = huffdflt(tipo); % Default tables DC
% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
% Construye Tablas de Decodificacion Huffman
[MINCODE,MAXCODE,VALPTR]=HDecodingTables(BITS, HUFFCODE);


