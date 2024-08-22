function crazyflie_update_position(scf, x, y, z)
    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end
    
    % Validate the x, y, z inputs
    if ~isnumeric(x) || ~isnumeric(y) || ~isnumeric(z)
        error('ERROR: x, y, and z must be numeric values.');
    end

    % Attempt to update the external position of the Crazyflie (returns an error code)
    update_code = py.crazyflie_commands.update_position(scf, x, y, z);
    
    % Check the result of the update position command
    if update_code == 0
        disp('Position updated successfully.');
    elseif update_code == 1
        error('ERROR: Invalid position parameters.');
    elseif update_code == 2
        error('ERROR: An error occurred during the position update.');
    else
        error('ERROR: Unexpected result from Python during the position update.');
    end
end