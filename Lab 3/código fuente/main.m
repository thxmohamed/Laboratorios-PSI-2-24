% Paso 1: Listar y seleccionar archivos
filesH = dir('h_*.wav');
filesY = dir('y_*.wav');

% Mostrar archivos disponibles
disp('Archivos disponibles para h:');
for i = 1:length(filesH)
    fprintf('%d: %s\n', i, filesH(i).name);
end

% Seleccionar 10 índices
fprintf('Seleccione 10 índices para h (separados por espacios):\n');
userInput = input('Índices: ', 's');
selectedIndices = str2num(userInput);

% Verificar validez
if isempty(selectedIndices) || length(selectedIndices) ~= 10 || ...
   any(selectedIndices < 1) || any(selectedIndices > length(filesH))
    error('Debe seleccionar exactamente 10 índices válidos.');
end

% Emparejar archivos
selectedFilesH = {filesH(selectedIndices).name};
selectedFilesY = strrep(selectedFilesH, 'h_', 'y_');

% Paso 2: Construir H y combinar señales
L_g = 20; % Largo del filtro
[H, d_combined, z_combined, fs_sd, sd] = build_H_and_Y(selectedFilesH, selectedFilesY, L_g);

% Imprimir dimensiones de H, d, y gMINT
fprintf('Dimensiones de la matriz H: %d x %d\n', size(H, 1), size(H, 2));
fprintf('Dimensiones del vector d: %d x 1\n', length(d_combined));
fprintf('Dimensiones de gMINT: %d x 1\n', size(H, 2));

% Número de respuestas al impulso de filtros de salida generados
fprintf('Número de respuestas al impulso de filtros generados: %d\n', length(selectedFilesH));

% Paso 3: Procesar de-reverberación
[z_combined, gMINT] = process_dereverberation(H, d_combined, selectedFilesY, L_g);

% Imprimir número de convoluciones necesarias
fprintf('Número de convoluciones necesarias: %d\n', length(selectedFilesY));

% Ajustar la señal combinada
% Asegurar que sd y z_combined tengan la misma longitud
minLen = min(length(sd), length(z_combined));
sd_trimmed = sd(1:minLen);
z_trimmed = z_combined(1:minLen);

% Normalizar la señal de-reverberada a la misma energía que sd
z_trimmed = z_trimmed * (norm(sd_trimmed) / norm(z_trimmed));

% Explicar cómo se usa el vector de impulso
fprintf('El vector de impulso unitario (d) se utiliza como objetivo ideal en el cálculo de gMINT, para que H * gMINT aproxime una señal impulsional sin reverberación.\n');

% Paso 4: Calcular métricas
[SSR_combined, EDC_combined] = calculate_metrics(sd_trimmed, z_trimmed);

% Paso 5: Graficar y exportar resultados
figure;
plot(EDC_combined);
xlabel('Muestras');
ylabel('Decaimiento de Energía');
title('Curva EDC combinada');

% Exportar señal ajustada
audiowrite('dereverberated_output.wav', z_trimmed, fs_sd);
fprintf('SSR combinado: %.2f dB\n', SSR_combined);
fprintf('Señal de-reverberada exportada como "dereverberated_output.wav"\n');
