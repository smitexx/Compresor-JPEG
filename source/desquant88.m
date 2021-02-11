function y=desquant88(x,P1);

% Descuantiza una matriz de etiquetas x
%  aplicando tabla de cuantizacion P1 de 8x8

% Entradas:
%  x: Matriz de 8x8 con etiquetas a decuantizar
%  P1: Tabla de cuantizacion 8x8
% Salidas:
%  y: Matriz de 8x8 con coeficientes ecuantizados

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion quant88:');
end

y=x.*P1;

if disptext
    disp('Terminado');
    disp('--------------------------------------------------');
end




