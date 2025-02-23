% Leer archivo JSON
jsonFile = 'examples.json';
jsonData = jsondecode(fileread(jsonFile));

% Definir la carpeta de audio
audioFolder = 'notas';

% Procesar los archivos
procesarArchivos(jsonData, audioFolder);
