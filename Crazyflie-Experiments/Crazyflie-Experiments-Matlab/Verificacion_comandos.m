%% TRABAJO DE GRADUACIÓN - PABLO CAAL 20538
% Universidad del Valle de Guatemala
% Diseño e Innovación en Ingeniería Mecatrónica
% Pruebas de los comandos desarrollados en Python
% Creado 25 - 07 - 2024
% Modificado: 29 - 07 - 2024

%% Comando para iniciar conexión PC-Crazyflie
% Genera la conexión con el Crazyflie con la URI indicada
% Drones 1 al 12
crazyflie_1 = crazyflie_connect(8);

%% Comando para finalizar conexión PC-Crazyflie
% Se desconecta del Crazyflie especificado
crazyflie_disconnect(crazyflie_1);

%%
motor_health_test(crazyflie_1)

%% Obtención de posición
XYZ = crazyflie_get_position(crazyflie_1);

%% Parado de emergencia
% Detiene al dron de forma segura, este descenderá y apagará
crazyflie_emergency_stop(crazyflie_1);

%% Despegue
% Función para el despegue inicial a una altura default de 0.5 metros
crazyflie_takeoff(crazyflie_1);

%% Aterrizaje
% Aterriza al dron de forma segura, desciende y apaga motores
crazyflie_land(crazyflie_1);

%% Función de envío de posición
% Envío de coordenas XYZ para actualizar posición
crazyflie_send_position(crazyflie_1, 0.1, 0, 0.4);

%% Actualización de posición con fuente externa
crazyflie_update_position(crazyflie_1, 0, 0, 0);