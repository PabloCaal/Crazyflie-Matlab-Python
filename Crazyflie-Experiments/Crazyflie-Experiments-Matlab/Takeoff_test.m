%% TRABAJO DE GRADUACIÓN - PABLO CAAL 20538
% UNIVERSIDAD DEL VALLE DE GUATEMALA
% Diseño e Innovación en Ingeniería Mecatrónica
% Script para prueba de despegue y aterrizaje
% 09/08/2024

%% Secuencia de comandos
dron_id = 8;    % ID del dron disponible 
% Conexión con dron y entorno Robotat
crazyflie_1 = crazyflie_connect(dron_id);

%% Despegue
crazyflie_takeoff2(crazyflie_1); 

%% Aterrizaje
crazyflie_land(crazyflie_1);

%% Desconexión
crazyflie_disconnect(crazyflie_1);