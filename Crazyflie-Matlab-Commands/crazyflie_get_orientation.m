%% UNIVERSIDAD DEL VALLE DE GUATEMALA
% Función para obtener la orientación actual del Crazyflie

function orientation = crazyflie_get_orientation(scf)
    % Importa el módulo Python
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    
    % Recarga el módulo para asegurarse de que Matlab ve los cambios
    py.importlib.reload(crazyflie_commands);
    
    % Obtiene la orientación del Crazyflie
    orientation = crazyflie_commands.get_orientation(scf);
    
    % Convertir la posición de Python a un arreglo de Matlab
    orientation = double([orientation{1}, orientation{2}, orientation{3}]);
end
