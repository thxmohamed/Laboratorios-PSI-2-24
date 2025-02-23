function [z_combined, gMINT] = process_dereverberation(H, d_combined, selectedFilesY, L_g)
    % PROCESS_DEREVERBERATION Realiza el proceso de dereverberación sobre las señales Y
    % utilizando la matriz H y el vector de impulso d_combined para calcular el 
    % filtro gMINT. La función aplica este filtro a las señales Y para obtener 
    % una señal combinada dereverberada.
    %
    % Parámetros:
    %   H: Matriz que representa el sistema de convolución de los filtros H.
    %   d_combined: Vector combinado de impulsos utilizados para calcular gMINT.
    %   selectedFilesY: Celda de rutas de archivos de señales Y (señales observadas).
    %   L_g: Longitud del filtro gMINT (no utilizada explícitamente en esta función, 
    %        pero puede ser relevante para la longitud de las señales de entrada).
    %
    % Devoluciones:
    %   z_combined: Señal combinada dereverberada, que resulta de aplicar el filtro gMINT
    %               a cada una de las señales Y.
    %   gMINT: Filtro calculado utilizando la pseudoinversa de H y d_combined, usado
    %          para la dereverberación.
    %
    % La función calcula el filtro gMINT mediante la pseudoinversa de H y el vector 
    % d_combined. Luego, aplica este filtro a cada señal Y utilizando la convolución
    % (con opción 'same' para mantener el tamaño de la señal original), y acumula
    % los resultados en z_combined, que es la señal dereverberada final.

    % Cálculo de gMINT
    gMINT = pinv(H) * d_combined;
    z_combined = zeros(size(H, 1), 1);

    % Procesar señales y
    for i = 1:length(selectedFilesY)
        [y, ~] = audioread(selectedFilesY{i});
        z = conv(y, gMINT, 'same');
        z_combined(1:length(z)) = z_combined(1:length(z)) + z;
    end
end
