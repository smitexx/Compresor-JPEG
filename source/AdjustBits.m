function BITS = AdjustBits(BITS)

% Ajusta la maxima longitud de palabra a 16 bits
% Elimina el punto de codigo reservado

% Control de verbosidad
disptext=0;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion AdjustBits:');
end

% Procedure Adjust_BITS (JPEG fig K.3): Reduce max code length to 16
I=32;
while I ~= 16
    if BITS(I) > 0
        J = I - 1;
        J = J - 1;
        while BITS(J) == 0
            J = J- 1;
        end
        BITS(I) = BITS(I) - 2; % Elimina dos de las palabras mas largas
        BITS(I-1) = BITS(I-1) + 1; % El prefijo se asigna a una de ellas
        BITS(J) = BITS(J) - 1; % Elimina un codigo de la siguiente longitud
        BITS(J+1) = BITS(J+1) + 2; % Su prefijo se asigna a las dos palabras huerfanas
    else 
        I = I - 1;
    end
end

% Si hay suerte, la palabra mas larga tiene longitud menor que 16
%   y debemos buscar la ultima palabra
while (BITS(I) == 0) & (I ~= 0)
    I = I - 1;
end

% Elimina el punto de codigo reservado (1111...1)
BITS(I) = BITS(I) - 1; 

% Recorta tabla de longitudes (16 o menos)
BITS = BITS(1:I,1); 


% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado AdjustBits');
    disp('--------------------------------------------------');
end