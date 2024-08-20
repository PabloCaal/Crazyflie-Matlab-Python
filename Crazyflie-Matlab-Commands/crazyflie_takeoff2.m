function crazyflie_takeoff2(scf)    
    % Importa el módulo Python
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    
    % Recarga el módulo para asegurarse de que Matlab ve los cambios
    py.importlib.reload(crazyflie_commands);
    
    % Enviar las coordenadas al Crazyflie
    result = crazyflie_commands.takeoff2(scf, 0.4, 0.8);
    
    if result
        disp(['Despegue realizado.']);
    else
        disp('No se pudo realizar el despegue.');
    end
end
