function Filtrado_Movil
    % Codigo para filtrar por promedioado Movil; Realizado por Bernal Sanchez J. Alexander Bernal
    % El archivo ECG está en mi repositorio de GitHub: https://github.com/EcoKnight/Filtros-Digitales/blob/main/ecg.mat
    clc; close;

    % Cargar los datos del archivo ecg.mat
    data = load('ecg.mat');
    
    % Suponiendo que el archivo 'ecg.mat' contiene una variable llamada 'ecg'
    ecg = data.ecg;
    
    % Definir los parámetros de muestreo
    Fs = 250;                                                        % frecuencia de muestreo en Hz
    Ts = 1 / Fs;                                                     % período de muestreo en segundos
    N = length(ecg);                                              % número de muestras
    vect = (1:N);
    t = vect * Ts;                                                  % vector de tiempo
    
    % Agregar ruido a los datos del ECG
    rng default;                                                    % Inicializar generador de números aleatorios
    C = 0.5;                                                         % Constante de ruido 
    x = ecg + C * rand(size(ecg));
    
    % Definir los coeficientes del filtro de promedio móvil
    taps = 4;
    b = (1/taps) * ones(1, taps);
    a = 1;                                                            % Para no atenuar
    
    % Aplicar el filtro de promedio móvil
    y = filter(b, a, x);
    
    % Normalizar las señales
    % Se usa el rango original de la señal sin filtrar para la normalización
    x_normalized = (x - mean(x)) / std(x);
    y_normalized = (y - mean(y)) / std(y);
    
    % Ajustar el rango de normalización a -1 a 6
    x_normalized = x_normalized / (max(x_normalized) - min(x_normalized)) * 7;
    y_normalized = y_normalized / (max(y_normalized) - min(y_normalized)) * 7;
    
    % Limitar los datos a los primeros 4 segundos
    time_limit = 4;                                                 % Seg del ECG
    sample_limit = time_limit * Fs;                         % número de muestras correspondientes a 4 segundos
    if sample_limit > N
        sample_limit = N;                                        % asegurar que no exceda el número de muestras disponibles
    end
    
    % Graficar los resultados
    figure(1);
        subplot(2,1,1);
            plot(t(1:sample_limit), x_normalized(1:sample_limit), 'r');
            title('ECG ruidoso');   grid on;    ylabel('Amplitud (mV)');
            xlabel('Tiempo (s)');   ylim([-1 6]); % Establecer el rango del eje y
    
        subplot(2,1,2);
            plot(t(1:sample_limit), y_normalized(1:sample_limit), 'g');
            title('ECG filtrado');  grid on;  ylabel('Amplitud (mV)');  
            xlabel('Tiempo (s)'); ylim([-1 6]); % Establecer el rango del eje y

    figure('DefaultAxesFontSize', 11);
        hold on;    grid on;
    plot(t(1:sample_limit), x_normalized(1:sample_limit), 'm');
    plot(t(1:sample_limit), y_normalized(1:sample_limit), 'b', 'linewidth', 2);
            legend('Datos de entrada', 'Datos filtrados');
            title('Filtro de promedio móvil de 4 puntos');
            ylabel('Amplitud (mV)');    xlabel('Tiempo (s)');
            xlim([0 4]);     ylim([-1 6]); % Establecer el rango del eje y % Establecer el límite en el eje x    
end
