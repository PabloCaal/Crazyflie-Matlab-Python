%% UNIVERSIDAD DEL VALLE DE GUATEMALA
% Función para detener de emergencia al dron Crazyflie

function crazyflie_emergency_stop(scf)    
    % Importa el módulo Python
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    
    % Recarga el módulo para asegurarse de que Matlab ve los cambios
    py.importlib.reload(crazyflie_commands);
    
    % Enviar el comando de parada de emergencia al Crazyflie
    result = crazyflie_commands.emergency_stop(scf);
    
    if result
        disp('Comando de parada de emergencia enviado.');
    else
        disp('No se pudo enviar el comando de parada de emergencia.');
    end
end
