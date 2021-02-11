function FScanrec=DecodeSingleScan(CodedString,mincodeDC,maxcodeDC,valptrDC,huffvalDC,mincodeAC,maxcodeAC,valptrAC,huffvalAC,tam)

% DecodeScans_dflt: Decodifica los tres scans binarios usando Huffman por defecto
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Nick Kingsbury, University of Cambridge
% Adaptado por Roque Marin

% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   tam: Tamaño del scan a devolver [mamp namp]
% Salidas:
%  XScanrec: Scans reconstruidos de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion DecodeSingleScan:');
end

% Instante inicial
tc=cputime;

% Inicializacion
FScanrec=zeros(tam);
rango = 1:8; % Rango de fila y columna
DCprevio=0;
EOB=[0 0];
ZRL=[240 0];
ptr=1; % Puntero a string CodedScan

% Reconstruye cada MCU del Scan
for r=0:8:(tam(1)-8)
    for c=0:8:(tam(2)-8)
        etiquetas=zeros(1,64); % Inicializa bloque a 0
        cf=1; % Indice de etiquetas a reconstruir
        % Decodifica DC
        [C, ptr]=DecodeWord(ptr, CodedString, mincodeDC, maxcodeDC, valptrDC, huffvalDC);
        if C ~= 0 % Para C=0, no hay bits de posicion
            P=bin2dec(CodedString(ptr:ptr+C-1)); % Posicion P
            ptr=ptr+C;
        else P=0;
        end
        Cpot=2^C;       
        DC=(P<Cpot/2)*(1-Cpot)+P+DCprevio; % Etiqueta para C y P
        DCprevio=DC;
        etiquetas(cf)=DC;
        % Decodifica 63 AC
        % Decodifica primer coeficiente AC
        [ZCdec, ptr]=DecodeWord(ptr, CodedString, mincodeAC, maxcodeAC, valptrAC, huffvalAC);
        C=mod(ZCdec,16); % Categoria C
        if C ~= 0 % Para C=0, no hay bits de posicion
            P=bin2dec(CodedString(ptr:ptr+C-1)); % Posicion P
            ptr=ptr+C;
        else P=0;
        end
        while any([ZCdec P] ~= EOB)
            Z=0;
            while all([ZCdec P] == ZRL)
                Z = Z + 16;
                [ZCdec, ptr]=DecodeWord(ptr, CodedString, mincodeAC, maxcodeAC, valptrAC, huffvalAC);
                C=mod(ZCdec,16); % Categoria C
                if C ~= 0 % Para C=0, no hay bits de posicion
                    P=bin2dec(CodedString(ptr:ptr+C-1)); % Posicion P
                    ptr=ptr+C;
                else P=0;
                end 
            end
            Z=Z+fix(ZCdec/16); % Nº de Ceros
            cf=cf+Z+1; % Indice de siguiente etiqueta no nula
            Cpot=2^C;
            etiq=(P<Cpot/2)*(1-Cpot)+P; % Etiqueta para C y POS      
            etiquetas(cf)=etiq;
            % Decodifica siguiente coeficiente AC
            [ZCdec, ptr]=DecodeWord(ptr, CodedString, mincodeAC, maxcodeAC, valptrAC, huffvalAC);
            C=mod(ZCdec,16); % Categoria C
            if C ~= 0 % Para C=0, no hay bits de posicion
                P=bin2dec(CodedString(ptr:ptr+C-1)); % Posicion P
                ptr=ptr+C;
            else P=0;
            end
        end
            % EOB detectado
            % Guardar bloque de etiquetas
            FScanrec(r+rango,c+rango)=(reshape(etiquetas,8,8))';
        end
    end

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Componente decodificada');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado DecodeSingleScan');
end