function [color, intensity] = getColorAndIntensity(imagePath)

    % getColorAndIntensity Extrae la información de color e intensidad de una imagen.
    %
    %   [color, intensity] = getColorAndIntensity(imagePath) lee una imagen desde la ruta 
    %   especificada, y calcula tanto los componentes de color normalizados como la intensidad 
    %   de cada píxel.
    %
    %   Entrada:
    %       imagePath - Ruta de la imagen que se desea procesar. La imagen debe estar en 
    %                   formato RGB.
    %
    %   Salida:
    %       color - Imagen de salida con los colores normalizados para cada píxel. Los colores 
    %               están ajustados en función de la intensidad para que su representación sea 
    %               relativa, en lugar de absoluta.
    %       intensity - Imagen en escala de grises que representa la intensidad de cada píxel. 
    %                   La intensidad es el valor máximo a lo largo de los canales RGB.
    %
    %   Proceso:
    %       1. Lee la imagen de la ruta especificada y la convierte a tipo de doble precisión.
    %       2. Separa los tres canales de color (Rojo, Verde y Azul).
    %       3. Calcula la intensidad como el valor máximo de los tres canales para cada píxel.
    %       4. Añade una pequeña constante a la intensidad para evitar divisiones por cero.
    %       5. Normaliza los canales de color dividiéndolos por la intensidad calculada.
    %       6. Combina los canales normalizados en una única imagen de salida.
    %
    %   Notas:
    %       - La constante 0.001 asegura que no haya divisiones por cero al normalizar.
    %       - El valor de intensidad utilizado es el máximo de los tres canales para representar 
    %         el brillo percibido de cada píxel.
    %       - La normalización de los colores ajusta la intensidad de cada canal sin alterar el tono.

    
    % Leer la imagen y convertirla a formato de doble precisión
    RGB = im2double(imread(imagePath));

    % Separar los canales de color directamente en una matriz
    R = RGB(:, :, 1);
    G = RGB(:, :, 2);
    B = RGB(:, :, 3);

    % Calcular la intensidad como el valor máximo a lo largo de los canales
    intensity = max(RGB, [], 3);

    % Asegurar que no haya divisiones por cero
    safeIntensity = intensity + 0.001;

    % Normalizar los canales de color
    norm_R = R ./ safeIntensity;
    norm_G = G ./ safeIntensity;
    norm_B = B ./ safeIntensity;

    % Combinar los canales normalizados en una sola imagen
    color = cat(3, norm_R, norm_G, norm_B);
end
