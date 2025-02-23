function [umbraMask, deltaIntensity] = findUmbraMask(flashImg, noflashImg)
    % findUmbraMask Detecta las áreas de umbra en imágenes con y sin flash.
    %
    %   [umbraMask, deltaIntensity] = findUmbraMask(flashImg, noflashImg) calcula una máscara binaria
    %   que identifica las áreas de umbra (sombras profundas) en una imagen comparando una imagen tomada 
    %   con flash y otra sin flash.
    %
    %   Entrada:
    %       flashImg - Imagen capturada con flash. Debe estar en formato RGB.
    %       noflashImg - Imagen capturada sin flash. Debe estar en formato RGB.
    %
    %   Salidas:
    %       umbraMask - Máscara binaria que identifica las áreas de umbra en la imagen.
    %       deltaIntensity - Imagen que representa la diferencia de intensidad entre las imágenes
    %                        con y sin flash.
    %
    %   Proceso:
    %       1. Convierte ambas imágenes de entrada al tipo 'double' para mayor precisión.
    %       2. Convierte las imágenes a escala de grises para facilitar el análisis de intensidad.
    %       3. Calcula la diferencia de intensidad entre la imagen con flash y la imagen sin flash.
    %       4. Genera un histograma de la diferencia de intensidad con 128 bins.
    %       5. Suaviza el histograma con un filtro gaussiano para reducir el ruido y facilitar la detección
    %          de umbrales.
    %       6. Define un umbral grueso como el 20% de la máxima diferencia de intensidad.
    %       7. Busca el segundo mínimo local en el histograma suavizado, antes del umbral grueso, para
    %          establecer un umbral más preciso.
    %       8. Si no se encuentra un segundo mínimo local, utiliza el umbral grueso como el valor final.
    %       9. Crea una máscara binaria (umbraMask) que identifica las áreas de umbra donde la diferencia
    %          de intensidad es menor al umbral calculado.
    %
    %   Notas:
    %       - El uso de imágenes con y sin flash permite detectar sombras profundas (umbra).
    %       - El histograma suavizado ayuda a identificar umbrales significativos para la detección de sombras.
    %       - El valor 'eps' en los cálculos asegura que no haya problemas numéricos debido a divisiones por cero.

    % Convertir las imágenes a formato de doble precisión
    flashImg = im2double(flashImg);
    noflashImg = im2double(noflashImg);
    
    % Convertir las imágenes a escala de grises
    flashGray = rgb2gray(flashImg);
    noflashGray = rgb2gray(noflashImg);
    
    % Diferencia de intensidad entre imagen con flash y sin flash
    deltaIntensity = flashGray;

    % Generar histograma con 128 contenedores (bins)
    [histCounts, binEdges] = histcounts(deltaIntensity, 128);

    % Suavizar el histograma usando una convolución con filtro gaussiano
    sigma = 2; % Varianza ajustada para mayor suavización
    binWidth = mean(diff(binEdges)); % Cálculo del ancho del bin
    gaussKernel = gausswin(round(6 * sigma / binWidth))'; % Usar gausswin en lugar de fspecial
    smoothedHist = conv(histCounts, gaussKernel, 'same');

    % Definir un umbral grueso del 20% de la máxima diferencia de intensidad
    roughThreshold = 0.2 * max(deltaIntensity(:));

    % Localizar el primer bin que cruza el umbral grueso
    thresholdBin = find(binEdges >= roughThreshold, 1);

    % Inicializar variables para buscar el segundo mínimo local
    minLocalCount = 0;
    umbraThresholdIdx = NaN;

    % Búsqueda del segundo mínimo local antes del umbral grueso
    for idx = 2:(thresholdBin - 1)
        if smoothedHist(idx) < smoothedHist(idx - 1) && smoothedHist(idx) < smoothedHist(idx + 1)
            % Contar mínimos locales
            minLocalCount = minLocalCount + 1;
            if minLocalCount == 2
                umbraThresholdIdx = idx;
                break;
            end
        end
    end

    % Definir el valor umbral final
    if isnan(umbraThresholdIdx)
        umbraThreshold = roughThreshold;
    else
        umbraThreshold = binEdges(umbraThresholdIdx);
    end

    % Crear la máscara binaria para la umbra usando el umbral final
    umbraMask = deltaIntensity < umbraThreshold;
end
