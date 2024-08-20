%% TRABAJO DE GRADUACIÓN - PABLO CAAL 20538
% UNIVERSIDAD DEL VALLE DE GUATEMALA
% Diseño e Innovación en Ingeniería Mecatrónica
% Gráfica de lecturas obtenidas con Tracker
% 15/08/2024

%% Gráfica de altura vs tiempo
figure; 
plot(t, -y, 'b-', 'LineWidth', 1.5); 
xlabel('Tiempo (s)'); 
ylabel('Altura (m)'); 
title('Gráfica de altura contra tiempo');
grid on; 

%% Gráfica de eje Y vs tiempo
figure; 
plot(t, -x, 'b-', 'LineWidth', 1.5); 
xlabel('Tiempo (s)'); 
ylabel('Eje Y (m)'); 
title('Gráfica de eje Y contra tiempo'); 
grid on;

%% Gráfica de altura vs tiempo
figure;
z = 0.3 * ones(715, 1);
plot3(x, y, z, 'b-', 'LineWidth', 1.5); 
xlabel('X (m)'); 
ylabel('Y (m)'); 
zlabel('Z (m)'); 
title('Trayectoria circular experimental (Tracker)'); 
grid on;
axis([1 -1.5 1 -1 1 -1]);
view(3);

%% Guardar datos
save('datos_tiempo_altura_2.mat', 't', 'x', 'y');


%%
% Suposición de valores teóricos para X, Y y Z
% Radio teórico de la circunferencia
radio_teorico = 0.25;

% Calcular la distancia desde cada punto al centro de la circunferencia (0,0)
distancia_experimental = sqrt(x.^2 + y.^2);

% Calcular el promedio de la distancia experimental
promedio_distancia_experimental = mean(distancia_experimental);

desviacion_estandar = std(distancia_experimental);

error_percentual = abs((promedio_distancia_experimental - radio_teorico) / radio_teorico) * 100;

% Crear una tabla con los resultados
T_resultados = table(promedio_distancia_experimental, radio_teorico, error_percentual, desviacion_estandar, ...
    'VariableNames', {'Promedio_Distancia_Experimental', 'Distancia_Teorica', 'Error_Percentual', 'Desviacion_Estandar'});

% Mostrar la tabla
disp(T_resultados);