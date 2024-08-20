%% TRABAJO DE GRADUACIÓN - PABLO CAAL 20538
% UNIVERSIDAD DEL VALLE DE GUATEMALA
% Diseño e Innovación en Ingeniería Mecatrónica
% Prueba de Trayectoria Circular únicamente con Flow Deck
% 15/08/2024

%% Conexión, y despegue
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
crazyflie_takeoff(crazyflie_1);

%% Desconexión y finalización del timer
crazyflie_land(crazyflie_1);
crazyflie_disconnect(crazyflie_1);

%% Generación de trayectoria
%origen = crazyflie_get_position(crazyflie_1);
%origen = [0,0,1];

N = 20;
radio = 0.25;

theta = linspace(0, 2*pi, N);  
x = origen(1) + radio * cos(theta);
y = origen(2) + radio * sin(theta);
z = origen(3) * ones(1, N);


% Mostrar los puntos
plot3(x, y, z, 'bo-', 'DisplayName', 'Trayectoria Circular');
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

%% Ejecución de trayectoria

pos_Crazyflie = zeros(N, 3); 

for i = 1:N
    crazyflie_send_position_2(crazyflie_1, x(i), y(i), z(i));
    pos_Crazyflie(i,:) = crazyflie_get_position(crazyflie_1);
    pause(0.1);
end

crazyflie_land(crazyflie_1);

%% Desconexión y finalización del timer
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