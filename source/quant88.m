function y=quant88(x,P1);

% Cuantiza una matriz x de 8x8 double
%  aplicando tabla de cuantizacion P1 de 8x8

% Entradas:
%  x: Matriz de 8x8 con valores double a cuantizar
%  P1: Tabla de cuantizacion 8x8
% Salidas:
%  y: Matriz de 8x8 con etiquetas de cuantizacion

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion quant88:');
end

y=floor((x ./ P1) + 0.5);

if disptext
    disp('Terminado');
    disp('--------------------------------------------------');
end




