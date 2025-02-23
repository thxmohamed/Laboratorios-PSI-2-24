function saveComponentDetailsToText(componentList, filename)
    % SAVECOMPONENTDETAILSTOTEXT escribe la información de cada componente detectado en la imagen
    % en un archivo de texto.
    %
    % Esta función toma una lista de componentes y un nombre de archivo, y guarda la información
    % relevante sobre cada componente (área, perímetro, bounding box, centroide, y circularidad)
    % en un formato legible y estructurado dentro de un archivo de texto.
    %
    % Parámetros:
    %   componentList: Lista de componentes detectados, donde cada componente es una estructura
    %                  con detalles sobre el área, perímetro, bounding box, y otros.
    %   filename: El nombre del archivo de texto donde se almacenará la información de los componentes.
    %
    % El archivo de texto tendrá una descripción por componente con las propiedades detalladas
    % de manera más explicativa.

    % Abrir el archivo para escritura
    fileID = fopen(filename, 'w');
    
    % Verificar si el archivo se abrió correctamente
    if fileID == -1
        error('No se pudo abrir el archivo para escribir.');
    end

    % Escribir el encabezado del archivo de texto
    fprintf(fileID, 'Informe de Componentes Detectados en la Imagen\n');
    fprintf(fileID, '============================================\n');
    
    % Iterar sobre cada componente en la lista y escribir su información
    for i = 1:length(componentList)
        component = componentList{i};
        
        % Calcular el centroide del componente
        centroid = mean(component.points, 1);
        
        % Calcular la circularidad del componente
        circularity = (4 * pi * component.area) / (component.perimeter ^ 2);
        
        % Escribir la información detallada del componente en el archivo
        fprintf(fileID, '\nComponente %d:\n', i);
        fprintf(fileID, '  - Área: %d píxeles\n', component.area);
        fprintf(fileID, '  - Perímetro: %d píxeles\n', component.perimeter);
        fprintf(fileID, '  - Bounding Box: [X: %d, Y: %d, Ancho: %d, Alto: %d]\n', ...
                component.bbox(1), component.bbox(2), component.bbox(3), component.bbox(4));
        fprintf(fileID, '  - Centroide: [X: %.2f, Y: %.2f]\n', centroid(1), centroid(2));
        fprintf(fileID, '  - Circularidad: %.4f \n', circularity);
    end
    
    % Cerrar el archivo de texto
    fclose(fileID);
    disp(['La información de los componentes se ha guardado en:', filename]);
end
