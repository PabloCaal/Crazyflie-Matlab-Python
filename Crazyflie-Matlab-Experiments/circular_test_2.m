% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Seguimiento de traycetoria circular con Flow Deck
% Lecturas de OptiTrack adicionales
% =========================================================================

%% Añadir al path las carpetas de comandos usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Generación de traycetoria circular
N = 40; % Cantidad de puntos en la trayectoria
r = 0.2; % Radio de la trayectoria
h = 1; % Altura constante de la trayectoria

theta = linspace(0, 2*pi, N);
x = r * cos(theta);
y = r * sin(theta);
z = h * ones(1,N);

plot3(x, y, z, 'b*-', 'DisplayName', 'Trayectoria Circular');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Trayectoria circular generada');
grid on;
axis equal;
axis([-1 1 -1 1 0 2]);
view(3);

%% Conexión, seguimiento de trayectoria circular y desconexión
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
agent_id = 50;  % ID del agente en el ecosistema Robotat
robotat = robotat_connect();
crazyflie_1 = crazyflie_connect(dron_id);
pause(5);

% Actualización de posición inicial 
% (Referencia absoluta (OptiTrack) -> Crazyflie)
pos = robotat_get_pose(robotat, agent_id)
crazyflie_update_position(crazyflie_1, pos(1), pos(2), pos(3));
pause(2);

%% Vuelo
% Take off
crazyflie_takeoff(crazyflie_1);
pause(2);

% Array para almacenar lecturas de posición de Crazyflie
relative_position = zeros(N, 6); % Posición relativa
absolute_position = zeros(N, 7); % Posición absoluta

% Seguimiento de trayectoria generada
for i = 1:N
    crazyflie_move_to(crazyflie_1, x(i), y(i), z(i));
    relative_position(i,:) = crazyflie_get_pose(crazyflie_1);
    absolute_position(i,:) = robotat_get_pose(robotat, agent_id);
    pause(0.01);
end

% Aterrizaje
crazyflie_land(crazyflie_1);
pause(2);

% Desconexión
crazyflie_disconnect(crazyflie_1);
robotat_disconnect(robotat);

%% Resultados del seguimiento de la trayecoria
x_absolute = absolute_position(:, 1);
y_absolute = absolute_position(:, 2);
z_absolute = absolute_position(:, 3);
x_relative = relative_position(:, 1);
y_relative = relative_position(:, 2);
z_relative = relative_position(:, 3);

figure;
plot3(x_absolute, y_absolute, z_absolute, '-*');
hold on
plot3(x_relative, y_relative, z_relative, '-*');
grid on;
xlabel('X [m]');
ylabel('Y [m]');
zlabel('Z [m]');
title('Trayectoria del marker en 3D');

% Ajustar los límites de los ejes
xlim([-2 2]);
ylim([-2.5 2.5]);
zlim([0 3]);

% Ajustar el espacio 3D
axis equal;
axis([-2 2 -2.5 2.5 0 3]);
view(3);