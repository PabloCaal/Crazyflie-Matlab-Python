%% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Trayectoria con 1 obstáculo en área de pruebas 0.6x0.6 metros
% =========================================================================

% Definir las posiciones y orientaciones (roll, pitch, yaw) de los puntos y el obstáculo
origin = [0, 0, 0];                % Punto de origen
takeoff = [0, 0, 0.5];             % Punto de takeoff
obstacle = [-0.4, 0, 0.25, 0, 0, pi/2]; % Obstáculo [x, y, z, roll, pitch, yaw]
final_point = [-0.3, -0.3, 0.5];   % Punto final

% Definir el diámetro del aro del obstáculo
diameter = 0.3;
radius = diameter / 2;

% Crear el ángulo para generar los puntos del círculo (aro)
theta = linspace(0, 2*pi, 50);

% Generar los círculos (aros) en el plano YZ (sin orientación)
circle_y = radius * cos(theta);
circle_z = radius * sin(theta);

% Función para aplicar la rotación por yaw
apply_yaw = @(x, y, yaw) [cos(yaw) -sin(yaw); sin(yaw) cos(yaw)] * [x; y];

% Calcular el punto pre-obstacle desplazado en la coordenada y (en función de yaw pi/2)
yaw_obstacle = obstacle(6);
pre_obstacle_distance = 0.3;  % Distancia de desplazamiento en y antes de atravesar el obstáculo
pre_obstacle = [obstacle(1), obstacle(2) + pre_obstacle_distance, obstacle(3)];  % Pre-obstacle

% Crear la figura
figure;
hold on;

% Graficar el aro del obstáculo con rotación en yaw
rotated_obstacle = apply_yaw(zeros(size(circle_y)), circle_y, yaw_obstacle);
plot3(obstacle(1) + rotated_obstacle(1, :), obstacle(2) + rotated_obstacle(2, :), obstacle(3) + circle_z, 'r', 'LineWidth', 2);

