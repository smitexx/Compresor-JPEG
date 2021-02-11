function [EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL)

% Genera las tablas  EHUFCO y EHUFSI a partir de HUFFSIZE Y HUFFCODE

% Entradas
%   HUFFSIZE: Vector columna con las longitudes de todas las palabras codigo
%       Esta ordenado por longitudes crecientes
%   HUFFCODE: Vector columna con palabras codigo expresadas en decimal
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Los codigos se generan a partir de 0, incrementando una unidad
%       Cuando se pasa a un nuevo grupo de longitudes, se suma 1
%       al codigo anterior y se multiplica por 2 (desplazamiento de bits SLL)

% Salidas:
%   EHUFCO: Vector columna con palabras codigo expresadas en decimal
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%   EHUFSI: Vector columna con las longitudes de todas las palabras codigo
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)

% Basado en ITU T.81, Anexo C
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge
% Adaptado por Roque Marin

% Control de verbosidad
disptext=0;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion HCodingTables:');
end

% Order Huffman code tables (JPEG fig C3):
EHUFCO = zeros(256,1);
EHUFSI = zeros(256,1);
EHUFCO(HUFFVAL+1) = HUFFCODE;
EHUFSI(HUFFVAL+1) = HUFFSIZE;

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado HCodingTables');
    disp('--------------------------------------------------');
end