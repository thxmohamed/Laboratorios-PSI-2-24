function [midiDetected, audioData] = procesarAudio(fileName, audioFolder)
    % PROCESARAUDIO Procesa un archivo de audio para detectar su frecuencia 
    % fundamental y convertirla a una nota MIDI.
    %
    % Esta función lee un archivo de audio, le aplica una ventana de Hamming, 
    % calcula su FFT, y detecta los picos en el espectro de frecuencias. 
    % A partir de los picos, se determina la frecuencia fundamental y se 
    % convierte esa frecuencia en una nota MIDI utilizando la fórmula estándar.
    %
    % Parámetros:
    %   fileName: Nombre del archivo de audio que se va a procesar.
    %   audioFolder: Carpeta que contiene los archivos de audio.
    %
    % Devoluciones:
    %   midiDetected: La nota MIDI detectada en el archivo de audio.
    %   audioData: La señal de audio procesada.
    %
    % Requiere:
    %   - La función 'findpeaks' para detectar los picos en el espectro.
    %   - La función 'smooth' para suavizar el espectro de frecuencias.
    
    % Leer el archivo de audio
    audioPath = fullfile(audioFolder, [fileName, '.wav']);
    [audioData, fs] = audioread(audioPath);
    audioData = audioData - mean(audioData); % Eliminar componente DC
    audioData = audioData / max(abs(audioData)); % Normalización

    % Aplicar ventana
    windowedAudio = audioData .* hamming(length(audioData));
    
    % Calcular la FFT
    N = 2^nextpow2(length(windowedAudio));
    fftSignal = fft(windowedAudio, N);
    magnitude = abs(fftSignal(1:N/2));
    frequencies = (0:N/2-1) * (fs / N);

    % Suavizar el espectro
    magnitude = smooth(magnitude, 5);

    % Limitar a rango de frecuencias MIDI válidas
    validIdx = frequencies >= 27.5 & frequencies <= 4186;
    frequencies = frequencies(validIdx);
    magnitude = magnitude(validIdx);

    % Detectar picos en el espectro
    minPeakHeight = max(magnitude) * 0.15;
    [pks, locs] = findpeaks(magnitude, 'MinPeakHeight', minPeakHeight);

    % Validar que se encontraron picos
    if isempty(pks)
        fprintf('No se encontraron picos para el archivo: %s\n', fileName);
        midiDetected = NaN; % Indicar que no se detectó pitch
        return;
    end
    
    % Frecuencias candidatas
    candidateFreqs = frequencies(locs);

    % Buscar la frecuencia fundamental
    fundamentalFreq = candidateFreqs(1); % Por defecto, el primer pico
    for j = 2:length(candidateFreqs)
        % Verificar relación armónica con la frecuencia actual
        ratio = candidateFreqs(j) / candidateFreqs(1);
        if abs(ratio - round(ratio)) < 0.05
            fundamentalFreq = min(candidateFreqs(1), candidateFreqs(j));
            break;
        end
    end

    % Convertir frecuencia a nota MIDI
    midiDetected = round(69 + 12 * log2(fundamentalFreq / 440));
end
