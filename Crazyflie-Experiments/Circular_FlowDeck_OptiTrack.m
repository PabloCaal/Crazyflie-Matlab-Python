%% TRABAJO DE GRADUACIÓN - PABLO CAAL 20538
% UNIVERSIDAD DEL VALLE DE GUATEMALA
% Diseño e Innovación en Ingeniería Mecatrónica
% Pruebas de los comandos desarrollados en Python
% Versión 27/07/2024
% Modificaciones 10/08/2024

%% 
agent_id = 50;  % ID del agente en el ecosistema Robotat
robotat = robotat_connect();

%% 
pos = robotat_get_pose(robotat, agent_id)

%%
crazyflie_update_position(crazyflie_1, pos(1), pos(2), pos(3));

%% Lectura de posición
N = 50;
pos_OptiTrack = zeros(N, 7); 

for i=1:N
    pos_OptiTrack(i,:) = robotat_get_pose(robotat, agent_id);
    pause(0.25);
end

%%
plot3(pos_OptiTrack(:,1), pos_OptiTrack(:,2), pos_OptiTrack(:,3), 'bo-', 'DisplayName', 'Trayectoria Circular');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Take off');
grid on;
axis equal;

% Ajustar el espacio 3D
axis equal;
view(3);

%%
robotat_disconnect(robotat);

%% Conexión, despegue, aterrizaje y desconexión
% Datos del agente
dron_id = 8;    % ID del dron disponible 
agent_id = 50;  % ID del agente en el ecosistema Robotat

% Conexión con dron y entorno Robotat
crazyflie_1 = crazyflie_connect(dron_id);
robotat = robotat_connect();

% Inicialización de timer
t = timer;
t.Period = 1;
t.ExecutionMode = 'fixedRate'; 
t.BusyMode = 'drop'; 
t.TimerFcn = @(~,~) updateDronPosition(robotat, agent_id, crazyflie_1);
start(t);

%% Lectura
% Arrays para almacenar las lecturas de posición
num_lecturas = 20;
pos_Crazyflie = zeros(num_lecturas, 3); 
pos_OptiTrack = zeros(num_lecturas, 7); 

% Ciclo para realizar lecturas de posición
for i = 1:num_lecturas
    try 
        pos_Crazyflie(i,:) = crazyflie_get_position(crazyflie_1);
        pos_OptiTrack(i,:) = robotat_get_pose(robotat, agent_id);
    catch ME
        disp('Error al obtener posición.');
        disp(ME.message);
    end 
    pause(1); % Periodo de lecturas (20 lecturas * 1 segundo = 20 segundos)
end


%% Desconexión y finalización del timer
crazyflie_disconnect(crazyflie_1);
robotat_disconnect(robotat);

% Finalización de timer
stop(t);
delete(t);

%% Gráfica 3D de lecturas
x_OptiTrack = pos_OptiTrack(:, 1);
y_OptiTrack = pos_OptiTrack(:, 2);
z_OptiTrack = pos_OptiTrack(:, 3);
x_Crazyflie = pos_Crazyflie(:, 1);
y_Crazyflie = pos_Crazyflie(:, 2);
z_Crazyflie = pos_Crazyflie(:, 3);

figure;
plot3(x_OptiTrack, y_OptiTrack, z_OptiTrack, '-o');
hold on
plot3(x_Crazyflie, y_Crazyflie, z_Crazyflie, '-*');
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

%% Prueba de callback para actualización de posición - con vuelo
% Datos del agente
dron_id = 8;    % ID del dron disponible 
agent_id = 50;  % ID del agente en el ecosistema Robotat

% Conexión con dron y entorno Robotat
crazyflie_1 = crazyflie_connect(dron_id);
robotat = robotat_connect();

% Arrays para almacenar las lecturas
pos_Crazyflie = [];
pos_OptiTrack = [];

% Inicialización de timer para callback
t = timer;
t.Period = 0.25;
t.ExecutionMode = 'fixedRate'; 
t.BusyMode = 'drop'; 
t.TimerFcn = @(~,~) updateDronPosition(robotat, agent_id, crazyflie_1);
start(t);

% Lectura inicial de posición del dron
pos_Crazyflie(1) = crazyflie_get_position(crazyflie_1);
pos_OptiTrack(1) = robotat_get_pose(robotat, agent_id);

% Despegue del dron
crazyflie_takeoff(crazyflie_1);
pos_Crazyflie(2) = crazyflie_get_position(crazyflie_1);
pos_OptiTrack(2) = robotat_get_pose(robotat, agent_id);
pause(0.5);

% Aterrizaje
crazyflie_land(crazyflie_1);
pos_Crazyflie(3) = crazyflie_get_position(crazyflie_1);
pos_OptiTrack(3) = robotat_get_pose(robotat, agent_id);
pause(0.5);

% Desconexión con el dron
crazyflie_disconnect(crazyflie_1);
robotat_disconnect(robotat);

% Finalización de timer
stop(t);
delete(t);


%% Conexión, despegue, envío de posición, aterrizaje y desconexión
crazyflie_1 = crazyflie_connect(8);
robotat = robotat_connect();
pause(0.25);

% Despegue
crazyflie_takeoff(crazyflie_1); 
pause(2);

% Lectura
pos_Crazyflie(1) = crazyflie_get_position(crazyflie_1);
pos_OptiTrack = robotat_get_pose(robotat, 50);
crazyflie_update_position(crazyflie_1, pos_OptiTrack(1), ...
                                       pos_OptiTrack(2), ...
                                       pos_OptiTrack(3));
pos_Crazyflie(2) = crazyflie_get_position(crazyflie_1);

% Envío de posición
crazyflie_send_position(crazyflie_1, 0.0, 0.0, 1.0);

