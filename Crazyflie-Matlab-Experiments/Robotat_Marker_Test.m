% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de conexión, lectura y desconexión de marker Crazyflie en Robotat
% =========================================================================

%% Conexión y definición de número de marker
robotat = robotat_connect();
agent_id = 50;  % ID del agente en el ecosistema Robotat

%% Desconexión
robotat_disconnect(robotat);

%% Lectura de pose de marker Crazyflie
pose = robotat_get_pose(robotat, agent_id);

%% Lectura de pose de marker Crazyflie en ciclo durante N segundos
Duration = 10; % Duración en segundos
Period = 2; % Lecturas por segundo
N = Duration*Period; % Cantidad de lecturas

Pose_Robotat = zeros(N, 7); % Array para lecturas de pose de marker

% Ciclo para realizar lecturas de pose del marker
for i = 1:N
    try 
        Pose_Robotat(i,:) = robotat_get_pose(robotat, agent_id);
    catch ME
        disp('Error al obtener posición.');
        disp(ME.message);
    end 
    pause(1/Period); % Delay de freuencia de muestreo
end

%% Gráfica 3D de lecturas
x_Robotat = Pose_Robotat(:, 1);
y_Robotat = Pose_Robotat(:, 2);
z_Robotat = Pose_Robotat(:, 3);

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