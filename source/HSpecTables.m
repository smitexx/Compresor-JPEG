function [BITS, HUFFVAL] = HSpecTables(FREQ)

% Genera las tablas BITS y HUFFVAL a partir de 256 frecuencias en FREQ
% Tiene en cuenta offset 1: Mensajes 0 a 255 -> indices 1 a 256
% Añade un codigo adicional reservado: Mensaje 256 con frecuencia 1
%   para evitar que se use la palabra 1111...11

% Entradas
%   FREQ: Vector columna de 256 enteros con frecuencias de los enteros presentes 
%   en la secuencia, indexada por enteros 0 a 255 
%   Hay un offset: FREQ(1) es frecuencia de entero 0

% Salidas:
%   BITS: Vector columna con el nº de palabras codigo de cada longitud (de 1 hasta 16)
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255

% Basado en ITU T.81, Anexo K
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge
% Adaptado por Roque Marin

% Control de verbosidad
disptext=0;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion HSpecTables:');
end

% Añade un codigo adicional (Mensaje 256 con frecuencia 1
%   para evitar que se use la palabra 1111...11
%   Decimos que reservamos un punto del codigo
FREQ(257)=1;

% Inicializa lista de tamaños de codigo y punteros de lista enlazada
codesize = zeros(257,1);
others = -ones(257,1); % Valor -1 termina una cadena de indices

% Procedure Code_size (JPEG fig K.1): Find Huffman code sizes 
% Find non-zero entries in freq and loop until 1 entry left.
nz = find(FREQ > 0);
while length(nz) > 1
    % Find v1 for least value of freq(v1) > 0.
    [y,i] = min(FREQ(nz));
    v1 = nz(i);
    % Find v2 for next least value of freq(v2) > 0.
    nz = nz([1:(i-1)  (i+1):length(nz)]);  % Remove v1 from nz.
    [y,i] = min(FREQ(nz));
    v2 = nz(i);
    % Combine frequency values to gradually reduce the code table size.
    FREQ(v1) = FREQ(v1) + FREQ(v2);
    FREQ(v2) = 0;
    % Increment the codeword lengths for all codes in the two combined sets.
    % Set 1 is v1 and all its members, stored as a linked list using 
    % non-negative entries in vector others(). The members of set 1 are the
    % frequencies that have already been combined into freq(v1).
    codesize(v1) = codesize(v1) + 1;
    while others(v1) > -1
        v1 = others(v1);
        codesize(v1) = codesize(v1) + 1;
    end
    others(v1) = v2; % Link set 1 with set 2.
    % Set 2 is v2 and all its members, stored as a linked list using 
    % non-negative entries in vector others(). The members of set 2 are the
    % frequencies that have already been combined into freq(v2).
    codesize(v2) = codesize(v2) + 1;
    while others(v2) > -1
        v2 = others(v2);
        codesize(v2) = codesize(v2) + 1;
    end
    nz = find(FREQ > 0);
end

% Asumimos que las probabilidades son suficientemente grandes
%   para que no haya palabras con longitud mayor que 32
%   En caso contrario, el algoritmo no es valido
% Code length limited to 32?
if max(codesize) > 32
  disp('Warning! HUFFDES.M: max(codesize) > 32'); % This should not happen. Abort.
end

% Procedure Count_BITS (JPEG fig K.2): Find no. of codes of each size
BITS = zeros(32,1);
for i = 1:257,
  if codesize(i) > 0 
    BITS(codesize(i)) = BITS(codesize(i)) + 1;
  end
end

% Procedure Adjust_BITS (JPEG fig K.3): Reduce max code length to 16
BITS = AdjustBits(BITS);

% Procedure Sort_input (JPEG fig K.4):
%   Genera HUFFVAL
%   Ensambla los mensajes en orden creciente de longitud de palabra
%   Corresponde a mensajes con frecuencia decreciente
%   Usar codesize en lugar de BITS no cambia la ordenacion
HUFFVAL = [];
for i=1:32
    for j=1:256
        if codesize(j) == i
            HUFFVAL = [HUFFVAL; j];
        end
    end
end

% Correct for indexes going 1:256 instead of 0:255.
HUFFVAL = HUFFVAL - 1;

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado HSpecTables');
    disp('--------------------------------------------------');
end