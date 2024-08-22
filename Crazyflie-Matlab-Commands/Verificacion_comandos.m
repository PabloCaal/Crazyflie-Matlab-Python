% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Script para realizar prueba de comandos crazyflie en Matlab
% =========================================================================

%% Comando para iniciar conexión PC-Crazyflie
% Genera la conexión con el Crazyflie con la URI indicada
% Drones 1 al 12
crazyflie_1 = crazyflie_connect(8);

%% Comando para finalizar conexión PC-Crazyflie
% Se desconecta del Crazyflie especificado
crazyflie_disconnect(crazyflie_1);

%% Comando para realizar el despegue del Crazyflie
% Función para el despegue inicial
%crazyflie_takeoff(crazyflie_1);

%% Comando para realizar el aterrizaje del Crazyflie
% Aterriza al dron de forma segura: desciende y apaga motores
%crazyflie_land(crazyflie_1);

%% Obtención de posición
XYZ = crazyflie_get_position(crazyflie_1)

%% Función de envío de posición
% Envío de coordenas XYZ para actualizar posición
%crazyflie_send_position(crazyflie_1, -0.2, 0, 0.5);

%% Función para recuperar la pose del Crazyflie
pose = crazyflie_get_pose(crazyflie_1)

%% Actualización de posición con fuente externa
crazyflie_update_position(crazyflie_1, 0, 0, 0);