% Lectura
pos_Crazyflie(3) = crazyflie_get_position(crazyflie_1);
pos_OptiTrack = robotat_get_pose(robotat, 50);
crazyflie_update_position(crazyflie_1, pos_OptiTrack(1), ...
                                       pos_OptiTrack(2), ...
                                       pos_OptiTrack(3));
pos_Crazyflie(4) = crazyflie_get_position(crazyflie_1);

% Aterrizaje
crazyflie_land(crazyflie_1);
pause(2);

% Desconexión
crazyflie_disconnect(crazyflie_1);
robotat_disconnect(robotat);

%% Lectura solo de marker
crazyflie_1 = crazyflie_connect(8);
robotat = robotat_connect();

num_lecturas = 60;
pos_Crazyflie = zeros(num_lecturas, 3); 
pos_OptiTrack = zeros(num_lecturas, 7); 

for i = 1:num_lecturas
    try 
        pos_Crazyflie(i, :) = crazyflie_get_position(crazyflie_1);
        pos_OptiTrack(i, :) = robotat_get_pose(robotat, 50);
        crazyflie_update_position(crazyflie_1, ...
            pos_OptiTrack(1), ...
            pos_OptiTrack(2), ...
            pos_OptiTrack(3));
    catch ME
        disp('Ocurrió un error al intentar obtener la pose del marker.');
        disp(ME.message);
    end 
    pause(0.25);
end

crazyflie_disconnect(crazyflie_1);
robotat_disconnect(robotat);



%% Conexión, despegue, posición absoluta, envío de posición, aterrizaje, desconexión
crazyflie_1 = crazyflie_connect(8);
crazyflie_takeoff(crazyflie_1);
crazyflie_send_position(crazyflie1, 1.0, 0.0, 0.5)
crazyflie_land(crazyflie_1);
crazyflie_disconnect(crazyflie_1);



%% Trayectoria circular
% Actualización de coordenadas relativas a coordenadas absolutas del dron
pos_OptiTrack = robotat_get_pose(robotat, 50);
crazyflie_update_position(crazyflie_1, pos_OptiTrack(1), ...
                                       pos_OptiTrack(2), ...
                                       pos_OptiTrack(3));

% Coordenadas de inicio para el dron
x0 = 2;%pos_OptiTrack(1); 
y0 = 2;%pos_OptiTrack(2); 
z0 = 0.5;%pos_OptiTrack(3);

% Definir parámetros del círculo
radius = 1.0;
z_circular = 1.0;
num_points = 36; % Número de puntos para la trayectoria circular
theta = linspace(0, 2*pi, num_points); % Ángulos para la trayectoria circular

% Generar puntos de transición desde (x0, y0, z0) a (radius, 0, z)
transition_points = [
    linspace(x0, radius, 10)' ...
    linspace(y0, 0, 10)' ...
    linspace(z0, z_circular, 10)'
];

% Generar puntos de la trayectoria circular
circular_points = [
    radius * cos(theta)', ...
    radius * sin(theta)', ...
    ones(num_points, 1)
];

% Añadir el punto central para aterrizar
final_point = [
    linspace(radius, 0, 10)' ...
    linspace(0, 0, 10)' ...
    linspace(1, 1, 10)'
];

% Combinar todas las trayectorias
trajectory = [transition_points; circular_points; final_point];
plot3(trajectory(:,1), trajectory(:,2), trajectory(:,3),'-*')
grid on

%% Seguimiento de trayectoria
n = size(trajectory, 1);

% Inicializar el array para almacenar las posiciones
positions_OptiTrack = zeros(n, 7);
positions_FlowDeck = zeros(n, 3);

% Capturar la posición cada segundo durante 30 segundos
for i = 1:n
    crazyflie_send_position(crazyflie1, trajectory(i,1), ...
                                        trajectory(i,2), ...
                                        trajectory(i,3));

    try % Obtener la posición del marcador y actualizar Dron
        pos_OptiTrack = robotat_get_pose(robotat, 50);
        crazyflie_update_position(crazyflie_1, pos_OptiTrack(1), pos_OptiTrack(2), pos_OptiTrack(3));
        positions_OptiTrack(i, :) = pos_OptiTrack;
    catch ME
        % Error
        disp('Ocurrió un error al intentar obtener la pose del marker.');
        disp(ME.message);
    end 

    try % Obtener la posición del Dron
        pos_FlowDeck = crazyflie_get_position(crazyflie_1);
        positions_FlowDeck(i, :) = pos_FlowDeck;
    catch
        % Error
        disp('Ocurrió un error al intentar obtener la pose del Dron.');
        disp(ME.message);
    end

    pause(0.25);
end

crazyflie_safe_emergency_stop(crazyflie_1);

robotat_disconnect(robotat);
crazyflie_disconnect(crazyflie_1);

%% Gráfica 3D
% Extraer las coordenadas x, y, z
x_OptiTrack = positions_OptiTrack(:, 1);
y_OptiTrack = positions_OptiTrack(:, 2);
z_OptiTrack = positions_OptiTrack(:, 3);
x_FlowDeck = positions_FlowDeck(:, 1);
y_FlowDeck = positions_FlowDeck(:, 2);
z_FlowDeck = positions_FlowDeck(:, 3);

figure;
plot3(x_OptiTrack, y_OptiTrack, z_OptiTrack, '-o');
hold on
plot3(x_FlowDeck, y_FlowDeck, z_FlowDeck, '-*');
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

%% Guardar muestras de datos
save('PosicionesPrueba3.mat', 'x_OptiTrack', 'y_OptiTrack', 'z_OptiTrack', 'x_FlowDeck', 'y_FlowDeck', 'z_FlowDeck')
