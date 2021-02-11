function [MINCODE,MAXCODE,VALPTR] = HufDecodTables_custom(BITS,HUFFVAL)
% Genera tablas de decodificacion a medida
% Entrada:
%   BITS: Numero de palabras que hay de una longitud
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255
% Salidas:
%   MINCODE: Codigo mas pequeño de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a nº de grupos de longitdes

% Construye Tablas del Codigo Huffman
[HUFFSIZE,HUFFCODE] = HCodeTables(BITS, HUFFVAL);

% Construye Tablas de Decodificacion Huffman
[MINCODE,MAXCODE,VALPTR] = HDecodingTables(BITS, HUFFCODE);

