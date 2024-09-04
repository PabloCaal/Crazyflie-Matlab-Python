%% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Verificación de callbacks para fusión de sensores
% =========================================================================

%% Añadir al path las carpetas de comandos usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%%
print_test();

%% Conexión con Robotat y Crazyflie
robotat = robotat_connect();
crazyflie_1 = crazyflie_connect(8);
agent_id = 50;

%% Event Callback
configureCallback(robotat, "byte", 1, @(src, event) robotat_update_crazyflie_position(crazyflie_1, src, agent_id));
pose = robotat_get_pose(robotat, agent_id)

%% Desactivar callback
configureCallback(robotat, "off");





%% Timer callback
% Definir la función anónima que llama a tu función
robotat = robotat_connect();
crazyflie_1 = crazyflie_connect(8);
agent_id = 50;

callbackFcn = @(~,~) robotat_update_crazyflie_position(crazyflie_1, robotat, agent_id);

% Crear el timer
updateInterval = 0.5; % Intervalo en segundos
positionUpdateTimer = timer('ExecutionMode', 'fixedRate', ... % Ejecutar en intervalos fijos
                            'Period', updateInterval, ...     % Intervalo de tiempo entre ejecuciones
                            'TimerFcn', callbackFcn);         % Función a ejecutar

% Iniciar el timer
start(positionUpdateTimer);

%% Cuando ya no necesites el timer, puedes detenerlo y eliminarlo:
stop(positionUpdateTimer);
delete(positionUpdateTimer);

%%
robotat_disconnect(robotat);
crazyflie_disconnect(crazyflie_1);

%% Lecturas durante delay
Duration = 20; % Duración en segundos
Period = 4; % Lecturas por segundo
N = Duration*Period; % Cantidad de lecturas

Pose_Crazyflie = zeros(N, 6); % Array para lecturas de pose de marker

% Ciclo para realizar lecturas de pose del marker
for i = 1:N
    try 
        Pose_Crazyflie(i,:) = crazyflie_get_pose(crazyflie_1);
    catch ME
        disp('Error al obtener posición.');
        disp(ME.message);
    end 
    pause(1/Period); % Delay de freuencia de muestreo
end

%% Gráfica 3D de lecturas
x_Robotat = Pose_Crazyflie(:, 1);
y_Robotat = Pose_Crazyflie(:, 2);
z_Robotat = Pose_Crazyflie(:, 3);

figure;
plot3(x_Robotat, y_Robotat, z_Robotat, '-*');
grid on;
xlabel('X [m]');
ylabel('Y [m]');
zlabel('Z [m]');
title('Trayectoria del marker en 3D');

% Ajustar los límites de los ejes
% xlim([-2 2]);
% ylim([-2.5 2.5]);
% zlim([0 3]);

% Ajustar el espacio 3D
axis equal;
axis([-2 2 -2.5 2.5 0 3]);
view(3); 

%% Configurar callback para enviar la posición absoluta al dron usando Robotat
configureCallback(robotat, "byte", 1, @(src, event) crazyflie_robotat_position_callback(crazyflie_1, src, agent_id));
pause(15)
configureCallback(robotat, "off");

%% Posición Robotat, actualización y lectura
pose = robotat_get_pose(robotat, agent_id)
crazyflie_update_position(crazyflie_1, pose(1), pose(2), pose(3));
pose = crazyflie_get_pose(crazyflie_1)
