function [border_image, component_list] = componentsDetection(binary_image)
    % COMPONENTSDETECTION realiza una segmentación de componentes conectados
    % en una imagen binaria.
    % Se utiliza un enfoque iterativo con pilas para explorar y etiquetar los
    % componentes conectados. También identifica los píxeles que forman el
    % borde de cada componente.
    %
    % Parámetros:
    %   binary_image: Una matriz binaria (2D) donde los píxeles de los objetos tienen un valor de 255 y
    %                 el fondo tiene un valor de 0.
    %
    % Devoluciones:
    %   border_image: Una matriz binaria (2D) del mismo tamaño que 'binary_image' donde sólo los píxeles
    %                 que forman el borde de cada componente están marcados con 255.
    %   component_list: Una celda donde cada elemento es una estructura que representa un componente
    %                   conectado. La estructura contiene los siguientes campos:
    %                   - points: Un arreglo Nx2 de [fila, columna] de píxeles pertenecientes al componente.
    %                   - border: Un arreglo Nx2 de [fila, columna] de píxeles del borde del componente.
    %                   - bbox: Un vector de 4 elementos [min_x, min_y, ancho, alto] que representa
    %                           el cuadro delimitador del componente.
    %                   - area: Un escalar que indica el número total de píxeles en el componente.
    %                   - perimeter: Un escalar que indica el número total de píxeles en el borde del componente.
    %                   - id: El identificador numérico único asignado al componente.
    %
    % La función recorre la imagen binaria y cuando encuentra un píxel blanco no visitado, inicia un
    % proceso iterativo basado en una pila para explorar todos los píxeles conectados que forman el componente.
    % Durante esta exploración, se determina si un píxel es parte del borde evaluando sus vecinos. También se
    % calculan las propiedades del componente, como su área, perímetro y cuadro delimitador.
    % Finalmente, se actualizan la imagen de bordes y la lista de componentes con la información recopilada.

    % Inicializar variables
    [rows, cols] = size(binary_image);
    visited = false(rows, cols);  % Matriz de píxeles visitados
    component_id = 0;  % Contador de ID de componentes
    component_list = {};  % Lista para almacenar información de componentes
    border_image = zeros(rows, cols, 'uint8');  % Imagen para guardar bordes

    % Direcciones para explorar vecinos (8-conectividad)
    directions = [0, 1; 1, 0; 0, -1; -1, 0; -1, -1; -1, 1; 1, -1; 1, 1];

    % Iterar por cada píxel de la imagen
    for i = 1:rows
        for j = 1:cols
            % Verificar si es un píxel blanco no visitado
            if binary_image(i, j) == 255 && ~visited(i, j)
                % Incrementar ID del componente
                component_id = component_id + 1;

                % Inicializar pila para explorar el componente
                stack = [i, j];
                visited(i, j) = true;

                % Variables para almacenar información del componente
                points = [];
                border = [];
                min_x = j; max_x = j;
                min_y = i; max_y = i;

                % Iterar mientras haya píxeles en la pila
                while ~isempty(stack)
                    % Extraer el último píxel de la pila
                    [y, x] = deal(stack(end, 1), stack(end, 2));
                    stack(end, :) = [];  % Eliminar el último elemento de la pila

                    % Agregar el píxel actual al componente
                    points = [points; y, x];

                    % Actualizar límites del cuadro delimitador
                    min_x = min(min_x, x);
                    max_x = max(max_x, x);
                    min_y = min(min_y, y);
                    max_y = max(max_y, y);

                    % Determinar si el píxel es parte del borde
                    is_border = false;
                    for d = 1:size(directions, 1)
                        ny = y + directions(d, 1);
                        nx = x + directions(d, 2);

                        % Comprobar límites y si el vecino es blanco
                        if ny < 1 || ny > rows || nx < 1 || nx > cols || binary_image(ny, nx) == 0
                            is_border = true;
                        elseif ~visited(ny, nx)
                            stack = [stack; ny, nx];  % Agregar vecino a la pila
                            visited(ny, nx) = true;  % Marcar vecino como visitado
                        end
                    end

                    % Agregar a la lista de bordes si es borde
                    if is_border
                        border = [border; y, x];
                        border_image(y, x) = 255;
                    end
                end

                % Calcular área y perímetro
                area = size(points, 1);
                perimeter = size(border, 1);

                % Guardar información del componente
                component_list{component_id} = struct(...
                    'points', points, ...
                    'border', border, ...
                    'bbox', [min_x, min_y, max_x - min_x + 1, max_y - min_y + 1], ...
                    'area', area, ...
                    'perimeter', perimeter, ...
                    'id', component_id ...
                );
            end
        end
    end
end
