% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de trayectoria circular utilizando únicamente el Flow Deck
% =========================================================================

%% Añadir la carpeta de comandos al path usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Ejecución de prueba de seguimiento de trayectoria circular
%origen = crazyflie_get_position(crazyflie_1);
origen = [0,0,1];

% Generación de trayectoria
N = 40;
radio = 0.15;
theta = linspace(0, 2*pi, N);  
x = origen(1) + radio * cos(theta);
y = origen(2) + radio * sin(theta);
z = origen(3) * ones(1, N);

plot3(x, y, z, 'bo-', 'DisplayName', 'Trayectoria Circular');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Trayectoria circular generada');
grid on;
axis equal;
axis([-1 1 -1 1 0 2]);
view(3);

%% Ejecución de trayectoria

% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(2);

% Take off
crazyflie_takeoff(crazyflie_1);
pause(2);

pos_Crazyflie = zeros(N, 3); 

for i = 1:N
    crazyflie_move_to(crazyflie_1, x(i), y(i), z(i));
    pos_Crazyflie(i,:) = crazyflie_get_position(crazyflie_1);
    %pause(0.1);
end

% Aterrizaje
crazyflie_land(crazyflie_1);

% Desconexión
crazyflie_disconnect(crazyflie_1);

%% Graficar resultados
% Mostrar los puntos
plot3(pos_Crazyflie(3:20,1), pos_Crazyflie(3:20,2), pos_Crazyflie(3:20,3), 'bo-', 'DisplayName', 'Trayectoria Circular');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Trayectoria circular generada');
grid on;
axis equal;

% Ajustar el espacio 3D
axis equal;
axis([-1 1 -1 1 0 2]);
view(3);