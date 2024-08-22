function crazyflie_disconnect(scf)
    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end

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

