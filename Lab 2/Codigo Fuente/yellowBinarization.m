function binary_image = yellowBinarization(rgb_image)
    % YELLOWBINARIZATION convierte una imagen RGB en una imagen binaria
    % donde los objetos amarillos aparecen en blanco y el resto en negro.
    % Usa una técnica de normalización para mejorar la detección de
    % colores específicos, enfocándose en la relación entre los canales
    % de color para identificar el amarillo.
    %
    % Parámetros:
    %   rgb_image: Imagen en formato RGB (matriz MxNx3).
    %
    % Devoluciones:
    %   binary_image: Imagen binaria (matriz MxN) donde los objetos amarillos
    %                 tienen un valor de 255 y todos los demás píxeles tienen un valor de 0.

    % Normalización de los canales R, G y B
    norm_R = double(rgb_image(:,:,1)) ./ (double(rgb_image(:,:,1)) + double(rgb_image(:,:,2)) + double(rgb_image(:,:,3)) + 1e-5);
    norm_G = double(rgb_image(:,:,2)) ./ (double(rgb_image(:,:,1)) + double(rgb_image(:,:,2)) + double(rgb_image(:,:,3)) + 1e-5);
    norm_B = double(rgb_image(:,:,3)) ./ (double(rgb_image(:,:,1)) + double(rgb_image(:,:,2)) + double(rgb_image(:,:,3)) + 1e-5);

    % Crear máscara binaria basada en la relación entre los canales
    yellow_mask = (norm_R > 0.4) & (norm_G > 0.4) & (norm_B < 0.2);

    % Refinar la detección de amarillo usando umbrales en intensidad
    intensity = rgb2gray(rgb_image);
    yellow_mask = yellow_mask & (intensity > 100);  % Filtrar por brillo para mejorar precisión

    % Operaciones morfológicas para limpiar la máscara
    se = strel('disk', 3);  % Tamaño ajustable según el ruido
    se2 = strel('disk', 7);

    % Erosionar y dilatar para mejorar la detección de objetos
    eroded_mask = imerode(yellow_mask, se);
    binary_image = imdilate(eroded_mask, se2);
    
    % Convertir la máscara final a una imagen binaria con valores de 0 o 255
    binary_image = uint8(binary_image) * 255;
end
