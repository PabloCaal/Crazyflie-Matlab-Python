function crazyflie_send_position(scf, x, y, z)    
    % Importa el módulo Python
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    
    % Recarga el módulo para asegurarse de que Matlab ve los cambios
    py.importlib.reload(crazyflie_commands);
    
    % Enviar las cooardenadas al Crazyflie
    result = crazyflie_commands.send_position(scf, x, y, z);
    
    if result
        disp(['Coordenadas enviadas: (', num2str(x), ', ', num2str(y), ', ', num2str(z), ')']);
    else
        disp('No se pudieron enviar las coordenadas.');
    end
end
