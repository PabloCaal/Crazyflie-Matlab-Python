%% UNIVERSIDAD DEL VALLE DE GUATEMALA
% Función para detener de emergencia al dron Crazyflie

function crazyflie_land(scf)  
    % Importa el módulo Python
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    
    % Recarga el módulo para asegurarse de que Matlab ve los cambios
    py.importlib.reload(crazyflie_commands);
    
    % Enviar las coordenadas al Crazyflie
    result = crazyflie_commands.land(scf, 0, 3.0);
    
    if result
        disp('Aterrizaje completado.');
    else
        disp('Error en el aterrizaje.');
    end
end
