function CodedScan=EncodeSingleScan(FScan, DC_CP, AC_ZCP, ehufDC, ehufAC)

% EncodeScans_dflt: Codifica en binario los tres scan usando Huffman por defecto
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge
% Adaptado por Roque Marin

% Entradas:
%   FScan: Scan cde una componente Y, Cb o Cr: Matriz mamp x namp
%   DC_CP: Valores DC a codificar
%   AC_ZCP: Valores AC a codificar
%   ehufDC: Es la concatenacion [EHUFCO EHUFSI] para valores DC_CP del scan
%   ehufAC: Es la concatenacion [EHUFCO EHUFSI] para valores AC_ZCP del scan
% Salidas:
%   CodedF: String binario con scan F codificado

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion EncodeSingleScan:');
end

% Instante inicial
tc=cputime;

% Codifica en binario el Scan
% Inicializacion
tamDC=size(DC_CP);
EOB=[0 0];
j=1; % Recorre filas de AC_ZCP
CodedScan=''; % String vacio

for i=1:tamDC(1) % Para cada bloque MCU
    % Codifica DC del bloque i
    % Categoria y posicion del DC
    % Mensaje es C=DC_CP(i,1) 
    % pero en ehuf los indices tienen offset 1
    C=DC_CP(i,1); % C. Indice a ehuf es C+1
    P=DC_CP(i,2); % P
    ehufvals=ehufDC(C+1,:); % offset 1
    % Añade bits de palabra codigo de C
    CodedScan=[CodedScan dec2bin(ehufvals(1), ehufvals(2))];
    % Añade bits de posicion P
    CodedScan=[CodedScan dec2bin(P, C)];
    % Recorrer tabla AC_ZCP hasta fin de bloque
    % Codificar cada valor Zdec y sus bits de posicion
    while any(AC_ZCP(j,:) ~= EOB)
        % Mensaje es Zdec=AC_ZCP(i,1) 
        % pero en ehuf los indices tienen offset 1
        ZCdec=AC_ZCP(j,1); % ZC. Indice a ehuf es ZCdec +1
        C=rem(ZCdec,16);
        P=AC_ZCP(j,2); % Posicion
        ehufvals=ehufAC(ZCdec+1,:); % offset 1
        % Añade bits de palabra codigo ZCdec
        CodedScan=[CodedScan dec2bin(ehufvals(1), ehufvals(2))];
        % Añade bits de posicion P
        CodedScan=[CodedScan dec2bin(P, C)];
        j=j+1; % Siguiente fila de AC_ZCP
    end 
    % Insertar codigo de EOB
    ZCdec=AC_ZCP(j,1); % ZC. Indice a ehuf es ZCdec +1
    C=rem(ZCdec,16);
    P=AC_ZCP(j,2); % Posicion
    ehufvals=ehufAC(ZCdec+1,:); % offset 1
    % Añade bits de palabra codigo ZCdec
    CodedScan=[CodedScan dec2bin(ehufvals(1), ehufvals(2))];
    % No añade bits de posicion P
    j=j+1;
end


% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Componente codificada en binario');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado EncodeSingleScan');
end