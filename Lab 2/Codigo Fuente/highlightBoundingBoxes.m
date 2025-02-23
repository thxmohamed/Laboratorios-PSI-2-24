function final_image = highlightBoundingBoxes(original_image, component_list)
    % HIGHLIGHTBOUNDINGBOXES dibuja rectángulos delimitadores alrededor de los
    % componentes detectados en una imagen, resaltándolos con un color específico.
    %
    % Esta función toma una imagen original y una lista de componentes detectados, y
    % dibuja un rectángulo delimitador alrededor de cada componente en la imagen.
    % Los rectángulos se dibujan en color rojo con un grosor de línea definido.
    %
    % Parámetros:
    %   original_image: La imagen original (en color o en escala de grises) en la que se
    %                   dibujarán los rectángulos delimitadores.
    %   component_list: Una lista de componentes detectados. Cada componente es una estructura
    %                   que contiene, entre otros, el campo 'bbox' que especifica el
    %                   bounding box del componente en formato [x, y, width, height].
    %
    % Devoluciones:
    %   final_image: Una copia de la imagen original con los rectángulos delimitadores
    %                dibujados sobre ella.
    %
    % La función utiliza la función 'insertShape' para agregar los rectángulos
    % directamente a la imagen y devolver el resultado en una matriz de imagen.
    
    % Crear una copia de la imagen original para trabajar sobre ella
    final_image = original_image;

    % Definir las propiedades del rectángulo
    rectangle_color = 'red';   % Color del rectángulo
    rectangle_thickness = 3;   % Grosor del rectángulo

    % Iterar sobre cada componente de la lista
    for i = 1:length(component_list)
        component = component_list{i};
        bbox = component.bbox;  % El bounding box en formato [x, y, width, height]
        
        % Insertar un rectángulo en la imagen usando insertShape
        final_image = insertShape(final_image, 'Rectangle', bbox, 'Color', rectangle_color, ...
                                  'LineWidth', rectangle_thickness);
    end
end
