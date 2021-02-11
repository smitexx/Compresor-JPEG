function [sbytes, ultl]=bits2bytes(sbits)

% Convierte la secuencia de bits del string sbits en una matriz de bytes

% Entradas:
%   sbits: Es un string 1 x k char array de '0' y '1'
%       No contiene espacios

% Salidas:
%   sbytes: array de tipo uint8 de tamaño z x 8 
%       Resulta de trocear el string sbits en segmentos de 8 digitos binarios
%       Cada segmento (byte) se almacena en una fila
%       Si el ultimo segmento tiene longitud ultlon menor que 8,
%       entonces se rellena con ceros.
%       Los bytes se interpretan como falsos ASCII
%       Por tanto, cada fila es un codigo ASCII entre 0 y 255
%   ultl: Longitud del ultimo segmento sin ceros de relleno
%       Es un numero entre 1 y 8

% Convierte a bytes
lens=length(sbits);
f=fix(lens/8); % Nº filas a generar, menos una
nb=8*f; % Nº de bits ocupados por las f filas
ultl=lens-nb; % Nº bits finales
% Pasa de vector a matriz
sbytes=(reshape((sbits(1:nb))',8,f))';
% Añade la ultima fila
if ultl>0
    sbytes(f+1,1:8)=strcat(sbits(nb+1:nb+ultl),dec2bin(0,8-ultl));
end

% Convierte a falsos ASCII de 8 bits
sbytes=uint8(bin2dec(sbytes)); % Convierte a nº entre 0 y 255

