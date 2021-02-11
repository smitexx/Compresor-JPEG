function imprimirResultadosImagen(fname)

%Factores de calidad utilizados para el estudio
factores = [1 , 25, 50,  100, 250, 500, 1000];

%Inicialización de variables necesarias para guardar resultados.
[pathstr,name,ext] = fileparts(fname);
nombreDes = strcat(name,".hud")
valsMSE_D = zeros(length(factores),1);
valsRC_D = zeros(length(factores),1);

valsMSE_C= zeros(length(factores),1);
valsRC_C = zeros(length(factores),1);

%Bucle que comprime y descomprime una imagen para los 7 factores de calidad.
for i = 1:7
       
      %Comprimimos con jpeg por default y descomprimimos la imagen
      RC_defC = jcom_dflt(fname,factores(i));
     [RC_defD,MSE_defD] = jdes_dflt(nombreDes);
     
     %Comprimimos con jpeg custom y descomprimimos la imagen
     RC_cusC = jcom_custom(fname,factores(i));
     [RC_cusD,MSE_cusD] = jdes_custom(nombreDes);
     
    valsMSE_D(i,1) = MSE_defD;
    valsRC_D(i,1) = RC_defD;
    
    valsMSE_C(i,1) = MSE_cusD;
    valsRC_C(i,1) = RC_cusD;
end
    %Creamos una tabla con la información y la guardamos en un fichero
    %.xlsx para después decorarla en excel
    t = table(transpose(factores), valsMSE_D, valsMSE_C, valsRC_D, valsRC_C)
    writetable(t,'tablasImgs.xlsx','Sheet',1);

    %Imprimimos las gráficas
    %Utilizamos semilogy para que los MSE <Eje Y> se muestren como
    %Log(MSE)como se indica en el guión final.
    %Ponemos '-*? para que los puntos en la gráfica se marquen
    %El Eje_x es RC
    %El EJE_Y es Log(MSE)
	
    Y_def =valsMSE_D;
    X_def = valsRC_D;

    Y_custom = valsMSE_C;
    X_custom = valsRC_C;

    figure
    semilogy(X_def, Y_def, '-*',X_custom, Y_custom, '-*');
    minDef = min(valsRC_D);
    minCus = min(valsRC_C);
    minimo = min(minDef, minCus);
    xlim([minimo, 100])
    xlabel('RC %');
    ylabel('MSE');

    legend({'Huffman dflt', 'Huffman custom'}, 'Location', 'northwest');

    titulo = strcat('MSE y RC para:  ', fname);
    subtitulo = 'Factores de Calidad: ';
    subtitulo = strcat(subtitulo, int2str(factores));

    title({titulo, subtitulo});