% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Verificación de comandos crazyflie en Matlab
% =========================================================================

%% Comando para iniciar conexión PC-Crazyflie
crazyflie_1 = crazyflie_connect(8);

%% Comando para finalizar conexión PC-Crazyflie
crazyflie_disconnect(crazyflie_1);

%% Comando para realizar el despegue del Crazyflie
crazyflie_takeoff(crazyflie_1);

%% Comando para realizar el aterrizaje del Crazyflie
crazyflie_land(crazyflie_1);

%% Obtención de posición
XYZ = crazyflie_get_position(crazyflie_1)

%% Función de envío de posición
crazyflie_move_to(crazyflie_1, 0.2, 0, 0.7);

%% Función para recuperar la pose del Crazyflie
pose = crazyflie_get_pose(crazyflie_1);

%% Actualización de posición con fuente externa
crazyflie_update_position(crazyflie_1, 1, 3, 0);

%% Lectura de constantes del controlador PID
PID = crazyflie_get_pid(crazyflie_1);

%% Definir las nuevas ganancias PID para cada eje
p_gains = struct('X', 4.5, 'Y', 2.5, 'Z', 2.0);
i_gains = struct('X', 0.1, 'Y', 0.1, 'Z', 0.2);
d_gains = struct('X', 0.0, 'Y', 0.0, 'Z', 0.1);

crazyflie_modify_pid(crazyflie_1, p_gains, i_gains, d_gains);