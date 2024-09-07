%% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de movimiento con lecturas de robotat
% =========================================================================

%% Añadir al path las carpetas de comandos usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Conexión
agent_id = 50;
dron_id = 8; 

crazyflie_1 = crazyflie_connect(dron_id);
pause(2);
robotat = robotat_connect();   

%% Actualización de pose inicial del dron
robotat_update_crazyflie_position(crazyflie_1, robotat, agent_id);
pause(2);

pose_inicial = crazyflie_get_pose(crazyflie_1);
pose_final = [pose_inicial(1) + 0.3, pose_inicial(2), pose_inicial(3)];

%% Despegue
% Take off
crazyflie_takeoff(crazyflie_1);

%% Actualización de posición
total_duration = 5; 
interval = 0.25;   
iterations = total_duration / interval;  

for i = 1:iterations
    robotat_update_crazyflie_position(crazyflie_1, robotat, agent_id);
    pause(interval);
    disp(crazyflie_get_pose(crazyflie_1));
end

crazyflie_land(crazyflie_1);
pause(2);

%% Land
crazyflie_land(crazyflie_1);
pause(2);

%% Desconexión
crazyflie_disconnect(crazyflie_1);
robotat_disconnect(robotat)