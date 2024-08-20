function crazyflie_update_position(scf, x, y, z)   
    % Importa el módulo Python
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    
    % Recarga el módulo para asegurarse de que Matlab ve los cambios
    py.importlib.reload(crazyflie_commands);
    
    % Conectar al Crazyflie
    result = crazyflie_commands.update_position(scf, x, y, z);
    
    if result
        disp(['Coordenadas actualizadas']);
    else
        disp('No se pudieron actualizar las coordenadas');
    end
end