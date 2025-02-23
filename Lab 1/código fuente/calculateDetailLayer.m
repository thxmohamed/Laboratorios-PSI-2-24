function [detailLayer, filteredIntensity] = calculateDetailLayer(intensityImage)

    % calculateDetailLayer Extrae la capa de detalles de una imagen de intensidad.
    %
    %   [detailLayer, filteredIntensity] = calculateDetailLayer(intensityImage) aplica un filtro 
    %   gaussiano en el dominio logarítmico para obtener la capa de detalles de la imagen, así como 
    %   una versión suavizada de la intensidad.
    %
    %   Entrada:
    %       intensityImage - Imagen de entrada en escala de grises que representa la intensidad 
    %                        de cada píxel.
    %
    %   Salida:
    %       detailLayer - Imagen resultante que contiene la capa de detalles, la cual enfatiza 
    %                     las texturas y variaciones finas en la imagen original.
    %       filteredIntensity - Imagen suavizada de intensidad, donde los detalles finos han sido 
    %                           eliminados, conservando solo las estructuras más grandes.
    %
    %   Proceso:
    %       1. Convierte la imagen de intensidad a tipo 'double' para realizar operaciones precisas.
    %       2. Aplica un logaritmo a la imagen de intensidad para reducir el rango dinámico y 
    %          facilitar la extracción de detalles.
    %       3. Crea un filtro gaussiano con un tamaño de ventana y desviación estándar definidos.
    %       4. Aplica el filtro gaussiano a la imagen logarítmica para suavizarla.
    %       5. Calcula la capa de detalles restando la versión suavizada del logaritmo de la 
    %          imagen original.
    %       6. Convierte la capa de detalles de nuevo al dominio lineal mediante la exponencial.
    %       7. Normaliza la capa de detalles para que sus valores estén entre 0 y 1.
    %       8. Convierte la imagen suavizada de nuevo al dominio lineal y la normaliza.
    %
    %   Notas:
    %       - La adición de 1e-4 antes de aplicar el logaritmo asegura que no haya problemas 
    %         numéricos debido a valores cercanos a cero.
    %       - El filtro gaussiano suaviza las variaciones finas en la imagen, permitiendo extraer 
    %         detalles de las estructuras más grandes.
    %       - La capa de detalles se normaliza para mejorar su visualización, asegurando que esté 
    %         dentro del rango [0, 1].

    % Convertir la imagen de intensidad a tipo double
    intensityImage = double(intensityImage);

    % Calcular el logaritmo de la imagen de intensidad
    logIntensity = log10(intensityImage + 1e-4);

    % Crear un filtro gaussiano
    filterSize = 21; % Tamaño del filtro
    sigma = 9; % Desviación estándar
    gaussianFilter = fspecial('gaussian', filterSize, sigma);

    % Aplicar el filtro gaussiano al logaritmo de la imagen
    smoothedLogIntensity = imfilter(logIntensity, gaussianFilter, 'replicate');

    % Calcular la capa de detalles restando el logaritmo suavizado de la imagen
    logDetailLayer = logIntensity - smoothedLogIntensity;

    % Transformar la capa de detalles de vuelta al dominio lineal
    detailLayer = exp(logDetailLayer);

    % Normalizar la capa de detalles para evitar aclaramiento excesivo
    detailLayer = (detailLayer - min(detailLayer(:))) / (max(detailLayer(:)) - min(detailLayer(:)));

    % Obtener la imagen filtrada de intensidad
    filteredIntensity = exp(smoothedLogIntensity);

    % Normalizar la imagen filtrada de intensidad
    filteredIntensity = (filteredIntensity - min(filteredIntensity(:))) / (max(filteredIntensity(:)) - min(filteredIntensity(:)));
end
