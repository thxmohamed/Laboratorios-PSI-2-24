function procesarArchivos(jsonData, audioFolder)
    % PROCESARARCHIVOS Itera sobre los archivos de audio, detecta las notas 
    % MIDI y las compara con las notas esperadas desde el archivo JSON.
    %
    % Esta función recorre todos los archivos listados en el archivo JSON, 
    % obtiene las notas esperadas y los nombres de los archivos de audio 
    % asociados, y luego procesa los archivos de audio para detectar las 
    % notas MIDI. Después, compara las notas detectadas con las esperadas 
    % para calcular la precisión.
    %
    % Parámetros:
    %   jsonData: Estructura de datos que contiene la información del archivo 
    %             JSON, incluyendo las notas esperadas y los nombres de 
    %             los archivos de audio.
    %   audioFolder: Carpeta que contiene los archivos de audio a procesar.
    %
    % Devoluciones:
    %   Ninguno.
    %
    % Requiere:
    %   - La función 'procesarAudio' para detectar las notas MIDI en los 
    %     archivos de audio.
    
    % Obtener los nombres de los archivos
    fields = fieldnames(jsonData);
    
    % Inicializar contadores
    correctPitchCount = 0;
    totalFiles = numel(fields);
    progreso = 1;
    
    for i = 1:totalFiles
        % Mostrar progreso
        if i / totalFiles >= progreso / 100
            fprintf("%d por ciento procesado\n", progreso);
            progreso = progreso + 1;
        end
        
        % Obtener información del archivo
        key = fields{i};
        fileName = jsonData.(key).note_str;
        midiPitch = jsonData.(key).pitch;
        
        % Procesar el audio
        [midiDetected, audioData] = procesarAudio(fileName, audioFolder);
        
        % Comparar pitch detectado con el esperado
        if midiDetected == midiPitch
            correctPitchCount = correctPitchCount + 1;
        end
    end
    
    % Mostrar resultados
    fprintf('Notas detectadas correctamente: %d de %d\n', correctPitchCount, totalFiles);
    fprintf("Precisión: %f%%\n", 100 * correctPitchCount / totalFiles);
end
