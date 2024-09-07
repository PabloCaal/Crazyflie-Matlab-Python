% =========================================================================
% PROYECTO DE GRADUACIÓN: HERRAMIENTAS DE SOFTWARE PARA CRAZYFLIE
% Pablo Javier Caal Leiva - 20538
% -------------------------------------------------------------------------
% Prueba de obstáculo hexagonal
% =========================================================================

%% Añadir al path las carpetas de comandos usando una ruta relativa
addpath('../Crazyflie-Matlab-Commands');
addpath('../Robotat-Matlab-Commands');

%% Ejecución de prueba de 9despegue y aterrizaje
% Conexión con Crazyflie
dron_id = 8;    % ID del dron disponible 
crazyflie_1 = crazyflie_connect(dron_id);
pause(2);

% Take off
crazyflie_takeoff(crazyflie_1);
pause(3);

x = [];
y = [];
z = [];

% Bajar a la altura del obstáculo
x(1) = 0;
y(1) = 0;
z(1) = 0.13;

% Atravesar el obstáculo
x(2) = 0.4;
y(2) = 0;
z(2) = 0.13;

for i = 1:size(x,2)
    crazyflie_send_position(crazyflie_1, x(i), y(i), z(i));
    pause(2);
end

% Land
crazyflie_land(crazyflie_1);
pause(2);

% Desconexión
crazyflie_disconnect(crazyflie_1);