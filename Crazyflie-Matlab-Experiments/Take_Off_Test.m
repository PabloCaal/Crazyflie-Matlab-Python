% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de despegue y aterrizaje
% =========================================================================

%% Añadir al path las carpetas de comandos usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Ejecución de prueba de despegue y aterrizaje
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(3);

% Take off
crazyflie_takeoff(crazyflie_1);
pause(3);

% Land
crazyflie_land(crazyflie_1);
pause(3);

% Desconexión
crazyflie_disconnect(crazyflie_1);