% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de despegue y aterrizaje
% =========================================================================

%% Añadir al path las carpetas de comandos usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Valores para PID originales
p_gains = struct('X', 2.0, 'Y', 2.0, 'Z', 2.0);
i_gains = struct('X', 0.0, 'Y', 0.0, 'Z', 0.5);
d_gains = struct('X', 0.0, 'Y', 0.0, 'Z', 0.0);

%% Ejecución de prueba de despegue y aterrizaje
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(2);

% Definir las nuevas ganancias PID para cada eje
p_gains = struct('X', 2.00, 'Y', 2.00, 'Z', 2.00);
i_gains = struct('X', 0.00, 'Y', 0.00, 'Z', 0.50);
d_gains = struct('X', 0.00, 'Y', 0.00, 'Z', 0.00);

% Modificación de parámetros PID, despegue, aterrizaje y desconexión
crazyflie_modify_pid(crazyflie_1, p_gains, i_gains, d_gains);
crazyflie_takeoff(crazyflie_1);
pause(2);
crazyflie_land(crazyflie_1);
pause(2);
crazyflie_disconnect(crazyflie_1);

%% Ejecución de prueba de despegue y aterrizaje
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(2);

% Funcionamiento con overshoot
% P = 6.0, I = 2.00, D = 0.00

% Arrays para nuevos parámetros del PID
p_gains = struct('X', 2.00, 'Y', 2.00, 'Z', 7.0);
i_gains = struct('X', 0.00, 'Y', 0.00, 'Z', 0.5);
d_gains = struct('X', 0.00, 'Y', 0.00, 'Z', 0.00);

% Modificación de parámetros PID, despegue, aterrizaje y desconexión
crazyflie_modify_pid(crazyflie_1, p_gains, i_gains, d_gains);
crazyflie_takeoff(crazyflie_1);
pause(2);
crazyflie_land(crazyflie_1);
pause(2);
crazyflie_disconnect(crazyflie_1);