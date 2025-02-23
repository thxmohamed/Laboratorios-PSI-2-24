function largeScale = calculateLargeScale(intensity, diagonal, mask)
    % calculateLargeScale Calcula la imagen de gran escala a partir de una imagen de intensidad.
    %
    %   largeScale = calculateLargeScale(intensity, diagonal, mask) aplica un filtro guiado 
    %   por imagen para suavizar la imagen de intensidad, preservando los bordes, y devuelve la 
    %   imagen suavizada como el componente de gran escala.
    %
    %   Entrada:
    %       intensity - La imagen de intensidad que se desea suavizar. 
    %                   Debe estar en formato de imagen en grises.
    %       diagonal - La diagonal de la imagen, que se utiliza para ajustar el tamaño del filtro.
    %       mask - (Opcional) Máscara binaria que define regiones de la imagen donde el suavizado
    %              no debe aplicarse. Si no se proporciona, se usará una máscara vacía (sin efecto).
    %
    %   Salida:
    %       largeScale - Imagen suavizada que representa la estructura de gran escala de la imagen
    %                    original.
    %
    %   Proceso:
    %       1. Si no se proporciona una máscara, se inicializa con ceros del tamaño de la imagen.
    %       2. Convierte la imagen de intensidad a tipo 'single' para un procesamiento más eficiente.
    %       3. Calcula el tamaño del vecindario para el filtro guiado según la diagonal de la imagen.
    %       4. Aplica el filtro guiado para suavizar la imagen, preservando los bordes importantes.
    %       5. Convierte el resultado del filtro a tipo 'double' para obtener la imagen de gran escala.
    %       6. Si se proporciona una máscara, aplica la máscara inversa a la imagen de gran escala 
    %          para evitar que se suavicen las regiones enmascaradas.
    %
    %   Notas:
    %       - El filtro guiado por imagen es útil para suavizar imágenes preservando los bordes.
    %       - La máscara inversa asegura que las regiones enmascaradas no sean afectadas por el filtro.
    %       - La división por 'eps' evita problemas numéricos al aplicar la máscara.


    % Verificar si se proporciona una máscara, de lo contrario usar una matriz vacía
    if nargin < 3
        mask = zeros(size(intensity));
    end

    % Convertir la imagen de intensidad a tipo single
    intensitySingle = im2single(intensity);
    
    % Definir el tamaño del vecindario para el filtro guiado por imagen
    neighborhoodSize = 2 * floor(diagonal * 0.015);
    
    % Aplicar el filtro guiado por imagen
    smoothedImage = imguidedfilter(intensitySingle, 'NeighborhoodSize', neighborhoodSize, 'DegreeOfSmoothing', 0.01);
    
    % Convertir el resultado de vuelta a tipo double
    largeScale = im2double(smoothedImage);

    % Aplicar la máscara inversa si se proporciona
    if any(mask(:)) % Verifica si la máscara tiene valores diferentes de cero
        maskInv = 1 - mask;
        largeScale = largeScale ./ (maskInv + eps); % Evitar división por cero
    end
end
