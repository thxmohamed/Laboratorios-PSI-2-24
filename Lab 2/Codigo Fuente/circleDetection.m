function [numCirculars, circularComponents] = circleDetection(componentList)
    % CIRCLEDETECTION evalúa los componentes de una imagen para determinar si 
    % son circulares según una métrica de circularidad.
    %
    % Parámetros:
    %   componentList: Una celda de estructuras de componentes, donde cada
    %                  componente tiene campos 'area' y 'perimeter'.
    %
    % Devoluciones:
    %   numCirculars: Número de componentes identificados como circulares.
    %   circularComponents: Una celda con las estructuras de componentes
    %                       que cumplen con el criterio de circularidad.
    %
    % La función evalúa cada componente conectado de la lista calculando
    % su métrica de circularidad con la fórmula:
    %   circularity = (4 * pi * area) / (perimeter ^ 2).
    % Si la circularidad del componente supera un umbral definido, este se
    % clasifica como circular. Al final, se devuelve el número total de
    % componentes circulares y una lista de estos.

    % Inicializar lista de componentes circulares y contador
    circularComponents = cell(size(componentList));  % Preasignar memoria
    circularIndexes = false(1, length(componentList));  % Marcar componentes circulares
    threshold = 0.6;  % Umbral de circularidad

    % Evaluar cada componente de la lista
    for idx = 1:length(componentList)
        component = componentList{idx};

        % Calcular la circularidad
        circularity = (4 * pi * component.area) / (component.perimeter ^ 2);

        % Verificar si el componente cumple con el umbral
        if circularity >= threshold
            circularIndexes(idx) = true;  % Marcar como circular
        end
    end

    % Extraer componentes circulares
    circularComponents = componentList(circularIndexes);
    numCirculars = sum(circularIndexes);  % Contar el número de componentes circulares
end
