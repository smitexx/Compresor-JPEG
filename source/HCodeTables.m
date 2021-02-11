function [HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL)

% Genera las tablas  HUFFSIZE y HUFFCODE a partir de BITS y HUFFVAL

% Entradas
%   BITS: Vector columna con el nº de palabras codigo de cada longitud (de 1 hasta 16)
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255

% Salidas:
%   HUFFSIZE: Vector columna con las longitudes de todas las palabras codigo
%       Esta ordenado por longitudes crecientes
%   HUFFCODE: Vector columna con palabras codigo expresadas en decimal
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Los codigos se generan a partir de 0, incrementando una unidad
%       Cuando se pasa a un nuevo grupo de longitudes, se suma 1
%       al codigo anterior y se multiplica por 2 (desplazamiento de bits SLL)

% Basado en ITU T.81, Anexo C
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge
% Adaptado por Roque Marin

% Control de verbosidad
disptext=0;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion HCodeTables:');
end

% Generate huffman size table HUFFSIZE (JPEG fig C1):
nb=length(BITS);
k=1;
j=1;
ncodes=sum(BITS);
HUFFSIZE=zeros(ncodes,1);
for i=1:nb,
  while j<=BITS(i)
      HUFFSIZE(k)=i; 
      k=k+1; 
      j=j+1; 
  end	
  j=1;
end

% Generate huffman code table HUFFCODE (JPEG fig C2):
HUFFCODE=zeros(ncodes,1);
code=0;
si=HUFFSIZE(1);
for k=1:ncodes,
  while HUFFSIZE(k)>si,
    code=code*2;
    si=si+1;
  end
  HUFFCODE(k)=code;
  code=code+1;
end

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado HCodeTables');
    disp('--------------------------------------------------');
end