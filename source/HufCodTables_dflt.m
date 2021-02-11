function ehuf = HufCodTables_dflt(tipo)

% Genera tablas de codificacion por defecto
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge

% Entradas:
%   tipo:
%       If tipo = 1, the default luminance DC coefficient table is generated (Y_DC)
%       If tipo = 2, the default chrominance DC coefficient table is generated (C_DC)
%       If tipo = 3, the default luminance AC coefficient table is generated (Y_AC)
%       If tipo = 4, the default chrominance AC coefficient table is generated (C_AC)
%       Las tablas de crominancia C_DC y C_AC se aplican, tanto a Cb, como a Cr
% Salidas
%   ehuf: Es la concatenacion [EHUFCO EHUFSI], donde;
%     EHUFCO: Vector columna con palabras codigo expresadas en decimal
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%     EHUFSI: Vector columna con las longitudes de todas las palabras codigo
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)


% Carga tablas de especificacion Huffman por defecto
[BITS,HUFFVAL] = huffdflt(tipo); % Default tables DC
% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
% Construye Tablas de Codificacion Huffman
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL);
ehuf=[EHUFCO EHUFSI];


