function position = crazyflie_get_position(scf)  
    % Import and reload the Python module to ensure Matlab sees the changes
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    py.importlib.reload(crazyflie_commands);
    
    % Obtener la posición actual del Crazyflie
    position = crazyflie_commands.get_position(scf);
    
    % Convertir la posición de Python a un arreglo de Matlab
    position = double([position{1}, position{2}, position{3}]);
end