% Graficar el origen como un punto
plot3(origin(1), origin(2), origin(3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

% Graficar el punto de takeoff como un punto
plot3(takeoff(1), takeoff(2), takeoff(3), 'mo', 'MarkerSize', 10, 'MarkerFaceColor', 'm');

% Graficar el punto antes del obstáculo (pre_obstacle)
plot3(pre_obstacle(1), pre_obstacle(2), pre_obstacle(3), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Graficar el punto final como un punto
plot3(final_point(1), final_point(2), final_point(3), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'c');

% Etiquetar los puntos
text(obstacle(1), obstacle(2), obstacle(3), 'Obstacle', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(origin(1), origin(2), origin(3), 'Origin', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(takeoff(1), takeoff(2), takeoff(3), 'Takeoff', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(pre_obstacle(1), pre_obstacle(2), pre_obstacle(3), 'Pre-Obstacle', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(final_point(1), final_point(2), final_point(3), 'Final Point', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

% Crear la trayectoria que pase por el punto antes del obstáculo, luego atraviese el obstáculo, y llegue al punto final
trajectory_points = [takeoff; pre_obstacle; obstacle(1:3); final_point];

% Número de puntos de interpolación para suavizar la trayectoria
n_interp = 10;

% Interpolación de la trayectoria para suavizarla
t = 1:size(trajectory_points, 1);  % Índices originales de los puntos
t_interp = linspace(1, t(end), n_interp);  % Nuevos puntos para interpolación

% Realizar la interpolación cúbica para las coordenadas x, y, z
x_interp = interp1(t, trajectory_points(:, 1), t_interp, 'pchip');  % 'pchip' para interpolación cúbica
y_interp = interp1(t, trajectory_points(:, 2), t_interp, 'pchip');
z_interp = interp1(t, trajectory_points(:, 3), t_interp, 'pchip');

% Graficar la trayectoria interpolada con línea y marcadores
plot3(x_interp, y_interp, z_interp, 'm-', 'LineWidth', 2);  % Línea suave
plot3(x_interp, y_interp, z_interp, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');  % Puntos interpolados

% Configurar los ejes
xlabel('X [m]');
ylabel('Y [m]');
zlabel('Z [m]');
title('Trayectoria interpolada que atraviesa el obstáculo');
grid on;
axis equal;
xlim([-0.6 0.6]);
ylim([-0.6 0.6]);
zlim([0 0.6]);
view(3);
hold off;


%% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Trayectoria con 2 obstáculo en área de pruebas 0.6x0.6 metros
% =========================================================================

% Definir las posiciones y orientaciones (roll, pitch, yaw) de los puntos y los obstáculos
origin = [0, 0, 0];                % Punto de origen
takeoff = [0, 0, 0.5];             % Punto de takeoff
obstacle1 = [-0.4, 0, 0.15, 0, 0, pi/2]; % Obstáculo 1 [x, y, z, roll, pitch, yaw]
obstacle2 = [0, -0.4, 0.15, 0, 0, 0];    % Obstáculo 2 [x, y, z, roll, pitch, yaw]
final_point = [0.4, -0.4, 0.5];     % Punto final
land_point = [0.4, -0.4, 0];        % Punto de aterrizaje (Land point)

% Definir el diámetro del aro del obstáculo
diameter = 0.3;
radius = diameter / 2;

% Crear el ángulo para generar los puntos del círculo (aro)
theta = linspace(0, 2*pi, 50);

% Generar los círculos (aros) en el plano YZ (sin orientación)
circle_y = radius * cos(theta);
circle_z = radius * sin(theta);

% Función para aplicar la rotación por yaw
apply_yaw = @(x, y, yaw) [cos(yaw) -sin(yaw); sin(yaw) cos(yaw)] * [x; y];

% Calcular el punto pre-obstacle1 desplazado en la coordenada y (en función de yaw pi/2)
yaw_obstacle1 = obstacle1(6);
pre_obstacle1_distance = 0.4;  % Distancia de desplazamiento en y antes de atravesar el obstáculo 1
pre_obstacle1 = [obstacle1(1), obstacle1(2) + pre_obstacle1_distance, obstacle1(3)];  % Pre-obstacle1

% Calcular el punto pre-obstacle2 desplazado en la coordenada x (por la orientación del obstáculo 2)
yaw_obstacle2 = obstacle2(6);
pre_obstacle2_distance = 0.4;  % Distancia de desplazamiento en x antes de atravesar el obstáculo 2
pre_obstacle2 = [obstacle2(1) - pre_obstacle2_distance, obstacle2(2), obstacle2(3)];  % Pre-obstacle2

% Crear la figura
figure;
hold on;

% Graficar el aro del obstáculo 1 con rotación en yaw
rotated_obstacle1 = apply_yaw(zeros(size(circle_y)), circle_y, yaw_obstacle1);
plot3(obstacle1(1) + rotated_obstacle1(1, :), obstacle1(2) + rotated_obstacle1(2, :), obstacle1(3) + circle_z, 'r', 'LineWidth', 2);

% Graficar el aro del obstáculo 2 con rotación en yaw (sin rotación en este caso)
rotated_obstacle2 = apply_yaw(zeros(size(circle_y)), circle_y, yaw_obstacle2);
plot3(obstacle2(1) + rotated_obstacle2(1, :), obstacle2(2) + rotated_obstacle2(2, :), obstacle2(3) + circle_z, 'g', 'LineWidth', 2);

% Graficar el origen como un punto
plot3(origin(1), origin(2), origin(3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

% Graficar el punto de takeoff como un punto
plot3(takeoff(1), takeoff(2), takeoff(3), 'mo', 'MarkerSize', 10, 'MarkerFaceColor', 'm');

% Graficar el punto antes del obstáculo 1 (pre_obstacle1)
plot3(pre_obstacle1(1), pre_obstacle1(2), pre_obstacle1(3), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Graficar el punto antes del obstáculo 2 (pre_obstacle2)
plot3(pre_obstacle2(1), pre_obstacle2(2), pre_obstacle2(3), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Graficar el punto final como un punto
plot3(final_point(1), final_point(2), final_point(3), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'c');

% Graficar el punto de aterrizaje (land_point)
plot3(land_point(1), land_point(2), land_point(3), 'co', 'MarkerSize', 10, 'MarkerFaceColor', 'b');

% Etiquetar los puntos
text(obstacle1(1), obstacle1(2), obstacle1(3), 'Obstacle 1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(obstacle2(1), obstacle2(2), obstacle2(3), 'Obstacle 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(origin(1), origin(2), origin(3), 'Origin', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(takeoff(1), takeoff(2), takeoff(3), 'Takeoff', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(pre_obstacle1(1), pre_obstacle1(2), pre_obstacle1(3), 'Pre-Obstacle 1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(pre_obstacle2(1), pre_obstacle2(2), pre_obstacle2(3), 'Pre-Obstacle 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(final_point(1), final_point(2), final_point(3), 'Final Point', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(land_point(1), land_point(2), land_point(3), 'Land Point', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

% Crear la trayectoria que pase por los puntos antes de cada obstáculo, luego los atraviese,
% pase por el punto final y llegue al punto de aterrizaje (land point)
trajectory_points = [takeoff; pre_obstacle1; obstacle1(1:3); pre_obstacle2; obstacle2(1:3); final_point; land_point];

% Número de puntos de interpolación para suavizar la trayectoria
n_interp = 20;

% Interpolación de la trayectoria para suavizarla
t = 1:size(trajectory_points, 1);  % Índices originales de los puntos
t_interp = linspace(1, t(end), n_interp);  % Nuevos puntos para interpolación

% Realizar la interpolación cúbica para las coordenadas x, y, z
x_interp = interp1(t, trajectory_points(:, 1), t_interp, 'pchip');  % 'pchip' para interpolación cúbica
y_interp = interp1(t, trajectory_points(:, 2), t_interp, 'pchip');
z_interp = interp1(t, trajectory_points(:, 3), t_interp, 'pchip');

% Graficar la trayectoria interpolada con línea y marcadores
plot3(x_interp, y_interp, z_interp, 'm-', 'LineWidth', 2);  % Línea suave
plot3(x_interp, y_interp, z_interp, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');  % Puntos interpolados

% Configurar los ejes
xlabel('X [m]');
ylabel('Y [m]');
zlabel('Z [m]');
title('Trayectoria interpolada que atraviesa dos obstáculos y aterriza en el land point');
grid on;
axis equal;
xlim([-0.6 0.6]);
ylim([-0.6 0.6]);
zlim([0 0.6]);
view(3);
hold off;
