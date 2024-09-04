% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de trayectoria en forma de Curva de Lissajous tridimensional
% utilizando únicamente el Flow Deck
% =========================================================================

%% Añadir la carpeta de comandos al path usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Ejecución de prueba de seguimiento de trayectoria en forma de Curva de Lissajous
origen = [0,0,1];

% Generación de trayectoria en forma de Curva de Lissajous tridimensional
N = 20;
theta = linspace(0, 2*pi, N);
x = 0.25 * origen(1) + 0.75 * sin(theta);         % Componente X: seno simple
y = 0.25 * origen(2) + 0.5 * sin(2*theta);        % Componente Y: seno doble para generar la "cintura"
z = origen(3) + 0.25 * (1 + cos(theta));   % Componente Z: oscilación suave en altura

% Graficar la trayectoria generada
plot3(x, y, z, 'bo-', 'DisplayName', 'Trayectoria Curva de Lissajous 3D');
xlabel('X (m)'); 
ylabel('Y (m)');
zlabel('Z (m)');
title('Trayectoria en forma de Curva de Lissajous 3D generada');
grid on;
axis equal;
axis([-1 1 -1 1 0 2]);
view(3);

%% Ejecución de la trayectoria generada
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(3);

% Take off
crazyflie_takeoff(crazyflie_1);
pause(3);

pos_Crazyflie = zeros(N, 3); 

for i = 1:N
    crazyflie_send_position(crazyflie_1, x(i), y(i), z(i));  % Enviar posición deseada al dron
    pos_Crazyflie(i,:) = crazyflie_get_position(crazyflie_1); % Obtener la posición real del dron
    %pause(0.1);
end

% Aterrizaje
crazyflie_land(crazyflie_1);

% Desconexión
crazyflie_disconnect(crazyflie_1);

%% Graficar resultados
% Mostrar la trayectoria seguida por el dron
plot3(pos_Crazyflie(:,1), pos_Crazyflie(:,2), pos_Crazyflie(:,3), 'bo-', 'DisplayName', 'Trayectoria Curva de Lissajous 3D');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Trayectoria Curva de Lissajous 3D seguida por el Crazyflie');
grid on;
axis igual;

% Ajustar el espacio 3D
axis equal;
axis([-1 1 -1 1 0 2]);
view(3);
