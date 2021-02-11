function ZCP = zercatpos(a)

% zercatpos: % Calcula Ceros, Categoria y Posicion de un bloque 63 AC
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Nick Kingsbury, University of Cambridge
% Es adaptacion directa de runampl
% Adaptado por Roque Marin

% Entradas:
%   a: Un vector de valores AC 63 x 1 
% Salidas:
%   ZCP: Ceros, Categoria y Posicion de los valores en val
%       Tamaño: filas indeterminadas x 3
%       Col 1: Zdec (Par Z/C en decimal)
%       Col 2: P (Posicion en categoria)

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion zercatpos:');
end

% Instante inicial
tc=cputime;

% Primero genera matriz ra
% Convert a vector of quantised values into run,ampl form.
% Column 1 of ra gives the runs of zeros between each non-zero value.
% Column 2 gives the JPEG sizes of the non-zero values

% Generate indices to non-zero elements of a.
b = find(a(:));
if isempty(b),
    ZCP = [0 0]; % EOB
    return
end

% List non-zero elements as a column vector.
c = reshape(a(b),length(b),1);

% Generate JPEG size vector ca = floor(log2(abs(c))+1)
ca = zeros(size(c));
k = 1;
cb = abs(c);
maxc = max(cb);
ka = 1;

% Form ca, and ka containing increasing powers of 2. 
while k <= maxc,
  ca = ca + (cb >= k);
  k = k * 2;
  ka = [ka; k];
end

% Find negative elements of c and add (2^ca - 1) to these to give the
% residuals of length ca bits.
cneg = find(c < 0);
c(cneg) = c(cneg) + ka(ca(cneg)+1) - 1;

% Assemble the 3 columns of ra.
ra=[diff([0;b])-1 ca c];

% Add end-of-block code (0,0,0) to all blocks for easy decoding.
ra = [ra; [0 0 0]];

% Convertir ZRLs
[r,c] = size(ra);
ZCP = [];
for i=1:r,
    run = ra(i,1);
    % If run > 15, use repeated codes for 16 zeros.
    while run > 15
        Zcdec = 15*16; 
        ZCP = [ZCP; [Zcdec 0]];
        run = run - 16;
    end
    % Code the run and size.
    % Si EOB, pone [1 0]
    Zcdec = run*16 + ra(i,2); 
    ZCP = [ZCP; [Zcdec ra(i,3)]];
end


% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Z, C y P calculado');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado zercatpos');
end