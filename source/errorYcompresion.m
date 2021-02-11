function errorYcompresion
%Vectores con el nombre de los porcentajes y el nombre de los archivos originales.
porcentajes = ["_1.jpg","_50.jpg","_100.jpg"];
fileNames = ["Img01.bmp","Img02.bmp","Img03.bmp","Img04.bmp","Img05.bmp","Img06.bmp","Img07.bmp"]

%Bucle para las imágenes.
for i = 1:7
    [pathstr,name,ext] = fileparts(fileNames(i));
    resultados= zeros(length(porcentajes),2);
    %Bucle para los % de los ficheros
    for j = 1:3
        %Leemos la información de los dos ficheros ahora.
        nombreComp = strcat (name,"",porcentajes(j))
        [X, Xamp, tipo, m, n, mamp, namp, TO] = imlee(fileNames(i));
        [Xrec, Xamp, tipo, m, n, mamp, namp, TC] = imlee(nombreComp);
        %Obtenemos medidas de error a partir de la imagen original y datos de
        %archivo comprimido
        RC = 100*(TO-TC)/TO;
        mse=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3);
	%Guardamos en una  matriz distinta para cada imágen.
        resultado(j,1) = RC;
        resultado(j,2) = mse;
    end
	%Creamos la tabla para cada imagen y le cambiamos el nombre a las columnas.
     t = table(transpose(porcentajes), resultado(:,1), resultado(:,2));
     t.Properties.VariableNames = {'PorcentajeCalidad' 'RC' 'MSE'}
     
end
