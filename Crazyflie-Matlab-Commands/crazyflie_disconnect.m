function crazyflie_disconnect(scf)
    % Import and reload the Python module to ensure Matlab sees the changes
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    py.importlib.reload(crazyflie_commands);
    
    % Disconnect from Crazyflie and clear the scf from the workspace
    % Attempt to disconnect from Crazyflie with error handling
    try
        crazyflie_commands.disconnect_crazyflie(scf);
        disp('Disconnected from Crazyflie.');
        evalin('base', ['clear ', inputname(1)]);
    catch ME
        error('Error using crazyflie_commands>disconnect_crazyflie: %s', ME.message);
    end
end