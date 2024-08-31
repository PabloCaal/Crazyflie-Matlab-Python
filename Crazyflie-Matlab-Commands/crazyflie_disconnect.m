function crazyflie_disconnect(scf)
    % Disconnect from Crazyflie and clear the scf from the workspace
    % Attempt to disconnect from Crazyflie with error handling
    try
        py.crazyflie_commands.disconnect(scf);
        disp('Disconnected from Crazyflie.');
        evalin('base', ['clear ', inputname(1)]);
    catch ME
        error('Error using crazyflie_commands>disconnect_crazyflie: %s', ME.message);
    end
end 