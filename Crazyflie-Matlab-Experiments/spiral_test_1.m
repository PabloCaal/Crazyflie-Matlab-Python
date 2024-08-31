% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de trayectoria en forma de Espiral utilizando únicamente el Flow Deck
% =========================================================================

%% Añadir la carpeta de comandos al path usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Ejecución de prueba de seguimiento de trayectoria en forma de Espiral
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(3);

% Take off
crazyflie_takeoff(crazyflie_1);
pause(3);

origen = crazyflie_get_position(crazyflie_1);
%origen = [0,0,1];

% Generación de trayectoria en forma de Espiral
N = 200;
theta = linspace(0, 8*pi, N);             % Ángulo que describe la espiral (2 vueltas completas)
radio_inicial = 1;                        % Radio inicial de la espiral
altura_inicial = 0.5;                     % Altura inicial de la espiral
altura_final = 2;                       % Altura final de la espiral

x = origen(1) + (radio_inicial * (1 - (theta / max(theta)))) .* cos(theta); % Componente X
y = origen(2) + (radio_inicial * (1 - (theta / max(theta)))) .* sin(theta); % Componente Y
z = linspace(altura_inicial, altura_final, N);                               % Componente Z, incrementa linealmente

% Graficar la trayectoria generada
plot3(x, y, z, 'bo-', 'DisplayName', 'Trayectoria Espiral');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Trayectoria en forma de Espiral generada');
grid on;
axis equal;
axis([-1 1 -1 1 0 2]);
view(3);

%% Ejecución de la trayectoria generada
pos_Crazyflie = zeros(N, 3); 

for i = 1:N
    crazyflie_send_position_2(crazyflie_1, x(i), y(i), z(i));  % Enviar posición deseada al dron
    pos_Crazyflie(i,:) = crazyflie_get_position(crazyflie_1); % Obtener la posición real del dron
    %pause(0.1);
end

% Aterrizaje
crazyflie_land(crazyflie_1);

% Desconexión
crazyflie_disconnect(crazyflie_1);

%% Graficar resultados
% Mostrar la trayectoria seguida por el dron
plot3(pos_Crazyflie(:,1), pos_Crazyflie(:,2), pos_Crazyflie(:,3), 'bo-', 'DisplayName', 'Trayectoria Espiral');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Trayectoria Espiral seguida por el Crazyflie');
grid on;
axis igual;

% Ajustar el espacio 3D
axis equal;
axis([-1 1 -1 1 0 2]);
view(3);
