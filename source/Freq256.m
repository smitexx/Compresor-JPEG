function FREQ = Freq256(x)

% Cuenta frecuencia de caracteres en un vector x con enteros en [0,255]
% Hay un offset: FREQ(1) es frecuencia de entero 0

% Entradas
%   x: Vector (fila o columna) con enteros en [0, 255] (Secuencia de mensajes de una fuente)

% Salidas:
%   FREQ: Vector columna de 256 enteros con las frecuencias de los enteros presentes 
%       en la secuencia x indexada por enteros 0 a 255 
%       Hay un offset: FREQ(1) es frecuencia de entero 0

% Control de verbosidad
disptext=0;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion Freq256:');
end

% Calcula frecuencias FREQ(i) de enteros i en [0, 255]
% Hay un offset: FREQ(1) es frecuencia de entero 0
FREQ=zeros(256,1);
for i=0:255
    j=find(x==i); % Posiciones en x donde aparece el codigo i
    FREQ(i+1)=length(j);
end

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado Freq256');
    disp('--------------------------------------------------');
end