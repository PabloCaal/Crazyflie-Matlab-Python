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

% Rango de valores aceptales en Z:

% Funcionamiento perfecto
% P = 2.00, I = 0.50, D = 0.00

% Funcionamiento con overshoot
% P = 6.0, I = 2.00, D = 0.00

% Funcionamiento con overshoot exagerado y comportamiento errático
% P = 10.0, I = 0.50, D = 0.00

% Definir las nuevas ganancias PID para cada eje
p_gains = struct('X', 2.00, 'Y', 2.00, 'Z', 2.00);
i_gains = struct('X', 0.00, 'Y', 0.00, 'Z', 0.50);
d_gains = struct('X', 0.00, 'Y', 0.00, 'Z', 0.00);

crazyflie_modify_pid(crazyflie_1, p_gains, i_gains, d_gains);

% Take off
crazyflie_takeoff(crazyflie_1);
pause(2);

%% Land
crazyflie_land(crazyflie_1);
pause(2);

% Desconexión
crazyflie_disconnect(crazyflie_1);