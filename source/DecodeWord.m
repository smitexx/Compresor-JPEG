function [val,ptr]=DecodeWord(ptr, CodedString, mincode, maxcode, valptr, huffval)

% DecodeWord: Decodifica siguiente palabra
% Decodifica CodedFrame en una pasada para los tres Scans
% Basado en ITU T.81, Anexos K, C y F
% Adaptado por Roque Marin

% Entradas:
%   ptr: Puntero a CodedString
%   CodedString: String binario con scan codificado
%   mincode: Codigo mas pequeño de cada longitud
%       Tamaño: DC: 9 x 1, AC: 16 x 1
%   maxcode: Codigo mas grande de cada longitud
%       Tamaño: DC: 9 x 1, AC: 16 x 1
%   valptr: Indice al primer valor de huffval que
%       se decodifica con una palabra de long. i
%       Tamaño: DC: 9 x 1, AC: 16 x 1
%   huffval: Mensajes ordenados por long de palabra creciente
%       Tamaño: nºmensajes x 1
% Salidas:
%   val: Valor decodificado
%       Para etiquetas DC es una categoria C
%       Para etiquetas AC es un par Z/C en forma decimal: ZCdec
%   ptr: Nuevo puntero a CodedString


disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion DecodeWord:');
end

% Instante inicial
tc=cputime;

% Decodificar siguiente palabar en CodedString, bit a bit
i=1; % Contador de bits de palabra
code=CodedString(ptr);
while bin2dec(code) > maxcode(i)
    ptr=ptr+1;
    code=[code CodedString(ptr)];
    i=i+1;
end
j=valptr(i);
j=j+bin2dec(code)-mincode(i);
val=huffval(j);
ptr=ptr+1;

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Palabra detectada');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado DecodeWord');
end