function [DC_CP, AC_ZCP]=CollectScan(Scan)

% CollectScan: Recolecta valores a codificar (no recolecta frecuencias)
% En la version 1, si se recolectan frecuencias
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Nick Kingsbury, University of Cambridge
% Adaptado por Roque Marin

% Entradas:
%   Scan: Scan de un plano de color P, matriz mamp x namp
%       con nbv x nbh bloques 8x8, cada uno en orden zigzag
% Salidas:
%   DC_CP: Diferencias entre DC de bloques adyacentes
%       Tamaño: (nbv * nbh) x 2
%       Col 1: C (Categoria)
%       Col 2: P (Posicion en categoria)
%   AC_ZCP: Scan codificado codigo/ longitud de palabra
%       Tamaño: Filas indeterminadas. Columnas: 2
%       Col 1: ZCdec (Par Z/C en decimal)
%       Col 2: P (Posicion en categoria)

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion CollectScan:');
end

% Instante inicial
tc=cputime;

% Dimensiones
tam=size(Scan);

% Recorre cada scan y actualiza valores
rango = 1:8; % Rango de fila y columna
DC_diff = [];
AC_ZCP = [];
DCprevio=0;
for r=0:8:(tam(1)-8)
    for c=0:8:(tam(2)-8)
        % Convierte las 64 etiquetas del bloque en un vector
        etiquetas = reshape((Scan(r+rango,c+rango))',1,64);
        % Calcula Categoria y Posicion de la diferencia DC
        DC_diff=[DC_diff; (etiquetas(1)- DCprevio)];
        DCprevio=etiquetas(1);
        % Calcula ceros, categoria y posicion de 63 coeficientes AC
        ac=etiquetas(2:64);
        ZCP=zercatpos(ac);
        % Actualiza AC_ZCP
        AC_ZCP = [AC_ZCP; ZCP];
    end
end
% Calcula categoria y posicion de diferencias coeficientes DC
DC_CP=catpos(DC_diff);

% Repeat the encoding process using the custom designed huffman tables.
% No implementado, por ahora
% Uso solo tablas huffman por defecto

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Valores de scan recolectados');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado CollectScan');
end