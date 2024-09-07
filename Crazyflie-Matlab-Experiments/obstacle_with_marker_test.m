% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de obstáculo hexagonal con marker en robotat
% =========================================================================

%% Añadir al path las carpetas de comandos usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Lectura de markers en obstáculos y generación de trayectoria
obstacle1_id = 20; 
obstacle2_id = 21;
obstacle3_id = 22;
obstacle1 = robotat_get_pose(robotat, obstacle1_id);
obstacle2 = robotat_get_pose(robotat, obstacle2_id);
obstacle3 = robotat_get_pose(robotat, obstacle3_id);
origin = robotat_get_pose(robotat, obstacle3_id);

%% Lectura de markers en obstáculos y generación de trayectoria
obstacle1_id = 20; 
obstacle2_id = 21;
obstacle3_id = 22;

% Definir las posiciones y orientaciones (roll, pitch, yaw) de los obstáculos y el origen
obstacle1 = [-2, -1, 0.25, 0, 0, pi/3];  % [x, y, z, roll, pitch, yaw]
obstacle2 = [-3, -2, 0.25, 0, 0, pi/4];  % [x, y, z, roll, pitch, yaw]
obstacle3 = [-4, -3, 0.25, 0, 0, pi/6];  % [x, y, z, roll, pitch, yaw]
origin = [0, 0, 0];
takeoff = [0, 0, 0.5];  % Punto de takeoff
final_point = [-5, -3, 0.5];  % Punto final

% Generar puntos de la trayectoria: desde takeoff hasta los centros de los obstáculos y el punto final
trajectory_points = [takeoff; obstacle1(1:3); obstacle2(1:3); obstacle3(1:3); final_point];

% Número de puntos de interpolación para suavizar la trayectoria
n_interp = 10;

% Interpolación de la trayectoria para suavizarla
t = 1:size(trajectory_points, 1);  % Índices originales de los puntos
t_interp = linspace(1, t(end), n_interp);  % Nuevos puntos para interpolación

% Realizar la interpolación cúbica para las coordenadas x, y, z
x_interp = interp1(t, trajectory_points(:, 1), t_interp, 'pchip');  % 'pchip' para interpolación cúbica
y_interp = interp1(t, trajectory_points(:, 2), t_interp, 'pchip');
z_interp = interp1(t, trajectory_points(:, 3), t_interp, 'pchip');

% Definir el diámetro del aro
diameter = 0.5;
radius = diameter / 2;

% Crear el ángulo para generar los puntos del círculo (aro)
theta = linspace(0, 2*pi, 50);

% Generar los círculos (aros) en el plano YZ (sin orientación)
circle_y = radius * cos(theta);
circle_z = radius * sin(theta);

% Función para aplicar la rotación por yaw
apply_yaw = @(x, y, yaw) [cos(yaw) -sin(yaw); sin(yaw) cos(yaw)] * [x; y];

% Crear la figura
figure;
hold on;

% Graficar el aro del obstáculo 1 con rotación en yaw (yaw es el 6to valor en la pose)
yaw_obstacle1 = obstacle1(6);
rotated_obstacle1 = apply_yaw(zeros(size(circle_y)), circle_y, yaw_obstacle1);
plot3(obstacle1(1) + rotated_obstacle1(1, :), obstacle1(2) + rotated_obstacle1(2, :), obstacle1(3) + circle_z, 'r', 'LineWidth', 2);

% Graficar el aro del obstáculo 2 con rotación en yaw (yaw es el 6to valor en la pose)
yaw_obstacle2 = obstacle2(6);
rotated_obstacle2 = apply_yaw(zeros(size(circle_y)), circle_y, yaw_obstacle2);
plot3(obstacle2(1) + rotated_obstacle2(1, :), obstacle2(2) + rotated_obstacle2(2, :), obstacle2(3) + circle_z, 'g', 'LineWidth', 2);

% Graficar el aro del obstáculo 3 con rotación en yaw (yaw es el 6to valor en la pose)
yaw_obstacle3 = obstacle3(6);
rotated_obstacle3 = apply_yaw(zeros(size(circle_y)), circle_y, yaw_obstacle3);
plot3(obstacle3(1) + rotated_obstacle3(1, :), obstacle3(2) + rotated_obstacle3(2, :), obstacle3(3) + circle_z, 'b', 'LineWidth', 2);

% Graficar el origen como un punto
plot3(origin(1), origin(2), origin(3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

% Graficar el punto de takeoff como un punto
plot3(takeoff(1), takeoff(2), takeoff(3), 'mo', 'MarkerSize', 10, 'MarkerFaceColor', 'm');

% Graficar el punto final como un punto
plot3(final_point(1), final_point(2), final_point(3), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'c');

% Etiquetar los puntos
text(obstacle1(1), obstacle1(2), obstacle1(3), 'Obstacle 1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(obstacle2(1), obstacle2(2), obstacle2(3), 'Obstacle 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(obstacle3(1), obstacle3(2), obstacle3(3), 'Obstacle 3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(origin(1), origin(2), origin(3), 'Origin', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(takeoff(1), takeoff(2), takeoff(3), 'Takeoff', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(final_point(1), final_point(2), final_point(3), 'Final Point', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

% Graficar la trayectoria suave que atraviesa los obstáculos y llega al punto final
plot3(x_interp, y_interp, z_interp, 'm-', 'LineWidth', 2);  % Línea suave
plot3(x_interp, y_interp, z_interp, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');  % Puntos de la trayectoria

% Configurar los ejes
xlabel('X [m]');
ylabel('Y [m]');
zlabel('Z [m]');
title('Trayectoria suave con puntos visibles');
grid on;
axis equal;
view(3);
hold off;









%% Ejecución de prueba de 9despegue y aterrizaje
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(1);

% Take off
crazyflie_takeoff(crazyflie_1);
pause(2);

x = [];
y = [];
z = [];

% Bajar a la altura del obstáculo
x(1) = 0;
y(1) = 0;
z(1) = 0.13;

% Atravesar el obstáculo
x(2) = 0.4;
y(2) = 0;
z(2) = 0.13;

for i = 1:size(x,2)
    crazyflie_send_position(crazyflie_1, x(i), y(i), z(i));
    pause(2);
end

% Land
crazyflie_land(crazyflie_1);
pause(2);

% Desconexión
crazyflie_disconnect(crazyflie_1);
