function [MINCODE,MAXCODE,VALPTR] = HDecodingTables(BITS, HUFFCODE)

% Genera las tablas MINCODE,MAXCODE y VALPTR a partir de BITS Y HUFFCODE

% Entradas
%   BITS: Vector columna con el nº de palabras codigo de cada longitud (de 1 hasta 16 max)
%   HUFFCODE: Vector columna con palabras codigo expresadas en decimal
%       Los codigos se generan a partir de 0, incrementando una unidad
%       Cuando se pasa a un nuevo grupo de longitudes, se suma 1
%       al codigo anterior y se multiplica por 2 (desplazamiento de bits SLL)

% Salidas:
%   MINCODE: Codigo mas pequeño de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a nº de grupos de longitdes

% Basado en ITU T.81, Anexo F
% Adaptado por Roque Marin

% Control de verbosidad
disptext=0;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion HDecodingTables:');
end

% Inicializacion
i=0;
j=1;
maxi=length(BITS);

% Construccion de las tablas (JPEG, Fig F.15)
while i < maxi
    i=i+1;
    if BITS(i) == 0
        MAXCODE(i,1)=-1;
    else
        VALPTR(i,1)=j;
        MINCODE(i,1)=HUFFCODE(j);
        j=j+BITS(i)-1;
        MAXCODE(i,1)=HUFFCODE(j);
        j=j+1;
    end
end

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado HDecodingTables');
    disp('--------------------------------------------------');
end