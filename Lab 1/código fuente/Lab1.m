% Rutas de las imágenes (imagen con flash y sin flash)
flashImagePath = 'carpet_00_flash.jpg';
noFlashImagePath = 'carpet_01_noflash.jpg';

% Leer las imágenes
flashImage = im2double(imread(flashImagePath));
noFlashImage = im2double(imread(noFlashImagePath));

% Paso 1: Extraer color e intensidad de la imagen con flash
[colorFlash, intensityFlash] = getColorAndIntensity(flashImagePath);

% Paso 2: Extraer detalles de la imagen con flash (que tiene mejores detalles)
[detailFlash, ~] = calculateDetailLayer(intensityFlash);

% Paso 3: Extraer la intensidad y el large scale de la imagen sin flash
[~, intensityNoFlash] = getColorAndIntensity(noFlashImagePath);
largeScaleNoFlash = calculateLargeScale(intensityNoFlash, size(noFlashImage, 1));

% Paso 4: Detección de sombras (umbra)
[umbraMask, deltaI] = findUmbraMask(flashImage, noFlashImage);

% Paso 5: Combinar imágenes utilizando detalles de la imagen con flash y large scale de la imagen sin flash
finalImage = combineImages(detailFlash, colorFlash, largeScaleNoFlash, umbraMask);

% Mostrar la imagen combinada
imshow(finalImage);
title("Imagen combinada");
