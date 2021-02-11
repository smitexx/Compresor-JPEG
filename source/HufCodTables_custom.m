function [ehuf,BITS,HUFFVAL] = HufCodTables_custom(matriz)

% Genera tablas de codificacion a medida
% Entrada:
    %matriz: Matriz de valores
% Salida:
%   ehuf: Es la concatenacion [EHUFCO EHUFSI], donde;
%     EHUFCO: Vector columna con palabras codigo expresadas en decimal
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%     EHUFSI: Vector columna con las longitudes de todas las palabras codigo
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%   BITS: es el numero de palabras que hay de distintos tamaños
%   HUFFVAL: Tabla con los simbolos de las longitudes

%Calculamos las frecuencias de valores
freq = Freq256(matriz);
% Carga tablas de especificacion Huffman por frecuencias de valores
[BITS,HUFFVAL] = HSpecTables(freq);
% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
% Construye Tablas de Codificacion Huffman
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL);
ehuf=[EHUFCO EHUFSI];

