function [SSR_combined, EDC_combined] = calculate_metrics(sd, z_combined)
    % CALCULATE_METRICS Calcula las métricas SSR (Signal-to-Signal Ratio) y EDC 
    % (Energy Decay Curve) entre las señales de referencia (sd) y la señal 
    % dereverberada (z_combined).
    %
    % Parámetros:
    %   sd: Señal directa (referencia) utilizada para comparar la calidad de la 
    %       señal dereverberada.
    %   z_combined: Señal dereverberada que será comparada con la señal directa sd.
    %
    % Devoluciones:
    %   SSR_combined: Métrica Signal-to-Signal Ratio (SSR), que mide la relación
    %                 entre la señal de referencia y la señal dereverberada.
    %   EDC_combined: Curva de decaimiento de energía (Energy Decay Curve) que 
    %                 mide cómo varía la energía en la señal dereverberada a lo 
    %                 largo del tiempo.
    %
    % La función ajusta las longitudes de las señales de entrada para que coincidan,
    % luego normaliza la señal dereverberada en relación a la señal de referencia. 
    % Después, calcula el SSR como una relación logarítmica entre la energía de la 
    % señal directa y la diferencia entre la señal dereverberada y la directa. 
    % Finalmente, calcula la EDC, que representa la distribución de la energía a lo 
    % largo de la señal dereverberada.

    % Asegurar longitudes
    minLen = min(length(sd), length(z_combined));
    sd_trimmed = sd(1:minLen);
    z_trimmed = z_combined(1:minLen);

    % Normalizar
    z_trimmed = z_trimmed * (norm(sd_trimmed) / norm(z_trimmed));

    % Calcular SSR
    SSR_combined = 10 * log10(norm(sd_trimmed)^2 / norm(z_trimmed - sd_trimmed)^2);

    % Calcular EDC
    L_EIR = length(z_trimmed);
    EDC_combined = zeros(L_EIR, 1);
    for n = 1:L_EIR
        EDC_combined(n) = sum(z_trimmed(n:end).^2) / sum(z_trimmed.^2);
    end
end
