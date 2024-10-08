% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de conexión, lectura y desconexión de marker Crazyflie en Robotat
% =========================================================================
addpath('../Robotat-Matlab-Commands');

%% Conexión y definición de número de marker
robotat = robotat_connect();
agent_id = 50;  % ID del agente en el ecosistema Robotat

%% Desconexión
robotat_disconnect(robotat);

%% Lectura de pose de marker Crazyflie
pose = robotat_get_pose(robotat, agent_id);
disp(pose);

%% Lectura de pose de marker Crazyflie en ciclo durante N segundos
Duration = 10; % Duración en segundos
Period = 4; % Lecturas por segundo
N = Duration*Period; % Cantidad de lecturas

pose_crazyflie = zeros(N, 7); % Array para lecturas de pose de marker

% Ciclo para realizar lecturas de pose del marker
for i = 1:N
    try 
        pose_crazyflie(i,:) = robotat_get_pose(robotat, agent_id);
    catch ME
        disp('Error al obtener posición.');
        disp(ME.message);
    end 
    pause(1/Period); % Delay de freuencia de muestreo
end


%% Lectura de pose de marker Crazyflie indefinidamente
robotat = robotat_connect();

pose_crazyflie = [];
s_actual = 0;

while true 
    try
        pose_crazyflie = robotat_get_pose(robotat, agent_id);
    catch
        robotat_disconnect(robotat);
        robotat = robotat_connect();
        disp("Reconectando.")
    end
    s_actual = s_actual + 1;
    pause(0.1)
end

%% Gráfica 3D de lecturas
x_crazyflie = pose_crazyflie(:, 1);
y_crazyflie = pose_crazyflie(:, 2);
z_crazyflie = pose_crazyflie(:, 3);

figure;
plot3(x_crazyflie, y_crazyflie, z_crazyflie, '-*');
grid on;
xlabel('X [m]');
ylabel('Y [m]');
zlabel('Z [m]');
title('Trayectoria del marker en 3D');

% Ajustar el espacio 3D
axis equal;
axis([-2 2 -2.5 2.5 0 3]);
view(3); 

%% Gráfica 2D componente Z

% Extraer la columna Z
z_Robotat = pose_crazyflie(:, 3);

% Crear un vector de tiempo basado en la longitud de Pose_Robotat (simulación de 100 muestras)
t = linspace(0, 10, length(z_Robotat));  % Ajusta el rango de tiempo según tus datos

% Graficar la componente Z en función del tiempo
figure;
plot(t, z_Robotat, '-*');
grid on;
xlabel('Tiempo [s]');
ylabel('Z [m]');
title('Componente Z del marker en función del tiempo');