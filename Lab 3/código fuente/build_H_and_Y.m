function [H, d_combined, z_combined, fs_sd, sd] = build_H_and_Y(selectedFilesH, selectedFilesY, L_g)
    % BUILD_H_AND_Y Construye la matriz H y el vector de impulso d_combined
    % combinando señales de archivos de entrada, y genera una señal combinada.
    %
    % Parámetros:
    %   selectedFilesH: Celda de rutas de archivos de señales H (filtrado).
    %   selectedFilesY: Celda de rutas de archivos de señales Y (señales observadas).
    %   L_g: Longitud de la señal de filtro para la construcción de la matriz H.
    %
    % Devoluciones:
    %   H: Matriz de bloques diagonales construida a partir de las señales H.
    %   d_combined: Vector combinado que contiene los impulsos para cada archivo H.
    %   z_combined: Señal combinada inicializada para las señales Y.
    %   fs_sd: Frecuencia de muestreo de la señal directa.
    %   sd: Señal directa leída desde el archivo 'singing.wav'.
    %
    % La función lee los archivos H y Y, construye la matriz H usando la función
    % 'toeplitz' para cada archivo H y genera un vector de impulso d_combined. 
    % También inicializa la señal combinada z_combined con la longitud máxima de Y.
    % Finalmente, se lee la señal 'singing.wav' como una referencia para la señal directa.

    H = [];
    d_combined = [];
    maxLenY = 0;
    z_combined = []; % Inicializar señal combinada

    [sd, fs_sd] = audioread('singing.wav'); % Señal directa

    % Construir H y combinar señales
    for i = 1:length(selectedFilesH)
        [h, fs] = audioread(selectedFilesH{i});
        [y, ~] = audioread(selectedFilesY{i});
        
        % Longitud máxima de y
        maxLenY = max(maxLenY, length(y));
        if isempty(z_combined)
            z_combined = zeros(maxLenY, 1); % Inicializar
        end
        
        % Construcción de H
        H_i = toeplitz(h, [h(1); zeros(L_g-1, 1)]);
        H = blkdiag(H, H_i);

        % Vector de impulso combinado
        d_i = zeros(size(H_i, 1), 1);
        d_i(1) = 1;
        d_combined = [d_combined; d_i];
    end
end
