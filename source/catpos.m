function CP = catpos(val)

% catpos: % Calcula Categoria y Posicion de un valor DC
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Nick Kingsbury, University of Cambridge
% Adaptado por Roque Marin

% Entradas:
%   val: Un valor DCdiff o un vector de valores DCdiff 
% Salidas:
%   CP: Categoria y Posicion de los valores en val
%       Es un vector, si val es un escalar
%       Es una matriz, si val es unvector
%       Col 1: C (Categoria)
%       Col 2: P (Posicion en categoria)

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion catpos:');
end

% Instante inicial
tc=cputime;

% Categorias y posiciones de valores en val
CP=[];
for i=1:length(val)
    C=ceil(log2(abs(val(i))+1));
    P=(val(i)<0).*(2.^C-1)+val(i);
    CP=[CP; C P];
end

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('C y P calculado');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado catpos');
end