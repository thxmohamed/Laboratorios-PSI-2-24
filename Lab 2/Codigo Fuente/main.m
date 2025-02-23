% main.m - Script para detectar círculos amarillos y dibujar cajas rojas alrededor de ellos

% Paso 1: Solicitar el nombre del archivo de la imagen al usuario
imageFileName = input('Ingrese el nombre del archivo de la imagen (incluyendo la extensión, por ejemplo, "image.png"): ', 's');

% Paso 2: Cargar la imagen
originalImage = imread(imageFileName);

% Verificar si la imagen es RGB
if size(originalImage, 3) ~= 3
    error('La imagen debe ser una imagen RGB (a color).');
end

% Paso 3: Convertir la imagen RGB a una imagen binaria con objetos amarillos
binaryImage = yellowBinarization(originalImage);

% Mostrar la imagen binarizada
imshow(binaryImage)
title('Imagen binarizada con los objetos amarillos')

% Extraer el nombre base y la extensión del archivo de imagen
[~, name, ext] = fileparts(imageFileName);

% Guardar la imagen binarizada con el prefijo 'binary_'
imwrite(binaryImage, strcat('binary_', name, ext));

% Paso 4: Detectar los componentes conectados en la imagen binaria
[borderImage, componentList] = componentsDetection(binaryImage);

% Paso 5: Identificar los componentes circulares
[circularCount, circularComponents] = circleDetection(componentList);

% Paso 6: Dibujar las cajas rojas alrededor de los círculos amarillos
finalImage = highlightBoundingBoxes(originalImage, circularComponents);

% Paso 7: Mostrar la imagen final con las cajas rojas
imshow(finalImage);
title('Imagen con cajas rojas alrededor de los círculos amarillos');

% Guardar la imagen final con el prefijo 'boxes_'
imwrite(finalImage, strcat('boxes_', name, ext));

% Guardar detalles de los componentes en un archivo de texto
saveComponentDetailsToText(componentList, strcat('details_', name, '.txt'));
