function sbits=bytes2bits(sbytes, ultl)

% Convierte la secuencia de matriz de bytes sbytes en una secuencia de bits sbits

% Entradas:
%   sbytes: array de tipo uint8 de tamaño z x 8 
%       Resulta de concatenar filas de sbytes (segmentos) en un string binario
%       Cada segmento (byte) se almacena en una fila de sbytes
%       Si el ultimo segmento tiene longitud ultl menor que 8,
%       entonces estara relleno con ceros.
%       Los bytes se interpretan como falsos ASCII
%       Por tanto, cada fila es un codigo ASCII entre 0 y 255
%   ultl: Longitud del ultimo segmento sin ceros de relleno
%       Es un numero entre 1 y 8

% Salidas:
%   sbits: Es un string 1 x k char array de '0' y '1'
%       No contiene espacios

% Convierte e uint8 a double para poder operar
sbytes=double(sbytes);
ultl=double(ultl);

% Convierte a bits todo salvo ultimo byte
lensbytes=length(sbytes);
sbits=reshape((dec2bin(sbytes,8))',1,8*lensbytes);
if ultl>0
    sbits=sbits(1:8*(lensbytes-1)+ultl);
end

