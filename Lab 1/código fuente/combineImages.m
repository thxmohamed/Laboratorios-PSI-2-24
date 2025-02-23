function finalImg = combineImages(detailImg, colorImg, largeScaleImg, shadowMaskImg)
    % combineImages Combina capas de detalles, imagen a gran escala, y máscara de sombras.
    %
    %   finalImg = combineImages(detailImg, colorImg, largeScaleImg, shadowMaskImg)
    %   toma varias imágenes procesadas y una máscara de sombras para generar una imagen final
    %   con detalles preservados, corrección de color, y manejo de sombras.
    %
    %   Entradas:
    %       detailImg - La capa de detalles extraída de la imagen original.
    %       colorImg - Imagen de corrección de color.
    %       largeScaleImg - Imagen a gran escala que contiene la iluminación principal.
    %       shadowMaskImg - Máscara que identifica las áreas con sombras en la imagen.
    %
    %   Salida:
    %       finalImg - La imagen combinada final con detalles preservados, corrección de color
    %                 y ajuste de sombras.
    %
    %   Proceso:
    %       1. Se crea una máscara inversa de sombras (invertida) basada en la máscara de sombras proporcionada.
    %       2. Se preservan los detalles de la imagen multiplicando la capa de detalles por la máscara inversa de sombras.
    %       3. Se preserva la iluminación general multiplicando la imagen a gran escala por la máscara de sombras original.
    %       4. Se combinan los detalles preservados con la iluminación preservada sumando ambas imágenes.
    %       5. Se ajusta el color de la imagen combinada multiplicando por la imagen de corrección de color.
    %       6. Se normaliza la imagen final para que los valores estén entre 0 y 255, y se convierte a formato `uint8` para la visualización.
    %
    %   Notas:
    %       - La función `bsxfun` permite realizar operaciones por cada píxel de las imágenes involucradas.
    %       - La máscara inversa ayuda a diferenciar las áreas de sombra y de luz en la imagen.
    %       - El proceso de normalización asegura que los valores de los píxeles estén en el rango correcto para ser mostrados como imagen.

    % Crear una máscara inversa para las sombras
    inverseShadowMask = 1 - shadowMaskImg;
    
    % Preservar los detalles multiplicando las imágenes pixel por pixel
    detailPreserved = bsxfun(@times, detailImg, inverseShadowMask);
    
    % Preservar la iluminación multiplicando las imágenes pixel por pixel
    largeScalePreserved = bsxfun(@times, largeScaleImg, shadowMaskImg);
    
    % Sumar los detalles preservados y la escala grande preservada
    combinedImg = bsxfun(@plus, detailPreserved, largeScalePreserved);
    
    % Ajustar el color multiplicando por la imagen de corrección de color
    finalImg = bsxfun(@times, combinedImg, colorImg);
    
    % Normalizar el resultado entre 0 y 255 utilizando la función rescale
    finalImg = rescale(finalImg, 0, 255);
    finalImg = uint8(finalImg);
end
